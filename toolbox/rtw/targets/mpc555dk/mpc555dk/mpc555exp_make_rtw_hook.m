function mpc555exp_make_rtw_hook(method, modelName, rtwRoot, tmf, buildOpts, buildArgs)
%MPC555EXP_MAKE_RTW_HOOK  Make RTW hook file for mpc555exp.tlc target

% Copyright 2004 The MathWorks, Inc.
% $Revision: 1.11.4.6 $
% $Date: 2004/04/16 22:19:57 $

switch method
case 'entry'
  FcnEntryMethod(modelName);
case 'before_tlc'
  % No action
case 'before_make'
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
  if (buildOpts.generateCodeOnly == 0)
    % force reload of htmlreport.m from disk
    clear htmlreport;
    htmlreport;
    delete htmlreport.m;  % house keeping
    fprintf(1,'### Successful completion of MPC Algorithm Export Target build procedure for model: %s\n', modelName); 
  else
    fprintf(1, '### Successful completion of MPC Algorithm Export target code generation procedure for model: %s\n', modelName);      
  end
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
  isoCSupported=0;
  mpc555_tfl(cs, tprefs, isoCSupported);
  
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

