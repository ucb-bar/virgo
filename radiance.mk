##############################################################
# extra variables/targets ingested by the chipyard make system
##############################################################

RADPIE_SRC_DIR = $(base_dir)/generators/radiance/radpie
RADPIE_BUILD_DIR = $(RADPIE_SRC_DIR)/target/release

##################################################################
# THE FOLLOWING MUST BE += operators
##################################################################

# EXTRA_SIM_REQS += radpie
EXTRA_SIM_LDFLAGS += -L$(RADPIE_BUILD_DIR) -Wl,-rpath,$(RADPIE_BUILD_DIR) -lradpie
ifeq ($(shell echo $(CONFIG) | grep -E "SynConfig$$"),$(CONFIG))
    EXTRA_SIM_PREPROC_DEFINES += +define+SYNTHESIS +define+NDEBUG +define+DPI_DISABLE
endif
EXTRA_SIM_PREPROC_DEFINES += \
	+define+SIMULATION \
	+define+GPR_RESET \
	+define+LSU_DUP_DISABLE \
	+define+DBG_TRACE_CORE_PIPELINE_VCS \
	+define+PERF_ENABLE \
	+define+ICACHE_DISABLE +define+DCACHE_DISABLE \
	+define+GBAR_ENABLE \
	+define+GBAR_CLUSTER_ENABLE \
	+define+NUM_FPU_BLOCKS=2 \
	+define+EXT_T_DISABLE \
	+define+FPU_FPNEW \
	+define+SMEM_LOG_SIZE=17

VCS_NONCC_OPTS += +vcs+initreg+random

# cargo handles building of Rust files all on its own, so make this a PHONY
# target to run cargo unconditionally
.PHONY: radpie
radpie:
	cd $(RADPIE_SRC_DIR) && cargo build --release
