# $RCSfile: makefile.gnu,v $
# $Revision: 1.1.6.2 $ $Date: 2004/01/25 22:58:16 $
# Copyright 2001-2003 The MathWorks, Inc.

#-------------------------------------------------------------------------------
# Makefile for RTDX Blocks
#  This will produce the necessary MEX files for 
#  "RTDX Blocks" for use with TI targets
#
# NOTE:1. This makefile must reside in ${MATLABROOT}/toolbox/ccslink/rtdxblks
#      2. It uses cygnusmake
#      3. PC-NT only
#
# To use on PC:
#
# 1) Open a dos prompt and run setmwe at your sandbox root (eg. d:\work\A\matlab)
#    This should set MATLABROOT to the appropriate path.
#
# 2) cd toolbox\ccslink\rtdxblks
#
# 3) cygnusmake -f makefile.gnu -Id:\work\A\matlab\makerules
#

include mexrules.gnu

# THIS PRODUCT IS WINDOWS-ONLY!
ifdef ISPC

ML_REL_ROOT         = ../../../..
DSPBLKS_DIR         = $(ML_REL_ROOT)/toolbox/dspblks
DSPBLKS_INCLUDE_DIR = $(DSPBLKS_DIR)/include
DSPBLKS_FIXPT_LIB_FILE  = $(DSPBLKS_DIR)/lib/win32/dsp_fixpt.lib
DSPBLKS_COMMON_LIB_FILE = $(DSPBLKS_DIR)/lib/win32/dsp_sim_common.lib
DSPBLKS_SIM_RT_LIB_FILE = $(DSPBLKS_DIR)/lib/win32/dsp_sim_rt.lib
DSPBLKS_DSPMEX      = $(DSPBLKS_DIR)/dspmex
FIXPTLIB  = $(ML_REL_ROOT)/lib/win32/libfixedpoint.lib

EXT_INC_DIR         = $(ML_REL_ROOT)/extern/include
TMW_SRC_INC_DIR     = $(ML_REL_ROOT)/src/include
TMW_LIB_DIR         = $(ML_REL_ROOT)/lib/win32
SL_INC_DIR          = $(ML_REL_ROOT)/simulink/include

rtdxblks_mex_cmd = $(MEX) $(MEXFLAGS) $< -I$(DSPBLKS_INCLUDE_DIR) -I$(TMW_SRC_INC_DIR) $(DSPBLKS_FIXPT_LIB_FILE) $(DSPBLKS_COMMON_LIB_FILE) $(DSPBLKS_SIM_RT_LIB_FILE) $(FIXPTLIB)

rtdxblks_sfcn_cmn_deps =   $(DSPBLKS_INCLUDE_DIR)/dsp_trailer.c     \
                           $(DSPBLKS_FIXPT_LIB_FILE)    \
                           $(DSPBLKS_SIM_RT_LIB_FILE)    \
                           $(DSPBLKS_COMMON_LIB_FILE)    \
                           $(SL_INC_DIR)/simstruc_types.h           \
                           $(SL_INC_DIR)/simulink.c                 \
                           $(SL_INC_DIR)/simstruc.h                 \
                           $(DEPENDS)                               \
                           makefile.gnu                             \
                           $(EXT_INC_DIR)/tmwtypes.h

rtdxblks_mex_comment = @echo --- Building RTDX block S-Function $@

# ------------------------------------------------------------
# TARGETS

all : rtdx_src.dll rtdx_snk.dll

# --------------------------------------------------------
# RULES
#

rtdx_src.dll : src/rtdx_src.c $(rtdxblks_sfcn_cmn_deps) $(DSPBLKS_FIXPT_LIB_FILE) $(DSPBLKS_COMMON_LIB_FILE) $(DSPBLKS_SIM_RT_LIB_FILE) 
	$(rtdxblks_mex_comment)
	$(rtdxblks_mex_cmd) 
	$(MAPCSF) $@

rtdx_snk.dll : src/rtdx_snk.c $(rtdxblks_sfcn_cmn_deps) $(DSPBLKS_FIXPT_LIB_FILE) $(DSPBLKS_COMMON_LIB_FILE) $(DSPBLKS_SIM_RT_LIB_FILE) 
	$(rtdxblks_mex_comment)
	$(rtdxblks_mex_cmd) 
	$(MAPCSF) $@

$(DSPBLKS_COMMON_LIB_FILE) :
	$(MAKE) -C $(DSPBLKS_DSPMEX) -I$(ML_REL_ROOT)/makerules -f makefile.gnu

$(DSPBLKS_FIXPT_LIB_FILE) :
	$(MAKE) -C $(DSPBLKS_DSPMEX) -I$(ML_REL_ROOT)/makerules -f makefile.gnu

$(DSPBLKS_SIM_RT_LIB_FILE) :
	$(MAKE) -C $(DSPBLKS_DSPMEX) -I$(ML_REL_ROOT)/makerules -f makefile.gnu


# --------------------------------------------------------
# Remove .dll's and .obj's 
clean : 
	$(RM) rtdx_src.dll rtdx_snk.dll

else

# Give empty target for Unix platforms.
all:

clean:

endif


	
# ==============================================================================
# [EOF] makefile.gnu
