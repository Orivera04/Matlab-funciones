# File: makefile.mk
#
# Abstract:
#   Makefile plugin for mpc555 flash_drivers
#
# Imports
#
# 	MPC5XX_VARIANT	-	555 565 etc
# 	OSCILLATOR_FREQ -   20000000 4000000
#
# Usage:
#
# 	 MPC5XX_VARIANT=555
# 	 OSCILLATOR_FREQ=20000000
# 	 COMPONENT:=flash_driver
# 	 include $(COMPONENT_MANAGER)
#
# 	 or
#
# 	 MPC5XX_VARIANT=555
# 	 OSCILLATOR_FREQ=4000000
# 	 COMPONENT:=flash_driver
# 	 include $(COMPONENT_MANAGER)

# $Revision: 1.1.6.1 $
# $Date: 2003/07/31 18:05:53 $ 
#
# Copyright 2003 The MathWorks, Inc.

ifndef __FLASH_DRIVER_COMPONENT__
__FLASH_DRIVER_COMPONENT__=defined

ifndef MPC5XX_VARIANT
$(error MPC5XX_VARIANT must be defined)
endif

ifeq ($(MPC5XX_VARIANT),555)
# Only the 555 variant requires special handling for
# the osscilator frequency. The other variants use the
# new c3f drivers which are osscilator frequency
# independent


#
# Locate the CMF Driver directory 
#
FLASH_LIBSRC_DIR=$(MPC555DK_ROOT)/drivers/src/libsrc/extensions/cmf_flash
CMFDIR:=$(FLASH_LIBSRC_DIR)/General_Market_CMF_Driver_V3.0.3
PREBUILT_DATA_ROOT_DIR:=$(CMFDIR)/MPC555/data_generator/prebuiltdata
CMF_DATA_FILE_DIR = $(PREBUILT_DATA_ROOT_DIR)/gmd_osc04_sys20

# Check OSCILLATOR_FREQ is defined
ifndef OSCILLATOR_FREQ
   $(error Please define OSCILLATOR_FREQ to be either 20000000 or 4000000)
endif

# Check OSCILLATOR_FREQ is one of the two correct values
ifneq ($(OSCILLATOR_FREQ),20000000)
   ifneq ($(OSCILLATOR_FREQ),4000000)
    $(error Please define OSCILLATOR_FREQ to be either 20000000 or 4000000. It is currently defined as $(OSCILLATOR_FREQ))
   endif
endif

# Choose the correct data file for the specified osscilator frequency
ifeq ($(OSCILLATOR_FREQ),20000000)
   CMF_DATA_FILE_DIR = $(PREBUILT_DATA_ROOT_DIR)/gmd_osc20_sys20
else
   CMF_DATA_FILE_DIR = $(PREBUILT_DATA_ROOT_DIR)/gmd_osc04_sys20
endif

# For MPC555 variant there will be a 20MHz and a 4MHz build
OSC_SUFFIX = _osc$(patsubst %000000,%,$(OSCILLATOR_FREQ))

# Copy the data file to the build directory
DATA_FILE_NAME 	 				= gmd_ppc_cmf_300_A61_200
DATA_FILE_SOURCE 				= $(CMF_DATA_FILE_DIR)/$(DATA_FILE_NAME).c
DATA_FILE_INTERMEDIATE_SOURCE 	= $(DATA_FILE_NAME)$(OSC_SUFFIX).c

# Check OBJDIR is defined. It always should be
ifndef OBJDIR
$(error OBJDIR has not yet been defined.)
endif

# Define a rule to copy the data file to the build directory
# under a new name marked by the oscillator frequency
$(OBJDIR)/$(DATA_FILE_INTERMEDIATE_SOURCE) : $(DATA_FILE_SOURCE)
	@echo ------------------------------------------------
	@echo Building $@
	@echo ------------------------------------------------
	$(CP) $(subst /,\,$< $@)

vpath $(DATA_FILE_INTERMEDIATE_SOURCE) $(OBJDIR)

# Add the object to the object list
OBJECTS += $(DATA_FILE_INTERMEDIATE_SOURCE:.c=.o)

endif #def MPC5XX_VARIANT

endif #def __FLASH_DRIVER_COMPONENT__
