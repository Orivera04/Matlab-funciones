# File: toolbox/rtw/targets/mpc555dk/common/drivers/bootcode/makefile
#
# Abstract:
#   Makefile for the bootcode autoflash file.
#
#   This compresses the bootcode srecord file and merges
#   it with an executable containing flash drivers. The
#   executable then runs from internal memory writing
#   to bootcode to internal flash
#
# $Revision: 1.1.6.2 $
# $Date: 2004/04/19 01:24:54 $
#
# Copyright 2002-2003 The MathWorks, Inc.

#
# Add some more object files for the
# initialization code
#
OBJECTS += auto_flash_init.o 

#
# Force debugging on
#
CFLAGS += -g

#
# Include the initialization template
#
COMPONENT:=initialization
include $(COMPONENT_MANAGER)

#
# Include the autoflash template
#
COMPONENT:=auto_flash
#
# Specify the file we wish to autoflash
#
AUTO_FLASH_FILE=../bootcode.s19
include $(COMPONENT_MANAGER)

.PHONY : all
all : auto_flash 
	$(CP) auto_flash.elf ..


clean : general_clean


