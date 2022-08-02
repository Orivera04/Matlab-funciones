function varargout = aeroblk6dofbody(action)
% AEROBLK6DOFBODY Aerospace Blockset 6DoF Model
%                 helper function for mask callback. 

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/06 01:04:04 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
    case 'icon'
        set_up_mask(blk);
        updatemodel(blk); 
        ports = get_labels(blk);
        set_conversion_factor(blk);
        varargout = {ports};
    case 'dynamic'
        % get correct filters for selected model
        set_up_mask(blk);
        updatemodel(blk);
        
otherwise
   error('aeroblks:aeroblk6dofbody:invalidiconaction','Icon action not defined');
end

return
% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'','',''},'port',{1},'txt',{''});  

umode = get_param(blk,'units');

f_str  = '{F_{xyz}} ';
m_str  = '{M_{xyz}} ';

ve_str    = 'V_e ';
xe_str    = 'X_e ';
euler_str = '\phi \theta \psi (rad)';
dcm_str   = 'DCM ';
vb_str    = 'V_b ';
ang_str   = '{\omega (rad/s)}';
ang2_str  = '{d\omega/dt}';
ab_str    = 'A_b ';

% Input port labels:
ports(1).type='input';
ports(1).port=1;

ports(2).type='input';
ports(2).port=2;

ports(3).type='input';
ports(3).port=1;

ports(4).type='input';
ports(4).port=1;

ports(5).type='input';
ports(5).port=1;

ports(6).type='input';
ports(6).port=1;

% Output port labels:

ports(7).type='output';
ports(7).port=1;

ports(8).type='output';
ports(8).port=2;

ports(9).type='output';
ports(9).port=3;
ports(9).txt=euler_str;

ports(10).type='output';
ports(10).port=4;
ports(10).txt=dcm_str;

ports(11).type='output';
ports(11).port=5;

ports(12).type='output';
ports(12).port=6;
ports(12).txt=ang_str;

ports(13).type='output';
ports(13).port=7;
ports(13).txt=ang2_str;

ports(14).type='output';
ports(14).port=8;

ports(15).type='output';
ports(15).port=1;

% Determine which model is being used
dtype = get_param(blk,'mtype');

blk3 = [blk '/m_dot'];
blk4 = [blk '/mass'];
blk5 = [blk '/I_dot'];
blk6 = [blk '/I'];
blk15 = [blk '/Out9'];

switch dtype
    case 'Fixed'
        ports(3).port=1;
        ports(4).port=1;
        ports(5).port=1;
        ports(6).port=1;
        ports(15).port=1;
        [str3 str4 str5 str6 str15] = deal('');
        addstub(blk3,'Ground');
        addstub(blk4,'Ground');
        addstub(blk5,'Ground');
        addstub(blk6,'Ground');
        addstub(blk15,'Terminator');
    case 'Simple Variable'   
        addport(blk3,'Inport','3');
        addport(blk15,'Outport','9');
        ports(3).port=3;
        ports(4).port=1;
        ports(5).port=1;
        ports(6).port=1;
        ports(15).port=9;
        str3  = 'dm/dt';
        [str4 str5 str6] = deal('');
        str15 = 'Fuel';
        addstub(blk4,'Ground');
        addstub(blk5,'Ground');
        addstub(blk6,'Ground');
    case 'Custom Variable'
        addport(blk3,'Inport','3');
        addport(blk4,'Inport','4');
        addport(blk5,'Inport','5');
        addport(blk6,'Inport','6');
        ports(3).port=3;
        ports(4).port=4;
        ports(5).port=5;
        ports(6).port=6;
        ports(15).port=1;
        str3 = 'dm/dt';
        str4 = 'm';
        str5 = 'dI/dt';
        str6 = 'I';
        str15 = '';
        addstub(blk15,'Terminator');
    otherwise
        error('aeroblks:aeroblk6dofbody:invalidtype','mass type not defined');
end

