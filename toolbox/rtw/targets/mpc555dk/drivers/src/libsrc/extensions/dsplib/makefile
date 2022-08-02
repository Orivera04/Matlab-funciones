# File : makefile
#
# Abstract :
# 	Builds a static version of the DSP libraries
#
# Copyright 2002 The MathWorks, Inc.
#
# $Revision: 1.1.6.5 $
# $Date: 2004/04/16 22:19:54 $
 
LIBRARY = $(MATLABROOT)/toolbox/dspblks/lib/win32/dsp_dyn_rt_5xx_$(MPC555_TOOL_CHAIN).a

INCLUDES+=-I$(MATLABROOT)/extern/include -I$(MATLABROOT)/simulink/include -I$(MATLABROOT)/rtw/c/libsrc -I$(MATLABROOT)/src/include
#
# Include the mpc555_build_rules component
#
MPC5XX_VARIANT=5XX
COMPONENT=mpc555_build_rules
include $(COMPONENT_MANAGER)

# include list of DSP dirs - defines DSPSRCDIRS
DSPSRCDIRFILE = dspsrcdirs.mk
include $(DSPSRCDIRFILE)

# Add MATLAB ROOT
DSPSRCDIRS_MOD:= $(foreach dspdir, $(DSPSRCDIRS), $(MATLABROOT)/$(dspdir))

##
## Get a list of the source files
##
SRCS := $(foreach dspdir, $(DSPSRCDIRS_MOD), $(notdir $(wildcard $(dspdir)/*.c )))

##
## Add the DSP blocks include path 
##
INCLUDES += -I$(MATLABROOT)/toolbox/dspblks/include
##
## Add the source directories to vpath
##
vpath %.c $(DSPSRCDIRS_MOD)

##
## Create a list of the object files
##
OBJECTS := $(SRCS:.c=.o)

# MATLABROOT/toolbox/dspblks/include
# is installed with the DSP Blockset - need to make a check for this here...

ifneq ($(wildcard $(MATLABROOT)/toolbox/dspblks/include),)
# DSP blockset exists
.PHONY : all
all: setup $(LIBRARY) 
else
# NO DSP blockset
all:
	@echo
	@echo ---------------------------------------------------------------------------
	@echo WARNING: RTW DSP Blockset Library was not built!
	@echo ---------------------------------------------------------------------------
	@echo Header files required to build the RTW DSP Blockset library were not found. 
	@echo Is the DSP Blockset installed?   If not, please ignore this warning.
	@echo ---------------------------------------------------------------------------
	@echo
endif

$(LIBRARY) : $(OBJECT_TARGETS) $(DSPSRCDIRFILE)
	$(LIBCMD) $(LIBRARY) $(OBJECT_TARGETS) 

$(OBJECT_TARGETS) : makefile
