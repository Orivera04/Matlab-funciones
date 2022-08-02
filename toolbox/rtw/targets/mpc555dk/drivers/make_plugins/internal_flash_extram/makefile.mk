# File: makefile.mk
#
#   Makefile for mpc555 application. 
#
# Usage:
#
# 	 MPC555_TOOL_CHAIN=DIAB
# 	 COMPONENT:=internal_flash_extram
# 	 include $(COMPONENT_MANAGER)
#
# 	 or
#
# 	 MPC555_TOOL_CHAIN=CODE_WARRIOR
# 	 COMPONENT:=internal_flash_extram
# 	 include $(COMPONENT_MANAGER)
#
# $Revision: 1.1.6.1 $
# $Date: 2004/04/08 20:57:57 $ 
#
# Copyright 2004 The MathWorks, Inc.

# Include the default compiler rules

ifndef __INTERNAL_FLASH_EXTRAM_COMPONENT__
__INTERNAL_FLASH_EXTRAM_COMPONENT__=defined

# This applications must be aware of the bootcode api which
# mean aquiring an exception table to be located in internal
# ram.
TARGET_MEMORY_MODEL=FLASH
include $(internal_flash_extram_DIR)/../mpc555_build_rules/memlayout.$(MPC5XX_VARIANT).prop
# FLASH_BASE_ADDR is used by CodeWarrior - need to make sure we locate
# the image in the application area
FLASH_BASE_ADDR:=$(bootrom_len)
COMPONENT=bootcode_aware
APPLICATION_EXCEPTION_FILE:=$(internal_flash_extram_DIR)/exceptions.xml
include $(COMPONENT_MANAGER)

# This application must have initialization code included
COMPONENT=initialization
include $(COMPONENT_MANAGER)

INTERNAL_FLASH_OBJECTS := copyappbios.o internal_flash_extram_init.o start.o 
OBJECTS += $(INTERNAL_FLASH_OBJECTS)


LINKER_COMMAND_FILE := $(internal_flash_extram_DIR)/internal_flash_extram.$(LINKER_COMMAND_FILE_EXT)

$(INTERNAL_FLASH_OBJECTS) : $(LINKER_COMMAND_FILE)

LINKER_COMMAND_FILE         :=internal_flash_extram.$(LINKER_COMMAND_FILE_EXT)
LINKER_COMMAND_FILE_TEMPATE :=$(internal_flash_extram_DIR)/$(LINKER_COMMAND_FILE).t
LINKER_COMMAND_FILE         :=$(OBJDIR)/$(LINKER_COMMAND_FILE)

$(LINKER_COMMAND_FILE) : $(LINKER_COMMAND_FILE_TEMPATE) $(MEMLAYOUT_PROPFILE) $(internal_flash_extram_DIR)/makefile.mk 
	@echo ----------------------------------------------------
	@echo Building $@
	@echo ----------------------------------------------------
	$(PERLTEMPLATE) -t=$<  -o=$@  -p=$(MEMLAYOUT_PROPFILE)


endif




