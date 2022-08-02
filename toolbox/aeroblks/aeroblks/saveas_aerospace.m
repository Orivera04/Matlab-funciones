function saveas_aerospace(sys,prompt)
%SAVEAS_AEROSPACE Replace Aerospace Blockset version 1.0 with Simulink demo.
%   SAVEAS_AEROSPACE(SYS) replaces Aerospace Blockset version 1.0 
%   blocks within the model SYS with Simulink demo version.  Note that 
%   the model must be open prior to calling SAVEAS_AEROSPACE.  Blocks that are
%   regressed include:
%
%       2nd Order linear Actuator
%       2nd Order Non-linear Actuator
%       6DoF Animation
%       3DoF Animation
%       Direction Cosine Matrix from quaterions   
%       Direction Cosine Martix from Euler Angles
%       Euler angles from quaternions
%       3x3 cross product
%       Atmosphere Model
%       Equation of Motion (Body Axes)
%       Incidence & Airspeed
%
%   SAVEAS_AEROSPACE(SYS, PROMPT) will prompt the user for each instance of 
%   a replaceable block if the value of PROMPT is 1. This is the
%   default. A value of 0 will not prompt the user. 
%
%   When prompted, the user has three options.
%   - "y" : Replace the block  (default)
%   - "n" : Do not replace the block
%   - "a" : Replace all blocks without further prompting
%
%   In addition to above changes, SAVEAS_AEROSPACE calls ADDTERMS to terminate
%   any unconnected input and output ports by attaching Ground and
%   Terminator blocks respectively.  SAVEAS_AEROSPACE also converts blocks
%   to links in the appropriate block libraries.
%
%   SAVEAS_AEROSPACE will look for all masked built-in blocks that are not
%   subsystems or s-functions, place the block in a subsystem and
%   copy the mask and block callbacks to the new subsystem.
%
%   See also FIND_SYSTEM, GET_PARAM, ADD_BLOCK, ADDTERMS, MOVEMASK.

%   Copyright 1990-2004 The MathWorks, Inc.
%   $Revision: 1.1.2.3 $

%
% Force the user to open the model first.  This limitation is due to the
% mechanism that we use to update the version number of the model - we
% insert a call to simver in to the MATLAB execution queue which instead
% of being executed gets eaten by the input call in AskToReplace.  The
% side effect, and it's a serious one, is that the input call will gag,
% and the version of the model will not be set to 2.0.
%

if nargin==0
  error('aeroblks:saveasaerospace:invalidmodel','You must specify a model name to update.')
end

sys = bdroot(sys);

if isempty(find_system('SearchDepth',0,'Name',sys)),
  if exist(sys) == 4,
    w = warning;
    warning('off');
    open_system(sys);
    warning('aeroblks:saveasaerospace:existingwarnings',w);
  else
    error('aeroblks:saveasaerospace:invalidmodel','The model ''%s'' cannot be found, you must open the model first before using aeroupdate.',sys);
  end
end

if nargin==1,
   prompt  = 1;
   replace = 0;
end
if prompt==0,
  replace=1;
end

%
% Libraries need to be unlocked before changes can be made to them.
%
isLibrary = strcmp(get_param(sys,'BlockDiagramType'),'library');
if isLibrary,
  set_param(sys,'Lock','off');
end

%
% replaceInfo is a data structure that contains the information about
% which blocks to replace and which function to call to replace it.
% The first field is the BlockDesc which contains the arguments to
% find_system that will identify the block to replace.  The second
% field is the name of the local function that will replace the block.
% The third field is a 1 to automatically prompt the user for block
% replacement.  0 to have the block's replace function handle the
% query.
%
replaceInfo = { ...
 { 'MaskType', '6DoF (Euler Angles) EoM' }, 'ReplaceGeneralWithMask',1;...
 { 'MaskType', '6DoF (Quaternion) EoM' }, 'ReplaceGeneralWithMask',1;...
 { 'MaskType', 'Second Order Linear Actuator' }, 'ReplaceGeneralWithMask',1;... 
 { 'MaskType', 'Second Order Nonlinear Actuator' }, 'ReplaceGeneralWithMask',1;...
 { 'MaskType', '6DoF_Animation' }, 'ReplaceGeneralWithMask',1;... 
 { 'MaskType', '3DoF_Animation' }, 'ReplaceGeneralWithMask',1;... 
 { 'MaskType', 'Quaternion2Euler' }, 'ReplaceBlockGeneral',1;...
 { 'MaskType', 'CrossProduct' }, 'ReplaceBlockGeneral',1;...
 { 'MaskType', 'Quaternion2DCM' }, 'ReplaceBlockGeneral',1;... 
 { 'MaskType', 'Euler2DCM' }, 'ReplaceBlockGeneral',1;... 
 { 'MaskType', 'International Standard Atmosphere Model' }, 'ReplaceBlockGeneral',1;...
 { 'MaskType', 'Incidence&Airspeed' }, 'ReplaceBlockGeneral',1;...
 { 'MaskType', '3DoF EoM' }, 'ReplaceGeneralWithMask',1;... 
};

