# File: makefile
#
# Abstract:
#   Makefile for bootcode
#
# $Revision: 1.1.6.4 $
# $Date: 2004/04/19 01:25:12 $
#
# Copyright 2002-2003 The MathWorks, Inc.

.PHONY : all 

variants = 555 561 562 563 564 565 566

all:
	$(MAKE) -f makefile.5xx MPC5XX_VARIANT=555 OSCILLATOR_FREQ=20000000
	$(MAKE) -f makefile.5xx MPC5XX_VARIANT=555 OSCILLATOR_FREQ=4000000
	$(MAKE) -f makefile.5xx MPC5XX_VARIANT=561
	$(MAKE) -f makefile.5xx MPC5XX_VARIANT=562
	$(MAKE) -f makefile.5xx MPC5XX_VARIANT=563
	$(MAKE) -f makefile.5xx MPC5XX_VARIANT=564
	$(MAKE) -f makefile.5xx MPC5XX_VARIANT=565
	$(MAKE) -f makefile.5xx MPC5XX_VARIANT=566


clean_variants = $(addprefix clean_,$(variants))
clean : $(clean_variants)
$(clean_variants) : 
	$(MAKE) -f makefile.5xx clean MPC5XX_VARIANT=$(subst clean_,,$@) OSCILLATOR_FREQ=20000000

