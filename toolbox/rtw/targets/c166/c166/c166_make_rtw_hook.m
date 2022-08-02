function varargout = c166_make_rtw_hook(method, modelName, rtwRoot, tmf, buildOpts, buildArgs)
%C166_MAKE_RTW_HOOK  Make RTW hook file for c166.tlc target
%   During its build process, Real-Time Workshop checks for the existence
%   of <target>_make_rtw_hook.m where <target> is the base name of the 
%   active system target file. For example, if your system target file
%   is grt.tlc, then the hook file name is grt_rtw_info_hook.m.  If the
%   hook file is present (i.e., on the MATLAB path), then the code
%   defined in this file is called at the corresponding stages during 
%   the build process.

% Copyright 2003 The MathWorks, Inc.
% $Revision: 1.11.6.6 $

persistent userData;

  switch method
   case 'entry'
    FcnEntryMethod(modelName);
   case 'before_tlc'
    localCreateMakeVariablesFile;
    localSetExtraBuildArgs(modelName);
   case 'before_make'
    localBeforeMake;
   case 'exit'
    FcnExitMethod(modelName, buildOpts.generateCodeOnly);      
   case 'setUserData'
    % cache the build data that may be required later
    userData.modelName = modelName;
    userData.buildDir = rtwprivate('rtwattic','getBuildDir');
   case 'getModelName'
    varargout{1} = userData.modelName;
   case 'getBuildDir'
    varargout{1} = userData.buildDir;
   case 'clean'
    % clear the userData, atticdata and actual RTWattic data.
    clear userData;
   otherwise
    errdlg(['Unrecognized hook file method: ', method]);
  end
  
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FcnEntryMethod(modelName)
 
  % Generate custom files for this target
  uset_param(modelName, 'ERTCustomFileTemplate','c166customfiles.tlc')
  
  % Find subsystem in code generation model
  hCodeGenBlk = FcnFindCodeGenBlk(modelName);
  
  if (hCodeGenBlk ~= -1) % i.e. subsystem build, not top-level model
                         % Check for configurable subsystem
    if FcnIsConfigSS(hCodeGenBlk)
      % Check that it is using the correct BlockChoice
      blockChoice = get_param(hCodeGenBlk, 'BlockChoice');
      memberBlocks = get_param(hCodeGenBlk, 'MemberBlocks');
      origBlkName = strtok(memberBlocks, ',');
      if ~strcmp(blockChoice, origBlkName)
        errTxt = sprintf([...
            'Invalid block choice selected for building the subsystem ', ...
            'for real-time standalone target.\nSelect the first ', ...
            'block choice and then start the build process again.']);
        error(errTxt);
      end    
      % Fix sample time settings:
      hPorts = find_system(get_param(modelName, 'Handle'), ...
                           'SearchDepth',   1, ...
                           'LookUnderMasks', 'on', ...
                           'FollowLinks',   'on', ...
                           'BlockType',     'Inport');
      hSSInside = find_system(hCodeGenBlk, ...
                              'SearchDepth',   1, ...
                              'LookUnderMasks', 'on', ...
                              'FollowLinks',   'on', ...
                              'BlockType',     'SubSystem');
      hSSInside = hSSInside(hSSInside~=hCodeGenBlk);
      hSSPorts = find_system(hSSInside, ...
                             'SearchDepth',   1, ...
                             'LookUnderMasks', 'on', ...
                             'FollowLinks',   'on', ...
                             'BlockType',     'Inport');
      for i=1:length(hPorts)
        ssPortTs = get_param(hSSPorts(i), 'SampleTime');
        if ((strcmp(ssPortTs, '-1')) | ...
            (strcmp(ssPortTs, get_param(hPorts(i), 'SampleTime'))))
          % Do not copy sample time setting from SSPort
        else
          set_param(hPorts(i), 'SampleTime', ssPortTs);
        end
      end
    end
  end
  
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FcnExitMethod(modelName,generateCodeOnly)
  
% ASAP2 processing utility
% specify perl script capable of processing the generated MAP file
perlFile = fullfile(matlabroot,'toolbox','rtw','targets','c166','tasking',...
                      'asap2','asap2post.pl');
