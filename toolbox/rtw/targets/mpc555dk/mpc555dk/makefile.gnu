# File: toolbox/rtw/targets/mpc555dk/mpc555dk/makefile.gnu
#
# Abstract:
#    This makefile will auto-generate Contents.m from Contents.m_template.
#    Additionally in the once target, the Target Function Mat files are generated

# $Revision: 1.1.4.1 $
# $Date: 2004/03/15 22:23:48 $
#
# Copyright 2004 The MathWorks, Inc.

include $(MATLABROOT)/makerules/mexrules.gnu

ifdef ISPC
  MATLAB_EXE := $(MATLABROOT)/bin/win32/matlab.exe
else
  MATLAB_EXE := $(MATLABROOT)/bin/matlab
endif

TEMPLATE_TARGETS := Contents.m
TFL_MATFILE_TARGETS := codewarrior_tfl_tmw.mat diab_tfl_tmw.mat
#
# need an empty all target
all:
once : $(TEMPLATE_TARGETS)

include $(MATLABROOT)/makerules/template_rules.gnu

ifeq ($(ARCH),glnx86)
premex:  $(TFL_MATFILE_TARGETS)
else
premex:
endif



#-----------------------------------------------------------------------------
# Target Function Library mat files rule
#
# currently, the way the mat files are generated, there is an inter-dependancy
# on how they get created as follows:
#
# mat file		   depenmdancies
# diab_tfl_tmw.mat 	   make_mpc555_targetfcnlib_mat_files.m
#			   make_diab_tfl.m
#                          make_codewarrior_tfl.m
# 
# codewarrior_tfl_tmw.mat  make_mpc555_targetfcnlib_mat_files.m
#			   make_diab_tfl.m
#                          make_codewarrior_tfl.m
# 
# Because of this interdependancy, if any one of the source files is changed,
# all of the mat files will be re-generated.  This is done to simplify the make
# rules.
#------------------------------------------------------------------------------
SUCCESS_TOK = No_Errors_Creating_TargetFcnLib_Mat_Files
MAKE_TFL_MATFILE_LOG = Make_TargetFcnLib_Log
$(TFL_MATFILE_TARGETS) :  make_mpc555_targetfcnlib_mat_files.m \
                          make_diab_tfl.m make_codewarrior_tfl.m
	rm -f $(MAKE_TFL_MATFILE_LOG)
	$(MATLAB_EXE) -nosplash -nojvm -noaccel \
	-r " try,  rehash toolboxcache; make_mpc555_targetfcnlib_mat_files; disp('$(SUCCESS_TOK)'); catch, disp('make_targetfcnlib_mat_files had errors'); disp(lasterr); end; quit" -logfile $(MAKE_TFL_MATFILE_LOG)
	tail -1  $(MAKE_TFL_MATFILE_LOG) | grep '^$(SUCCESS_TOK)$$'
	rm -f $(MAKE_TFL_MATFILE_LOG)

#------------#
# Clean rule #
#------------#

clean :
	rm -f $(TEMPLATE_TARGETS)
	rm -f $(TFL_MATFILE_TARGETS)
	rm -f $(MAKE_TFL_MATFILE_LOG)
