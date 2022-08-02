# File: makefile.mk
#
# Abstract:
#   Makefile for mpc555 application. 
#
# Usage:
#
# 	 MPC555_TOOL_CHAIN=DIAB
# 	 COMPONENT:=external_ram
# 	 include $(COMPONENT_MANAGER)
#
# 	 or
#
# 	 MPC555_TOOL_CHAIN=CODE_WARRIOR
# 	 COMPONENT:=external_ram
# 	 include $(COMPONENT_MANAGER)
#
# $Revision: 1.1.4.4 $
# $Date: 2004/04/19 01:24:24 $ 
#
# Copyright 2002-2004 The MathWorks, Inc.

# Include the default compiler rules

ifndef __EXTERNAL_RAM_COMPONENT__
__EXTERNAL_RAM_COMPONENT__=defined

# This applications must be aware of the bootcode api which
# mean aquiring an exception table to be located in internal
# ram.
TARGET_MEMORY_MODEL=RAM
APPLICATION_EXCEPTION_FILE:=$(external_ram_DIR)/exceptions.xml
COMPONENT=bootcode_aware
include $(COMPONENT_MANAGER)

# This application must have initialization code included
COMPONENT=initialization
include $(COMPONENT_MANAGER)


EXTERNAL_RAM_OBJECTS := copyappbios.o external_ram_init.o start.o

OBJECTS += $(EXTERNAL_RAM_OBJECTS)


$(EXTERNAL_RAM_OBJECTS) : $(LINKER_COMMAND_FILE)

LINKER_COMMAND_FILE         :=external_ram.$(LINKER_COMMAND_FILE_EXT)
LINKER_COMMAND_FILE_TEMPATE :=$(external_ram_DIR)/$(LINKER_COMMAND_FILE).t
LINKER_COMMAND_FILE         :=$(OBJDIR)/$(LINKER_COMMAND_FILE)

$(LINKER_COMMAND_FILE) : $(LINKER_COMMAND_FILE_TEMPATE) $(MEMLAYOUT_PROPFILE) $(external_ram_DIR)/makefile.mk
	@echo ----------------------------------------------------
	@echo Building $@
	@echo ----------------------------------------------------
	$(PERLTEMPLATE) -t=$<  -o=$@  -p=$(MEMLAYOUT_PROPFILE)

endif




