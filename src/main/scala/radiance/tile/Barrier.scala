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

class BarrierSynchronizer(param: BarrierParams) extends Module {
  val numBarrierIds = 1 << param.barrierIdBits
  val numCores = 1 << param.numCoreBits
  println(s"numBarrierIds: ${numBarrierIds}, numCores: ${numCores}")

  val io = IO(new Bundle {
    val reqs = Vec(numCores, Flipped(Decoupled(new BarrierRequestBits(param))))
    val resp = Decoupled(new BarrierResponseBits(param))
  })

  // 2-dimensional table of per-id, per-core "done" signals
  val table = RegInit(VecInit(Seq.fill(numBarrierIds)(VecInit(Seq.fill(numCores)(false.B)))))
  val done = Wire(Vec(numBarrierIds, Bool()))
  table.zipWithIndex.foreach { case (row, i) =>
    done(i) := row.reduce(_ && _)
  }
  dontTouch(done)

  io.reqs.zipWithIndex.foreach { case (req, coreId) =>
    // always ready; all this module does is latch to boolean regs
    req.ready := true.B
    when(req.fire) {
      assert(coreId.U === req.bits.coreId)
      // FIXME: don't need coreId to be hardware here
      table(req.bits.barrierId)(coreId.U) := true.B
    }
  }

  val doneArbiter = Module(new RRArbiter(Bool(), numBarrierIds))
  (doneArbiter.io.in zip done).zipWithIndex.foreach { case ((in, d), i) =>
    in.valid := d
    in.bits := d
    when(in.fire) {
      table(i).foreach(_ := false.B)
    }
  }
  io.resp.valid := doneArbiter.io.out.valid
  io.resp.bits.barrierId := doneArbiter.io.chosen
  when(io.resp.fire) {
    table(io.resp.bits.barrierId).foreach(_ := false.B)
  }
  doneArbiter.io.out.ready := io.resp.ready
}
