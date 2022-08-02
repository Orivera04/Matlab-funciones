# $Revision: 1.1.4.3 $
# $Date: 2004/04/19 01:25:23 $
#
# Copyright 2002-2003 The MathWorks, Inc.
# Import the utility rules

COMPONENT=utility_rules
include $(COMPONENT_MANAGER)

# List the subdirectories to build libraries for
extensions = cmf_flash rtwlib dsplib

all : $(extensions)

.PHONY : $(extensions)
$(extensions) :
	$(MAKE) -C ./$@ all 


# Define a template for generating clean rules
define clean_template

clean : clean_$(1)

.PHONY : clean_$(1)
clean_$(1) :
	$(MAKE) -C $(1) clean 

endef

# Generate the clean rules
$(foreach ext, $(extensions),$(eval $(call clean_template,$(ext))))



