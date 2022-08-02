function varargout = mpc555pil_make_rtw_hook(method, modelName, rtwRoot, tmf, buildOpts, buildArgs)
% MPC555PIL_MAKE_RTW_HOOK  Make RTW hook file for mpc555pil.tlc target

% Copyright 2004 The MathWorks, Inc.
% $Revision: 1.13.2.7 $ $Date: 2004/04/16 22:19:59 $

persistent userdata;
persistent atticdata;

switch method
case 'entry'
	%open_system(modelName);
	FcnEntryMethod(modelName);
case 'before_tlc'
	% No action
case 'before_make'
	clear([modelName, '_sf']);
	clear([modelName, '_pil_sf']);
        % Ensure that the target preferences are valid before 
        % building.
        p = RTW.TargetPrefs.load('mpc555.prefs');
        try
          p.validate;
        catch
          uiwait(errordlg(lasterr,'Target Preference Error'));
          p.gui;
          return;
        end
case 'exit'
	FcnExitMethod(modelName, buildOpts.generateCodeOnly, modelName, rtwRoot, tmf, buildOpts, buildArgs);      

case 'backupRTWattic'
	% cache the rtw attic's userdata locally.
	atticdata = getRTWattic;
	varargout{1} = atticdata;
case 'restoreRTWattic'
	% restore the cached rtw attic userdata to the attic.
	status = loadRTWattic(atticdata);
case 'atu'
	% copy atticdata to userdata
	userdata = atticdata;
case 'uta'
	% copy userdata to atticdata
	atticdata = userdata;
case 'getUserdata'
	% return a copy of the userdata structure
	varargout{1} = userdata;
case 'getAtticdata'
	% return a copy of the atticdata structure
	varargout{1} = atticdata;
case 'setUserdata'
	% (modelName is argv(1)) - place the give data in userdata.
	userdata = modelName;
case 'setAtticdata'
	% (modelName is argv(1)) - place the give data in atticdata.
	atticdata = modelName;
case 'addtoRTWattic'
	% add something new to the rtw attic.
	addtoRTWattic(modelName,rtwRoot);
case 'getfromRTWattic'
	% add something new to the rtw attic.
	varargout{1} = getfromRTWattic(modelName);
case 'clean'
	% clear the userdata, atticdata and actual RTWattic data.
	clear userdata;
	clear atticdata;
	userdata = rtwprivate('rtwattic','clean');
