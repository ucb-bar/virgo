##############################################################
# extra variables/targets ingested by the chipyard make system
##############################################################

VORTEX_SRC_DIR = $(base_dir)/generators/radiance/src/main/resources/vsrc/vortex
RADPIE_SRC_DIR = $(base_dir)/generators/radiance/radpie
RADPIE_BUILD_DIR = $(RADPIE_SRC_DIR)/target/release

##################################################################
# THE FOLLOWING MUST BE += operators
##################################################################

# EXTRA_SIM_REQS += radpie
# EXTRA_SIM_LDFLAGS += -L$(RADPIE_BUILD_DIR) -Wl,-rpath,$(RADPIE_BUILD_DIR) -lradpie
ifeq ($(shell echo $(CONFIG) | grep -E "SynConfig$$"),$(CONFIG))
    EXTRA_SIM_PREPROC_DEFINES += +define+SYNTHESIS +define+NDEBUG +define+DPI_DISABLE
endif
EXTRA_SIM_PREPROC_DEFINES += \
	+define+SIMULATION \
	+define+GPR_RESET \
	+define+GPR_DUPLICATED \
	+define+DBG_TRACE_CORE_PIPELINE_VCS \
	+define+PERF_ENABLE \
	+define+ICACHE_DISABLE +define+DCACHE_DISABLE \
	+define+GBAR_ENABLE \
	+define+GBAR_CLUSTER_ENABLE \
	+define+FPU_FPNEW \
	+define+SMEM_LOG_SIZE=19
	# +define+LSU_DUP_DISABLE \

VCS_NONCC_OPTS += +vcs+initreg+random

# cargo handles building of Rust files all on its own, so make this a PHONY
# target to run cargo unconditionally
.PHONY: radpie
radpie:
	cd $(RADPIE_SRC_DIR) && cargo build --release

EXTRA_SIM_REQS += vortex_vsrc.$(CONFIG)
# below manipulation of VORTEX_VLOG_SOURCES doesn't work if we try to reuse
# $(call lookup_srcs) from common.mk, the variable doesn't expand somehow
ifeq ($(shell which fd 2> /dev/null),)
	VORTEX_VLOG_SOURCES := $(shell find -L $(VORTEX_SRC_DIR) -type f -iname "*.sv" -o -iname "*.vh" -o -iname "*.v")
else
	VORTEX_VLOG_SOURCES := $(shell fd -L -t f -e "sv" -e "vh" -e "v" . $(VORTEX_SRC_DIR))
endif
# VORTEX_COLLATERAL := $(patsubst $(VORTEX_SRC_DIR)%,$(GEN_COLLATERAL_DIR)%,$(VORTEX_VLOG_SOURCES))
# check if expanded
# $(info VORTEX_VLOG_SOURCES: $(VORTEX_VLOG_SOURCES))

# For every Vortex verilog source file, if there's a matching file in
# gen-collateral/, copy them over.  This is a hacky way to ensure the changes
# in the verilog sources are reflected before Verilator/VCS kicks in. This is
# necessary when common.mk does not trigger chipyard jar rebuild upon verilog
# source updates, in which case we need to manually ensure the up-to-date-ness
# of gen-collateral/.
vortex_vsrc.$(CONFIG): $(VORTEX_VLOG_SOURCES)
	@for file in $(VORTEX_VLOG_SOURCES); do \
		filename=$$(basename "$$file"); \
		if [ -f $(GEN_COLLATERAL_DIR)/$$filename ]; then \
			if ! diff $$file $(GEN_COLLATERAL_DIR)/$$filename &>/dev/null ; then \
				cp -v "$$file" $(GEN_COLLATERAL_DIR); \
			fi; \
		fi; \
	done
	touch $@
