# File: makefile
#
# Abstract:
# 	The module for building auto_flash applications.  
#
# $Revision: 1.1 $
# $Date: 2002/09/13 09:03:08 $ 
#
# Copyright 2002 The MathWorks, Inc.

# Usage :
#
#  Create a makefile like
#
##################################################
#  COMPONENT = auto_flash
#  AUTO_FLASH_FILE = application.s19
#  include $(COMPONENT_MANAGER)
#
#  all : auto_flash
##################################################
#
#  The variables AUTO_FLASH_FILE points to the
#  srecord you wish to build into a self flashing
#  utility. The compression utility on average
#  manages about 20%-25% compression. Considering
#  the auto_flash driver functions themselves take
#  up some space the application you are trying to
#  flash should not take up more than 26k of memory.
#

# Include the default compiler rules

ifndef __AUTO_FLASH_COMPONENT__
__AUTO_FLASH_COMPONENT__=1

TARGET_MEMORY_MODEL=RAM

#
# Include the default mpc555 rules file
#
COMPONENT=mpc555_build_rules
include $(COMPONENT_MANAGER)

OBJECTS += main.o \
           srec_c.o \
           huff_decode.o

#
# Overide or add to the standard application
# make variables and then call the 'application'
# rule defined in application.mk
#
LINKER_COMMAND_FILE=$(auto_flash_DIR)\auto_flash.$(LINKER_COMMAND_FILE_EXT)

srec_c.c : $(AUTO_FLASH_FILE) $(auto_flash_DIR)\huff.pm $(auto_flash_DIR)\srec2c.pl
	$(PERL) -I$(auto_flash_DIR) $(auto_flash_DIR)\srec2c.pl $(AUTO_FLASH_FILE) srec_c

main.o : srec_c.c $(auto_flash_DIR)/huff_decode.h

.PHONY : auto_flash
auto_flash : auto_flash.s19

auto_flash.s19 : $(OBJECTS)
	$(build-srec-file)

clean : general_clean
	-$(RM) srec_c.c srec_c.h

endif




