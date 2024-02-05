package radiance.memory

import chisel3._
import chisel3.experimental.SourceInfo
import chisel3.util._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.tilelink.TLAdapterNode
import org.chipsalliance.cde.config.Parameters


class AddressRewriterNode(baseAddr: BigInt)(implicit p: Parameters) extends LazyModule {
  require(isPow2(baseAddr) || (baseAddr == 0), "base address must be a power of 2")

  val node = TLAdapterNode(clientFn = c => c, managerFn = m => m)
  lazy val module = new LazyModuleImp(this) {
    (node.in.map(_._1) zip node.out.map(_._1)).foreach { case (i, o) =>
      o.a <> i.a
      o.a.bits.address := i.a.bits.address | baseAddr.U
      i.d <> o.d
    }
  }
}

object AddressRewriterNode {
  def apply(baseAddr: BigInt)(implicit p: Parameters, valName: ValName, sourceInfo: SourceInfo): TLAdapterNode = {
    LazyModule(new AddressRewriterNode(baseAddr)).node
  }
}