switch umode
case 'Metric (MKS)'
    ports(1).txt=[f_str '(N)'];
    ports(2).txt=[m_str '(N-m)'];
    ports(7).txt=[ve_str '(m/s)'];
    ports(8).txt=[xe_str '(m)'];
    ports(11).txt=[vb_str '(m/s)'];
    ports(14).txt=[ab_str '(m/s^2)'];
    
    if (strcmp(str3,'dm/dt') && strcmp(str4,''))
        ports(3).txt=[str3 ' (kg/s)'];
        ports(4).txt=str4;
        ports(5).txt=str5;
        ports(6).txt=str6;
        ports(15).txt=str15;
    elseif strcmp(str4,'m')
        ports(3).txt=[str3 ' (kg/s)'];
        ports(4).txt=[str4 ' (kg)'];
        ports(5).txt=[str5 ' (kg-m^2/s)'];
        ports(6).txt=[str6 ' (kg-m^2)'];
        ports(15).txt=str15;
    else
        ports(3).txt=str3;
        ports(4).txt=str4;
        ports(5).txt=str5;
        ports(6).txt=str6;
        ports(15).txt=str15;
    end
    
case 'English (Velocity in ft/s)'
    ports(1).txt=[f_str '(lbf)'];
    ports(2).txt=[m_str '(lbf-ft)'];
    ports(7).txt=[ve_str '(ft/s)'];
    ports(8).txt=[xe_str '(ft)'];
    ports(11).txt=[vb_str '(ft/s)'];
    ports(14).txt=[ab_str '(ft/s^2)'];
    
    if (strcmp(str3,'dm/dt') && strcmp(str4,''))
        ports(3).txt=[str3 ' (slug/s)'];
        ports(4).txt=str4;
        ports(5).txt=str5;
        ports(6).txt=str6;
        ports(15).txt=str15;
    elseif strcmp(str4,'m')
        ports(3).txt=[str3 ' (slug/s)'];
        ports(4).txt=[str4 ' (slug)'];
        ports(5).txt=[str5 ' (slug-ft^2/s)'];
        ports(6).txt=[str6 ' (slug-ft^2)'];
        ports(15).txt=str15;
    else
        ports(3).txt=str3;
        ports(4).txt=str4;
        ports(5).txt=str5;
        ports(6).txt=str6;
        ports(15).txt=str15;
    end
    
case 'English (Velocity in kts)'
    ports(1).txt=[f_str '(lbf)'];
    ports(2).txt=[m_str '(lbf-ft)'];
    ports(7).txt=[ve_str '(kts)'];
    ports(8).txt=[xe_str '(ft)'];
    ports(11).txt=[vb_str '(kts)'];
    ports(14).txt=[ab_str '(ft/s^2)'];
    
    if (strcmp(str3,'dm/dt') && strcmp(str4,''))
        ports(3).txt=[str3 ' (slug/s)'];
        ports(4).txt=str4;
        ports(5).txt=str5;
        ports(6).txt=str6;
        ports(15).txt=str15;
    elseif strcmp(str4,'m')
        ports(3).txt=[str3 ' (slug/s)'];
        ports(4).txt=[str4 ' (slug)'];
        ports(5).txt=[str5 ' (slug-ft^2/s)'];
        ports(6).txt=[str6 ' (slug-ft^2)'];
        ports(15).txt=str15;
    else
        ports(3).txt=str3;
        ports(4).txt=str4;
        ports(5).txt=str5;
        ports(6).txt=str6;
        ports(15).txt=str15;
    end
    
otherwise
   error('aeroblks:aeroblk6dofbody:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');

switch umode
case 'Metric (MKS)'
   
   set_conversions(blk,'m/s','m/s');

case 'English (Velocity in ft/s)'
   
   set_conversions(blk,'ft/s','ft/s');
   
case 'English (Velocity in kts)'
   
   set_conversions(blk,'ft/s','kts');
   
otherwise
   error('aeroblks:aeroblk6dofbody:invalidunits','Unit conversion not defined');
end

return
% ----------------------------------------------------------
function set_conversions(blk,velocity_in,velocity_out)

vel_blk    = [blk '/Velocity Conversion'];
vel1_blk   = [blk '/Velocity Conversion1'];

vmask = get_param(vel_blk,'MaskValues');
convert = ~strcmp(vmask{2},velocity_out);

if convert
    set_param(vel_blk,'MaskValues',[{velocity_in} {velocity_out}]);
    set_param(vel1_blk,'MaskValues',[{velocity_in} {velocity_out}]);
end

return
% ----------------------------------------------------------
function updatemodel(blk)

tmode = get_param(blk,'mtype');
rmode = get_param(blk,'rep');

