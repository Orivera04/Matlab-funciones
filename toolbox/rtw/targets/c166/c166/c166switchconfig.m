function c166switchconfig(model,config)
% C166SWITCHCONFIG convenience function to switch processor configuration
%    C166SWITCHCONFIG(MODEL) makes changes to MODEL and to the C166 Target
%    Preferences in order to use one of a number of pre-defined configurations.
%    Note that running this function will overwrite certain C166 Target
%    Preferences that may previously have been entered by hand. 
%
%    C166SWITCHCONFIG(MODEL,CONFIG) makes changes to MODEL and to the C166 Target
%    Preferences in order to use the pre-defined configurations CONFIG. In this
%    case the function runs non-interactively.

% Copyright 2003-2004 The MathWorks, Inc.
%   $File: $
%   $Revision: 1.1.6.6 $
%   $Date: 2004/04/19 01:18:38 $  

if nargin < 2
  disp(' ')
  disp(['Running file ''' mfilename ''' for model ' model])
  disp(['This is a convenience function to set up your model and your C166 Target '])
  disp(['Preferences for one of the pre-defined configurations below. If your '])
  disp(['setup does not correspond to one of the pre-defined configurations, you '])
  disp(['may wish to use this file as a template for setting up your own customized'])
  disp(['configurations.'])
  disp(' ')
  disp(['Please select one of the pre-defined target processor configurations.'])
  disp(' ')
  disp('Options:')
  disp(['[1] Phytec phyCORE-C167CS (RAM)'])
  disp(['[2] Phytec phyCORE-C167CS (flash)'])
  disp(['[3] Infineon XC167CI Starter Kit'])
  disp(['[4] Phytec phyCORE-ST10F269'])
  disp(['[5] Phytec kitCON-C167CR (RAM)'])
  disp(['[6] Phytec kitCON-C167CR (flash)'])
  disp(' ')
  disp('[0] Cancel')
  disp(' ')
  commandwindow
  c = input('Option: ','s');
  
  switch c
   case '1'
    config = 'Phytec phyCORE-C167CS (RAM)';
   case '2'
    config = 'Phytec phyCORE-C167CS (flash)';
   case '3'
    config = 'Infineon XC167CI Starter Kit';
   case '4'
    config = 'Phytec phyCORE-ST10F269';
   case '5'
    config = 'Phytec kitCON-C167CR (RAM)';
   case '6'
    config = 'Phytec kitCON-C167CR (flash)';
   otherwise
    return
  end

  disp([' '])
  disp(['You have selected ''' config ''''])
  disp([' '])
  disp(['Corresponding changes will be made to the model ' model '.mdl '])
  disp(['and your Target Preferences.'])
  disp([' '])
  c = input('Do you wish to proceed: [y]/n: ','s');
  if  ~isempty(c) & ~strcmp(c,'y')
    return
  end
  
end
  
prefs = RTW.TargetPrefs.load('c166.prefs');
compilerPath = prefs.TargetCompilerPath;
resource_config_blk = find_system(gcs,'FollowLinks','on','LookUnderMasks','on','Tag','RTW CONFIGURATION BLOCK');
target = get_param(resource_config_blk,'userdata');
if ~isempty(target)
  target = target{:};
  timers = target.findConfigForClass('c166Config.C166System');
else
  % No resource config block: use dummy timers object.
  timers = c166Config.C166System;
end

switch config
  
 case {'Phytec phyCORE-C167CS (RAM)','Phytec phyCORE-C167CS (flash)'}
  prefs.TaskingRegisterDefs = 'reg167cs.h';
  prefs.TaskingCfgOnChip = '$(MATLAB_ROOT)/toolbox/rtw/targets/c166/tasking/cfg/ph167cs_mw.cfg';
  prefs.TaskingCfgSimulator = [ compilerPath '/ETC/sim167cs.cfg' ];
  timers.System_frequency = 2e7;              % Resource configuration system frequency
  timers.External_oscillator_frequency = 5e6; % Resource configuration external oscillator frequency
  if strcmp(config,'Phytec phyCORE-C167CS (RAM)')
    prefs.MakeVariablesReferenceFile = '$(MATLAB_ROOT)/toolbox/rtw/targets/c166/tasking/make/phyCORE_C167CS_v80/pc167cs.mak';
    uset_param(model,'BuildActionC166','Download_and_run');  % Use Minimon
  elseif strcmp(config,'Phytec phyCORE-C167CS (flash)')
    prefs.MakeVariablesReferenceFile = '$(MATLAB_ROOT)/toolbox/rtw/targets/c166/tasking/make/pc167csV80Flash/pc167csV80Flash.mak';
    uset_param(model,'BuildActionC166','None');
  else 
    error(['Unrecognized value for config = ' config ])
  end
    
 case {'Phytec kitCON-C167CR (RAM)','Phytec kitCON-C167CR (flash)'}
  prefs.TaskingRegisterDefs = 'reg167cr.h';
  prefs.TaskingCfgOnChip = [ compilerPath '/ETC/kc167.cfg' ];
  prefs.TaskingCfgSimulator = [ compilerPath '/ETC/sim167cr.cfg' ];
  timers.System_frequency = 2e7;              % Resource configuration system frequency
  timers.External_oscillator_frequency = 5e6; % Resource configuration external oscillator frequency
  if strcmp(config,'Phytec kitCON-C167CR (RAM)')
    prefs.MakeVariablesReferenceFile = '$(MATLAB_ROOT)/toolbox/rtw/targets/c166/tasking/make/kc167crV80/kc167crV80.mak';
    uset_param(model,'BuildActionC166','Download_and_run');  % Use Minimon
  elseif strcmp(config,'Phytec kitCON-C167CR (flash)')
    prefs.MakeVariablesReferenceFile = '$(MATLAB_ROOT)/toolbox/rtw/targets/c166/tasking/make/kc167crV80Flash/kc167crV80Flash.mak';
    uset_param(model,'BuildActionC166','Download_and_run_with_debugger');
  else 
    error(['Unrecognized value for config = ' config ])
  end
  
 case 'Infineon XC167CI Starter Kit' % Infineon XC167CI Starter Kit
  prefs.TaskingRegisterDefs = 'regxc167ci.h';
  prefs.TaskingCfgOnChip = [ compilerPath '/ETC/inf_xc167ci_ocds_demux.cfg' ];
  prefs.TaskingCfgSimulator = [ compilerPath '/ETC/simxc167ci.cfg' ];
  prefs.MakeVariablesReferenceFile = '$(MATLAB_ROOT)/toolbox/rtw/targets/c166/tasking/make/SK_XC167CI_v80/sk_xc167ci.mak';
  timers.System_frequency = 4e7;              % Resource configuration system frequency
  timers.External_oscillator_frequency = 8e6; % Resource configuration external oscillator frequency
  uset_param(model,'BuildActionC166','Download_and_run_with_debugger');  % Use CrossView
  
 case 'Phytec phyCORE-ST10F269' 
  prefs.TaskingRegisterDefs = 'reg269.h';
  prefs.TaskingCfgOnChip = '$(MATLAB_ROOT)/toolbox/rtw/targets/c166/tasking/make/phyCORE_ST10F269_v80/_st10f269.cfg';
  prefs.TaskingCfgSimulator = [ compilerPath '/ETC/sim269.cfg' ];
  prefs.MakeVariablesReferenceFile = '$(MATLAB_ROOT)/toolbox/rtw/targets/c166/tasking/make/phyCORE_ST10F269_v80/st10f269.mak';
  timers.System_frequency = 2e7;              % Resource configuration system frequency
  timers.External_oscillator_frequency = 5e6; % Resource configuration external oscillator frequency
  uset_param(model,'BuildActionC166','Download_and_run');  % Use Minimon
 otherwise
  error(['Unrecognized configuration: ' config ])
end

newcpu = localGetCPUType(prefs.MakeVariablesReferenceFile);
localCanBlocksWarn(newcpu, model);   
prefs.save;

if nargin < 2
  disp(' ')
  disp('Done')
end




%%%%%%%%%%%%%%%%%%%
% Local Functions %
%%%%%%%%%%%%%%%%%%%

function localCanBlocksWarn(newcpu, model)
  if strcmp(newcpu,'0x1662')
    warntype='CAN';
    othertype = 'TwinCAN';
  elseif ~strcmp(newcpu,'0x1662')
    warntype='TwinCAN';
    othertype = 'CAN';
  else 
    return
  end

  warnblocks = find_system(model,...
                           'RegExp','on',...
                           'LookUnderMasks','On',...
                           'ReferenceBlock',...
                           ['(^c166drivers/' warntype ')|(^c166drivers/Execution Profiling.*\s' warntype ')']);
  
  if ~isempty(warnblocks)
    disp(' ')
    disp(['WARNING: you are switching from a processor with ' warntype ' to one with'])
    disp([othertype '. The following blocks must be changed to the ' othertype ])
    disp(['equivalents:'])
    disp(warnblocks)
  end

  
function cputype = localGetCPUType(inputFile)

  inputFile = strrep(inputFile,'$(MATLAB_ROOT)',matlabroot);
  inputDir = fileparts(inputFile);
  
  fid=fopen(inputFile,'r');
  if fid==-1
    error(['The file ' inputFile ' cannot be opened. This error occurs '...
           'if a the reference makefile specified does not exist. ']);
  end
  bufIn=fread(fid,Inf);
  bufIn=char(bufIn');
  fclose(fid);
  
  
  % Extract the CPUTYPE
  re = '-DCPUTYPE=([^\s])*[\s]';
  [s,f,t] = regexp(bufIn,re);
  if size(t)~= 1 | length(t{1}) ~= 2
    error(['CPUTYPE is not specified inside ' inputFile '. ' ...
           'This error occurred because the string ''-DCPUTYPE=cpunumber'' could not '...
           'be found inside the OPT_CC variable. To fix this problem, you must make '...
           'sure that the reference make variables file contains a make variable '...
           'OPT_CC that specifies e.g. -DCPUTYPE=0x167.']);
  else
    t = t{1};
    cputype = bufIn(t(1):t(2));
  end
  