otherwise
	errordlg(['Unrecognized hook file method: ', method]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FcnEntryMethod(codeGenModelName)

  cs = getActiveConfigSet(codeGenModelName);  
  tprefs = RTW.TargetPrefs.load('mpc555.prefs');

  % Set ISO or ANSI C for floating point math calls
  isoCSupported=0;
  mpc555_tfl(cs, tprefs, isoCSupported);
  
% Save the model being built later use by tgtaction.
addtoRTWattic('modelName',codeGenModelName);

% Verify that our invocation came through the correct context, ssgencode.
FcnValidateBuildContext;

% Make sure the option to build an s-function
% is always selected - otherwise PIL build fails.
FcnForceGenERTSfun;

% Find subsystem in code generation model
hCodeGenBlk = FcnFindCodeGenBlk(codeGenModelName);

% Check for configurable subsystem
if FcnIsConfigSS(hCodeGenBlk)
	% Check that it is using the correct BlockChoice
	blockChoice = get_param(hCodeGenBlk, 'BlockChoice');
	memberBlocks = get_param(hCodeGenBlk, 'MemberBlocks');
	origBlkName = strtok(memberBlocks, ',');
	if ~strcmp(blockChoice, origBlkName)
		errTxt = sprintf([...
		'Invalid block choice selected for building the subsystem ', ...
		'for processor-in-the-loop co-simulation.\nSelect the first ', ...
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
else
	FcnCheckValidCodeGenBlk(hCodeGenBlk);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FcnExitMethod(codeGenModelName,generateCodeOnly,modelName, rtwRoot, tmf, buildOpts, buildArgs)


  % Find generated S-Function, otherwise return
  hSFunBlk = FcnFindSFunBlk(codeGenModelName);
  if ~isempty(hSFunBlk)
    % Clear mask initialization code inherited from RTW S-Function block.
    set_param(hSFunBlk,'MaskInitialization','');
  else
    return;
  end

   if (generateCodeOnly == 0)
      % Our post processing to create a configuable subsystem is only 
	   % performed when we have actually compiled the generated code
	   try
		   % Go to working directory
   		oldDir = cd;
	   	cd ..

   		% Find original block
	   	hOrigBlk = FcnFindOrigBlk(codeGenModelName);

   		% Create / modify library with configurable subsystem
	   	FcnPILSFunPost(codeGenModelName, hOrigBlk, hSFunBlk);

   		% Close ERT S-Function model now that we're done with it.
	   	sFunModel = get_param(bdroot(hSFunBlk), 'Name');
		   bdclose(sFunModel);

		   % Return to build directory
   		cd(oldDir);
	   catch
		   cd(oldDir);
   		error(lasterr);
	   end
   end

   if (generateCodeOnly == 0)
	   %
   	% Some target action may be requested, which is only relevent
   	% when we have actually compiled the generated code
   	%
   
	   % Get the BuildAction into our context
      BuildAction = uget_param(codeGenModelName,'BuildAction');

   	% handle the BuildAction.
	   switch BuildAction
   	case 'None'
	   case 'Launch_Download_Control_Panel'
         i_launchCanDownload(codeGenModelName);
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
   end

   if (generateCodeOnly == 0)
   % force reload of htmlreport.m from disk
   clear htmlreport;
	htmlreport;
	delete htmlreport.m;  % house keeping
	fprintf('### Successful completion of MPC PIL target build procedure for model: %s\n', codeGenModelName);  
   else 
	% When no compilation has been performed we simply declare the
	% process to be complete.
	fprintf('### Successful completion of MPC PIL target code generation procedure for model: %s\n', codeGenModelName);
   end
   %
   % Whether we compile or not we cache the rtwattic context in case a
   % tgtaction requires it in further post processing.
   %
   % tgtaction requires information from the rtw attic, but it gets
   % cleared when the make is complete so here it is cached away
   % to be restored through this hook's loadRTWattic function when
   % needed. This hook's 'clean' method is used to clear both the
   % cached userdata and rtwattic's data. This hook's local userdata
   % is cleared when it is successfully restored to the rtwattic.
   mpc555pil_make_rtw_hook('backupRTWattic');
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hCodeGenBlk = FcnFindCodeGenBlk(codeGenModelName)
hCodeGenModel = get_param(codeGenModelName, 'Handle');

if (strncmp('6.1',version,3) ~= 1)
	hCodeGenBlk = find_system(hCodeGenModel, ...
	'SearchDepth', 1, ...
	'BlockType',   'SubSystem', ...
	'Name', codeGenModelName);
else
	hCodeGenBlk = find_system(hCodeGenModel, ...
	'SearchDepth', 1, ...
	'BlockType',   'SubSystem');
end

% REDUNDANT ERROR CHECK:
% Should never error out from Rt-click build
if length(hCodeGenBlk)>1
	errTxt = sprintf(['Multiple subsystems were found where only one was ', ...
	'expected.\nThe processor-in-the-loop co-simulation target is ', ...
	'designed to generate code for a single subsystem. To initiate ', ...
	'the build process, right-click on the relevant subsystem and ', ...
	'select ''Build Subsystem'' from the ''Real-Time Workshop'' submenu.']);
	error(errTxt);
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FcnCheckValidCodeGenBlk(hCodeGenBlk)
if (strncmp('6.1',version,3) ~= 1)
	% In 6.5+ subsystem generation no longer appends the '_blk'
	% suffix. The generated subsystem now has the same name as the
	% original sybsystem, so this check is not valid for 6.5+.
	%
	% This is dealt with in two ways. The original subsystem handle and
	% the generated model handle are now cached in the rtwattic by
	% ss2mdl. Also, there is another check that validates that this
	% function is from a Rt-click build before getting here.
	return;
end

% CodeGenBlk must end in '_blk'
codeGenBlkName = get_param(hCodeGenBlk, 'Name');

% REDUNDANT ERROR CHECK:
% Should never error out from Rt-click build
if ~strncmp(fliplr(codeGenBlkName), 'klb_', 4)
	errTxt = sprintf('Subsystem name is invalid: \n%s', getfullname(hCodeGenBlk));
	error(errTxt);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hSFunBlk = FcnFindSFunBlk(rootSFunName)

SFunName = [rootSFunName, '_sf'];

hSFunBlk = find_system(0, ...
'SearchDepth',  1, ...
'FunctionName', SFunName, ...
'BlockType',    'S-Function');

if length(hSFunBlk)>1
	warnTxt = sprintf('Multiple S-Function blocks found with FunctionName ''%s''', ...
	SFunName);
	warning(warnTxt);
end
hSFunBlk = hSFunBlk(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hOrigBlk = FcnFindOrigBlk(codeGenModelName)
if (strncmp('6.1',version,3) ~= 1)
	% The original subsystem handle and the generated model handle
	% are now cached in the rtwattic by ss2mdl. 
	hOrigBlk = rtwprivate('rtwattic','AtticData','OrigBlockHdl');
	return;
end

% Find subsystem in code generation model
hCodeGenBlk = FcnFindCodeGenBlk(codeGenModelName);

% Check validity of this block
FcnCheckValidCodeGenBlk(hCodeGenBlk);

% Remove '_blk' from codeGenBlkName to get origBlkName
codeGenBlkName = get_param(hCodeGenBlk, 'Name');
origBlkName = codeGenBlkName(1:end-4);

% Find original block based on block name
hOpenModels = find_system(0, 'BlockDiagramType', 'model');
hOrigBlk = find_system(hOpenModels, ...
'BlockType', 'SubSystem', ...
'Name', origBlkName);

% Handle case of multiple blocks with same name
%warning('Need to check case of multiple blocks with same name');
if length(hOrigBlk)>1
	% Find the correct block if you can
	warnTxt = sprintf(['Multiple subsystems were found from which the build ', ...
	'process could have been initiated. The first one is being copied to ', ...
	'the newly created library. If this is the incorrect subsystem, please ', ...
	'copy the correct one into the library in its place.']);
	warning(warnTxt);
end

hOrigBlk = hOrigBlk(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FcnPILSFunPost(rootSFunName, hOrigBlk, hSFunBlk);

% Check for PIL S-Function MEX file
ertSFunMexFile = [cd, filesep, rootSFunName, '_sf'];
pilSFunMexFile = [cd, filesep, rootSFunName, '_pil_sf'];
%warning('Check for ERT & PIL S-Function MEX files not currently being done')

% Define local constants:
spacing = 50;
titleWidth = 250;
titleHeight = 130;
buttonSize = 25;

% Load necessary libraries
SLLib = 'simulink3';
load_system(SLLib);

% Check whether original block is a configurable subsystem
codeGenFromConfigSS = FcnIsConfigSS(hOrigBlk);

if codeGenFromConfigSS
	% NOTE:
	% - If you get this far, the number of ports in the original block
	%   differs from the number of ports in the SIL & PIL subsystems.
	%   ==> Delete these two subsystems and replace them with new ones.

	% Get handles from configurable subsystem in model
	hNewConfigSS = get_param(get_param(hOrigBlk, 'TemplateBlock'), 'Handle');
	hLib = bdroot(hNewConfigSS);
	libName = get_param(hLib, 'Name');
	set_param(hLib, 'Lock', 'off');

	% Get names of blocks in the library from MemberBlocks
	% 1 - Original Subsystem
	% 2 - SIL Subsystem
	% 3 - PIL Subsystem 
	% ... there should not be any others, but use strtok just in case ...
	memberBlocks = get_param(hNewConfigSS, 'MemberBlocks');
	[origBlkName, memberBlocks] = strtok(memberBlocks, ',');
	[newSILSSName, memberBlocks] = strtok(memberBlocks(2:end), ',');
	newPILSSName = strtok(memberBlocks(2:end), ',');

	% NOTE: Configurable subsystem treats new-line characters as spaces.
	% We need to get the actual name from the blocks themselves
	origBlkName = get_param([libName, '/', origBlkName], 'Name');
	newSILSSName = get_param([libName, '/', newSILSSName], 'Name');
	newPILSSName = get_param([libName, '/', newPILSSName], 'Name');

	newConfigSSName = get_param(hNewConfigSS, 'Name');
	parentOrigBlk = get_param(hOrigBlk, 'Parent');
	newSSName = origBlkName;

	%***********************************************************************
	% WARNING: REVERTING hOrigBlk TO ORIGINAL BLOCK IN THE LIBRARY
	%***********************************************************************
	hOrigBlk = get_param([libName, '/', origBlkName], 'Handle');

	% Delete all annotations
	hAnnotations = find_system(hLib, ...
	'FindAll', 'on', ...
	'SearchDepth', 1, ...
	'Type', 'annotation');
	for i = 1:length(hAnnotations)
		set_param(hAnnotations(i), 'Text', '');
  end

  % Delete all blocks except original subsystem & configurable subsystem
  set_param(hNewConfigSS, 'MemberBlocks', strrep(origBlkName, sprintf('\n'), ' '));
  hBlocks = find_system(hLib, 'SearchDepth', 1);
  for i = 1:length(hBlocks)
	  hThisBlk = hBlocks(i);
	  if ((hThisBlk == hLib) | ...
		  (hThisBlk == hOrigBlk) | ...
		  (hThisBlk == hNewConfigSS))
		  % No action
	else
		delete_block(hThisBlk);
	end
end
else
	% Set up names for new blocks
	origBlkName = get_param(hOrigBlk, 'Name');
	newSILSSName = [origBlkName, sprintf('\n(SIL)')];
	newPILSSName = [origBlkName, sprintf('\n(PIL)')];
	newConfigSSName = [origBlkName, sprintf('\n(Configurable Subsystem)')];
	parentOrigBlk = get_param(hOrigBlk, 'Parent');
	newSSName = origBlkName;

	% Create new library & force ModelBrowserVisibility OFF
	libName = local_GetUniqueLibraryName(rootSFunName);
	hLib = new_system(libName, 'Library');
	set_param(hLib, 'ModelBrowserVisibility', 'off');
	save_system(hLib);
end

% Get block dimensions from original block
origBlkPos  = get_param(hOrigBlk, 'Position');
widthBlk  = origBlkPos(3)-origBlkPos(1);
heightBlk = origBlkPos(4)-origBlkPos(2);

% Add title text
xPos = 2*spacing+3/2*widthBlk-titleWidth/2;
yPos = spacing/3;
FcnAddTitleText([parentOrigBlk, '/', origBlkName], libName, xPos, yPos);
yPos = yPos + titleHeight + 0.75*spacing;

if ~codeGenFromConfigSS
	% Add Configurable subsystem
	xPos = 2*spacing+widthBlk;
	srcBlk = sprintf([SLLib, '/Subsystems/Configurable\nSubsystem']);
	configSSOpenFcn = [...
	'if strcmp(get_param(bdroot(gcbh), ''BlockDiagramType''), ''model''),', ...
	'  open_system(gcbh, ''force''); ', ...
	'end'];
	hNewConfigSS = add_block(srcBlk, [libName, '/', newConfigSSName], ...
	'Position', [xPos, yPos, xPos+widthBlk, yPos+heightBlk], ...
	'Orientation', get_param(hOrigBlk, 'Orientation'), ...
	'NamePlacement', get_param(hOrigBlk, 'NamePlacement'), ...
	'OpenFcn', configSSOpenFcn);
end

% Move position to below configurable subsystem
yPos = yPos + heightBlk + 0.75*spacing;

% Add buttons to launch help & insert configurable subsystem into original model
xPos = spacing/2;
FcnAddButtonBlocks(hOrigBlk, parentOrigBlk, hNewConfigSS, yPos, buttonSize, spacing);
yPos = yPos + 3*buttonSize + spacing;

if ~codeGenFromConfigSS
	% Copy original block to library
	xPos = spacing;
	newSSName = origBlkName;
	hNewSSBlk = add_block(hOrigBlk, [libName, '/', newSSName], ...
	'Position', [xPos, yPos, xPos+widthBlk, yPos+heightBlk]);
else
	% Set up positioning for new subsystems
	xPos = origBlkPos(1);
	yPos = origBlkPos(2);
end

% Create temporary subsystem
hTmpSSBlk = FcnCreateTmpSSBlk(hOrigBlk, hSFunBlk);

% Add SIL S-Function subsystem:
xPos = xPos+(spacing+widthBlk);
hNewSILSS    = add_block(hTmpSSBlk, [libName, '/', newSILSSName], ...
'Position', [xPos, yPos, xPos+widthBlk, yPos+heightBlk], ...
'MaskDisplay', 'disp(''SIL'')', ...
'Tag', 'MPC555_SIL_SFunction');
hNewSILSFcn   = find_system(hNewSILSS, 'LookUnderMasks', 'all', ...
'SearchDepth', 1, 'BlockType', 'S-Function');
set_param(hNewSILSFcn, 'Name', 'SIL_sfcn');

% Add Processor-in-the-loop subsystem
xPos = xPos+(spacing+widthBlk);
hNewPILSS    = add_block(hTmpSSBlk, [libName, '/', newPILSSName], ...
'Position', [xPos, yPos, xPos+widthBlk, yPos+heightBlk], ...
'MaskDisplay', 'disp(''PIL'')', ...
'Tag', 'MPC555_PIL_SFunction');
hNewPILSFcn   = find_system(hNewPILSS, 'LookUnderMasks', 'all', ...
'SearchDepth', 1, 'BlockType', 'S-Function');
set_param(hNewPILSFcn, 'Name', 'PIL_sfcn', ...
'rtw_sf_name', [rootSFunName, '_pil_sf'],...
'FunctionName',[rootSFunName, '_pil_sf']);

% Set up Configurable subsystem
memberBlocks = [newSSName, ',', newSILSSName, ',', newPILSSName];
set_param(hNewConfigSS, ...
'MemberBlocks', strrep(memberBlocks, sprintf('\n'), ' '), ...
'BlockChoice', strrep(newSSName, sprintf('\n'), ' '), ...
'AttributesFormatString', '%<BlockChoice>', ...
'ShowName', 'off');

% Set up location of library
libWidth = max((3*widthBlk + 4*spacing), (titleWidth+spacing));
libHeight = titleHeight + 2*heightBlk + 3*buttonSize + 3.75*spacing;
set_param(hLib, 'Location', spacing+[0, 0, libWidth, libHeight]);

% Close intermediate model
bdclose(bdroot(hTmpSSBlk));

% If this is a new library, save it.
if ~codeGenFromConfigSS
	save_system(hLib);
end

% Open library
open_system(hLib);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FcnAddTitleText(fullOrigBlkName, libName, titleX, titleY)

% Get values needed for creating title
rtwVer = ver('rtw');
rtwVer = rtwVer.Version;
mpc555Ver = ver('mpc555dk');
mpc555Ver = mpc555Ver.Version;
fullOrigBlkName = strrep(fullOrigBlkName, sprintf('\n'), ' ');

% Add annotations for Title & Details
titleText = sprintf([libName, '/\n', ...
'  *** Simulink library generated for MPC555PIL ***  \n', ...
'\n', ...
'    Real-Time Workshop %s\n', ...
'    Embedded Target for Motorola MPC555 %s\n', ...
'    Generated on: %s\n', ...
'\n', ...
'    Original subsystem:\n', ...
'      %s\n'], ...
rtwVer, mpc555Ver, datestr(now, 31), strrep(fullOrigBlkName, '/', '//'));
add_block('built-in/Note', titleText, ...
'Position', [titleX, titleY, titleX, titleY], ...
'HorizontalAlignment', 'left', ...
'DropShadow', 'on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FcnAddButtonBlocks(hOrigBlk, parentOrigBlk, hNewConfigSS, yPos, buttonSize, spacing)

% Set up names for button blocks
libName = get_param(bdroot(hNewConfigSS), 'Name');
fullHelpBlkName = [libName, sprintf('/PIL Single Model Help')];
fullInsertBlkName = [libName, sprintf('/Insert Configurable Subsystem')];
fullRevertBlkName = [libName, sprintf('/Revert to Original Subsystem')];
xPos = spacing/2;

% Get names for original block & configurable subsystem
origBlkName = get_param(hOrigBlk, 'Name');
configSSName = get_param(hNewConfigSS, 'Name');
fullOrigBlkName = [parentOrigBlk, '/', origBlkName];
fullConfigSSName = [parentOrigBlk, '/', configSSName];

% Add "Help" block
fullButtonName = fullHelpBlkName;
buttonMaskType = 'PIL Single Model Help';
buttonMaskDisplay = 'disp(''?'');';
buttonDescription = sprintf([...
'Double-click for help with\n', ...
'modifying the original model.']);
buttonMaskVariables = '';
buttonMaskPrompts = {};
buttonMaskValues = {};
buttonOpenFcn = ['mpc555pil_single_model_help'];
buttonPos = [xPos yPos xPos+buttonSize yPos+buttonSize];
buttonText = [libName, '/', buttonDescription];
buttonTextPos = [buttonPos(3)+15, buttonPos(2), buttonPos(3)+15, buttonPos(2)];
yPos = yPos + buttonSize + spacing/5;

add_block('built-in/Subsystem', fullButtonName, ...
'Position', buttonPos, ...
'BackgroundColor', 'cyan', ...
'DropShadow', 'on', ...
'ShowName', 'off', ...
'MaskType', buttonMaskType, ...
'MaskDescription', buttonDescription, ...
'MaskDisplay', buttonMaskDisplay, ...
'OpenFcn', buttonOpenFcn);
add_block('built-in/Note', buttonText, ...
'Position', buttonTextPos, ...
'HorizontalAlignment', 'left');

% Add "Insert" block
fullButtonName = fullInsertBlkName;
buttonMaskType = 'Insert Configurable Subsystem';
buttonMaskDisplay = 'disp(''==>'');';
buttonDescription = sprintf([...
'Replace the original subsystem in the model\n', ...
'with the configurable subsystem from this library.']);
buttonMaskVariables = 'configSSName=@1;fullOrigBlkName=@2;';
buttonMaskPrompts = {'Configurable subsystem:', 'Original subsystem:'};
buttonMaskValues = {configSSName, fullOrigBlkName};
buttonOpenFcn = ['mpc555pil_replace_config_subsys(''insert'', ', ...
'bdroot, get_param(gcb, ''configSSName''), get_param(gcb, ''fullOrigBlkName''));'];
buttonPos = [xPos yPos xPos+buttonSize yPos+buttonSize];
buttonText = [libName, '/', buttonDescription];
buttonTextPos = [buttonPos(3)+15, buttonPos(2), buttonPos(3)+15, buttonPos(2)];
yPos = yPos + buttonSize + spacing/5;

add_block('built-in/Subsystem', fullButtonName, ...
'Position', buttonPos, ...
'BackgroundColor', 'cyan', ...
'DropShadow', 'on', ...
'ShowName', 'off', ...
'MaskType', buttonMaskType, ...
'MaskDescription', buttonDescription, ...
'MaskDisplay', buttonMaskDisplay, ...
'MaskVariables', buttonMaskVariables, ...
'MaskPrompts', buttonMaskPrompts, ...
'MaskValues', buttonMaskValues, ...
'OpenFcn', buttonOpenFcn);
add_block('built-in/Note', buttonText, ...
'Position', buttonTextPos, ...
'HorizontalAlignment', 'left');

% Add "Revert" block
fullButtonName = fullRevertBlkName;
buttonMaskType = 'Revert to Original Subsystem';
buttonMaskDisplay = 'disp(''<=='');';
buttonDescription = sprintf([...
'Replace the configurable subsystem in the model\n', ...
'with the copy of the original subsystem in this library.']);
buttonMaskVariables = 'origBlkName=@1;fullConfigSSName=@2;';
buttonMaskPrompts = {'Original subsystem:', 'Configurable subsystem:'};
buttonMaskValues = {origBlkName, fullConfigSSName};
buttonOpenFcn = ['mpc555pil_replace_config_subsys(''revert'', ', ...
'bdroot, get_param(gcb, ''origBlkName''), get_param(gcb, ''fullConfigSSName''));'];
buttonPos = [xPos yPos xPos+buttonSize yPos+buttonSize];
buttonText = [libName, '/', buttonDescription];
buttonTextPos = [buttonPos(3)+15, buttonPos(2), buttonPos(3)+15, buttonPos(2)];
yPos = yPos + buttonSize + spacing/5;

add_block('built-in/Subsystem', fullButtonName, ...
'Position', buttonPos, ...
'BackgroundColor', 'cyan', ...
'DropShadow', 'on', ...
'ShowName', 'off', ...
'MaskType', buttonMaskType, ...
'MaskDescription', buttonDescription, ...
'MaskDisplay', buttonMaskDisplay, ...
'MaskVariables', buttonMaskVariables, ...
'MaskPrompts', buttonMaskPrompts, ...
'MaskValues', buttonMaskValues, ...
'OpenFcn', buttonOpenFcn);
add_block('built-in/Note', buttonText, ...
'Position', buttonTextPos, ...
'HorizontalAlignment', 'left');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fileName = local_GetUniqueLibraryName(baseName)

% Remove numbers at the end of baseName and add '_lib'.
baseName = [baseName(1:max(find(baseName>'9'))), '_lib'];
fileName = baseName;
counter = 1;

% Add number suffix if a model of this name already exists.
while (exist(fileName)==4) % Existing Simulink model name
	fileName = [baseName, num2str(counter)];
	counter=counter+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hTmpSSBlk = FcnCreateTmpSSBlk(hOrigBlk, hSFunBlk)

% Specify name for S-Function block
sfunName = 'rtw_sfcn';

% Create temporary model
hTmpModel = new_system;
tmpModelName = get_param(hTmpModel, 'Name');

% Add subsystem to temporary model (same appearance as original block)
tmpSSBlk = [tmpModelName, '/SubSystem'];
hTmpSSBlk = add_block('built-in/SubSystem', tmpSSBlk, ...
'Backgroundcolor', get_param(hOrigBlk, 'Backgroundcolor'), ...
'Foregroundcolor', get_param(hOrigBlk, 'Foregroundcolor'), ...
'Position', get_param(hOrigBlk, 'Position'), ...
'Orientation', get_param(hOrigBlk, 'Orientation'), ...
'NamePlacement', get_param(hOrigBlk, 'NamePlacement'), ...
'FontName', get_param(hOrigBlk, 'FontName'), ...
'FontSize', get_param(hOrigBlk, 'FontSize'), ...
'FontWeight', get_param(hOrigBlk, 'FontWeight'), ...
'FontAngle', get_param(hOrigBlk, 'FontAngle'));

% Copy S-Function block to subsystem
tmpSFunBlk = [tmpSSBlk, '/', sfunName];
hTmpSFunBlk = add_block(hSFunBlk, tmpSFunBlk);
sfunPos = get_param(hTmpSFunBlk, 'Position');
xMin = 100;
xMax = xMin+sfunPos(3)-sfunPos(1);
yMin = 100;
yMax = yMin+sfunPos(4)-sfunPos(2);
set_param(hTmpSFunBlk, ...
'Position',      [xMin yMin xMax yMax], ...
'Orientation',   'right', ...
'NamePlacement', 'normal');

% Add input ports
hPorts = find_system(hOrigBlk, ...
'SearchDepth', 1, ...
'LookUnderMasks', 'on', ...
'FollowLinks',    'on', ...
'BlockType',      'Inport');
for i = 1:length(hPorts)
	portName = get_param(hPorts(i), 'Name');
	hTmp = add_block(hPorts(i), [tmpSSBlk, '/', portName], ...
	'Position', [xMin-55 50*i xMin-30 14+50*i]);
	add_line(hTmpSSBlk, [portName, '/1'], [sfunName, '/', num2str(i)]);
end

% Add output ports
hPorts = find_system(hOrigBlk, ...
'SearchDepth', 1, ...
'LookUnderMasks', 'on', ...
'FollowLinks',    'on', ...
'BlockType',      'Outport');
for i = 1:length(hPorts)
	portName = get_param(hPorts(i), 'Name');
	hTmp = add_block(hPorts(i), [tmpSSBlk, '/', portName], ...
	'Position', [xMax+30 50*i xMax+55 14+50*i]);
	add_line(hTmpSSBlk, [sfunName, '/', num2str(i)], [portName, '/1']);
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
function userdata = getRTWattic
% return a copy of the RTWattic data.
userdata = fRTWattic('userdata');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function addtoRTWattic(var, value)
fRTWattic(var,value);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = getfromRTWattic(var);
varargout{1} = fRTWattic(var);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function status = loadRTWattic(userdata)
% take the given structure and update or add 
% its fields to the RTWattic
status = 0;
try
	fields = fieldnames(userdata);
	for i=1:length(fields)
		data = eval(['userdata.' char(fields(i))]);
		eval(['fRTWattic(''' char(fields(i)) ''',data);']);
	end
	status = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function userdata = fRTWattic(varargin)
% interface the rtwattic method mechanism
fhandle = @setRTWatticdata;
userdata = rtwprivate('rtwattic',fhandle,varargin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = setRTWatticdata(UD, varargin)
% This is an external rtwattic method.
varargout{1} = UD;
switch length(varargin)
case 1
	varargin = varargin{1};
end
switch length(varargin)
case 1
		if  isempty(UD)
			varargout{2} = [];
		else    
			switch varargin{1}
			case 'userdata'
				varargout{2} = UD;
	 otherwise
		 varargout{2} = eval(['UD.' varargin{1}]);
	end
end 
   case (2)
	   eval(['UD.' varargin{1} ' =  varargin{2};']);
	   varargout{2} = [];
   otherwise
	   error([mfilename ' localState accepts no more than two arguments']);
  end
  varargout{1} = UD;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function value = FcnValidateBuildContext
%
% The model we build must fix certain criteria. 
%

% One way to be sure we have the correct criteria is to be sure
% the build process came from the right-click-build-subsystem
% UI. This UI invokes ssgencode, so we can check that arriving
% here came through ssgencode by looking at the execution stack.

Context = dbstack;
for i = 1:length(Context)
	  if strfind(Context(i).name,'ssgencode')
		  value = 1;
		  return;
	  end
  end

  % Another way to end up here is through programatic invocation
  % that reproduces the behavior of ssgencode without calling
  % it. Our regression test engine, rtwsim, does this. So, check
  % for rtwsim on the stack.
  for i = 1:length(Context)
	  if strfind(Context(i).name,'rtwsim')
		  value = 1;
		  return;
	  end
  end
  errTxt = sprintf([...
  'Invalid block choice selected for building. Select a\n', ...
  'subsystem for processor-in-the-loop co-simulation and\n', ...
  'start a Build Subsystem process.']); 
  error(errTxt);
  value = 0;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function TargetCompiler = FcnGetTargetCompiler
  %
  % The compiler is determined from the target preferences when the
  % TemplateMakeFile (TMF) is the default,
  % 'mpc555pil_default_tmf'. 
  % 

  %
  % get the preferred target compiler
  %
  prefs = RTW.TargetPrefs.load('mpc555.prefs');
  TargetCompiler = prefs.ToolChain;


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  function FcnForceGenERTSfun
  %
  % force -aGenerateErtSFunction=0 to -aGenerateErtSFunction=1
  % 
  
  % get the model name
  modelName = getfromRTWattic('modelName');

  % silently enforce s-function generation
  % otherwise a PIL build error occurs
  genERTSfun = uget_param(modelName, 'GenerateErtSFunction');
  if ~strcmp(lower(genERTSfun), 'on')
     uset_param(modelName, 'GenerateErtSFunction', 'on');
  end


function i_launchCanDownload(codeGenModelName)
    a = pwd;
    cd ..
    fname =fullfile(pwd,[codeGenModelName '_ram.s19'])
    mpc555_launch_downloader(fname, 0);
    cd(a);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
