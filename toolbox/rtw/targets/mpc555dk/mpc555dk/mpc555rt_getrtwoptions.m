% Function mpc555rt_getrtwoptions
%
% Abstract :
%   Handles the callbacks for the MPC555 Optimization Flags


% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $
% $Date: 2004/04/19 01:27:07 $
function rtwoptions = mpc555rt_getrtwoptions
  tp =  RTW.TargetPrefs.load('mpc555.prefs');
  opt_flags_default = tp.ToolChainOptions.CompilerOptimizationSwitches.Speed;
  
  rtwoptions = [];
  
  rtwoptions(end+1).prompt         = 'ET MPC555 real-time options (1)';
  rtwoptions(end).type           = 'Category';
  rtwoptions(end).enable         = 'on';  
  rtwoptions(end).default        = 6;   % number of items under this category
  rtwoptions(end).popupstrings  = '';
  rtwoptions(end).tlcvariable   = '';
  rtwoptions(end).tooltip       = '';
  rtwoptions(end).callback      = '';
  rtwoptions(end).opencallback  = '';
  rtwoptions(end).closecallback = '';
  rtwoptions(end).makevariable  = '';

  n = sprintf('\n');
  rtwoptions(end+1).prompt        = 'Optimize compiler for';
  rtwoptions(end).type           = 'Popup';
  rtwoptions(end).default        = 'speed';
  rtwoptions(end).popupstrings   = 'speed|size|debug|custom';
  rtwoptions(end).tlcvariable    = 'MPC555_OPTIMIZATION_SWITCH';
  rtwoptions(end).makevariable   = 'MPC555_OPTIMIZATION_SWITCH';
  rtwoptions(end).tooltip        = ['Apply C compiler optimizations to minimize execution time',...
                                               n,'or to minimize code size.'];
  %% dummy callback to trigger FLAGS get function on switch selection %%
  rtwoptions(end).callback      = 'mpc555_callback_handler(''callback'', hSrc, hDlg, currentVar)';
  rtwoptions(end).opencallback  = '';
  rtwoptions(end).closecallback = '';


  rtwoptions(end+1).prompt        = 'Compiler optimization switches';
  rtwoptions(end).type           = 'Edit';
  rtwoptions(end).enable         = 'on';  
  rtwoptions(end).default        = [ '''' opt_flags_default '''' ]; 
  rtwoptions(end).tlcvariable    = 'MPC555_OPTIMIZATION_FLAGS';
  rtwoptions(end).makevariable   = '';
  rtwoptions(end).tooltip        = ['Custom optimisation flags'];
  %% set the SWITCH to custom %%
  rtwoptions(end).callback      = 'mpc555_callback_handler(''callback'', hSrc, hDlg, currentVar)';
  rtwoptions(end).opencallback  = '';
  rtwoptions(end).closecallback = '';
  %% get function handles whether to use Target Prefs or custom flags
  rtwoptions(end).getfunction   = '@mpc555rt_optflags_getfcn';

  rtwoptions(end+1).prompt        = 'Target memory model';
  rtwoptions(end).type           = 'Popup';
  rtwoptions(end).default        = 'RAM';
  rtwoptions(end).popupstrings   = 'RAM|FLASH';
  rtwoptions(end).tlcvariable    = 'TARGET_MEMORY_MODEL';
  rtwoptions(end).makevariable   = 'TARGET_MEMORY_MODEL';
  rtwoptions(end).tooltip        = 'Generated code for the MPC555 can run from RAM or FLASH';
  rtwoptions(end).callback      = '';
  rtwoptions(end).opencallback  = '';
  rtwoptions(end).closecallback = '';

  
  rtwoptions(end+1).prompt         =  'Build action';
  rtwoptions(end).type           =  'Popup';
  rtwoptions(end).default        =  'None';
  rtwoptions(end).popupstrings   =  'None|Launch_Download_Control_Panel|Run_via_BDM|Debug_via_BDM';
  rtwoptions(end).tlcvariable    =  'BuildAction'; 
  rtwoptions(end).makevariable   =  '';
  rtwoptions(end).tooltip        =  ['Action to perform after building target'];
  rtwoptions(end).callback       =  '';
  rtwoptions(end).opencallback   =  '';
  rtwoptions(end).closecallback  =  '';

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

  rtwoptions(end+1).prompt         = 'ET MPC555 real-time options (2)';
  rtwoptions(end).type           = 'Category';
  rtwoptions(end).enable         = 'on';  
  rtwoptions(end).default        = 4;   % number of items under this category
  rtwoptions(end).popupstrings  = '';
  rtwoptions(end).tlcvariable   = '';
  rtwoptions(end).tooltip       = '';
  rtwoptions(end).callback      = '';
  rtwoptions(end).opencallback  = '';
  rtwoptions(end).closecallback = '';
  rtwoptions(end).makevariable  = '';

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
    'Includes code for logging execution profile data. See also MATLAB command '...
    sprintf('\n'), ...
    'profile_mpc555.'];
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
