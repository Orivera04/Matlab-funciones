# File: makefile
#
#   Makefile for mpc555 application. 
#
# Usage:
#
# 	 MPC555_TOOL_CHAIN=DIAB
# 	 MPC5XX_VARIANT=555 
# 	 COMPONENT:=internal_ram
# 	 include $(COMPONENT_MANAGER)
#
# 	 or
#
# 	 MPC555_TOOL_CHAIN=CODE_WARRIOR
# 	 MPC5XX_VARIANT=565 
# 	 COMPONENT:=internal_ram
# 	 include $(COMPONENT_MANAGER)
# 	 
# 	 etc 
#
# $Revision: 1.1.6.2 $
# $Date: 2004/04/19 01:24:37 $ 
#
# Copyright 2002-2003 The MathWorks, Inc.

# Include the default compiler rules

ifndef __INTERNAL_RAM_COMPONENT__
__INTERNAL_RAM_COMPONENT__=defined

# This applications must be aware of the bootcode api which
# mean aquiring an exception table to be located in internal
# ram.
TARGET_MEMORY_MODEL=RAM

# This application must have initialization code included
COMPONENT=mpc555_build_rules
include $(COMPONENT_MANAGER)

#
# Locate the linker command file and its template
#
LINKER_COMMAND_FILE_NAME    :=	internal_ram.$(LINKER_COMMAND_FILE_EXT)
LINKER_COMMAND_FILE_TEMPATE :=	$(internal_ram_DIR)/$(LINKER_COMMAND_FILE_NAME).t
LINKER_COMMAND_FILE         :=	$(OBJDIR)/$(LINKER_COMMAND_FILE_NAME)

#
# Rule to build linker command file.
#
$(LINKER_COMMAND_FILE) : $(LINKER_COMMAND_FILE_TEMPATE) $(MEMLAYOUT_PROPFILE) $(internal_ram_DIR)/makefile.mk 
	@echo ----------------------------------------------------
	@echo Building $@
	@echo ----------------------------------------------------
	$(PERLTEMPLATE) -t=$<  -o=$@  -p=$(MEMLAYOUT_PROPFILE)

endif




