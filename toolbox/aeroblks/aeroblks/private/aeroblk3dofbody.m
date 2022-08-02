function varargout = aeroblk3dofbody(action)
% AEROBLK3DOFBODY Aerospace Blockset 3DoF Model
%                 helper function for mask callback. 

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision $  $Date: 2004/04/06 01:04:03 $

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
   error('aeroblks:aeroblk3dofbody:invalidiconaction','Icon action not defined');
end

return
% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'','',''},'port',{1},'txt',{''});  

umode = get_param(blk,'units');

fx_str  = '{F_{x}} ';
fz_str  = '{F_{z}} ';
m_str  = '{M} ';


x_str    = 'X_e Z_e ';
theta_str = '\theta (rad)';
v_str    = 'U w ';
ang_str   = '{\omega_y (rad/s)}';
ang2_str  = '{d\omega_y/dt}';
ab_str    = 'A_x A_z ';

% Input port labels:
ports(1).type='input';
ports(1).port=1;

ports(2).type='input';
ports(2).port=2;

ports(3).type='input';
ports(3).port=3;

ports(4).type='input';
ports(4).port=1;

ports(5).type='input';
ports(5).port=1;

ports(6).type='input';
ports(6).port=1;

ports(7).type='input';
ports(7).port=1;

ports(8).type='input';
ports(8).port=1;

% Output port labels:

ports(9).type='output';
ports(9).port=1;
ports(9).txt=theta_str;

ports(10).type='output';
ports(10).port=2;
ports(10).txt=ang_str;

ports(11).type='output';
ports(11).port=3;
ports(11).txt=ang2_str;

ports(12).type='output';
ports(12).port=4;

ports(13).type='output';
ports(13).port=5;

ports(14).type='output';
ports(14).port=6;

ports(15).type='output';
ports(15).port=1;

% Determine which mass model is being used
dtype = get_param(blk,'mtype');

blk4 = [blk '/m_dot'];
blk5 = [blk '/mass'];
blk6 = [blk '/I_dot'];
blk7 = [blk '/I'];
blk15 = [blk '/Out7'];

switch dtype
    case 'Fixed'
        gcnt = 4;
        ports(4).port=1;
        ports(5).port=1;
        ports(6).port=1;
        ports(7).port=1;
        ports(15).port=1;
        [str4,str5]=deal('');
        addstub(blk4,'Ground');
        addstub(blk5,'Ground');
        addstub(blk6,'Ground');
        addstub(blk7,'Ground');
        addstub(blk15,'Terminator');
    case 'Simple Variable'   
        gcnt = 5;
        addport(blk4,'Inport','4');
        addport(blk15,'Outport','7');
        ports(4).port=4;
        ports(5).port=1;
        ports(6).port=1;
        ports(7).port=1;
        ports(15).port=7;
        str4  = 'dm/dt';
        str5  = '';
        str15 = 'Fuel';
        addstub(blk5,'Ground');
        addstub(blk6,'Ground');
        addstub(blk7,'Ground');
    case 'Custom Variable'
        gcnt = 8;
        addport(blk4,'Inport','4');
        addport(blk5,'Inport','5');
        addport(blk6,'Inport','6');
        addport(blk7,'Inport','7');
        ports(4).port=4;
        ports(5).port=5;
        ports(6).port=6;
        ports(7).port=7;
        ports(15).port=1;
        str4 = 'dm/dt';
        str5 = 'm';
        str6 = 'dI/dt';
        str7 = 'I';
        addstub(blk15,'Terminator');
    otherwise
        error('aeroblks:aeroblk3dofbody:invalidtype','mass type not defined');
end

% Determine if gravity is an input
gtype = get_param(blk,'g_in');
if strcmp(gtype,'External')
    addport([blk '/gravity'],'Inport',gcnt);
    ports(gcnt).port=gcnt;
    g_str  = 'g';
else
    g_str = '';
    ports(gcnt).port=1;
    ports(gcnt).txt='';
    addconst([blk '/gravity'],'g')
end

switch umode
case 'Metric (MKS)'
    ports(1).txt=[fx_str '(N)'];
    ports(2).txt=[fz_str '(N)'];
    ports(3).txt=[m_str '(N-m)'];
    ports(12).txt=[x_str '(m)'];
    ports(13).txt=[v_str '(m/s)'];
    ports(14).txt=[ab_str '(m/s^2)'];
    
    if strcmp(g_str,'g')
        ports(gcnt).txt=[g_str ' (m/s^2)'];
    end
            
    if (strcmp(str4,'dm/dt') && strcmp(str5,''))
        ports(4).txt=[str4 ' (kg/s)'];
        [ports(6:8).txt]=deal('');
        ports(15).txt=str15;
    elseif strcmp(str5,'m')
        ports(4).txt=[str4 ' (kg/s)'];
        ports(5).txt=[str5 ' (kg)'];
        ports(6).txt=[str6 ' (kg-m^2/s)'];
        ports(7).txt=[str7 ' (kg-m^2)'];
        ports(15).txt='';
    else
        [ports([5:8,15]).txt]=deal('');
    end
    
