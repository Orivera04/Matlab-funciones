# File : makefile
#
# Abstract :
# 	Builds a static version of the RTW libraries 
#
# Copyright 2003-2004 The MathWorks, Inc.
#
# $Revision: 1.1.6.4 $
# $Date: 2004/04/19 01:18:48 $

ifndef MATLABROOT
# error works with later versions of gmake
$(error MATLABROOT must be defined to be the root location of MATLAB)
MATLABROOT=(MATLABROOT NOT DEFINED)
endif

ifndef C166ROOT
# error works with later versions of gmake
$(error C166ROOT must be defined to be the root location of the C166 Compiler)
C166ROOT=(C166ROOT NOT DEFINED)
endif

# Make dependency generator
.PHONY : default
default: all
include $(MATLABROOT)/toolbox/rtw/targets/common/tgtcommon/makedepend.mk

CC166   = $(C166ROOT)/bin/cc166
LIBCMD  = $(C166ROOT)/bin/ar166

# A default set of compiler flags
CFLAGS_DEFAULT = -Ms -Wcp-D_USMLIB= -Wc-xmifp -DCPUTYPE=0x167 -Wc-Bhoeufmknladij -Wc-OB -Wc-OE -Wc-zswitch_tabmem_default -Wc-zautobitastruct-4 -Wc-zautobita-0 -FSC -noc++ -Wc-A1 -Wc-zvolatile_union -Wc-O1 -Wc-g -Wc-s -WaWA"(1)" -WaEXTEND -WaNOM166 -WaSN"(reg167cs.def)"

# CFLAGS can be specified by the user
ifndef CFLAGS
COMBINED_CFLAGS = -c $(CFLAGS_DEFAULT) $(INCLUDES)
else
COMBINED_CFLAGS = -c $(CFLAGS) $(INCLUDES)
endif
# Name and location of rtwlib
STATIC_RTWLIB = $(MATLABROOT)/rtw/c/lib/win32/rtwlib_c166

INCLUDES=	-I$(MATLABROOT)/extern/include \
			 	-I$(MATLABROOT)/simulink/include \
			 	-I$(MATLABROOT)/rtw/c/libsrc \
				-Iinclude
#
# List all the source files in the directory
#
LIBSRC:=$(notdir $(wildcard $(MATLABROOT)/rtw/c/libsrc/*.c))

##
## Get a list of the object files
##
OBJECTS:=$(LIBSRC:.c=.obj)
OBJECTS:=$(filter-out rt_logging.obj,$(OBJECTS))
#

.PHONY : all DISP_CFLAGS
all: DISP_CFLAGS $(STATIC_RTWLIB).lib 

# rule to build object files
%.obj : $(MATLABROOT)/rtw/c/libsrc/%.c
	$(MAKEDEPEND)
	$(CC166) $(COMBINED_CFLAGS) $<

$(OBJECTS) : makefile

DISP_CFLAGS:
ifdef CFLAGS
	@echo -------------------------------------
	@echo
	@echo Extra command line CFLAGS = $(CFLAGS)
	@echo
	@echo -------------------------------------
else
	@echo --------------------------------------------------- 
	@echo
	@echo Set the CFLAGS variable to add extra compiler flags
	@echo
	@echo ---------------------------------------------------
endif

$(STATIC_RTWLIB).lib : $(OBJECTS)
	@echo ### Creating $@
	-rm $@
	$(LIBCMD) rc $@ $(OBJECTS)
	@echo ### Created $@

# clean the rtwlib
clean:
	-rm *.obj
