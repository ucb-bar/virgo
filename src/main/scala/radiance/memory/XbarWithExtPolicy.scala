package radiance.memory

import chisel3._
import chisel3.experimental.SourceInfo
import chisel3.util.Valid
import freechips.rocketchip.tilelink._
import org.chipsalliance.cde.config.Parameters
import org.chipsalliance.diplomacy.ValName
import org.chipsalliance.diplomacy.lazymodule._
import org.chipsalliance.diplomacy.nodes.{RenderedEdge, SimpleNodeImp, SinkNode, SourceNode}

object ExtPolicyNodeImp extends SimpleNodeImp[Int, Int, Int, UInt] {
  def bundle(x: Int) = UInt(x.W)
  def edge(x: Int, y: Int, p: Parameters, sourceInfo: SourceInfo): Int = x
  def render(x: Int): RenderedEdge = RenderedEdge("ffffff")
}
case class ExtPolicyMasterNode(w: Int)(implicit valName: ValName) extends SourceNode(ExtPolicyNodeImp)(Seq(w))
case class ExtPolicySlaveNode()(implicit valName: ValName) extends SinkNode(ExtPolicyNodeImp)(Seq(0))

class XbarWithExtPolicy(nameSuffix: Option[String] = None)
                       (implicit p: Parameters) extends TLXbar(nameSuffix = nameSuffix) {
  val policySlaveNode = ExtPolicySlaveNode()

  class ImplChild extends Impl {
    val policy: TLArbiter.Policy = (width, valids, select) => {
      val readys = policySlaveNode.in.head._1
      Mux((valids & readys).orR,
        readys, // take hint
        TLArbiter.lowestIndexFirst(width, valids, select)
      )
      // readys & VecInit.fill(width)(VecInit((valids.asBools zip readys.asBools).map {
      //   case (v, r) => r || !v
      // }).asUInt.andR).asUInt
    }
    // val wide_bundle = TLBundleParameters.union((node.in ++ node.out).map(_._2.bundle))
    // override def desiredName = (Seq("TLXbar") ++ nameSuffix ++ Seq(s"i${node.in.size}_o${node.out.size}_${wide_bundle.shortName}")).mkString("_")
    TLXbar.circuit(policy, node.in, node.out)
  }

  override lazy val module = new ImplChild
}

object XbarWithExtPolicy {
  def apply(nameSuffix: Option[String] = None)
           (implicit p: Parameters): XbarWithExtPolicy = {
    val xbar = LazyModule(new XbarWithExtPolicy(nameSuffix))
    xbar
  }
}