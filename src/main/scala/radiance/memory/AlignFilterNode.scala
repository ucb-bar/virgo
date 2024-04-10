package radiance.memory

import chisel3._
import chisel3.experimental.SourceInfo
import chisel3.util._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.BundleField
import org.chipsalliance.cde.config.Parameters

// this node splits the incoming requests into two outgoing edges,
// the first edge contains requests that match the filter AddressSet,
// and the second edge contains requests that don't.
// on the return leg, the two responses are arbitrated in a RR fashion.
class AlignFilterNode(filters: Seq[AddressSet])(implicit p: Parameters) extends LazyModule {

  val node = TLNexusNode(clientFn = seq => {
    require(seq.map(_.masters.size).sum == 1, s"there should only be one client to a filter node, " +
      s"found ${seq.map(_.masters.size).sum}")
    val master = seq.head.masters.head

    // TODO: to implement multiple filters, source Id mapping needs to be redone
    assert(filters.length == 1, "multiple filters currently not supported")

    seq.head.v1copy(
      clients = filters.map { filter =>
        master.v2copy(
          name = s"${name}_filter_aligned",
          sourceId = master.sourceId,
          visibility = Seq(filter),
          emits = seq.map(_.anyEmitClaims).reduce(_ mincover _)
        )
      } ++ Seq(
        master.v2copy(
          name = s"${name}_filter_unaligned",
          sourceId = master.sourceId.shift(master.sourceId.size),
          visibility = Seq(AddressSet.everything),
          emits = seq.map(_.anyEmitClaims).reduce(_ mincover _)
        ),
      )
    )
  }, managerFn = seq => {
    val addresses = seq.flatMap(_.slaves.flatMap(_.address))
    val unifiedAddressRange = addresses.flatMap(_.toRanges).sorted.reduce(_.union(_).get)
    assert(isPow2(unifiedAddressRange.size))
    println(s"$name address range ${unifiedAddressRange}")
    seq.head.v1copy(
      responseFields = BundleField.union(seq.flatMap(_.responseFields)),
      requestKeys = seq.flatMap(_.requestKeys).distinct,
      minLatency = seq.map(_.minLatency).min,
      endSinkId = TLXbar.mapOutputIds(seq).map(_.end).max,
      managers = Seq(TLSlaveParameters.v2(
        name = Some(s"${name}_manager"),
        address = Seq(AddressSet(unifiedAddressRange.base, unifiedAddressRange.size - 1)),
        supports = seq.map(_.anySupportClaims).reduce(_ mincover _)
      ))
    )
  })

  def cast_d[T <: TLBundleD](d: TLBundleD, target_d_t: T): T = {
    val new_d = Wire(target_d_t.cloneType)
    d.elements.foreach { case (name, data) =>
      val new_d_field = new_d.elements.filter(_._1 == name).head._2
      new_d_field := data.asTypeOf(new_d_field)
    }
    new_d
  }

  def cast_d[T <: DecoupledIO[TLBundleD]](ds: Seq[DecoupledIO[TLBundleD]], target_d_t: T): Seq[T] = {
    ds.map { d =>
      val new_d = Wire(target_d_t.cloneType)
      new_d.valid := d.valid
      new_d.bits := cast_d(d.bits, target_d_t.bits)
      d.ready := new_d.ready
      new_d
    }
  }

  lazy val module = new LazyModuleImp(this) {
    val (c, c_edge) = node.in.head
    val a = node.out.init.map(_._1)
    val ua = node.out.last._1

    val a_aligned = filters.map(_.contains(c.a.bits.address))

    (a zip a_aligned).foreach { case (a, aligned) =>
      a.a.bits := c.a.bits
      a.a.valid := c.a.valid && aligned
    }
    ua.a.bits := c.a.bits
    ua.a.bits.source := c.a.bits.source + (1.U << c.a.bits.source.getWidth)
    ua.a.valid := c.a.valid && !a_aligned.reduce(_ || _)
    c.a.ready := MuxCase(ua.a.ready, (a zip a_aligned).map { case (a, aligned) => aligned -> a.a.ready })

    TLArbiter.robin(c_edge, c.d, cast_d(a.map(_.d) ++ Seq(ua.d), c.d): _*)
  }
}

object AlignFilterNode {
  def apply(filters: Seq[AddressSet])(implicit p: Parameters, valName: ValName, sourceInfo: SourceInfo): TLNexusNode = {
    LazyModule(new AlignFilterNode(filters)).node
  }
}
