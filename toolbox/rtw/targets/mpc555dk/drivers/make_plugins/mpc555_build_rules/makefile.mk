# File: makefile.mk
#
# Abstract:
# 		Sets up the rules for the specified toolchain
#
# Imports :
# 	   MATLAB_ROOT			-	Where matlab lives eg "d:\r13"
# 	   MPC555_DRIVERS_ROOT	-   Where the mpc555 drivers live
# 	   MPC555_TOOL_CHAIN    -   DIAB | CODE_WARRIOR
#
# 	   CWROOT 	- Root to CodeWarrior { if required }
# 	   DIABROOT	- Root to DIAB { if required }
#
# Exports :
#
# 	Most of these variables can be overloaded or added to once
# 	mpc555_rules.mk is included into you application makefile.
# 	You should be able to change the name of any of the target
# 	files or append or override such things as CFLAGS.
#
# 	-- Usefull variables ---
#
# 		DRIVERS_LIBRARY_DIR - Location of static driver libraries 
#
# 	-- Action Sequences --
#
# 		compile-c-file   - action sequence
# 		compile-asm-file - action sequence
# 		build-srec-file  - action sequence
# 		build-out-file   - action sequence
#
#	-- Build Flags ---
#
# 		CFLAGS				- C Flags
# 		OPTIM_FLAGS       - Optimizer Flags - Can be overridden
# 		ASFLAGS				- Assembly Flags	
# 		LDFLAGS				- Linker Flags
#
#	-- Build Resources ---
#		
# 		INCLUDES			- List of include directories
# 		OBJECTS				- List of required objects
# 		LIBS				- List of required libraries
#
#   -- Target Names ---
#
# 		OUTFILE				  - Name of output file
# 		SRECFILE			     - Name of srecord file
#
#   -- License File ---
# 	    
# 	    LM_LICENSE_FILE		- Default location of license file
#
# 	-- Memory Layout Properties Files --
#
#	 	MEMLAYOUT_555_PROPFILE
#	 	MEMLAYOUT_565_PROPFILE
#
# $Revision: 1.14.4.6 $
# $Date: 2004/04/19 01:24:38 $
#
# Copyright 2002-2004 The MathWorks, Inc.
#

ifndef __MPC555_RULES_MK__
__MPC555_RULES_MK__=defined

###################### COMPONENTS SECTION ###################################

#
# Import the OS utility variables
#
COMPONENT:=utility_rules
include $(COMPONENT_MANAGER)

#
# Include the MPC555 Register definition files
#
COMPONENT:=mpc5xx_registers
include $(COMPONENT_MANAGER)

#############################################################################


#
# Directory where the application support files are
#
DRIVERS_LIBRARY_DIR = $(MPC555_DRIVERS_ROOT)/lib/$(MPC555_TOOL_CHAIN)

#
# Plug-in mechanism for toolchain rules files
#
TOOL_CHAIN_RULE_FILE := $(mpc555_build_rules_DIR)/toolchain_rules/$(MPC555_TOOL_CHAIN)_rules.mk
_TOOL_CHAIN_RULE_FILE := $(strip $(wildcard $(TOOL_CHAIN_RULE_FILE)))
ifeq "$(_TOOL_CHAIN_RULE_FILE)" ""
# The error command does not seem to work ???
$(warning $(TOOL_CHAIN_RULE_FILE) does not exist. There is no support for $(MPC555_TOOL_CHAIN))
else
include $(TOOL_CHAIN_RULE_FILE)
endif

LIBCMD  := $(_LIBCMD)

# 
# Define the location of the library modules
#
LIBSRCDIR = $(MPC555_DRIVERS_ROOT)/src/libsrc

#
# Declare the build variables
#

