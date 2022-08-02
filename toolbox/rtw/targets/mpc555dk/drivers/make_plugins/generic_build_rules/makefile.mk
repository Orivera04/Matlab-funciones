# File : makefile.mk
#
# Abstract :
# 	A set of implicit rules for gmake
#
# The actions for each rule must be defined elsewhere
#
# Exports
# 	OBJDIR			-	The directory where object files will live
# 	OBJECT_TARGETS	-	If the users defines the variable 
# 							OBJECTS
# 						which should refer to a list of object files
# 						that are required to be made then OBJECT_TARGETS
# 						will refere to the list of OBJECTS but relocated
# 						to the OBJDIR. OBJECT_TARGETS may also contain
# 						references to other standard prerequistes required
# 						by the build-srec-file macro such as 
# 							$(LINKER_COMMAND_FILE) .
#
# 						For example
#
# 						OBJECTS = a.o b.o c.o
#
# 						x.s19 : $(OBJECT_TARGETS)
#
# $Revision: 1.1.4.2 $
# $Date: 2004/04/19 01:24:25 $
#
# Copyright 2002-2003 The MathWorks, Inc.
#

ifndef __GENERIC_BUILD_RULES__
__GENERIC_BUILD_RULES__=defined

ifndef OBJDIR
	OBJDIR=bin/$(MPC555_TOOL_CHAIN)/$(MPC5XX_VARIANT)
endif

.PHONY : setup

# A setup rule that should be run for every makefile. It makes sure that
# the object directories are all built
setup : $(OBJDIR)

$(OBJDIR) :
	$(MKDIR) $(OBJDIR)

OBJECT_TARGETS = $(addprefix $(OBJDIR)/,$(OBJECTS)) $(LINKER_COMMAND_FILE)

#Turning assembler files into object files
$(OBJDIR)/%.o : %.s
	$(compile-asm-file)

#Turning c files into object files
$(OBJDIR)/%.o : %.c
	$(compile-c-file)

###############################################################################
# Clean Rules
###############################################################################

#
# Finds if any files exists in the TO_CLEAN_FILES macro. If they do
# then they are deleted.
#
.PHONY : clean general_clean

clean : clean_general

clean_general :
	@echo --------------------------------
	@echo -- Cleaning $(OBJDIR) --- 
	@echo --------------------------------
	@$(RM) $(OBJDIR)/*.*
endif

