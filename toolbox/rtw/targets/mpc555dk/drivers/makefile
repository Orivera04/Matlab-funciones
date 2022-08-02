# File: makefile
#
# Abstract:
#   Top level makefile to build all driver code.
#
#   This files should be independent of whether
#   CodeWarrior or DIAB have been used.
#
#   See the comments lower down in the file on choosing
#   an MPC5xx processor variant to build the libraries
#   against.
#
# $Revision: 1.1.4.2 $
# $Date: 2004/04/19 01:24:53 $
#
# Copyright 2002-2003 The MathWorks, Inc.

.PHONY : default
default : all

#
# Declare the processor variant we are building the drivers for
#
ifndef MPC5XX_VARIANT
MPC5XX_VARIANT = 555
endif

#
# Declare where all the template are kept
#
export COMPONENT_MANAGER := $(MPC555_DRIVERS_ROOT)/make_plugins/component_manager.mk

#
# Import the utility rules
#
COMPONENT=utility_rules
include $(COMPONENT_MANAGER)

#--------------------------- Rules ---------------------------
.PHONY : all release clean src $(COMPONENT_MANAGER) 

#
# Default rule
#
all : src 
	@echo *********************************
	@echo *** [drivers makefile] complete
	@echo *********************************

src :
	$(MAKE) -C src


# ----------------------------------------------------------------------------------
#	Cleaning.
# ----------------------------------------------------------------------------------

clean: 
	$(MAKE) -C src clean
	@echo ***********************
	@echo *** Drivers Cleaned ***
	@echo ***********************

