function varargout = aeroblkhwind(action)
%  AEROBLKHWIND - Aerospace Blockset Horizontal wind model 
%  block helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/06 01:04:08 $

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
   mask_visible = get_param(blk,'maskvisibilities');  % remove non-options
   
   % Determine determine if model has external sources
    Wsource = get_param(blk,'Vw_source');
    Dsource = get_param(blk,'W_source');
 
   if strcmp(Wsource,'Internal')
       mask_visible{3}='on';
   else
       mask_visible{3}='off';
   end
   if strcmp(Dsource,'Internal')
       mask_visible{5}='on';
   else
       mask_visible{5}='off';
   end

   set_param(blk,'maskvisibilities',mask_visible);
 
otherwise
   error('aeroblks:aeroblkhwind:invalidiconaction','Icon action not defined');
end
return

% ----------------------------------------------------------
function ports = get_labels(blk)

umode = get_param(blk,'units');

% Input port labels:
ports(1).type='input';
ports(1).port=1;
ports(1).txt='DCM';

ports(2).type='input';

ports(3).type='input';

angstr = '\theta_{wind} (deg)';
speedstr = 'V_{wind} ';
vstr = 'V_{wind} ';

% Determine determine if model has external sources
Wsource = get_param(blk,'Vw_source');
WBlk    = [blk '/Wind Speed'];
Dsource = get_param(blk,'W_source');
DBlk    = [blk '/Wind Direction'];

if strcmp(Wsource,'Internal')
    % Change Port to Constant
    addconst(WBlk,'Vwind');
    ports(2).port=1;
    ports(2).txt='';
    if strcmp(Dsource,'Internal')
        % Change Port to Constant
        addconst(DBlk,'Wdeg');
        ports(3).port=1;
        ports(3).txt='';
    else
      % Change Constant to Port
      addport(DBlk,'Inport','2');
      ports(2).port=2;
      ports(2).txt=angstr;
      ports(3).port=1;
      ports(3).txt='';
  end
else
    % Change Constant to Port
    addport(WBlk,'Inport','2');
    ports(2).port=2;
    ports(2).txt=speedstr;
    if strcmp(Dsource,'Internal')
        % Change Port to Constant
        addconst(DBlk,'Wdeg');
        ports(3).port=1;
        ports(3).txt='';
    else
        % Change Constant to Port
        addport(DBlk,'Inport','3');
        ports(3).port=3;
        ports(3).txt=angstr;
    end
end

% Output port labels:

ports(4).type='output';
ports(4).port=1;

switch umode
case {'Metric (MKS)'}
   ports(4).txt=[vstr '(m/s)'];
   if strcmp(ports(2).txt,speedstr)
      ports(2).txt=[speedstr '(m/s)'];
   end
   
case 'English (Velocity in ft/s)'
   ports(4).txt=[vstr '(ft/s)'];
   if strcmp(ports(2).txt,speedstr)
      ports(2).txt=[speedstr '(ft/s)'];
   end
   
case 'English (Velocity in kts)'
   ports(4).txt=[vstr '(kts)'];
   if strcmp(ports(2).txt,speedstr)
      ports(2).txt=[speedstr '(kts)'];
   end
otherwise
   error('aeroblks:aeroblkhwind:invalidunits','Unit conversion not defined');
end

return
% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

MaskPromptStore = {'Wind speed at altitude '};

MaskPrompt=get_param(gcb,'MaskPrompts');    % Get Strings for Mask Prompts

% Convert to user defined units
switch umode
case 'Metric (MKS)'
   MaskPrompt{3} = [MaskPromptStore{1} '(m/s):'];
    
case 'English (Velocity in ft/s)'
   MaskPrompt{3} = [MaskPromptStore{1} '(ft/s):'];
    
case 'English (Velocity in kts)'
   MaskPrompt{3} = [MaskPromptStore{1} '(kts):'];
    
otherwise
   error('aeroblks:aeroblkhwind:invalidunits','Unit conversion not defined');
end

set_param(gcb,'MaskPrompts',MaskPrompt);

return

