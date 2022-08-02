# File: component_manager.mk
#
# Abstract:
#   This makefile is the interface to a number of application templates defined
#   for the MPC555. An application template is a set of startup files and compiler
#   directives to build an application. They are not applications themselves but
#   are frameworks for specific memory layouts and board support packages.
#
# Imports:
#   COMPONENT				: name of components to use
#
# $Revision: 1.1.4.2 $
# $Date: 2004/04/19 01:24:20 $ 
#
# Copyright 2002-2003 The MathWorks, Inc.

#
# $(COMPONENT)_DIR is used by the specific template. For example in the
# directory initialization the makefile referes to the variable
# initialization_DIR to know how to refer to files and directories relative to
# its own locations
#
export $(COMPONENT)_DIR := $(MPC555_DRIVERS_ROOT)/make_plugins/$(COMPONENT)
export COMPONENT_DIR 	:= $(MPC555_DRIVERS_ROOT)/make_plugins/$(COMPONENT)
export COMPONENT_MANAGER:= $(MPC555_DRIVERS_ROOT)/make_plugins/component_manager.mk


#
# Add the template directories to the INCLUDES variable
#
ifeq ($(findstring $(COMPONENT),$(PROCESSED_COMPONENTS)),) 
    # Only include add an include directory to the includes path
	# if it has not been added before
    PROCESSED_COMPONENTS += $(COMPONENT)
ifneq ($(wildcard $(COMPONENT_DIR)/*.h*),)
	# Only add paths that have header files
    INCLUDES += -I$(COMPONENT_DIR)
endif
	# Force the immediate evaluation of COMPONENT and COMPONENT_DIR.
	# If we allow lazy evaluation then this process does not work.
    PROCESSED_COMPONENTS := $(PROCESSED_COMPONENTS) 
    INCLUDES := $(INCLUDES) 
endif

vpath %.c $(COMPONENT_DIR)

vpath %.cpp $(COMPONENT_DIR)

vpath %.s $(COMPONENT_DIR)

#
# Include the specific template directory
#
include $(COMPONENT_DIR)/makefile.mk

.PHONY : $(COMPONENT_DIR)/makefile.mk
