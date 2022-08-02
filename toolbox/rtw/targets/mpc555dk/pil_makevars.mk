# File: pil_makevars.mk
#
# Abstract:
#
#
# $Revision: 1.7.4.2 $
# $Date: 2004/04/19 01:28:18 $
#
# Copyright 2001-2003 The MathWorks, Inc.

#
# INTERNAL FILE, NOT FOR RELEASE.
# This file is used by the BAT build process.
#
ifndef MAKEVARS_MPC_DEFINED
  include rt_makevars.mk
endif

export MPC555DK_PIL_INTERNAL 	= $(MPC555DK_ROOT)/pil/internal
export PHYCORE_TMW_BSP		= $(MPC555DK_PIL_INTERNAL)/BSPs/phyCore-555
export PHYCORE_DIST_BSP	= $(MPC555DK_ROOT)/pil/BSPs/phyCore-555
