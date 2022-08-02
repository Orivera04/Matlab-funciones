function varargout = aeroblkpalt(action)
% AEROBLKASCORR Aerospace Blockset pressure altitude
%                 helper function for mask callback. 

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision $  $Date: 2004/04/06 01:04:10 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
    case 'icon'
        set_conversion_factor(blk);
        ports = get_labels(blk);
        varargout = {ports};
        
    case 'dynamic'
    otherwise
        error('aeroblks:aeroblkpalt:invalidiconaction','Icon action not defined');
end
return
% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

pvalues = get_param([blk '/Pressure Conversion'],'MaskValues');
lvalues = get_param([blk '/Length Conversion'],'MaskValues');

switch umode
    case 'Metric (MKS)'
        set_param([blk '/Pressure Conversion'],'MaskValues',[{'Pa'} {pvalues{2}} ]);
        set_param([blk '/Length Conversion'],'MaskValues',[{lvalues{1}} {'m'}]);
    case 'English'
        set_param([blk '/Pressure Conversion'],'MaskValues',[{'psi'} {pvalues{2}} ]);
        set_param([blk '/Length Conversion'],'MaskValues',[{lvalues{1}} {'ft'}]);
    otherwise
        error('aeroblks:aeroblkpalt:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'',''},'port',{1},'txt',{''});

umode = get_param(blk,'units');

% Input port labels:
ports(1).type='input';
ports(1).port=1;

% Output port labels:

ports(2).type='output';
ports(2).port=1;

switch umode
case 'Metric (MKS)'
   ports(1).txt='P_o (Pa)';
   ports(2).txt='Alt_{pres} (m)';
   
case 'English'
   ports(1).txt='P_o (psi)';
   ports(2).txt='Alt_{pres} (ft)';
   
otherwise
   error('aeroblks:aeroblkpalt:invalidunits','Unit conversion not defined');
       
end

return
