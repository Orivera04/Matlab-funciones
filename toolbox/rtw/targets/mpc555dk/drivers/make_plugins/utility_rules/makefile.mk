# File: makefile.mk
#
# Abstract:
#		 Defines some commands usefull to the make process
#
# Imports :
# 	    MATLABROOT - The root of the matlab directory
#
# Exports :
#
# 		PERL
# 		MAKE
# 		CP
# 		MV
# 		RM
# 		MKDIR
# 		PRINT
#
# $Revision: 1.6.6.5 $
# $Date: 2004/04/19 01:24:50 $
#
# Copyright 2002-2004 The MathWorks, Inc.
#

ifndef __UTILITY_RULES__
__UTILITY_RULES__=defined

# For somereason the PERL glob command does not work unless this is done
PERLBIN:=$(MATLABROOT)/sys/perl/win32/bin

#
# Adding PERLBIN to the path
#
ifndef PATH
ifdef Path
PATH=$(Path)
else
ifdef path
PATH=$(path)
endif
endif
endif
export PATH := $(PATH);$(PERLBIN)
path:=$(PATH)
Path:=$(PATH)
export PATH
export Path
export path

# #############################################
# Define some OS interaction variables
PERL 	  = $(MATLABROOT)/sys/perl/win32/bin/perl.exe -I$(MATLABROOT)/toolbox/rtw/targets/mpc555dk/bin/win32/perl/lib 
MAKE    = $(MATLABROOT)/toolbox/rtw/targets/mpc555dk/bin/win32/make.exe 
CP      = cmd /C copy    
MV      = cmd /C move
RM      = $(PERL) $(utility_rules_DIR)/rm.pl
MKDIR   = $(PERL) $(utility_rules_DIR)/mkdir.pl 
DIE     = $(PERL) -e 'die "/n"'
JREVER := $(shell $(PERL) $(utility_rules_DIR)/jrever.pl $(MATLABROOT))
JAVA   := $(MATLABROOT)/sys/java/jre/win32/jre$(JREVER)/bin/java.exe
PERLTEMPLATE := $(PERL) $(utility_rules_DIR)/template.pl


SAXON   = $(JAVA) -jar "$(MATLABROOT)/java/jarext/saxon.jar" 
SWIG    = $(MATLABROOT)/toolbox/rtw/targets/mpc555dk/internal/SWIG-1.3.13/swig.exe
PRINT   = $(PERL) $(utility_rules_DIR)/print.pl
READ    = $(PERL) -e "open FH,shift;@l=<FH>;print @l;"
REGEXPREP = $(PERL) $(utility_rules_DIR)/regexprep.pl
include $(MATLABROOT)/toolbox/rtw/targets/common/tgtcommon/makedepend.mk





endif
