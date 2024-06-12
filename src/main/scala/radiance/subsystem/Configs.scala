// See LICENSE.SiFive for license details.
// See LICENSE.Berkeley for license details.

package radiance.subsystem

import chisel3.util._
import org.chipsalliance.cde.config._
import freechips.rocketchip.rocket._
import freechips.rocketchip.tile._
import freechips.rocketchip.subsystem._
import gemmini.{CapacityInKilobytes, GemminiFPConfigs}
import radiance.tile._
import radiance.memory._

case class RadianceSharedMemKey(address: BigInt,
                                size: Int,
                                numBanks: Int,
                                numWords: Int,
                                wordSize: Int = 4,
                                strideByWord: Boolean = true,
                                filterAligned: Boolean = true,
                                disableMonitors: Boolean = true,
                                serializeUnaligned: Boolean = true)
case object RadianceSharedMemKey extends Field[Option[RadianceSharedMemKey]](None)

case class RadianceFrameBufferKey(baseAddress: BigInt,
                                  width: Int,
                                  size: Int,
                                  validAddress: BigInt,
                                  fbName: String = "fb")
case object RadianceFrameBufferKey extends Field[Seq[RadianceFrameBufferKey]](Seq())

class WithRadianceCores(
  n: Int,
  location: HierarchicalLocation,
  crossing: RocketCrossingParams,
  useVxCache: Boolean
) extends Config((site, _, up) => {
  case TilesLocated(`location`) => {
    val prev = up(TilesLocated(`location`))
    val idOffset = prev.size
    val vortex = RadianceTileParams(
      core = VortexCoreParams(fpu = None),
      btb = None,
      useVxCache = useVxCache,
      dcache = Some(DCacheParams(
        rowBits = site(SystemBusKey).beatBits,
        nSets = 64,
        nWays = 1,
        nTLBSets = 1,
        nTLBWays = 1,
        nTLBBasePageSectors = 1,
        nTLBSuperpages = 1,
      nMSHRs = 0,
        blockBytes = site(CacheBlockBytes))),
      icache = Some(ICacheParams(
        rowBits = site(SystemBusKey).beatBits,
        nSets = 64,
        nWays = 1,
        nTLBSets = 1,
        nTLBWays = 1,
        nTLBBasePageSectors = 1,
        nTLBSuperpages = 1,
        blockBytes = site(CacheBlockBytes))))
    List.tabulate(n)(i => RadianceTileAttachParams(
      vortex.copy(tileId = i + idOffset),
      crossing
    )) ++ prev
  }
}) {
  def this(n: Int, location: HierarchicalLocation = InSubsystem, useVxCache: Boolean = false) = this(n, location, RocketCrossingParams(
    master = HierarchicalElementMasterPortParams.locationDefault(location),
    slave = HierarchicalElementSlavePortParams.locationDefault(location),
    mmioBaseAddressPrefixWhere = location match {
      case InSubsystem => CBUS
      case InCluster(clusterId) => CCBUS(clusterId)
    }
  ), useVxCache)
}

class WithRadianceGemmini(location: HierarchicalLocation,
                          crossing: RocketCrossingParams,
                          dim: Int, accSizeInKB: Int, tileSize: Int) extends Config((site, _, up) => {
  case TilesLocated(`location`) => {
    val prev = up(TilesLocated(`location`))
    val idOffset = prev.size
    if (idOffset == 0) {
      println("******WARNING****** gemmini tile id is 0! radiance tiles in the same cluster needs to be before gemmini")
    }
    val numPrevGemminis = prev.map(_.tileParams).map {
      case _: GemminiTileParams => 1
      case _ => 0
    }.sum
    val smKey = site(RadianceSharedMemKey).get
    val tileParams = GemminiTileParams(
      gemminiConfig = GemminiFPConfigs.FP32DefaultConfig.copy(
        has_training_convs = false,
        has_max_pool = false,
        use_tl_ext_mem = true,
        sp_singleported = false,
        spad_read_delay = 4,
        use_shared_ext_mem = true,
        acc_sub_banks = 1,
        has_normalizations = false,
        meshRows = dim,
        meshColumns = dim,
        tile_latency = 0,
        dma_maxbytes = site(CacheBlockBytes),
        dma_buswidth = dim * 32,
        tl_ext_mem_base = smKey.address,
        sp_banks = smKey.numBanks,
        sp_capacity = CapacityInKilobytes(smKey.size >> 10),
        acc_capacity = CapacityInKilobytes(accSizeInKB),
      ),
      tileId = idOffset,
      tileSize = tileSize,
      slaveAddress = smKey.address + smKey.size + 0x3000 + 0x100 * numPrevGemminis
    )
    Seq(GemminiTileAttachParams(
      tileParams,
      crossing
    )) ++ prev
  }
}) {
  def this(location: HierarchicalLocation = InSubsystem, dim: Int, accSizeInKB: Int, tileSize: Int) =
    this(location, RocketCrossingParams(
      master = HierarchicalElementMasterPortParams.locationDefault(location),
      slave = HierarchicalElementSlavePortParams.locationDefault(location),
      mmioBaseAddressPrefixWhere = location match {
        case InSubsystem => CBUS
        case InCluster(clusterId) => CCBUS(clusterId)
      }
    ), dim, accSizeInKB, tileSize)
}