target_asap2_utils('postProcess', modelName, perlFile);
 
% Save the model being built later use by tgtaction.
  c166_make_rtw_hook('setUserData',modelName);

% Code profile report
  if (generateCodeOnly == 0)  
    % force reload of htmlreport.m from disk
    clear htmlreport;
    htmlreport;
    delete htmlreport.m;  % house keeping
    fprintf(1,...
	    ['### Successful completion of C166 Real-Time Target build '...
	    'procedure for model: %s\n'], modelName); 
  else
    fprintf(1,...
	    ['### Successful completion of C166 Real-Time target code '...
             'generation procedure for model: %s\n'], modelName);      
  end
  
  if (generateCodeOnly == 0)
    %
    % Some target action may be requested, which is only relevent
    % when we have actually compiled the generated code
    %
    
    % Get the buildAction and other variables into our context
    buildAction = uget_param(modelName,'BuildActionC166');
    xViewStartOptionsFile = uget_param(modelName,'XviewStartupOptionsFile');
    
    % handle the BuildAction.
    switch buildAction
      case 'Download_and_run'
       c166tgtaction(buildAction);
     case 'Download_and_run_with_debugger'
      c166tgtaction(buildAction,xViewStartOptionsFile);
     case 'Run_with_simulator'
      c166tgtaction(buildAction,xViewStartOptionsFile);
     case 'None'
      % no action
     otherwise
      error(['Unhandled build action: ' buildAction])
    end
  end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hCodeGenBlk = FcnFindCodeGenBlk(modelName)
hCodeGenModel = get_param(modelName, 'Handle');
hCodeGenBlk = find_system(hCodeGenModel, ...
  'SearchDepth', 1, ...
  'BlockType',   'SubSystem');

if length(hCodeGenBlk)>1
  hCodeGenBlk = -1; % Indicates that a top level model is being built
end  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = FcnIsConfigSS(hBlk)
if strcmp(get_param(hBlk, 'BlockType'), 'SubSystem')
  if strcmp(get_param(hBlk, 'TemplateBlock'), '')
    result = 0;
  else 
    result = 1;
  end
else
  result = 0;
end


% Check RTW Options and set defaults from target preferences if necessary
function localSetExtraBuildArgs(modelName)
    
  args = get_param(modelName,'RTWBuildArgs');
  prefs = RTW.TargetPrefs.load('c166.prefs');
  
  tgtCompilerPath = prefs.TargetCompilerPath;
  
  args = [args ...
          ' C166ROOT="' prefs.TargetCompilerPath '"' ...
         ];
  
  dirty=get_param(modelName,'Dirty');
  set_param(modelName,'RTWBuildArgs',args);
  set_param(modelName,'Dirty',dirty);
  
  
% Check RTW Options and set defaults from target preferences if necessary
function localBeforeMake
    
  prefs = RTW.TargetPrefs.load('c166.prefs');
  
  tgtCompilerPath = prefs.TargetCompilerPath;
  if exist(tgtCompilerPath) ~= 7
    error(['The directory ' tgtCompilerPath ' does not exist. ' ...
           'You should open the C166 target preferences dialog and specify '...
           'the directory where your compiler toolchain is installed.']);
  end
  

% Create the make variables file
function localCreateMakeVariablesFile

  buildDir = rtwprivate('rtwattic','getBuildDir');
    
  prefs = RTW.TargetPrefs.load('c166.prefs');
  
  refFile = prefs.MakeVariablesReferenceFile;
  refFile = strrep(refFile,'$(MATLAB_ROOT)',matlabroot);
  tgtCompilerPath = prefs.TargetCompilerPath;
   
  % Extract make variables from the reference file and write them
  % to a new file in the build directory
  cputype = c166_extract_makevars(refFile, buildDir, tgtCompilerPath);
  
  switch cputype
   case '0x166'
    twinCAN = 0;
   case '0x167'
    twinCAN = 0;
   case '0x1662'
    twinCAN = 1;
   otherwise
    twinCAN = 1;
  end
  
  c166cache('set','CPUType',cputype);
  c166cache('set','TwinCAN',twinCAN);

