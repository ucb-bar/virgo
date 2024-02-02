##############################################################
# extra variables/targets ingested by the chipyard make system
##############################################################

##################################################################
# THE FOLLOWING MUST BE += operators
##################################################################

RADPIE_SRC_DIR = $(base_dir)/generators/radiance/radpie
RADPIE_BUILD_DIR = $(RADPIE_SRC_DIR)/target/release

EXTRA_SIM_REQS += radpie
EXTRA_SIM_LDFLAGS += -L$(RADPIE_BUILD_DIR) -Wl,-rpath,$(RADPIE_BUILD_DIR) -lradpie
EXTRA_SIM_PREPROC_DEFINES += \
	+define+SIMULATION \
	+define+SV_DPI \
	+define+GPR_RESET \
	+define+DBG_TRACE_CORE_PIPELINE_VCS

# cargo handles building of Rust files all on its own, so make this a PHONY
# target to run cargo unconditionally
.PHONY: radpie
radpie:
	cd $(RADPIE_SRC_DIR) && cargo build --release
