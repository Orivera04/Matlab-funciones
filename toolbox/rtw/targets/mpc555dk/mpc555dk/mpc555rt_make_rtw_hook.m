function mpc555rt_make_rtw_hook(method, modelName, rtwRoot, tmf, buildOpts, buildArgs)
%MPC555RT_MAKE_RTW_HOOK  Make RTW hook file for mpc555rt.tlc target

% Copyright 2004 The MathWorks, Inc.
% $Revision: 1.8.4.11 $
% $Date: 2004/04/29 03:40:13 $

switch method
case 'entry'
  FcnEntryMethod(modelName);
case 'before_tlc'

case 'before_make'
  p = RTW.TargetPrefs.load('mpc555.prefs');
  try
    p.validate;
  catch
    err = lasterr;
    uiwait(errordlg(err,'Target Preference Error'));
    p.gui;
    error(err);
  end
case 'exit'
   FcnExitMethod(modelName, buildOpts.generateCodeOnly);
otherwise
  errdlg(['Unrecognized hook file method: ', method]);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FcnEntryMethod(codeGenModelName)
  
  cs = getActiveConfigSet(codeGenModelName);  
  tprefs = RTW.TargetPrefs.load('mpc555.prefs');

  % Set ISO or ANSI C for floating point math calls
  isoCSupported=1;
  mpc555_tfl(cs, tprefs, isoCSupported);
  
% this an RT build - enforce that exactly one 
% Resource Configuration block is in the model
RTWConfigurationCB('get_target_from_system', codeGenModelName);

% Find subsystem in code generation model
hCodeGenBlk = FcnFindCodeGenBlk(codeGenModelName);

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
    hPorts = find_system(get_param(codeGenModelName, 'Handle'), ...
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

function FcnExitMethod(codeGenModelName, generateCodeOnly)
% ASAP2 processing utility
% use the MPC555 Target Preferences to determine the toolchain
% and select the perl file to use
tprefs = RTW.TargetPrefs.load('mpc555.prefs');
switch lower(tprefs.ToolChain)
case 'diab'
   % specify perl script capable of processing the MAP file
   % generated by the Diab compiler
   perlFile = fullfile(matlabroot,'toolbox','rtw','targets','mpc555dk','common',...
                      'canlib','asap2','diabmap','asap2post.pl');
case 'codewarrior'
   % specify perl script capable of processing the MAP file
   % generated by the CodeWarrior compiler
   perlFile = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', 'mpc555dk', 'common', ...
                        'canlib', 'asap2', 'codewarriormap', 'asap2post.pl');
otherwise 
   warning(['ASAP2 address propagation from the MAP file is not supported for toolchain, ' tprefs.ToolChain]);
end;
% post process the ASAP2 file
memModel = uget_param(codeGenModelName,'TARGET_MEMORY_MODEL');
mapfile = ['../' codeGenModelName '_' lower(memModel) '.map'];
target_asap2_utils('postProcess', codeGenModelName, perlFile, mapfile);

%% code generation only, or full build?
if (generateCodeOnly == 0)  
   % force reload of htmlreport.m from disk
   clear htmlreport;
   htmlreport;
   delete htmlreport.m;  % house keeping
   fprintf(1,'### Successful completion of MPC Real-Time Target build procedure for model: %s\n', codeGenModelName); 
   % Some target action may be requested, which is only relevent
   % when we have actually compiled the generated code      
   i_processBuildAction(codeGenModelName);    
else
   fprintf(1, '### Successful completion of MPC Real-Time target code generation procedure for model: %s\n', codeGenModelName);      
end;
return;

function i_processBuildAction(codeGenModelName)
   % Get the BuildAction into our context
   BuildAction = uget_param(codeGenModelName,'BuildAction');
   % handle the BuildAction.
   switch BuildAction
   case 'None'
   case 'Launch_Download_Control_Panel'
         i_launchDownload(codeGenModelName);
	case { 'Run_via_BDM', 'Debug_via_BDM'}
    		% remember build dir
    		olddir = pwd;
    		% change to target dir
    		cd ..;    
			switch BuildAction
			case 'Run_via_BDM'
				tgtaction('run','mdl',codeGenModelName,0);
			case 'Debug_via_BDM'
				tgtaction('run','mdl',codeGenModelName,1);
			end
			cd(olddir);
   otherwise
      error('Unknown build action!');
   end
return;
  
function i_launchDownload(codeGenModelName)
    % remember build dir
    olddir = pwd;
    % change to target dir
    cd ..;    
    
    % initialise can download without showing gui
    import('com.mathworks.toolbox.ecoder.canlib.CanDownload.*');
    embedded_target_download('commandline');
    MemModel = uget_param(codeGenModelName,'TARGET_MEMORY_MODEL');
    switch (lower(MemModel))
        case 'ram'
            % RAM build
            % set RAM downloadtype
            embedded_target_download('set','DownloadType', char(StandaloneMPC555Control.RAM_APPLICATION_CODE));
            % set download filename
            embedded_target_download('set','DownloadFilename',fullfile(pwd,[codeGenModelName '_ram.s19']));    
        case 'flash'
            % FLASH build
            % set FLASH downloadtype
            embedded_target_download('set','DownloadType', char(StandaloneMPC555Control.FLASH_APPLICATION_CODE));
            % set download filename
            embedded_target_download('set','DownloadFilename',fullfile(pwd,[codeGenModelName '_flash.s19']));    
        otherwise
            error('Unknown memory model');        
    end;
    % show the gui
    embedded_target_download('showgui');
    
    % return to build dir
    cd(olddir);
return;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hCodeGenBlk = FcnFindCodeGenBlk(codeGenModelName)
hCodeGenModel = get_param(codeGenModelName, 'Handle');
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
