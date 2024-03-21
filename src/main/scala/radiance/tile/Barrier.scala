// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.tile

import chisel3._
import chisel3.experimental.SourceInfo
import chisel3.util._

import org.chipsalliance.cde.config.{Field, Parameters}
import freechips.rocketchip.subsystem._
import freechips.rocketchip.diplomacy._

case class EmptyParams()

case class BarrierParams(
  barrierIdBits: Int,
  numCoreBits: Int
)

class BarrierRequestBits(
  param: BarrierParams
) extends Bundle {
  val barrierId = UInt(param.barrierIdBits.W)
  val sizeMinusOne = UInt(param.numCoreBits.W)
  val coreId = UInt(param.numCoreBits.W)
}

class BarrierResponseBits(
  param: BarrierParams
) extends Bundle {
  val barrierId = UInt(param.barrierIdBits.W)
}

class BarrierBundle(param: BarrierParams) extends Bundle {
  val req = Decoupled(new BarrierRequestBits(param))
  val resp = Flipped(Decoupled(new BarrierResponseBits(param)))
}

// FIXME Separate BarrierEdgeParams from BarrierParams
object BarrierNodeImp extends SimpleNodeImp[BarrierParams, EmptyParams, BarrierParams, BarrierBundle] {
  def edge(pd: BarrierParams, pu: EmptyParams, p: Parameters, sourceInfo: SourceInfo) = {
    // barrier parameters flow strictly downward from the master node
    pd
  }
  def bundle(e: BarrierParams) = new BarrierBundle(e)
  // FIXME render
  def render(e: BarrierParams) = RenderedEdge(colour = "ffffff", label = "X")
}

case class BarrierMasterNode(val srcParams: BarrierParams)(implicit valName: ValName)
    extends SourceNode(BarrierNodeImp)(Seq(srcParams))
case class BarrierSlaveNode(val numEdges: Int)(implicit valName: ValName)
    extends SinkNode(BarrierNodeImp)(Seq.fill(numEdges)(EmptyParams()))

// `delay`: number of cycles used to delay the response after all cores are
// synchronized.  This is used for debugging purposes to give some time for the
// cores to "settle" after the barrier synchronization, e.g. resolve
// outstanding smem requests.
class BarrierSynchronizer(
  param: BarrierParams,
  delay: Option[Int] = None
) extends Module {
  val numBarriers = 1 << param.barrierIdBits
  val numCores = 1 << param.numCoreBits
  println(s"numBarriers: ${numBarriers}, numCores: ${numCores}")

  val io = IO(new Bundle {
    val reqs = Vec(numCores, Flipped(Decoupled(new BarrierRequestBits(param))))
    val resp = Decoupled(new BarrierResponseBits(param))
  })

  // 2-dimensional table of per-id, per-core "done" signals
  val table = RegInit(VecInit(Seq.fill(numBarriers)(VecInit(Seq.fill(numCores)(false.B)))))
  val done = Seq.fill(numBarriers)(Wire(Bool()))
  val delayer = delay.map(n => Seq.fill(numBarriers)(Counter(n)))

  (table zip done).zipWithIndex.foreach { case ((row, d), i) =>
    d := row.reduce(_ && _)
    delayer.foreach{ dl => when (d) { dl(i).inc() }}
    dontTouch(d)
  }

  io.reqs.zipWithIndex.foreach { case (req, coreId) =>
    // always ready; all this module does is latch to boolean regs
    req.ready := true.B
    when(req.fire) {
      assert(coreId.U === req.bits.coreId)
      // FIXME: don't need coreId to be hardware here
      table(req.bits.barrierId)(coreId.U) := true.B
    }
  }

  val doneArbiter = Module(new RRArbiter(Bool(), numBarriers))
  (doneArbiter.io.in zip done).zipWithIndex.foreach { case ((in, d), i) =>
    val alarm = delayer match {
      case Some(dl) => dl(i).value === (dl(i).n - 1).U
      case None => true.B
    }
    in.valid := (d && alarm)
    in.bits := d
    when(in.fire) {
      table(i).foreach(_ := false.B)
      delayer.foreach(_(i).reset())
    }
  }
  io.resp.valid := doneArbiter.io.out.valid
  io.resp.bits.barrierId := doneArbiter.io.chosen
  doneArbiter.io.out.ready := io.resp.ready
}
