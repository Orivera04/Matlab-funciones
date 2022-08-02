function aeroblkwindgust
% AEROBLKWINDGUST Aerospace Blockset Discrete Gust Model
%                 helper function for mask callback. 

%   Copyright 1990-2002 The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 2002/04/10 16:52:00 $

UnitsStore = {'(meters/second)','(feet/second)','(knots)','(meters)','(feet)'};
MaskPromptStore = {'Gust amplitude [ug vg wg] ','Gust length [dx dy dz] '};

MaskVals=get_param(gcb,'MaskValues');       % Get Current Mask Settings
MaskPrompt=get_param(gcb,'MaskPrompts');    % Get Strings for Mask Prompts
VelUnits=MaskVals(1);                       % Get velocity units

% Convert to user defined units
if strcmp(VelUnits,'meters/second')
   MaskPrompt{6}=[MaskPromptStore{2} UnitsStore{4} ':'];
   MaskPrompt{7}=[MaskPromptStore{1} UnitsStore{1} ':'];
elseif strcmp(VelUnits,'feet/second')
   MaskPrompt{6}=[MaskPromptStore{2} UnitsStore{5} ':'];
   MaskPrompt{7}=[MaskPromptStore{1} UnitsStore{2} ':'];
else
   MaskPrompt{6}=[MaskPromptStore{2} UnitsStore{5} ':'];
   MaskPrompt{7}=[MaskPromptStore{1} UnitsStore{3} ':'];
end
set_param(gcb,'MaskPrompts',MaskPrompt);