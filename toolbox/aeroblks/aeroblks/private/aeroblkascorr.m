function varargout = aeroblkascorr(action)
% AEROBLKASCORR Aerospace Blockset airspeed correction
%                 helper function for mask callback. 

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision.3 $  $Date: 2004/04/06 01:04:05 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
    case 'icon'
        set_conversion_factor(blk);
        set_out_of_range(blk);
        vel_case = find_velcase(blk);
        ports = get_labels(blk,vel_case);
        varargout = {vel_case,ports};
        
    case 'dynamic'
        MaskVals  = get_param(gcb,'MaskValues');       % Get Current Mask Settings

        mask_visibility = get_param(blk,'maskvisibilities');  % remove non-options
        
        [mask_visibility{3:5}]=deal('off');

        switch MaskVals{2}
            case 'TAS'
                    mask_visibility{3}='on';
            case 'EAS'
                    mask_visibility{4}='on';
            case 'CAS'
                    mask_visibility{5}='on';
        end
        
        set_param(blk,'maskvisibilities',mask_visibility);
   otherwise
   error('aeroblks:aeroblkascorr:invalidiconaction','Icon action not defined');
end
return
% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

pvalues = get_param([blk '/Pressure Conversion'],'MaskValues');
values = get_param([blk '/Velocity Conversion'],'MaskValues');
values1 = get_param([blk '/Velocity Conversion1'],'MaskValues');
values2 = get_param([blk '/Velocity Conversion2'],'MaskValues');

switch umode
    case 'Metric (MKS)'
        set_param([blk '/Velocity Conversion'],'MaskValues',[{'m/s'} {values{2}} ]);
        set_param([blk '/Velocity Conversion1'],'MaskValues',[{'m/s'} {values1{2}} ]);
        set_param([blk '/Pressure Conversion'],'MaskValues',[{'Pa'} {pvalues{2}} ]);
        set_param([blk '/Velocity Conversion2'],'MaskValues',[{values2{1}} {'m/s'}]);
    case 'English (Velocity in ft/s)'
        set_param([blk '/Velocity Conversion'],'MaskValues',[{'ft/s'} {values{2}} ]);
        set_param([blk '/Velocity Conversion1'],'MaskValues',[{'ft/s'} {values1{2}} ]);
        set_param([blk '/Pressure Conversion'],'MaskValues',[{'psi'} {pvalues{2}} ]);
        set_param([blk '/Velocity Conversion2'],'MaskValues',[{values2{1}} {'ft/s'}]);
    case 'English (Velocity in kts)'
        set_param([blk '/Velocity Conversion'],'MaskValues',[{'kts'} {values{2}} ]);
        set_param([blk '/Velocity Conversion1'],'MaskValues',[{'kts'} {values1{2}} ]);
        set_param([blk '/Pressure Conversion'],'MaskValues',[{'psi'} {pvalues{2}} ]);
        set_param([blk '/Velocity Conversion2'],'MaskValues',[{values2{1}} {'kts'}]);
    otherwise
        error('aeroblks:aeroblkascorr:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function set_out_of_range(blk)

amode = get_param(blk,'action');
assertblk = [blk '/Mach <= 1.0'];

maskVals = get_param(assertblk,'MaskValues');

switch amode
    case 'None'
        set_param(assertblk,'MaskValues',{maskVals{1:2} 'off' maskVals{4} 'off' maskVals{6:end}}');
    case 'Warning'
        set_param(assertblk,'MaskValues',{maskVals{1:2} 'on' maskVals{4} 'off' maskVals{6:end}}');
    case 'Error'
        set_param(assertblk,'MaskValues',{maskVals{1:2} 'on' maskVals{4} 'on' maskVals{6:end}}');
    otherwise
        error('aeroblks:aeroblkascorr:invalidaction','Out of Range method not defined');
end

return
% ----------------------------------------------------------
function vel_case = find_velcase(blk)

MaskVals  = get_param(blk,'MaskValues');       % Get Current Mask Settings
switch MaskVals{2}
    case 'TAS'
        switch MaskVals{3}
            case 'EAS'
                vel_case = 1;
            case 'CAS'
                vel_case = 3;
        end                
    case 'EAS'
        switch MaskVals{4}
            case 'TAS'
                vel_case = 2;
            case 'CAS'
                vel_case = 5;
        end                
    case 'CAS'
        switch MaskVals{5}
            case 'TAS'
                vel_case = 4;
            case 'EAS'
                vel_case = 6;
        end                
    otherwise
        error('aeroblks:aeroblkascorr:invalidairspeed','Type of airspeed not defined');
end


return
% ----------------------------------------------------------
function ports = get_labels(blk,vel_case)

ports = struct('type',{'','','',''},'port',{1},'txt',{''});
 
umode = get_param(blk,'units');

% Input port labels:
ports(1).type='input';
ports(1).port=1;

ports(2).type='input';
ports(2).port=2;

ports(3).type='input';
ports(3).port=3;

% Output port labels:

ports(4).type='output';
ports(4).port=1;

switch num2str(vel_case)
    case '1'
        InStr = 'TAS';
        OutStr = 'EAS';
    case '2'
        InStr = 'EAS';
        OutStr = 'TAS';
    case '3'
        InStr = 'TAS';
        OutStr = 'CAS';
    case '4'
        InStr = 'CAS';
        OutStr = 'TAS';
    case '5'
        InStr = 'EAS';
        OutStr = 'CAS';
    case '6'
        InStr = 'CAS';
        OutStr = 'EAS';
    otherwise
        error('aeroblks:aeroblkascorr:invalidconversion','Velocity case not defined');
end

switch umode
case 'Metric (MKS)'
   ports(1).txt=[InStr ' (m/s)'];
   ports(2).txt='a (m/s)';
   ports(3).txt='P_o (Pa)';
   ports(4).txt=[OutStr ' (m/s)'];
case 'English (Velocity in ft/s)'
    ports(1).txt=[InStr ' (ft/s)'];
    ports(2).txt='a (ft/s)';
    ports(3).txt='P_o (psi)';
    ports(4).txt=[OutStr ' (ft/s)'];
case 'English (Velocity in kts)'
    ports(1).txt=[InStr ' (kts)'];
    ports(2).txt='a (kts)';
    ports(3).txt='P_o (psi)';
    ports(4).txt=[OutStr ' (kts)'];
otherwise
   error('aeroblks:aeroblkascorr:invalidunits','Unit conversion not defined');    
end

return