replaceInfo = cell2struct(replaceInfo, { 'BlockDesc', 'ReplaceFcn', 'AutoPrompt' }, 2);

updatedBlocks = {};

%
% scan the model for instances of the blocks that need replacing
%
for i=1:size(replaceInfo,1),

  % call find_system to locate any blocks that need replacing
  args=replaceInfo(i).BlockDesc;
  blocks=find_system(sys,'LookUnderMasks','all', args{:});

  % if any are found, call the ReplaceFcn
  for j=1:length(blocks),

    % strip out the carriage returns
    name=CleanBlockName(blocks{j});
    
    
    % For the "normal" case, the AutoPrompt field is 1.  This means that we 
    % handle the prompt out here and call the ReplaceFcn with 1 arg, the block
    % and expect no return.  For the case that the ReplaceFcn needs to handle the
    % prompt on its own (AutoPrompt == 0), the ReplaceFcn is called with the block,
    % and the current prompt status.  The new prompt status is returned.
    %
    replace = 1;
    if replaceInfo(i).AutoPrompt,
      if prompt
        [replace,prompt]=AskToReplace(name);
      end
    
      if replace
        % check to see if block should be replaced and replace it before 
        % giving message
        replace = feval(replaceInfo(i).ReplaceFcn, blocks{j});
      end
      
      if replace
        disp(sprintf('Updating: ''%s''\n', name));
      else
        disp(sprintf('Skipping: ''%s''\n', name));
      end
    else
      [replace, prompt] = feval(replaceInfo(i).ReplaceFcn, blocks{j}, replace, prompt);
    end %if replaceInfo(i).AutoPrompt
  
    if (replace),
      updatedBlocks{end+1} = name;
    end
  end %j
end %i

%
% terminate any unconnected ports in block diagrams, not libraries
%
if ~isLibrary,
  addterms(sys);
end

%
% Move the mask off of built-in blocks that are not subsystems
movemask(sys);

%
% generate a report of what may have been updated and suggested libraries that
% might need updating
%
indent = '  ';
disp(sprintf('\n'));
if isempty(updatedBlocks),
  disp(sprintf('No blocks in ''%s'' were updated.\n', sys));
else
  disp(sprintf('The following blocks in ''%s''were updated:\n', sys));
  for i=1:length(updatedBlocks),
    disp(sprintf('%s%s\n', indent, updatedBlocks{i}))
  end
  disp(sprintf('\n'));
end

libs = FindLibsInModel(sys);
if ~isempty(libs),
  disp(sprintf('The model ''%s'' is referencing the block libraries:\n', sys));
  for i=1:length(libs),
    disp(sprintf('%s%s\n', indent, libs{i}));
  end
  disp(sprintf('\n'));
  disp(sprintf(['You should consider running aeroupdate on them if they are ' ...
           'not Mathworks-supplied block libraries.\n']));
end

% end save_aerospace

%
%=============================================================================
% ReplaceBlockWithLink
%=============================================================================
%
function replace = ReplaceBlockWithLink(block)

replace = 1;

switch(get_param(block, 'MaskType')),
case 'Second Order Linear Actuator',
    libBlock = sprintf('aerospace/Actuators/2nd Order linear Actuator');    
case 'Second Order Nonlinear Actuator',
    libBlock = sprintf('aerospace/Actuators/2nd Order Non-linear Actuator'); 
case '6DoF_Animation',
    libBlock = sprintf('aerospace/Animation/6DoF Animation');    
case '3DoF_Animation',
    libBlock = sprintf('aerospace/Animation/3DoF Animation'); 
case 'Quaternion2Euler',
    libBlock = sprintf('aerospace/Axes\nTransformations/Euler angles\nfrom quaternions');    
case 'CrossProduct',
    libBlock = sprintf('aerospace/Axes\nTransformations/3x3 cross product'); 
case 'Quaternion2DCM', 
    libBlock = sprintf('aerospace/Axes\nTransformations/Direction Cosine Matrix\nfrom quaternions');
case 'Euler2DCM', 
    libBlock = sprintf(['aerospace/Axes\nTransformations/Direction Cosine',...
                        ' Matrix\nfrom Euler Angles']);