#
# The list of required libraries are those which end in
#
# *mpc5xx.a
# *$(MPC555_TOOL_CHAIN).a
#
_LIBS := $(_LIBS) $(wildcard $(DRIVERS_LIBRARY_DIR)/*$(MPC5XX_VARIANT).a) $(wildcard $(DRIVERS_LIBRARY_DIR)/*5xx.a)

#
# If STATIC_RTWLIB is not defined then remove the rtwlib libraries from the list
#
ifeq ($(STATIC_RTWLIB),1)
	# Use the RTWLIB libraries
	LIBS+=$(_LIBS)
else
	# Remove the RTWLIB libraries from the list
	RTWLIBPATTERN:=[^\\s]*rtwlib[^\\s]*
	LIBS+=$(shell $(REGEXPREP) "$(_LIBS)" "$(RTWLIBPATTERN)" "")
endif


ifdef OVERRIDE_DEFAULT_OPT_OPTS 
# compiler flags for optimisation
OPT_OPTS := $(MPC555_OPTIMIZATION_FLAGS) 
else
# defaults specified in toolchain makefiles
OPT_OPTS := $(_OPT_OPTS)
endif

ifdef OVERRIDE_DEFAULT_DEBUG_OPTS 
# debug opts for compiler, linker & assembler
DEBUG_OPTS := $(MPC555_DEBUG_FLAGS)
else
DEBUG_OPTS := $(_DEBUG_OPTS)
endif


# Optionally include the SCP directory.
# (Note the wildcard command does not like backslash characters )
SCPDIR=$(LIBSRCDIR)/internal/jag_scp
ifneq ("$(wildcard $(subst \,/,$(SCPDIR)))","")
	OPTIONAL_INCLUDES+=-I$(SCPDIR)
endif

###############################################################################
# Properties files that describe the memory layout of the 
# current architecture.
###############################################################################
MEMLAYOUT_PROPFILE = $(mpc555_build_rules_DIR)/memlayout.$(MPC5XX_VARIANT).prop


CFLAGS += $(OPT_OPTS) $(_CFLAGS) 
ASFLAGS += $(_ASFLAGS)
LDFLAGS +=  $(_LDFLAGS)
INCLUDES += $(_INCLUDES) \
   -I. \
   -I$(LIBSRCDIR)/standard/include \
   -I$(LIBSRCDIR)/extensions/cmf_flash \
   -I$(MATLABROOT)/rtw/c/src/ext_mode/serial \
   -I$(MATLABROOT)/rtw/c/src/ext_mode/common \
   -I$(MATLABROOT)/toolbox/rtw/targets/common/can/datatypes \
   -I$(MATLABROOT)/extern/include \
   $(OPTIONAL_INCLUDES)

OBJECTS += $(_OBJECTS)

##############################################################
# Define make rules using the canned action sequences.
#
# They expect 3 macros
#
# _compile-c-file      
# _compile-asm-file
# _build-srec-file
# _build-library
#
# These above actions should be defined by the tool
# specific included make files.  
##############################################################

#
# Compile a c file 
#
define compile-c-file
	@echo ---------------------------------------------------------------------------
	@echo --  Compiling C : $< ---
	@echo ---------------------------------------------------------------------------
	$(MAKEDEPEND)
	$(_compile-c-file) 
endef

#
# Compile an assembler file
#
define compile-asm-file
	@echo ---------------------------------------------------------------------------
	@echo -- Y Compiling ASM :  $< ---
	@echo ---------------------------------------------------------------------------
	$(MAKEDEPEND)
	$(_compile-asm-file)
endef

#
# Build a static library
#
define build-library
	-@$(RM) $@
	$(if $^, $(LIBCMD) $@ $^ )
endef



#
# Generate an application srecord file
#
SRECFILE = $@ # Passed to toolchain rules file
OUTFILE  = $(basename $(SRECFILE)).elf # Passed to toolchain rules file
MAPFILE  = $(basename $(SRECFILE)).map	# Passed to toolchain rules file
BINFILE  = $(basename $(SRECFILE)).bin # Passed to toolchain rules file (only used for building bootcode) 
ifdef TARGET_MEMORY_MODEL
define build-srec-file
	@echo --------------------------------------------------------------------------- 
	@echo -- Compiling S-Record : $(SRECFILE) --- $(filter %.o, $^)
	@echo ---------------------------------------------------------------------------
	$(_build-srec-file) 
	$(PERL) $(mpc555_build_rules_DIR)/srec_sort.pl $(SRECFILE) $(SRECFILE)
	@echo ---------------------------------------------------------------------------
	@echo -- $(MPC555_TOOL_CHAIN) build for $(basename $@) complete
	@echo -- 
	@echo -- $(OUTFILE) ready for download
	@echo -- $(SRECFILE) ready for download
	@echo ---------------------------------------------------------------------------
endef
else
define build-srec-file
	@echo --------------------------------------------------------------------------- 
	@echo -- Compiling S-Record : $(SRECFILE) --- $(OBJECTS)
	@echo ---------------------------------------------------------------------------
	@echo You must define the variable TARGET_MEMORY_MODEL = RAM | FLASH to build this $(SRECFILE)
	$(DIE)
	@echo --------------------------------------------------------------------------- 
	@echo -- Build Failed -----------------------------------------------------------
	@echo ---------------------------------------------------------------------------
endef
endif

###############################################################################
# Implicit Rules for current directory
###############################################################################

COMPONENT:=generic_build_rules
include $(COMPONENT_MANAGER)



endif
