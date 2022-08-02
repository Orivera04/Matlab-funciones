function AddVariablesToMask(system,names,varargin)
%AddVariablesToMask adds the variables held in the cell array names to the
% block system. The optional arguments in varargin{1}, or varargin{:} will
% be considered as the values to be held in the newly created variables.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:02:31 $

% Get current variables %
% MaskPrompt names first
InitPrompts = get_param(system,'MaskPrompts');
% MaskVariables returns string like 'param1=@1;param2=@2;'
NewVars	= get_param(system, 'MaskVariables');
NumInitPrompts = length(InitPrompts);

% Ensure that the new names are held in a cell array that is 1xn
if ~iscell(names)
   names = {names};
end

% Merge old and new MaskPrompts together in a cell array
NewPrompts = {InitPrompts{:} names{:}};
% Check to see wheather MaskVariables ends in a ';'
if ~isempty(NewVars) & (NewVars(end) ~= ';')
   NewVars = [NewVars ';'];
end

% Create the new MaskVariables string
for i = 1:length(names)
   NewVars = [NewVars names{i} '=@' num2str(i+NumInitPrompts) ';'];
end

% Set the parameters on the simulink mask
set_param(system,'MaskPrompts',NewPrompts,'MaskVariables',NewVars);

% Are there any values to add to the new variables
if length(varargin) > 0
   if iscell(varargin{1})
      % If the thrid input parameter is a cell array then
      % assume it contains all the necassary values
      NewValues = varargin{1};
   else
      % Assume that varargin contains the values
      NewValues = varargin;
   end
   % Is there the correct amount of data to fill each new variable
   if length(NewValues) ~= length(names)
      error('Values and variables have different lengths')
   end
   % Concatenate the two cell arrays and set all the variables
   param = {names{:};NewValues{:}};
   set_param(system,param{:});
end
