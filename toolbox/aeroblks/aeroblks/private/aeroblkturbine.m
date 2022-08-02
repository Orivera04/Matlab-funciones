function varargout = aeroblkturbine(action)
%  AEROBLKTURBINE - Aerospace Blockset turbine engine models 
%  block helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.4.2.6 $ $Date: 2004/04/06 01:04:13 $

if nargin == 0, 
    action = 'dynamic'; 
end

%blk = gcbh;
blk = gcb;

switch action
case 'icon'
   ports = get_labels(blk);
   set_conversion_factor(blk);
   varargout = {ports};
   
case 'dynamic'
   mask_visible = get_param(blk,'maskvisibilities');  % remove non-options
   
   % Determine determine if model has external sources
    Fsource = get_param(blk,'ic_source');
 
   if strcmp(Fsource,'Internal')
       mask_visible{3}='on';
   else
       mask_visible{3}='off';
   end
  
   set_param(blk,'maskvisibilities',mask_visible);
 
otherwise
   error('aeroblks:aeroblkturbine:invalidiconaction','Icon action not defined');
end
return

% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'','','','','',''},'port',{1},'txt',{''});  
  
umode = get_param(blk,'units');

% Input port labels:
ports(1).type='input';
ports(1).port=1;
ports(1).txt='Throttle position';

ports(2).type='input';
ports(2).port=2;
ports(2).txt='Mach';

ports(3).type='input';
ports(3).port=3;

ports(4).type='input';
 
% Determine determine if model has external sources
Fsource = get_param(blk,'ic_source');
FBlk      = [blk '/IC'];

if strcmp(Fsource,'Internal')
    % Change Port to Constant
    addconst(FBlk,'IC');
    ports(4).port=1;
    ports(4).txt='';
else
    % Change Constant to Port
    addport(FBlk,'Inport','4');
    ports(4).port=4;
    ports(4).txt='Initial Thrust';
end

% Output port labels:

ports(5).type='output';
ports(5).port=1;

ports(6).type='output';
ports(6).port=2;

switch umode
case {'Metric','Metric (MKS)'}
   ports(3).txt='Altitude (m)';
   ports(5).txt='Thrust (N)';
   ports(6).txt='Fuel flow (kg/s)';
   if strcmp(ports(4).txt,'Initial Thrust')
      ports(4).txt='Initial Thrust (N)';
   end
   
case 'English'
   ports(3).txt='Altitude (ft)';
   ports(5).txt='Thrust (lbf)';
   ports(6).txt='Fuel flow (lbm/s)';
   if strcmp(ports(4).txt,'Initial Thrust')
      ports(4).txt='Initial Thrust (lbf)';
   end
otherwise
   error('aeroblks:aeroblkturbine:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

lvalues = get_param([blk '/Length Conversion'],'MaskValues');

switch umode
case {'Metric','Metric (MKS)'}
   set_param([blk '/Length Conversion'],'MaskValues',[{'m'} {lvalues{2}}]);
case 'English'
   set_param([blk '/Length Conversion'],'MaskValues',[{'ft'} {lvalues{2}}]);
otherwise
   error('aeroblks:aeroblkturbine:invalidunits','Unit conversion not defined');
end

return
