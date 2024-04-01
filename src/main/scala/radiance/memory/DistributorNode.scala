package radiance.memory

import chisel3._
import chisel3.experimental.SourceInfo
import chisel3.util._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.BundleField
import org.chipsalliance.cde.config.Parameters


class DistributorNode(from: Int, to: Int)(implicit p: Parameters) extends LazyModule {
  require(isPow2(from) && isPow2(to) && (from >= to), "invalid distributor node parameters")
  println(s"distributor node to segment from $from into $to")
  val num_clients = from / to

  val node = TLNexusNode(clientFn = seq => {
    require(seq.map(_.masters.size).sum == 1, s"there should only be one client to a distributor node, found ${seq.map(_.masters.size).sum}")
    val master = seq.head.masters.head
    require(isPow2(master.sourceId.size))
    seq.head.v1copy(
      clients = Seq.tabulate(num_clients)(i => master.v2copy(
        name = s"${name}_dist_client_$i",
        emits = TLMasterToSlaveTransferSizes(
          get = TransferSizes(to, to),
          putFull = TransferSizes(to, to),
          putPartial = TransferSizes(to, to)
        ),
        sourceId = master.sourceId.shift(master.sourceId.size * i)
      ))
    )
  }, managerFn = seq => {
    seq.head.v1copy(
      responseFields = BundleField.union(seq.flatMap(_.responseFields)),
      requestKeys = seq.flatMap(_.requestKeys).distinct,
      minLatency = seq.map(_.minLatency).min,
      endSinkId = TLXbar.mapOutputIds(seq).map(_.end).max,
      managers = Seq(TLSlaveParameters.v2(
        name = Some(s"${name}_manager"),
        address = AddressSet.unify(seq.flatMap(_.slaves.flatMap(_.address))),
        supports = TLMasterToSlaveTransferSizes(
          get = TransferSizes(from, from),
          putFull = TransferSizes(from, from),
          putPartial = TransferSizes(from, from)
        ),
        fifoId = Some(0),
      )),
      beatBytes = from
    )
  })

  lazy val module = new LazyModuleImp(this) {
    val cn = node.in.head._1
    val mn = node.out.map(_._1)
    println(f"$name node in size ${node.in.size}, out size ${node.out.size}")
    assert(node.out.size == num_clients, s"got ${node.out.size} clients instead of $num_clients")

    // A channel
    val ca = cn.a.bits
    mn.map(_.a.bits).zipWithIndex.foreach { case (m, i) =>
      println(s"$i master source id width ${m.source.getWidth}, client source id width ${ca.source.getWidth}")
      m.opcode := ca.opcode
      m.param := ca.param
      m.user := ca.user
      m.source := Cat(i.U(log2Ceil(num_clients).W), ca.source)
      m.address := ca.address + (to * i).U
      m.mask := ca.mask((i + 1) * to - 1, i * to)
      m.data := ca.data((i + 1) * to * 8 - 1, i * to * 8)
      m.size := log2Ceil(to).U
    }
    mn.map(_.a.valid).foreach(_ := cn.a.valid)
    cn.a.ready := mn.map(_.a.ready).reduce(_ && _)

    // D channel
    val cd = cn.d.bits
    cd.size := log2Ceil(from).U
    val partialWait = RegInit(false.B)
    val arrived = RegInit(0.U(num_clients.W))
    val cdReg = RegInit(0.U.asTypeOf(cd.cloneType))

    def setMetadata(to: TLBundleD, from: TLBundleD): Unit = {
      to.opcode := from.opcode
      to.user := from.user
      to.param := from.param
      to.sink := from.sink
      to.denied := from.denied
      to.corrupt := from.corrupt
      to.source := from.source(to.source.getWidth - 1, 0)
    }

    def partialData: UInt = VecInit(mn.map(_.d).map(d => Mux(d.fire, d.bits.data, 0.U(d.bits.data.getWidth.W)))).asUInt
    def partialValid: UInt = VecInit(mn.map(_.d.fire)).asUInt

    mn.map(_.d.ready).zip(arrived.asBools).foreach { case (r, a) =>
      r := cn.d.ready && (!partialWait || !a) // if waiting for partial response, ready only if not arrived yet
    }

    // TODO: might need coverage test for this
    when (!partialWait) {
      cn.d.valid := false.B
      partialWait := false.B
      when (partialValid.asBools.reduce(_ && _)) {
        // all valids, immediately return both metadata and data
        cn.d.valid := true.B
        cd.data := Cat(mn.map(_.d.bits.data).reverse)
        setMetadata(cd, mn.head.d.bits)
        assert(cd.data === partialData, "sanity check")
      }.elsewhen (partialValid.asBools.reduce(_ || _)) {
        // at least 1 valid: enter partial valid state, store partial data into regs
        partialWait := true.B
        arrived := partialValid
        cdReg.data := partialData
        when (mn.head.d.valid) { setMetadata(cdReg, mn.head.d.bits) }
      }
    }.otherwise {
      cn.d.valid := false.B
      partialWait := true.B
      when ((arrived | partialValid).asBools.reduce(_ && _)) {
        // all valids received now
        when (mn.head.d.valid) {
          setMetadata(cd, mn.head.d.bits)
        }.otherwise {
          cd := cdReg
        }
        cn.d.valid := true.B
        cd.data := cdReg.data | partialData
        partialWait := false.B
        cdReg := 0.U.asTypeOf(cdReg.cloneType)
        arrived := 0.U
      }.elsewhen (partialValid.asBools.reduce(_ || _)) {
        // update partial data
        arrived := arrived | partialValid
        cdReg.data := cdReg.data | partialData
        when (mn.head.d.valid) { setMetadata(cdReg, mn.head.d.bits) }
      }
    }
  }
}

object DistributorNode {
  def apply(from: Int, to: Int)(implicit p: Parameters, valName: ValName, sourceInfo: SourceInfo): TLNexusNode = {
    LazyModule(new DistributorNode(from, to)).node
  }
}
