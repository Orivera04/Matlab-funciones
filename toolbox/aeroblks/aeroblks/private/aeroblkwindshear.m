function aeroblkwindshear
% AEROBLKWINDSHEAR Aerospace Blockset Wind Shear Model
%                 helper function for mask callback. 

%   Copyright 1990-2002 The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 2002/04/10 16:52:03 $

MaskVals=get_param(gcb,'MaskValues');       % Get Current Mask Settings
MaskPrompt=get_param(gcb,'MaskPrompts');    % Get Strings for Mask Prompts
VelUnits=MaskVals(1);                       % Get Velocity Units

% Convert to user defined units
if strcmp(VelUnits,'meters/second')
   MaskPrompt{3}='Wind speed at 6 meters altitude (meters/second):';
   MaskPrompt{4}='Wind direction at 6 meters altitude (degrees clockwise from north):';
elseif strcmp(VelUnits,'feet/second')
   MaskPrompt{3}='Wind speed at 20 feet altitude (feet/second):';
   MaskPrompt{4}='Wind direction at 20 feet altitude (degrees clockwise from north):';
else
   MaskPrompt{3}='Wind speed at 20 feet altitude (knots):';
   MaskPrompt{4}='Wind direction at 20 feet altitude (degrees clockwise from north):';
end
set_param(gcb,'MaskPrompts',MaskPrompt);
