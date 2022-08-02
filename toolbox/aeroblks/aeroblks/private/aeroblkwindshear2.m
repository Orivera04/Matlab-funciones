function varargout = aeroblkwindshear2(action)
% AEROBLKWINDSHEAR Aerospace Blockset Wind Shear Model
%                 helper function for mask callback. 

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision $  $Date: 2004/04/06 01:04:15 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
case 'icon'
   ports = get_labels(blk);
   set_conversion_factor(blk);
   varargout = {ports};
case 'dynamic'
otherwise
   error('aeroblks:aeroblkwindshear2:invalidiconaction','Icon action not defined');
end

return

% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'','',''},'port',{1},'txt',{''});  

umode = get_param(blk,'units');

alt_str = 'h ';
wind_str = 'V_{wind} ';

% Input port labels:
ports(1).type='input';
ports(1).port=1;

ports(2).type='input';
ports(2).port=2;
ports(2).txt='DCM';

% Output port labels:

ports(3).type='output';
ports(3).port=1;

switch umode
case 'Metric (MKS)'
    ports(1).txt=[alt_str '(m)'];
    ports(3).txt=[wind_str '(m/s)'];
    
case 'English (Velocity in ft/s)'
    ports(1).txt=[alt_str '(ft)'];
    ports(3).txt=[wind_str '(ft/s)'];
    
case 'English (Velocity in kts)'
    ports(1).txt=[alt_str '(ft)'];
    ports(3).txt=[wind_str '(kts)'];
    
otherwise
   error('aeroblks:aeroblkwindshear2:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

MaskPromptStore = {'Wind speed at 6 m altitude ','Wind speed at 20 ft altitude ', ...
               'Wind direction at 6 m altitude (degrees clockwise from north):', ...
               'Wind direction at 20 ft altitude (degrees clockwise from north):'};

MaskPrompt=get_param(gcb,'MaskPrompts');    % Get Strings for Mask Prompts

% Convert to user defined units
switch umode
case 'Metric (MKS)'
   set_param([blk '/Length Conversion'],'MaskValues',[{'m'} {'ft'}]);

   MaskPrompt{3} = [MaskPromptStore{1} '(m/s):'];
   MaskPrompt{4} = MaskPromptStore{3};
    
case 'English (Velocity in ft/s)'
   set_param([blk '/Length Conversion'],'MaskValues',[{'ft'} {'ft'}]);

   MaskPrompt{3} = [MaskPromptStore{2} '(ft/s):'];
   MaskPrompt{4} = MaskPromptStore{4};
    
case 'English (Velocity in kts)'
   set_param([blk '/Length Conversion'],'MaskValues',[{'ft'} {'ft'}]);

   MaskPrompt{3} = [MaskPromptStore{2} '(kts):'];
   MaskPrompt{4} = MaskPromptStore{4};
    
otherwise
   error('aeroblks:aeroblkwindshear2:invalidunits','Unit conversion not defined');
end

set_param(gcb,'MaskPrompts',MaskPrompt);
