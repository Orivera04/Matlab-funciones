# File : makefile
#
# Abstract :
# 	makefile for the libsrc directory
#
# $Revision: 1.4.4.2 $
# $Date: 2004/04/19 01:25:29 $
#
# Copyright 2002-2003 The MathWorks, Inc.

.PHONY : default

default : all

COMPONENT=utility_rules
include $(COMPONENT_MANAGER)

.PHONY : standard extensions internal clean

all: standard extensions $(wildcard internal)


standard :
	@echo ===========================================
	@echo Making the libsrc/standard directory
	@echo ===========================================
	$(MAKE) -C standard/src all

extensions:
	@echo ===========================================
	@echo Making the libsrc/extensions directory
	@echo ===========================================
	$(MAKE) -C extensions all

internal :
	@echo ===========================================
	@echo Making the libsrc/internal directory
	@echo ===========================================
	$(MAKE) -C internal all

clean: 
	@echo ===========================================
	@echo Cleaning libsrc
	@echo ===========================================
	@echo 	===========================================
	@echo 	Cleaning libsrc/standard/src
	@echo 	===========================================
	$(MAKE) -C standard/src clean
	@echo 	===========================================
	@echo 	Cleaning libsrc/extensions
	@echo 	===========================================
	$(MAKE) -C extensions clean
ifneq ("$(wildcard internal)","")
	@echo 	===========================================
	@echo 	Cleaning internal
	@echo 	===========================================
	$(MAKE) -C internal clean
endif