class WithRadianceSharedMem(address: BigInt,
                            size: Int,
                            numBanks: Int,
                            numWords: Int,
                            strideByWord: Boolean = true,
                            filterAligned: Boolean = true,
                            disableMonitors: Boolean = true,
                            serializeUnaligned: Boolean = true
                           ) extends Config((site, _, _) => {
  case RadianceSharedMemKey => {
    require(isPow2(size) && size >= 1024)
    Some(RadianceSharedMemKey(
      address, size, numBanks, numWords, 4, strideByWord,
      filterAligned, disableMonitors, serializeUnaligned
    ))
  }
})

class WithRadianceFrameBuffer(baseAddress: BigInt,
                              width: Int,
                              size: Int,
                              validAddress: BigInt,
                              fbName: String = "fb") extends Config((_, _, up) => {
  case RadianceFrameBufferKey => {
    up(RadianceFrameBufferKey) ++ Seq(
      RadianceFrameBufferKey(baseAddress, width, size, validAddress, fbName)
    )
  }
})

class WithFuzzerCores(
  n: Int,
  useVxCache: Boolean
) extends Config((site, _, up) => {
  case TilesLocated(InSubsystem) => {
    val prev = up(TilesLocated(InSubsystem))
    val idOffset = prev.size
    val fuzzer = FuzzerTileParams(
      core = VortexCoreParams(fpu = None),
      useVxCache = useVxCache)
    List.tabulate(n)(i => FuzzerTileAttachParams(
      fuzzer.copy(tileId = i + idOffset),
      RocketCrossingParams()
    )) ++ prev
  }
})

class WithRadianceCluster(
  clusterId: Int,
  location: HierarchicalLocation = InSubsystem,
  crossing: RocketCrossingParams = RocketCrossingParams()
) extends Config((site, here, up) => {
  case ClustersLocated(`location`) => up(ClustersLocated(location)) :+ RadianceClusterAttachParams(
    RadianceClusterParams(clusterId = clusterId),
    crossing)
  case TLNetworkTopologyLocated(InCluster(`clusterId`)) => List(
    ClusterBusTopologyParams(
      clusterId = clusterId,
      csbus = site(SystemBusKey),
      ccbus = site(ControlBusKey).copy(errorDevice = None),
      coherence = site(ClusterBankedCoherenceKey(clusterId))
    )
  )
  case PossibleTileLocations => up(PossibleTileLocations) :+ InCluster(clusterId)
})

// `nSrcIds`: number of source IDs for each mem lane.  This is for all warps
class WithSimtConfig(nWarps: Int = 4, nCoreLanes: Int = 4, nMemLanes: Int = 4, nSrcIds: Int = 8)
extends Config((site, _, up) => {
  case SIMTCoreKey => {
    Some(up(SIMTCoreKey).getOrElse(SIMTCoreParams()).copy(
      nWarps = nWarps,
      nCoreLanes = nCoreLanes,
      nMemLanes = nMemLanes,
      nSrcIds = nSrcIds
      ))
  }
})

class WithMemtraceCore(tracefilename: String, traceHasSource: Boolean = false)
extends Config((site, _, _) => {
  case MemtraceCoreKey => {
    require(
      site(SIMTCoreKey).isDefined,
      "Memtrace core requires a SIMT configuration. Use WithNLanes to enable SIMT."
    )
    Some(MemtraceCoreParams(tracefilename, traceHasSource))
  }
})

