function varargout = aeroblkwindgust2(action)
% AEROBLKWINDGUST Aerospace Blockset Discrete Gust Model
%                 helper function for mask callback. 

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision  $  $Date: 2004/04/06 01:04:14 $

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
   error('aeroblks:aeroblkwindgust2:invalidiconaction','Icon action not defined');
end

return

% ----------------------------------------------------------
function ports = get_labels(blk)
  
ports = struct('type',{'',''},'port',{1},'txt',{''});
umode = get_param(blk,'units');

air_str = 'V ';
wind_str = 'V_{wind} ';

% Input port labels:
ports(1).type='input';
ports(1).port=1;

% Output port labels:

ports(2).type='output';
ports(2).port=1;

switch umode
case 'Metric (MKS)'
    ports(1).txt=[air_str '(m/s)'];
    ports(2).txt=[wind_str '(m/s)'];
    
case 'English (Velocity in ft/s)'
    ports(1).txt=[air_str '(ft/s)'];
    ports(2).txt=[wind_str '(ft/s)'];
    
case 'English (Velocity in kts)'
    ports(1).txt=[air_str '(kts)'];
    ports(2).txt=[wind_str '(kts)'];
    
otherwise
   error('aeroblks:aeroblkwindgust2:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

UnitsStore = {'(m/s)','(ft/s)','(kts)','(m)','(ft)'};
MaskPromptStore = {'Gust amplitude [ug vg wg] ','Gust length [dx dy dz] '};

MaskPrompt = get_param(blk,'MaskPrompts');     % Get Current Mask Settings

switch umode
case 'Metric (MKS)'
   set_param([blk '/Velocity Conversion'],'MaskValues',[{'m/s'} {'m/s'}]);
   
   MaskPrompt{6}=[MaskPromptStore{2} UnitsStore{4} ':'];
   MaskPrompt{7}=[MaskPromptStore{1} UnitsStore{1} ':'];
   
case 'English (Velocity in ft/s)'
   set_param([blk '/Velocity Conversion'],'MaskValues',[{'ft/s'} {'ft/s'}]);
   
   MaskPrompt{6}=[MaskPromptStore{2} UnitsStore{5} ':'];
   MaskPrompt{7}=[MaskPromptStore{1} UnitsStore{2} ':'];
 
case 'English (Velocity in kts)'
   set_param([blk '/Velocity Conversion'],'MaskValues',[{'kts'} {'ft/s'}]);
   MaskPrompt{6}=[MaskPromptStore{2} UnitsStore{5} ':'];
   MaskPrompt{7}=[MaskPromptStore{1} UnitsStore{3} ':'];
    
otherwise
   error('aeroblks:aeroblkwindgust2:invalidunits','Unit conversion not defined');
end

set_param(blk,'MaskPrompts',MaskPrompt);

return