# File : makefile
#
# Abstract : makefile for the internal flash test file
#
# $Revision: 1.2.4.3 $
# $Date: 2003/12/11 03:48:56 $
#
# Copyright 1990-2003 The MathWorks, Inc.
#

variants = 555 561 562 563 564 565 566
clean_variants = $(addprefix clean_,$(variants))

.PHONY : $(variants)
all: $(variants)

$(variants) :
		$(MAKE) -f makefile.5xx MPC5XX_VARIANT=$@


clean : $(clean_variants)
$(clean_variants) : 
	$(MAKE) -f makefile.5xx clean MPC5XX_VARIANT=$(subst clean_,,$@) OSCILLATOR_FREQ=20000000



