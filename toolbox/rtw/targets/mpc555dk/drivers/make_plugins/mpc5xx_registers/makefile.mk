# This directory is just for the mpc555 register definition files
#
# $Revision: 1.1.6.3 $
# $Date: 2004/04/19 01:24:47 $
#
# Copyright 2002-2003 The MathWorks, Inc.
#

# Declare a list of supported 5xx variants supported
# by our product
SUPPORTED_VARIANTS = 5XX 555 561 562 563 564 565 566

# Declare an error string
variant-error = $(error Please define MPC5XX_VARIANT to be one of { $(SUPPORTED_VARIANTS) } )

# If MPC5XX_VARIANT has not been defined then throw an error
ifndef MPC5XX_VARIANT
   $(variant-error)
endif

# If MPC5XX_VARIANT is not on the list of SUPPORTED_VARIANTS then throw an error
ifeq ($(findstring $(MPC5XX_VARIANT),$(SUPPORTED_VARIANTS)),) 
   $(variant-error)
endif

# Generate a compiler flag to define the processor variant
CFLAGS += -DMPC$(MPC5XX_VARIANT)_VARIANT
ASFLAGS += -DMPC$(MPC5XX_VARIANT)_VARIANT
