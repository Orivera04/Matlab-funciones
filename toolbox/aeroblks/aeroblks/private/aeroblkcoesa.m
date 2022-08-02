function varargout = aeroblkcoesa(action)
%  AEROBLKCOESA - Aerospace Blockset COESA atmosphere model 
%  block helper function for mask parameters.

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.3.2.4 $ $Date: 2004/04/06 01:04:07 $

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
otherwise
   error('aeroblks:aeroblkcoesa:invalidiconaction','Icon action not defined');
end
return

% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'','','','',''},'port',{1},'txt',{''});

umode = get_param(blk,'units');

% Input port labels:
ports(1).type='input';
ports(1).port=1;

% Output port labels:

ports(2).type='output';
ports(2).port=1;

ports(3).type='output';
ports(3).port=2;

ports(4).type='output';
ports(4).port=3;

ports(5).type='output';
ports(5).port=4;

switch umode
case {'Metric','Metric (MKS)'}
    ports(1).txt='Height (m)';
    ports(2).txt='Temperature (K)';
    ports(3).txt='Speed of Sound (m/s)';
    ports(4).txt='Air Pressure (Pa)';
    ports(5).txt='Air Density (kg/m^3)';
    
case 'English'
    ports(1).txt='Height (ft)';
    ports(2).txt='Temperature (R)';
    ports(3).txt='Speed of Sound (ft/s)';
    ports(4).txt='Air Pressure (psi)';
    ports(5).txt='Air Density (lbm/ft^3)';
otherwise
   error('aeroblks:aeroblkcoesa:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

lvalues = get_param([blk '/Length Conversion'],'MaskValues');
tvalues = get_param([blk '/Temperature Conversion'],'MaskValues');
pvalues = get_param([blk '/Pressure Conversion'],'MaskValues');
vvalues = get_param([blk '/Velocity Conversion'],'MaskValues');
dvalues = get_param([blk '/Density Conversion'],'MaskValues');

switch umode
case {'Metric','Metric (MKS)'}
   set_param([blk '/Length Conversion'],'MaskValues',[{'m'} {lvalues{2}}]);
   set_param([blk '/Temperature Conversion'],'MaskValues',[{tvalues{1}} {'K'}]);
   set_param([blk '/Pressure Conversion'],'MaskValues',[{pvalues{1}} {'Pa'}]);
   set_param([blk '/Velocity Conversion'],'MaskValues',[{vvalues{1}} {'m/s'}]);
   set_param([blk '/Density Conversion'],'MaskValues',[{dvalues{1}} {'kg/m^3'}]);
   
case 'English'
   set_param([blk '/Length Conversion'],'MaskValues',[{'ft'} {lvalues{2}}]);
   set_param([blk '/Temperature Conversion'],'MaskValues',[{tvalues{1}} {'R'}]);
   set_param([blk '/Pressure Conversion'],'MaskValues',[{pvalues{1}} {'psi'}]);
   set_param([blk '/Velocity Conversion'],'MaskValues',[{vvalues{1}} {'ft/s'}]);
   set_param([blk '/Density Conversion'],'MaskValues',[{dvalues{1}} {'lbm/ft^3'}]);
otherwise
   error('aeroblks:aeroblkcoesa:invalidunits','Unit conversion not defined');   
end

return