FEulerstr  = 'web(asbhelp(''6dofeulerangles''));';
SVEulerstr = 'web(asbhelp(''simplevariablemass6dofeulerangles''));';
CVEulerstr = 'web(asbhelp(''customvariablemass6dofeulerangles''));';
FQuatstr   = 'web(asbhelp(''6dofquaternion''));';
SVQuatstr  = 'web(asbhelp(''simplevariablemass6dofquaternion''));';
CVQuatstr  = 'web(asbhelp(''customvariablemass6dofquaternion''));';

switch tmode
    case 'Fixed'
        replaceblock([blk sprintf('/Determine Force, \nMass & Inertia')],...
            'Mass & Inertia (fixed)','aerolib6dofsys');
        switch rmode
            case 'Euler Angles'
                replaceblock([blk sprintf('/Calculate DCM &\nEuler Angles')],...
                             'DCM & Euler Angles (Euler)','aerolib6dofsys');
                set_mask_help(blk,FEulerstr);
            case 'Quaternion'
                replaceblock([blk sprintf('/Calculate DCM &\nEuler Angles')],...
                             'DCM & Euler Angles (Quaternion)','aerolib6dofsys');
                set_mask_help(blk,FQuatstr);
            otherwise
                error('aeroblks:aeroblk6dofbody:invalidrep',...
                    'representation not defined');
        end
    case 'Simple Variable'
        replaceblock([blk sprintf('/Determine Force, \nMass & Inertia')],...
            'Mass & Inertia (simple)','aerolib6dofsys');
        switch rmode
            case 'Euler Angles'
                replaceblock([blk sprintf('/Calculate DCM &\nEuler Angles')],...
                             'DCM & Euler Angles (Euler)','aerolib6dofsys');
                set_mask_help(blk,SVEulerstr);
            case 'Quaternion'
                replaceblock([blk sprintf('/Calculate DCM &\nEuler Angles')],...
                             'DCM & Euler Angles (Quaternion)','aerolib6dofsys');
                set_mask_help(blk,SVQuatstr);
            otherwise
                error('aeroblks:aeroblk6dofbody:invalidrep',...
                    'representation not defined');
        end
    case 'Custom Variable'
        replaceblock([blk sprintf('/Determine Force, \nMass & Inertia')],...
            'Mass & Inertia (custom)','aerolib6dofsys');
        switch rmode
            case 'Euler Angles'
                replaceblock([blk sprintf('/Calculate DCM &\nEuler Angles')],...
                             'DCM & Euler Angles (Euler)','aerolib6dofsys');
                set_mask_help(blk,CVEulerstr);
            case 'Quaternion'
                replaceblock([blk sprintf('/Calculate DCM &\nEuler Angles')],...
                             'DCM & Euler Angles (Quaternion)','aerolib6dofsys');
                set_mask_help(blk,CVQuatstr);
            otherwise
                error('aeroblks:aeroblk6dofbody:invalidrep',...
                    'representation not defined');
        end
    otherwise
        error('aeroblks:aeroblk6dofbody:invalidtype','mass type not defined');
end

return
% ----------------------------------------------------------
function set_up_mask(blk)

mask_visibility = get_param(blk,'maskvisibilities');  % remove non-options

% Determine which 6DOF model is being used
mtype = get_param(blk,'mtype');
rtype = get_param(blk,'rep');

switch mtype
    case 'Fixed'
        if ~strcmp(mask_visibility(11),'on')
            [mask_visibility{9:13}]=deal('off');
            mask_visibility{11}    ='on';
            mask_visibility{8}     ='on';
        end
    case 'Simple Variable'   
        if ~strcmp(mask_visibility(9),'on')
            [mask_visibility{8:13}]=deal('on');
            mask_visibility{11}    ='off';
        end
    case 'Custom Variable' 
        if ~strcmp(mask_visibility(8),'off')
            [mask_visibility{8:13}]=deal('off');
        end
    otherwise
        error('aeroblks:aeroblk6dofbody:invalidtype','mass type not defined');
end
switch rtype
    case 'Euler Angles'
        if ~strcmp(mask_visibility(14),'off')
            mask_visibility{14}    ='off';
        end
    case 'Quaternion'   
        if ~strcmp(mask_visibility(14),'on')
            mask_visibility{14}    ='on';
        end
    otherwise
        error('aeroblks:aeroblk6dofbody:invalidrep','Representation not defined');
end

set_param(blk,'maskvisibilities',mask_visibility);

return
% ----------------------------------------------------------