case 'English (Velocity in ft/s)'
    ports(1).txt=[fx_str '(lbf)'];
    ports(2).txt=[fz_str '(lbf)'];
    ports(3).txt=[m_str '(lbf-ft)'];
    ports(12).txt=[x_str '(ft)'];
    ports(13).txt=[v_str '(ft/s)'];
    ports(14).txt=[ab_str '(ft/s^2)'];
    
    if strcmp(g_str,'g')
        ports(gcnt).txt=[g_str ' (ft/s^2)'];
    end

    if (strcmp(str4,'dm/dt') && strcmp(str5,''))
        ports(4).txt=[str4 ' (slug/s)'];
        [ports(6:8).txt]=deal('');
        ports(15).txt=str15;
    elseif strcmp(str5,'m')
        ports(4).txt=[str4 ' (slug/s)'];
        ports(5).txt=[str5 ' (slug)'];
        ports(6).txt=[str6 ' (slug-ft^2/s)'];
        ports(7).txt=[str7 ' (slug-ft^2)'];
        ports(15).txt='';
    else
        [ports([5:8,15]).txt]=deal('');
    end
        
case 'English (Velocity in kts)'
    ports(1).txt=[fx_str '(lbf)'];
    ports(2).txt=[fz_str '(lbf)'];
    ports(3).txt=[m_str '(lbf-ft)'];
    ports(12).txt=[x_str '(ft)'];
    ports(13).txt=[v_str '(kts)'];
    ports(14).txt=[ab_str '(ft/s^2)'];
    
    if strcmp(g_str,'g')
        ports(gcnt).txt=[g_str ' (ft/s^2)'];
    end

    if (strcmp(str4,'dm/dt') && strcmp(str5,''))
        ports(4).txt=[str4 ' (slug/s)'];
        [ports(6:8).txt]=deal('');
        ports(15).txt=str15;
    elseif strcmp(str5,'m')
        ports(4).txt=[str4 ' (slug/s)'];
        ports(5).txt=[str5 ' (slug)'];
        ports(6).txt=[str6 ' (slug-ft^2/s)'];
        ports(7).txt=[str7 ' (slug-ft^2)'];
        ports(15).txt='';
    else
        [ports([5:8,15]).txt]=deal('');
    end
    
otherwise
   error('aeroblks:aeroblk3dofbody:invalidunits','Unit conversion not defined');
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
   error('aeroblks:aeroblk3dofbody:invalidunits','Unit conversion not defined');
end

return
% ----------------------------------------------------------
function set_conversions(blk,velocity_in,velocity_out)

vel_blk    = [blk '/Velocity Conversion'];

vmask = get_param(vel_blk,'MaskValues');
convert = ~strcmp(vmask{2},velocity_out);

if convert
    set_param(vel_blk,'MaskValues',[{velocity_in} {velocity_out}]);
end

return
% ----------------------------------------------------------
function updatemodel(blk)

tmode = get_param(blk,'mtype');

Fstr  = 'web(asbhelp(''3dofbodyaxes''));';
SVstr = 'web(asbhelp(''simplevariablemass3dofbodyaxes''));';
CVstr = 'web(asbhelp(''customvariablemass3dofbodyaxes''));';

switch tmode
    case 'Fixed'
        replaceblock([blk sprintf('/Determine Force, \nMass & Inertia')],...
            'Mass & Inertia (fixed)','aerolib3dofsys');
        set_mask_help(blk,Fstr);
    case 'Simple Variable'
        replaceblock([blk sprintf('/Determine Force, \nMass & Inertia')],...
            'Mass & Inertia (simple)','aerolib3dofsys');
        set_mask_help(blk,SVstr);
    case 'Custom Variable'
        replaceblock([blk sprintf('/Determine Force, \nMass & Inertia')],...
            'Mass & Inertia (custom)','aerolib3dofsys');
        set_mask_help(blk,CVstr);
    otherwise
        error('aeroblks:aeroblk3dofbody:invalidtype','mass type not defined');
end

return
% ----------------------------------------------------------
function set_up_mask(blk)

mask_visibility = get_param(blk,'maskvisibilities');  % remove non-options

% Determine which 3DOF model is being used
mtype = get_param(blk,'mtype');
gtype = get_param(blk,'g_in');

switch mtype
    case 'Fixed'
        if ~strcmp(mask_visibility(11),'on')
            mask_visibility{8}     ='on';
            [mask_visibility{9:13}]=deal('off');
            mask_visibility{11}    ='on';
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
        error('aeroblks:aeroblk3dofbody:invalidtype','mass type not defined');
end
switch gtype
    case 'Internal'
        if ~strcmp(mask_visibility(15),'on')
            mask_visibility{15} = 'on';
        end
    case 'External'
        if ~strcmp(mask_visibility(15),'off')
            mask_visibility{15} = 'off';
        end
    otherwise
        error('aeroblks:aeroblk3dofbody:invalidinput',...
            'gravity input type not defined');
end

set_param(blk,'maskvisibilities',mask_visibility);

return
