# File: toolbox/rtw/targets/mpc555dk/rt/blockset/tlc_c/makefile
#
# Abstract:
#   Makefile for s-functions related to MPC555 I/O drivers
#
# $Revision: 1.16.4.6 $
# $Date: 2004/04/19 01:30:09 $
#
# Copyright 2001-2004 The MathWorks, Inc.

##############################################################
# Import global macro definitions:
# - MATLABROOT
# - DIAB_ERT_ROOT
# - SLIB_CAN_ROOT
##############################################################
.PHONY: default clean all 

default: all 

ifndef MAKEVARS_MPC_DEFINED
  include ..\..\..\rt_makevars.mk
endif

# ################
# Usefull macros
# ################

SFUN_DIR = ..
OBJDIR   = bin

INCLUDES += -I$(MATLABROOT)/extern/include \
            -I$(MATLABROOT)/simulink/include

##############################################################
# Specify source files to be built (using MEX):
##############################################################

############################################################ 
# -- The following SFunctions require extra source files ---
############################################################ 
SFUNCTIONS1 := $(addprefix $(SFUN_DIR)/, \
	sfun_register_irq_level.dll \
	sfun_xtra_bitop.dll \
	sfun_enforce_real.dll \
	sfun_mdlstart_fcn.dll \
	sfun_tpu3_pwm.dll \
	sfun_tpu3_dig_out.dll \
	sfun_tpu3_dig_in.dll \
	sfun_tpu3_fqd.dll \
	sfun_tpu3_nitc.dll \
	sfun_tpu3_pta.dll \
	qsmcm_sci_rx.dll \
	qsmcm_sci_tx.dll \
	qsmcm_sci_status.dll \
	sfun_ccp_mpc555_rtwmakecfg.dll \
	)

# Extra dependencies
$(SFUNCTIONS1) :

SFUNCTIONS += $(SFUNCTIONS1)

############################################################ 
# -- The following SFunctions require extra source files ---
############################################################ 
SFUNCTIONS2 := $(addprefix $(SFUN_DIR)/, \
    sfun_mpc555_can_rx.dll \
    sfun_mpc555_can_tx.dll \
	)

# Extra dependencies
$(SFUNCTIONS2) : $(addprefix $(OBJDIR)/,sfun_can_util.obj can_msg.obj)

SFUNCTIONS += $(SFUNCTIONS2)

CAN_DATATYPES   := $(MATLABROOT)/toolbox/rtw/targets/common/can/datatypes
INCLUDES        += -I$(CAN_DATATYPES)

# -- Locate the extra sources --- 
vpath			sfun_can_util.c 	$(CAN_DATATYPES)
vpath			can_msg.c 			$(CAN_DATATYPES)

##############################################################
# Define MEX
##############################################################

MEX    		= $(MATLABROOT)/bin/win32/mex.bat $(INCLUDES) -f $(MATLABROOT)/bin/win32/mexopts/mexopts.bat
MEXC   		= $(MEX) -c

##############################################################
# TARGETS:
##############################################################

# Setup this makefile for makedepend
include $(MATLABROOT)/toolbox/rtw/targets/common/tgtcommon/makedepend.mk

# Loads some utilty functions for make
COMPONENT = utility_rules
include $(MATLABROOT)/toolbox/rtw/targets/mpc555dk/drivers/make_plugins/component_manager.mk

all : $(OBJDIR) $(SFUNCTIONS)
	@echo -----------------------------------------------------
	@echo Completed [$^] in $(CURDIR) 
	@echo -----------------------------------------------------

# Create the object directory if it does not exist
$(OBJDIR) :
	$(MKDIR) $(OBJDIR)

# SFUNCTIONS depend on the makedile
$(SFUNCTIONS) : makefile

# Everything in the objects directory depends on makefile
$(wildcard $(OBJDIR)/*) : makefile 

# -- Pattern rules ---

define display-status
	@echo ---------------------------------
	@echo Building $@
	@echo ---------------------------------
endef


# Command to build an object file
define build-obj
	$(display-status)
	$(MAKEDEPEND)
	$(MEXC) -outdir $(@D) $<
endef

# Command to build a dll from a source file and a list of
# object files.
#
# Assumes that $< will refer to a C or C++ file so
# that that MAKEDEPEND will work
define build-dll
	$(display-status)
	$(MAKEDEPEND)
	$(MEX) -outdir $(@D) $< $(filter %.obj, $^ )
endef

$(OBJDIR)/%.obj : %.c
	$(build-obj)

$(OBJDIR)/%.obj : %.cpp
	$(build-obj)

$(SFUN_DIR)/%.dll : %.c 
	$(build-dll)

$(SFUN_DIR)/%.dll : %.cpp 
	$(build-dll)

clean: 
	-rm $(SFUNCTIONS)
	-rm dependencies.mk
