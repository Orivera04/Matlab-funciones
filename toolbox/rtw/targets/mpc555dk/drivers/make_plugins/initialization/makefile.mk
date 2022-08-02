# File: makefile.mk
#
# Abstract:
#		makefile for the initialization module
#
# $Revision: 1.1.4.1 $
# $Date: 2004/04/19 01:24:28 $
#
# Copyright 1990-2002 The MathWorks, Inc.

# Including this component allows your application to include
# a toolchain independent entry point for your initialization 
# code.
#
# Create a C file as below
#
# #include "mpc555dk_init.h"
# static void usr_init(void){
# 	 /* Any initialization code */
# }
#
# ensure in your makefile to include this component as
#
# COMPONENT=initialization
# include $(COMPONENT_MANAGER)

# ################################################
# TO FIX
# ################################################
# There are also files in this directory for
# turning as toolchain independent register
# settings file into either assembly code
# or toolchain specific debug configuration
# scripts. This has not yet been fully
# implemented.
# ################################################
#
# $Revision: 1.1.4.1 $
# $Date: 2004/04/19 01:24:28 $ 
#
# Copyright 2002 The MathWorks, Inc.

# Include the default compiler rules

ifndef __INITIALIZATION_COMPONENT__
__INITIALIZATION_COMPONENT__=1

ifeq ($(MPC555_TOOL_CHAIN),DIAB)
OBJECTS += init_diab.o
endif

endif




