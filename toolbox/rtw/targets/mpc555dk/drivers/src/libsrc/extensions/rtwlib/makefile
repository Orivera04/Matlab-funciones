# File : makefile
#
# Abstract :
# 	Builds a static version of the RTW libraries
#
# Copyright 2002-2003 The MathWorks, Inc.
#
# $Revision: 1.3.4.3 $
# $Date: 2004/04/19 01:25:24 $


LIBRARY = $(MATLABROOT)/rtw/c/lib/win32/rtwlib_5xx_$(MPC555_TOOL_CHAIN).a

INCLUDES+=-I$(MATLABROOT)/extern/include -I$(MATLABROOT)/simulink/include -I$(MATLABROOT)/rtw/c/libsrc
#
# Include the mpc555_build_rules component
#
MPC5XX_VARIANT=5XX
COMPONENT=mpc555_build_rules
include $(COMPONENT_MANAGER)
#
# Locate the CMF Driver directory 
#
RTWLIBDIR:=$(MATLABROOT)/rtw/c/libsrc

#
# List all the source files in the directory
#
LIBSRC:=$(notdir $(wildcard $(RTWLIBDIR)/*.c))


##
## Get a list of the object files
##
OBJECTS:=$(LIBSRC:.c=.o)
OBJECTS:=$(filter-out rt_logging.o,$(OBJECTS))
#
.PHONY : all
all: setup $(LIBRARY) 

vpath %.c $(RTWLIBDIR)

$(LIBRARY) : $(OBJECT_TARGETS) 
	$(LIBCMD) $(LIBRARY) $(OBJECT_TARGETS) 

$(OBJECT_TARGETS) : makefile