class WithPriorityCoalXbar extends Config((site, _, up) => {
  case CoalXbarKey => {
    Some(up(CoalXbarKey).getOrElse(CoalXbarParam))
  }
})

class WithVortexL1Banks(nBanks: Int = 4) extends Config ((site, here, up) => {
  case VortexL1Key => {
    Some(defaultVortexL1Config.copy(
      numBanks = nBanks,
      inputSize = up(SIMTCoreKey).get.nMemLanes * 4/*32b word*/,
      cacheLineSize = up(SIMTCoreKey).get.nMemLanes * 4/*32b word*/,
      memSideSourceIds = 16,
      mshrSize = 16,
    ))
  }
})

// When `enable` is false, we still elaborate Coalescer, but it acts as a
// pass-through logic that always outputs un-coalesced requests.  This is
// useful for when we want to keep the generated wire and net names the same
// to e.g. compare waveforms.
class WithCoalescer(nNewSrcIds: Int = 8, enable : Boolean = true) extends Config((site, _, up) => {
  case CoalescerKey => {
    val (nLanes, numOldSrcIds) = up(SIMTCoreKey) match {
      case Some(param) => (param.nMemLanes, param.nSrcIds)
      case None => (1,1)
    }

    val sbusWidthInBytes = site(SystemBusKey).beatBytes
    // FIXME: coalescer fails to instantiate with 4-byte bus
    require(sbusWidthInBytes > 2,
      "FIXME: coalescer currently doesn't instantiate with 4-byte sbus")

    // If instantiating L1 cache, the maximum coalescing size should match the
    // cache line size
    val maxCoalSizeInBytes = up(VortexL1Key) match {
      case Some(param) => param.inputSize
      case None => sbusWidthInBytes
    }
      
    // Note: this config chooses a single-sized coalescing logic by default.
    Some(DefaultCoalescerConfig.copy(
      enable       = enable,
      numLanes     = nLanes,
      numOldSrcIds = numOldSrcIds,
      numNewSrcIds = nNewSrcIds,
      addressWidth = 32, // FIXME hardcoded as 32-bit system
      dataBusWidth = log2Ceil(maxCoalSizeInBytes),
      coalLogSizes = Seq(log2Ceil(maxCoalSizeInBytes))
      )
    )
  }
})

class WithNCustomSmallRocketCores(
                             n: Int,
                             overrideIdOffset: Option[Int] = None,
                             crossing: RocketCrossingParams = RocketCrossingParams()
                           ) extends Config((site, here, up) => {
  case TilesLocated(InSubsystem) => {
    val prev = up(TilesLocated(InSubsystem))
    val idOffset = overrideIdOffset.getOrElse(prev.size)
    val med = RocketTileParams(
      core = RocketCoreParams(fpu = None),
      btb = None,
      dcache = Some(DCacheParams(
        rowBits = site(SystemBusKey).beatBits,
        nSets = 2,
        nWays = 1,
        nTLBSets = 1,
        nTLBWays = 2,
        nTLBBasePageSectors = 1,
        nTLBSuperpages = 1,
        nMSHRs = 0,
        blockBytes = site(CacheBlockBytes))),
      icache = Some(ICacheParams(
        rowBits = site(SystemBusKey).beatBits,
        nSets = 2,
        nWays = 1,
        nTLBSets = 1,
        nTLBWays = 2,
        nTLBBasePageSectors = 1,
        nTLBSuperpages = 1,
        blockBytes = site(CacheBlockBytes))))
    List.tabulate(n)(i => RocketTileAttachParams(
      med.copy(tileId = i + idOffset),
      crossing
    )) ++ prev
  }
})

class WithExtGPUMem(address: BigInt = BigInt("0x100000000", 16),
                    size: BigInt = 0x80000000) extends Config((site, here, up) => {
  case GPUMemory() => Some(GPUMemParams(address, size))
  case ExtMem => up(ExtMem).map(x => {
    val gap = address - x.master.base - x.master.size
    x.copy(master = x.master.copy(size = x.master.size + gap + size))
  })
})
case class GPUMemParams(address: BigInt = BigInt("0x100000000", 16), size: BigInt = 0x80000000)
case class GPUMemory() extends Field[Option[GPUMemParams]](None)

object RadianceSimArgs extends Field[Option[Boolean]](None)

class WithRadianceSimParams(enabled: Boolean) extends Config((_, _, _) => {
  case RadianceSimArgs => Some(enabled)
})
