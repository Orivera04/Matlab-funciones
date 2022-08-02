function s = hc12_make_rtw_hook(method, modelName, rtwRoot, tmf, buildOpts, buildArgs)
%HC12_MAKE_RTW_HOOK: 
%  For the HC12 target, this is allow Real-Time Workshop Embedded Coder 
%  to hook cleanly into Real-Time Workshop build process.
%
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/03/21 22:57:07 $

persistent userdata;
persistent atticdata;
persistent srcMCPProjectPathAndFile;
 
if nargin == 0
  errmsg = ['No arguments provided to hc12_make_rtw_hook']
end

switch method
case 'entry' 
  master = find_system(modelName,'Tag','HardwareResourceMaster');
  if (isempty(master))
    errmsg = 'HC12 target requires one Master block from the hc12drivers library.';
    hc12drivers
	error(errmsg)
  end
  if (length(master)>1)
    errmsg = 'HC12 target requires one and only one Master block from the hc12drivers library.';
    error(errmsg)
  end
  
  tpObj = RTW.TargetPrefs.load('hc12.prefs','structure');
  mpcProjectPathAndFile_RAM    = tpObj.ProjectStationery.ProjectPathAndFile_RAM;
  mpcProjectPathAndFile_Flash  = tpObj.ProjectStationery.ProjectPathAndFile_Flash;
  mpcProjectPathAndFile_Banked = tpObj.ProjectStationery.ProjectPathAndFile_Banked;
  mpcTargetProjectType         = tpObj.TargetProjectType;
  switch lower(mpcTargetProjectType)
     case 'ram'
       srcMCPProjectPathAndFile = mpcProjectPathAndFile_RAM;
       
    case 'flash'
       srcMCPProjectPathAndFile = mpcProjectPathAndFile_Flash;
       
    case 'banked' 
       srcMCPProjectPathAndFile = mpcProjectPathAndFile_Banked;
       
     otherwise
  end
  FcnEntryMethod(modelName);

case 'before_tlc'   

    if (isappdata(0,'hc12driversMaster'))
        rmappdata(0,'hc12driversMaster');
    end
    hc12_cwautomation_close;
    [srcProjDir, srcProjFile, projSuffix, dummy1] = fileparts(srcMCPProjectPathAndFile);
    dstProjDir = pwd;
    [dstProjDir, dummy1, dummy3, dummy3] = fileparts(dstProjDir);
    
case 'after_tlc'
    
case 'before_make'
    % Generate files containing lists for building any necessary libraries.
    % For example, rtwlib.lib.
    %
    % This is the first case (e.g. 'before_make' ) where "buildOpts" is available.
    %
    hc12_libgen(modelName,rtwRoot,tmf,buildOpts,buildArgs);  

case 'exit'
  if (buildOpts.generateCodeOnly == 0)
    %
    try
    hc12_tgtaction(srcMCPProjectPathAndFile,'build');
      setappdata(0,'CodeWarriorNotFound','false');
    catch
      % Can't locate CodeWarrior
      setappdata(0,'CodeWarriorNotFound','true');
      disp('Embedded Target for Motorola HC12 requires Metrowerks CodeWarrior HC12 version 1.2 or 2.0 which was not found')
    end
    

    
    % Run code profiling report
    if (exist('htmlreport')==2)
      errmsg = htmlreport;
      if ~isempty(errmsg)
        disp(errmsg);
        error(errmsg);
      end
      delete htmlreport.m;  % housekeeping
    end
    %
    fprintf(1,'### Successful completion of BUILD for HC12 target model: %s\n', modelName); 
  else
    hc12_tgtaction(srcMCPProjectPathAndFile,'codegenonly');
    % Code gen only will not produce the htmlreport for code profiling
    %
    fprintf(1,'### Successful completion of Code Generation for HC12 target model: %s\n', modelName);      
  end 
otherwise
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTIONS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FcnEntryMethod(codeGenModelName)

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
