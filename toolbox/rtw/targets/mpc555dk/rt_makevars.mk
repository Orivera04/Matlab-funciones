# File: toolbox/rtw/targets/mpc555dk/rt_makevars.mk
#
# Abstract:
#   Define variables used by the build process
#
# $Revision: 1.19.2.5 $
# $Date: 2004/04/19 01:30:38 $
#
# Copyright 2001-2003 The MathWorks, Inc.

##############################################################
# Requires definition of:
# - MATLABROOT
#   or
# - MATLAB_ROOT
##############################################################
ifdef MATLAB_ROOT
  export MATLABROOT:=$(MATLAB_ROOT)
else
	ifndef MATLABROOT
		MATLABROOT = ???<MATLABROOT_NOT_DEFINED>???
	else
		export MATLAB_ROOT=$(MATLABROOT)
	endif
endif

##############################################################
# Local symbols:
##############################################################
ifndef MPC555DK_ROOT
  MPC555DK_ROOT = $(MATLABROOT)/toolbox/rtw/targets/mpc555dk
endif

##############################################################
# Exported symbols:
##############################################################
ifndef DIABBIN
  DIABBIN         = $(DIABROOT)/WIN32/BIN
endif

ifndef DCONFIG
  DCONFIG         = $(DIABROOT)/conf/dtools.conf
endif

export DIAB_ERT_ROOT = $(MPC555DK_ROOT)/rt
export SLIB_CAN_ROOT = $(MPC555DK_ROOT)/common/canlib
export MPC555_DRIVERS_ROOT   = $(MPC555DK_ROOT)/drivers
export MPC555DK_ROOT
export DIABROOT
export DIABBIN
export DCONFIG

export MAKEVARS_MPC_DEFINED = 1



