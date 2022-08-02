function rtwoptions = c166_getrtwoptions(rtwoptions)
% C166_GETRTWOPTIONS gets C166-specific RTW options.

% Copyright 2002-2003 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:18:33 $  

  rtwoptions(end+1).prompt         = 'C166 Options (1)';
  rtwoptions(end).type           = 'Category';
  rtwoptions(end).enable         = 'on';  
  rtwoptions(end).default        = 9;   % number of items under this category
  rtwoptions(end).popupstrings  = '';
  rtwoptions(end).tlcvariable   = '';
  rtwoptions(end).tooltip       = '';
  rtwoptions(end).callback      = '';
  rtwoptions(end).opencallback = '';
  rtwoptions(end).closecallback = '';
  rtwoptions(end).makevariable  = '';

  rtwoptions(end+1).prompt         = 'Build action:';
  rtwoptions(end).type           = 'Popup';
  rtwoptions(end).default        = 'None';
  rtwoptions(end).popupstrings   = [...
    'Run_with_simulator|Download_and_run_with_debugger|Download_and_run|None'];
  rtwoptions(end).enable         = 'on';
  rtwoptions(end).tlcvariable    = 'BuildActionC166';
  rtwoptions(end).makevariable    = 'BUILD_ACTION_C166';
  rtwoptions(end).tooltip        = ['Action to perform after building target.'];
  rtwoptions(end).opencallback   = 'c166_callback_handler(''opencallback'', hSrc, hDlg)';
  rtwoptions(end).callback       = 'c166_callback_handler(''callback'', hSrc, hDlg, currentVar)';
  
  rtwoptions(end+1).prompt         = 'CrossView startup options file:';
  rtwoptions(end).type           = 'Edit';
  rtwoptions(end).default        = '';
  rtwoptions(end).tlcvariable    = 'XviewStartupOptionsFile';
  rtwoptions(end).tooltip        = ...
    ['Specify a startup options file to be used when launching CrossView;' ...
     sprintf('\n'), ...
     'if no file is specified, a default startup options file will be used';];
      
  rtwoptions(end+1).prompt         = 'Include input/output driver function hooks';
  rtwoptions(end).type           = 'Checkbox';
  rtwoptions(end).default        = 'off';
  rtwoptions(end).tlcvariable    = 'InputOutputDriverHooks';
  rtwoptions(end).tooltip        = [...
    'Check this box to include hooks for input/output driver functions that you' ...
    sprintf('\n'), ...
    'supply. See documentation for details on how to make the build process aware' ... 
    sprintf('\n'), ...
    'of your file locations.'];
  
  rtwoptions(end+1).prompt         = 'Maximum number of concurrent base-rate overruns:';
  rtwoptions(end).type           = 'Edit';
  rtwoptions(end).default        = '5';
  rtwoptions(end).tlcvariable    = 'BaseRateMaxOverrunsValue';
  rtwoptions(end).makevariable   = 'BASE_RATE_MAX_OVERRUNS_VALUE';
  rtwoptions(end).tooltip        = [...
    'The maximum number of concurrent base-rate overruns that are allowed to occur before '...
    sprintf('\n'), ...
    'an overrun error status is set. Set this value to zero, if you require any base-rate '...
    sprintf('\n'), ...
    'overruns to be handled as a failure.'];

  rtwoptions(end+1).prompt         = 'Maximum number of concurrent sub-rate overruns:';
  rtwoptions(end).type           = 'Edit';
  rtwoptions(end).default        = '0';
  rtwoptions(end).makevariable   = 'SUB_RATE_MAX_OVERRUNS_VALUE';
  rtwoptions(end).tlcvariable    = 'SubRateMaxOverrunsValue';
  rtwoptions(end).tooltip        = [...
    'The maximum number of concurrent sub-rate overruns that are allowed to occur before '...
    sprintf('\n'), ...
    'an overrun error status is set. Note that if sub-rate overruns are allowed, this may '...
    sprintf('\n'), ...
    'cause non-deterministic data transfer for any rate transition blocks in the model.'];

  rtwoptions(end+1).prompt         = 'Execution profiling';
  rtwoptions(end).type           = 'Checkbox';
  rtwoptions(end).default        = 'off';
  rtwoptions(end).tlcvariable    = 'ExecutionProfilingEnabled';
  rtwoptions(end).makevariable   = 'EXECUTION_PROFILING_ENABLED';
  rtwoptions(end).tooltip        = [...
    'Include code for logging execution profile data. See also MATLAB command '...
    sprintf('\n'), ...
    'profile_c166.'];
  rtwoptions(end).callback       = [...
    'exprofile_callback(''callback'', hSrc, hDlg, currentVar)'];
  rtwoptions(end).opencallback       = [...
    'exprofile_callback(''opencallback'', hSrc, hDlg)'];
  
  rtwoptions(end+1).prompt         = 'Number of data points:';
  rtwoptions(end).type           = 'Edit';
  rtwoptions(end).default        = '500';
  rtwoptions(end).makevariable   = 'EXECUTION_PROFILING_NUM_SAMPLES';
  rtwoptions(end).tlcvariable    = 'ExecutionProfilingNumSamples';
  rtwoptions(end).tooltip        = [...
    'The number of data points recorded during an execution profiling run.'];

  rtwoptions(end+1).prompt = 'Use prebuilt RTW libraries';
  rtwoptions(end).type = 'Checkbox';
  rtwoptions(end).default = 'on';
  rtwoptions(end).tlcvariable = 'STATIC_RTWLIB';
  rtwoptions(end).makevariable = 'STATIC_RTWLIB';
  rtwoptions(end).tooltip =  ...
     'A prebuilt version of the RTWLIB sources are provided and can result in faster builds if selected.';
  rtwoptions(end).callback       =  '';
  rtwoptions(end).opencallback   =  '';
  rtwoptions(end).closecallback  =  '';