case 'International Standard Atmosphere Model',
    libref_atmos = sprintf('aerolibatmos/ISA Atmosphere Model');
    
    if strcmp(get_param(block,'ReferenceBlock'),libref_atmos)
        libBlock = sprintf('aerospace/Atmosphere/Atmosphere\nmodel'); 
        safe_set_param(block,'LinkStatus','none');
    else
        msg=sprintf(['Skipping ''%s''.  This block is either from a newer',...
                     ' version of the Aerospace Blockset or may have been ' ,...
                     'customized.  It will not be replaced.\n'],block);
        disp(msg)
        replace = 0;
        return;
    end    
case 'Incidence&Airspeed',
    libBlock = sprintf(['aerospace/3DoF\nEquations\nof\nMotion /Incidence',...
                        ' \n& Airspeed']); 
case '3DoF EoM',
    libref_atmos = sprintf('aerolib3dof/Equations of Motion\n(Body Axes)');
    
    if strcmp(get_param(block,'ReferenceBlock'),libref_atmos)
        libBlock = sprintf(['aerospace/3DoF\nEquations\nof\nMotion / ',...
                            'Equations of Motion\n(Body Axes)']);
        safe_set_param(block,'LinkStatus','none');
    else
        msg=sprintf(['Skipping ''%s''.  This block is either from a newer',...
                     ' version of the Aerospace Blockset or may have been ' ,...
                     'customized.  It will not be replaced.\n'],block);
        disp(msg)
        replace = 0;
        return;
    end
   
case '6DoF (Euler Angles) EoM', 
    libBlock = sprintf('aerospace/6DoF/Euler Angles');
case '6DoF (Quaternion) EoM', 
    libBlock = sprintf('aerospace/6DoF/Quaternions');
otherwise,
    error('aeroblks:saveasaerospace:invalidblocktype','Unrecognized block type');
end

block2link(block, libBlock);

% end ReplaceBlockWithLink

%
%===============================================================================
% AskToReplace
% Prompts the user for confirmation to replace a specific block.
%===============================================================================
%
function [replace,prompt]=AskToReplace(block)

%
% initialize prompt, it is only changed if the input is 'a'
%
prompt=1;

