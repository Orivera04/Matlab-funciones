# File: makefile
#
# Abstract:
#   Top level makefile to build all 
#   applications.
#
# $Revision: 1.1.4.2 $
# $Date: 2004/04/19 01:25:14 $
#
# Copyright 2002-2003 The MathWorks, Inc.

.PHONY : default all

default : all

COMPONENT=utility_rules
include $(COMPONENT_MANAGER)

all : 
	$(PERL) makefile.pl > make_applications.mk
	$(MAKE) -f make_applications.mk 


clean :
	$(PERL) makefile.pl > make_applications.mk
	$(MAKE) -f make_applications.mk clean 

