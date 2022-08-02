# File: makefile
#
# Abstract:
#   Makefile for bootcode
#
# $Revision: 1.22.6.5 $
# $Date: 2004/04/19 01:25:05 $
#
# Copyright 2001-2003 The MathWorks, Inc.

#
# Include the default mpc555 rules file
#
COMPONENT=utility_rules
include $(COMPONENT_MANAGER)

variants = 555 561 562 563 564 565 566
clean_variants = $(addprefix clean_,$(variants))

.PHONY : all $(variants)

all: $(variants)

$(variants) :
	$(MAKE) -f makefile.5xx all MPC5XX_VARIANT=$@ OSCILLATOR_FREQ=20000000
	$(MAKE) -f makefile.5xx all MPC5XX_VARIANT=$@ OSCILLATOR_FREQ=4000000


clean : $(clean_variants)
$(clean_variants) : 
	$(MAKE) -f makefile.5xx clean MPC5XX_VARIANT=$(subst clean_,,$@) OSCILLATOR_FREQ=20000000
