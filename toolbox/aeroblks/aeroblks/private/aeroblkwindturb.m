function aeroblkwindturb
% AEROBLKWINDTURB Aerospace Blockset Dryden Turbulance Model
%                 helper function for mask callback. 

%   Copyright 1990-2002 The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 2002/04/10 16:51:57 $
UnitsStore = {'(meters/second)','(feet/second)','(knots)','(meters)','(feet)'};
MaskPromptStore = {'Wind speed at 6 m defines the low-altitude intensity ', ...
                   'Wind speed at 20 ft defines the low-altitude intensity ', ...
                   'Scale length at medium/high altitudes ', ...
                   'Wingspan '};

MaskVals  =get_param(gcb,'MaskValues');       % Get Current Mask Settings
MaskPrompt=get_param(gcb,'MaskPrompts');      % Get Current Mask Settings
VelUnits=MaskVals(1);                         % Get velocity units

% Convert to user defined units
if strcmp(VelUnits,'meters/second')
   MaskPrompt{2}=[MaskPromptStore{1} UnitsStore{1} ':'];
   MaskPrompt{4}=[MaskPromptStore{3} UnitsStore{4} ':'];
   MaskPrompt{5}=[MaskPromptStore{4} UnitsStore{4} ':'];
elseif strcmp(VelUnits,'feet/second')
   MaskPrompt{2}=[MaskPromptStore{2} UnitsStore{2} ':'];
   MaskPrompt{4}=[MaskPromptStore{3} UnitsStore{5} ':'];
   MaskPrompt{5}=[MaskPromptStore{4} UnitsStore{5} ':'];
else
   MaskPrompt{2}=[MaskPromptStore{2} UnitsStore{3} ':'];
   MaskPrompt{4}=[MaskPromptStore{3} UnitsStore{5} ':'];
   MaskPrompt{5}=[MaskPromptStore{4} UnitsStore{5} ':'];
end
set_param(gcb,'MaskPrompts',MaskPrompt);