replace=input(['Replace ''' block '''? ([y]/n/a) '],'s');
if isempty(replace),
  replace=1;
else
  switch replace(1)
    case 'y'
      replace=1;

    case 'n'
      replace=0;
	
    case 'a'
      replace=1;
      prompt=0;

    otherwise,
      warning('aeroblks:saveasaerospace:invalidinput','Invalid input ''%s'', assuming ''n''.\n',replace);
      replace = 0;
  end
end

% end AskToReplace

%
%=============================================================================
% CleanBlockName
% Returns a cleansed version of the block name (cr's --> spaces)
%=============================================================================
%
function cleanName = CleanBlockName(blockName)

cleanName = strrep(blockName, sprintf('\n'), ' ');

% end CleanBlockName

%
%===============================================================================
% FindLibsInModel
% Returns a cell arry of libraries that the model references
%===============================================================================
%
function libs=FindLibsInModel(sys)

libLinks = find_system(sys,'FollowLinks','on','LookUnderMasks','all',...
                           'LinkStatus','resolved');

srcBlocks = get_param(libLinks,'ReferenceBlock');
libs = cell(size(srcBlocks));
for i=1:length(srcBlocks),
  srcBlock = srcBlocks{i};
  slashIdx = findstr(srcBlock, '/');    
  libs{i}  = srcBlock(1:(slashIdx(1)-1));
end

libs = unique(libs);
slIdx = [find(strncmp(libs,'simulink',8)); ...
         find(strncmp(libs,'aerolib',7)); ...       % aerospace blockset
         find(strncmp(libs,'cdmalib',7)); ...       % CDMA ref blockset
         find(strncmp(libs,'commlib',7)); ...       % com blockset
         find(strcmp(libs,'cstblocks')); ...        % control toolbox
         find(strncmp(libs,'daqlib',6)); ...        % daq blockset
         find(strncmp(libs,'dnglib',6)); ...        % dials blockset
         find(strcmp(libs,'c166drivers')); ...      % C166 target
         find(strcmp(libs,'hc12drivers')); ...      % CH12 target
         find(strncmp(libs,'mpc555',6)); ...        % MPC555 target
         find(strcmp(libs,'canblocks')); ...        % MPC555 target
         find(strcmp(libs,'vector_candrivers')); ...% MPC555 target
         find(strncmp(libs,'oseklib',7)); ...       % OSEK target
         find(strcmp(libs,'osekdrivers')); ...      % OSEK target
         find(strcmp(libs,'c6416dsklib')); ...      % C6000 target
         find(strcmp(libs,'c6711dsklib')); ...      % C6000 target
         find(strcmp(libs,'c6713dsklib')); ...      % C6000 target
         find(strcmp(libs,'c6701evmlib')); ...      % C6000 target
         find(strcmp(libs,'c6000dspcorelib')); ...  % C6000 target
         find(strcmp(libs,'tic62dsplib')); ...      % C6000 target
         find(strcmp(libs,'tic64dsplib')); ...      % C6000 target
         find(strcmp(libs,'tmdx326040lib')); ...    % C6000 target
         find(strcmp(libs,'rtdxBlock')); ...        % C6000 target
         find(strcmp(libs,'fuzblocks')); ...        % fuzzy logic toolbox
         find(strcmp(libs,'neural')); ...           % neural net toolbox
         find(strncmp(libs,'rfphysmodels',12)); ... % rf blockset
         find(strncmp(libs,'rfmixers',8)); ...      % rf blockset
         find(strncmp(libs,'rfamplifiers',12)); ... % rf blockset
         find(strncmp(libs,'rfblackbox',10)); ...   % rf blockset
         find(strncmp(libs,'rfmathmodels',12)); ... % rf blockset
         find(strncmp(libs,'rfladderfilt',12)); ... % rf blockset
         find(strncmp(libs,'rftxlines',9)); ...     % rf blockset
         find(strcmp(libs,'rtwinlib')); ...         % rtw target
         find(strcmp(libs,'rtwlib')); ...           % rtw 
         find(strcmp(libs,'mptlib')); ...           % rtw ecoder
         find(strcmp(libs,'rptgenlib')); ...        % report generator
         find(strncmp(libs,'dsp',3)); ...           % dsp blockset
         find(strncmp(libs,'simevents',9)); ...     % simevents
         find(strncmp(libs,'mblib',5)); ...         % simmechanics
         find(strcmp(libs,'powerlib')); ...         % simpowersystems
         find(strcmp(libs,'electricdrivelib')); ... % simpowersystems-drives
         find(strcmp(libs,'slctrlextras')); ...     % simulink control design
         find(strcmp(libs,'spelib')); ...           % simulink parameter estimation
         find(strcmp(libs,'srolib')); ...           % simulink response optimizer
         find(strcmp(libs,'sflib')); ...            % stateflow
         find(strcmp(libs,'slident')); ...          % sysid toolbox
         find(strcmp(libs,'tdma_lib')); ...         % TDMA blockset
         find(strcmp(libs,'vrlib')); ...            % virtual reality toolbox
         find(strcmp(libs,'xpclib')); ...           % xpc target        
         find(strcmp(libs,sys))];
libs(slIdx) = [];

% end FindLibsInModel

%
%=============================================================================
% block2link
% Replace a block with a link to a block
%=============================================================================
%
function block2link(block, refstring)

if strcmp(get_param(block, 'linkstatus'),'none'),

  slashes = find(refstring=='/');
  library = refstring(1:slashes(1)-1);

  if isempty(find_system('type','block_diagram','name',library)),
    feval(library,[],[],[],'load');
  end

  safe_set_param(block, 'ReferenceBlock', refstring);

  origLock = get_param(library,'Lock');
  set_param(library, 'Lock', 'off');
  get_param(block, 'LinkStatus'); % force update
  set_param(library, 'Lock', origLock);

end

% end block2link

%
%=============================================================================
% safe_set_param
% Same as set_param, however, the call to set_param is protected by try/catch
% so that errors can be treated as a warning.
%=============================================================================
%
function safe_set_param(block, varargin)

try
  set_param(block, varargin{:})
catch
  errmsg = lasterr;
  msg = sprintf(['An error occured when setting a parameter for ''%s''.  ' ...
                 'The error message reported by MATLAB was:\n%s\n'],...
                 CleanBlockName(block), errmsg);
  warning('aeroblks:saveasaerospace:safeseterror',msg);
end
                                                                 
%end safe_set_param

%
%===============================================================================
% ReplaceGeneralWithMask
% Replace blocks with mask parameters
%===============================================================================
%
function replace = ReplaceGeneralWithMask( block )

% Save the original settings for the initial conditions
entries = get_param(block,'MaskValues');

replace = ReplaceBlockGeneral( block );

safe_set_param(block,'MaskValues',entries);

% end ReplaceGeneralWithMask

%
%===============================================================================
% ReplaceBlockGeneral
% Replace blocks without mask parameters
%===============================================================================
%
function replace = ReplaceBlockGeneral( block )

safe_set_param(block,'LinkStatus','none');

replace = ReplaceBlockWithLink( block );

% end ReplaceBlockGeneral

