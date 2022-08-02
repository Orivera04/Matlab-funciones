function ert_make_rtw_hook(hookMethod,modelName,rtwroot,templateMakefile,buildOpts,buildArgs)
% ERT_MAKE_RTW_HOOK - This is the standared ERT hook file for the RTW build
% process (make_rtw), and implements automatic configuration of the
% models cofiguration parameters.  When the buildArgs option is specified
% as 'optimized_fixed_point=1' or 'optimized_floating_point=1', the model
% is configured automatically for optmized code generation.
%
% This hook file (i.e., file that implements various RTW callbacks) is
% called by RTW for system target file ert.tlc.  The file leverages
% strategic points of the RTW process.  A brief synopsis of the callback
% API is as follows:
%
% ert_make_rtw_hook(hookMethod, modelName, rtwroot, templateMakefile,
%                   buildOpts, buildArgs)
%
% hookMethod:
%   Specifies the stage of the RTW build process.  Possible values are
%   entry, before_tlc, before_make, and exit.
%
% modelName:
%   Name of model.  Valid for all stages.
%
% rtwroot:
%   Reserved.
%
% templateMakefile:
%   Name of template makefile.  Valid for stages 'before_make' and 'exit'.
%
% buildOpts:
%   Valid for stages 'before_make' and 'exit', a MATLAB structure
%   containing fields
%
%   modules:
%     Char array specifying list of generated C files: model.c, model_data.c,
%     etc.
%
%   codeFormat:
%     Char array containing code format: 'RealTime', 'RealTimeMalloc',
%     'Embedded-C', and 'S-Function'
%
%   noninlinedSFcns:
%     Cell array specifying list of non-inlined S-Functions.
%
%   compilerEnvVal:
%     String specifying compiler environment variable value, e.g.,
%     D:\Applications\Microsoft Visual
%
% buildArgs:
%   Char array containing the argument to make_rtw.  When pressing the build
%   button through the Configuration Parameter Dialog, buildArgs is taken
%   verbatim from whatever follows make_rtw in the make command edit field.
%   From MATLAB, it's whatever is passed into make_rtw.  For example, its
%   'optimized_fixed_point=1' for make_rtw('optimized_fixed_point=1').
%
%   This file implements these buildArgs:
%     optimized_fixed_point=1
%     optimized_floating_point=1
%
% You are encouraged to add other configuration options, and extend the
% various callbacks to fully integrate ERT into your environment.

% Copyright 1996-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2003/12/31 19:42:57 $
  
  switch hookMethod
   case 'entry'
    % Called at start of code generation process (before anything happens.)
    % Valid arguments at this stage are hookMethod, modelName, and buildArgs.
    disp(sprintf(['\n### Starting Real-Time Workshop build procedure for ', ...
                  'model: %s'],modelName));
    
    option = LocalParseArgList(buildArgs);
    
    if ~strcmp(option,'none')
      try
        ert_unspecified_hardware(modelName);
        ert_auto_configuration(modelName,option);
      catch
        % Error out if necessary hardware information is missing or
        % there is a problem with the configuration script.
        error(lasterr)
      end
    end
    
   case 'before_tlc'
    % Called just prior to invoking TLC Compiler (actual code generation.)
    % Valid arguments at this stage are hookMethod, modelName, and
    % buildArgs
    
   case 'before_make'
    % Called after code generation is complete, and just prior to kicking
    % off make process (assuming code generation only is not selected.)  All
    % arguments are valid at this stage.

   case 'exit'
    % Called at the end of the RTW build process.  All arguments are valid
    % at this stage.
    disp(['### Successful completion of Real-Time Workshop build ',...
          'procedure for model: ', modelName]);
  end


% Simple parse function to find:
%   optimized_fixed_point=1
%   optimized_floating_point=1
function option = LocalParseArgList(args)
  
  if findstr(args,'optimized_fixed_point=1')
    option = 'optimized_fixed_point';
  elseif findstr(args,'optimized_floating_point=1')
    option = 'optimized_floating_point';
  else
    option = 'none';
  end
  