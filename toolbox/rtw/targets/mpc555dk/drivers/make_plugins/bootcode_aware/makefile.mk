# File: makefile.mk
#
# Abstract:
#	Bootcode aware module makefile
# 	Creates an exception handling table at the start of application
# 	memory. The bootcode forwards all exceptions to this table. The
# 	user specifies which exceptions they wish to handle using a simple
# 	xml file. 
#
# $Revision: 1.1.6.4 $
# $Date: 2004/04/19 01:24:19 $
#
# Copyright 2002-2004 The MathWorks, Inc.

# Usage:
#
# COMPONENT=bootcode_aware
# APPLICATION_EXCEPTION_FILE=my_exceptions.xml
# include $(COMPONENT_MANAGER)
#
# See the xsl file for more details
#
#
ifndef __BOOTCODE_AWARE_COMPONENT__
__BOOTCODE_AWARE_COMPONENT__=defined


COMPONENT=mpc555_build_rules
include $(COMPONENT_MANAGER)


# Mergedoc requires the full path to the file $<
define create-application-exceptions
	$(SAXON) -o $@ $(bootcode_aware_DIR)/exception_defaults.xml \
      $(bootcode_aware_DIR)/exceptions.xsl \
	  mergedoc=file:///$(subst .,$(CURDIR),$(<D))/$(<F) 
endef

# A rule to build the application exception table that
# lives at the start of the application image. The
# rule is for a specific file name.
#
# This will work for application_exceptions that are in the
# current directory. If you wish to make a component that
# defines the exception table you will need to define the
# variable
#
# APPLICATION_EXCEPTION_LOCATION := <full path to exception file>
# wish to overide this then they should create add a
# dependency rule that will locate the application_exceptions.xml as
# this default rule will only find the file in the current directory
# and it's name will be forced to be application_exceptions.xml
ifndef APPLICATION_EXCEPTION_FILE
	APPLICATION_EXCEPTION_FILE=application_exceptions.xml
	OBJECTS+=application_exceptions.o
else
	OBJECTS+=$(notdir $(patsubst %.xml,%.o,$(APPLICATION_EXCEPTION_FILE)))
endif

	OBJECTS+=dec_handler.o

_ASSEMBLY_APPLICATION_EXCEPTION_FILE := $(notdir $(patsubst %.xml,%.s,$(APPLICATION_EXCEPTION_FILE)))

$(_ASSEMBLY_APPLICATION_EXCEPTION_FILE) : $(APPLICATION_EXCEPTION_FILE)
	$(create-application-exceptions)



endif
