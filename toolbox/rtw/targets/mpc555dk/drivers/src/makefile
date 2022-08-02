# $Revision: 1.1.4.2 $
# $Date: 2004/04/19 01:26:02 $
#
# Copyright 2002-2003 The MathWorks, Inc.
#
# Import the utility rules
#

.PHONY : default
default : all

COMPONENT=utility_rules
include $(COMPONENT_MANAGER)

.PHONY : all libsrc applications

all: libsrc applications

libsrc:
	$(MAKE) -C libsrc

applications:
	$(MAKE) -C applications

clean:
	$(MAKE) -C libsrc clean
	$(MAKE) -C applications clean

