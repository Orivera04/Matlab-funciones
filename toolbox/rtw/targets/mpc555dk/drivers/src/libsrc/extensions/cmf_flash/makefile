# Makefile for CMF and C3F Flash Drivers
#
# Architecture Overview
#
# flash_driver.h ( Find this in the libsrc/standard/include directory )
# 		Defines the high level interface into the flash drivers for any processor
# 		variant
#
# flash_interface.h
# flash_interface.c
# 		Implementation of the high level flash API.
#
# cmf_flash.h
# cmf_flash.c
# 		Implementation of lower level flash API into the
# 		CMF drivers. This provides an interface that high level
# 		flash_interface can use.
#
# c3f_flash.h
# c3f_flash.c
# 	   Implementation of lower level flash API into the
# 	   3CF drivers. This provides an interface that high level 
# 	   flash_interface can use
#
# Copyright 2002-2003 The MathWorks, Inc.
.PHONY : all

all : 
	$(MAKE) -f makefile.cmf 	MPC5XX_VARIANT=555 all
	$(MAKE) -f makefile.custom MPC5XX_VARIANT=561 all
	$(MAKE) -f makefile.custom MPC5XX_VARIANT=562 all
	$(MAKE) -f makefile.c3f 	MPC5XX_VARIANT=563 all
	$(MAKE) -f makefile.c3f 	MPC5XX_VARIANT=564 all
	$(MAKE) -f makefile.c3f 	MPC5XX_VARIANT=565 all
	$(MAKE) -f makefile.c3f 	MPC5XX_VARIANT=566 all

clean :
	$(MAKE) -f makefile.cmf 	MPC5XX_VARIANT=555 clean 
	$(MAKE) -f makefile.custom MPC5XX_VARIANT=561 clean
	$(MAKE) -f makefile.custom MPC5XX_VARIANT=562 clean
	$(MAKE) -f makefile.c3f 	MPC5XX_VARIANT=563 clean
	$(MAKE) -f makefile.c3f 	MPC5XX_VARIANT=564 clean
	$(MAKE) -f makefile.c3f 	MPC5XX_VARIANT=565 clean
	$(MAKE) -f makefile.c3f 	MPC5XX_VARIANT=566 clean
