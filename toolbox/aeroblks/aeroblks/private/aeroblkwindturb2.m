function varargout = aeroblkwindturb2(action)
% AEROBLKWINDTURB Aerospace Blockset Turbulance Model
%                 helper function for mask callback. 

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2003/11/01 13:17:04 $

if nargin == 0, 
    action = 'dynamic'; 
end

blk = gcb;

switch action
case 'icon'
   updatefilter(blk); 
   ports = get_labels(blk);
   set_conversion_factor(blk);
   varargout = {ports};
case 'dynamic'
    % get correct filters for selected model
    updatefilter(blk);
    
otherwise
   error('aeroblks:aeroblkwindturb2:invalidiconaction','Icon action not defined');
end

return
% ----------------------------------------------------------
function ports = get_labels(blk)

ports = struct('type',{'','',''},'port',{1},'txt',{''});  

umode = get_param(blk,'units');

alt_str  = 'h ';
air_str  = 'V ';
dcm_str  = 'DCM';
wind_str = 'V_{Wind} ';
ang_str  = '\omega_{wind} (rad/s)';

% Input port labels:
ports(1).type='input';
ports(1).port=1;

ports(2).type='input';
ports(2).port=2;

ports(3).type='input';
ports(3).port=3;
ports(3).txt=dcm_str;

% Output port labels:

ports(4).type='output';
ports(4).port=1;

ports(5).type='output';
ports(5).port=2;
ports(5).txt = ang_str;

switch umode
case 'Metric (MKS)'
    ports(1).txt=[alt_str '(m)'];
    ports(2).txt=[air_str '(m/s)'];
    ports(4).txt=[wind_str '(m/s)'];
    
case 'English (Velocity in ft/s)'
    ports(1).txt=[alt_str '(ft)'];
    ports(2).txt=[air_str '(ft/s)'];
    ports(4).txt=[wind_str '(ft/s)'];
    
case 'English (Velocity in kts)'
    ports(1).txt=[alt_str '(ft)'];
    ports(2).txt=[air_str '(kts)'];
    ports(4).txt=[wind_str '(kts)'];
    
otherwise
   error('aeroblks:aeroblkwindturb2:invalidunits','Unit conversion not defined');
end

return

% ----------------------------------------------------------
function set_conversion_factor(blk)

umode = get_param(blk,'units');
mmode = get_param(blk,'model');

UnitsStore = {'(m/s)','(ft/s)','(kts)','(m)','(ft)'};
MaskPromptStore = {'Wind speed at 6 m defines the low-altitude intensity ', ...
                   'Wind speed at 20 ft defines the low-altitude intensity ', ...
                   'Scale length at medium/high altitudes ', ...
                   'Wingspan ', ...
                   'Wind direction at 6 m (degrees clockwise from north):',...
                   'Wind direction at 20 ft (degrees clockwise from north):',...
                   'Band limited noise sample time (sec):',...
                   'Band limited noise and discrete filter sample time (sec):'};

MaskPrompt = get_param(blk,'MaskPrompts');     % Get Current Mask Settings

switch umode
case 'Metric (MKS)'
   
   convert = set_conversions(blk,'m','m/s');
   
   if convert
       MaskPrompt{4}=[MaskPromptStore{1} UnitsStore{1} ':'];
       MaskPrompt{5}= MaskPromptStore{5};
       MaskPrompt{7}=[MaskPromptStore{3} UnitsStore{4} ':'];
       MaskPrompt{8}=[MaskPromptStore{4} UnitsStore{4} ':'];
   end

case 'English (Velocity in ft/s)'
   
   convert = set_conversions(blk,'ft','ft/s');
   
   if convert
       MaskPrompt{4}=[MaskPromptStore{2} UnitsStore{2} ':'];
       MaskPrompt{5}= MaskPromptStore{6};
       MaskPrompt{7}=[MaskPromptStore{3} UnitsStore{5} ':'];
       MaskPrompt{8}=[MaskPromptStore{4} UnitsStore{5} ':'];
   end
   
case 'English (Velocity in kts)'
   
   convert = set_conversions(blk,'ft','kts');
   
   if convert
       MaskPrompt{4}=[MaskPromptStore{2} UnitsStore{3} ':'];
       MaskPrompt{5}= MaskPromptStore{6};
       MaskPrompt{7}=[MaskPromptStore{3} UnitsStore{5} ':'];
       MaskPrompt{8}=[MaskPromptStore{4} UnitsStore{5} ':'];
   end

otherwise
   error('aeroblks:aeroblkwindturb2:invalidunits','Unit conversion not defined');
end

switch mmode
    case {'Discrete Dryden (+q -r)','Discrete Dryden (+q +r)','Discrete Dryden (-q +r)'}
         MaskPrompt{9} = MaskPromptStore{8};
    otherwise
         MaskPrompt{9} = MaskPromptStore{7};
end

set_param(blk,'MaskPrompts',MaskPrompt);

return
% ----------------------------------------------------------
function convert = set_conversions(blk,length,velocity)

length_blk = [blk '/Length Conversion'];
wingspan_blk = [blk '/Length Conversion1'];
vel_blk = [blk '/Velocity Conversion'];
vel1_blk = [blk '/Velocity Conversion1'];
intensity_blk = [blk '/Velocity Conversion2'];
tlength_blk = [blk sprintf('/Turbulence scale lengths/Medium//High altitude\nscale length/Length Conversion')];

vmask = get_param(vel_blk,'MaskValues');
convert = ~strcmp(vmask{1},velocity);

if convert
    set_param(length_blk,'MaskValues',[{length} {'ft'}]);
    set_param(wingspan_blk,'MaskValues',[{length} {'ft'}]);
    set_param(vel_blk,'MaskValues',[{velocity} {'ft/s'}]);
    set_param(vel1_blk,'MaskValues',[{'ft/s'} {velocity}]);
    set_param(intensity_blk,'MaskValues',[{velocity} {'ft/s'}]);
    set_param(tlength_blk,'MaskValues',[{length} {'ft'}]);
end

return
% ----------------------------------------------------------
function updatefilter(blk)

mmode = get_param(blk,'model');

CDrydenstr    = 'web(asbhelp(''Dryden Wind Turbulence Model (Continuous)''));';
DDrydenstr    = 'web(asbhelp(''Dryden Wind Turbulence Model (Discrete)''));';
CVonKarmanstr = 'web(asbhelp(''Von Karman Wind Turbulence Model (Continuous)''));';

vnoise = [blk sprintf('/White Noise\n(u,v,w)')];
pnoise = [blk sprintf('/White Noise\n(p)')];

switch mmode
    case 'Continuous Dryden (+q -r)'
        set_scale_length(blk,'1');
        replaceblock([blk '/Filters on velocities'],'Dryden Continuous Filters','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hpgw'],'Hpgw(s)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(s) (+q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(s) (-r)','aerolibwindfilters');
        set_mask_help(blk,CDrydenstr);
        set_noise(vnoise,'[1 1 1]*pi');
        set_noise(pnoise,'pi');
    case 'Continuous Dryden (+q +r)'
        set_scale_length(blk,'1');
        replaceblock([blk '/Filters on velocities'],'Dryden Continuous Filters','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hpgw'],'Hpgw(s)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(s) (+q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(s) (+r)','aerolibwindfilters');
        set_mask_help(blk,CDrydenstr);
        set_noise(vnoise,'[1 1 1]*pi');
        set_noise(pnoise,'pi');
    case 'Continuous Dryden (-q +r)'
        set_scale_length(blk,'1');
        replaceblock([blk '/Filters on velocities'],'Dryden Continuous Filters','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hpgw'],'Hpgw(s)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(s) (-q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(s) (+r)','aerolibwindfilters');
        set_mask_help(blk,CDrydenstr);
        set_noise(vnoise,'[1 1 1]*pi');
        set_noise(pnoise,'pi');
    case 'Continuous Von Karman (+q -r)'
        correct_scale_length(blk);
        replaceblock([blk '/Filters on velocities'],'Von Karman Continuous Filters','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hpgw'],'Hpgw(s)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(s) (+q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(s) (-r)','aerolibwindfilters');
        set_mask_help(blk,CVonKarmanstr);
        set_noise(vnoise,'[1 1 1]*pi');
        set_noise(pnoise,'pi');
    case 'Continuous Von Karman (+q +r)'
        correct_scale_length(blk);
        replaceblock([blk '/Filters on velocities'],'Von Karman Continuous Filters','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hpgw'],'Hpgw(s)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(s) (+q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(s) (+r)','aerolibwindfilters');
        set_mask_help(blk,CVonKarmanstr);
        set_noise(vnoise,'[1 1 1]*pi');
        set_noise(pnoise,'pi');
    case 'Continuous Von Karman (-q +r)'
        correct_scale_length(blk);
        replaceblock([blk '/Filters on velocities'],'Von Karman Continuous Filters','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hpgw'],'Hpgw(s)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(s) (-q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(s) (+r)','aerolibwindfilters');
        set_mask_help(blk,CVonKarmanstr);
        set_noise(vnoise,'[1 1 1]*pi');
        set_noise(pnoise,'pi');
    case 'Discrete Dryden (+q -r)'
        set_scale_length(blk,'1');
        replaceblock([blk '/Filters on velocities'],'Dryden Discrete Filters','aerolibwindfilters');
        set_p_subsystem(blk);
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(z) (+q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(z) (-r)','aerolibwindfilters');
        set_mask_help(blk,DDrydenstr);
        set_noise(vnoise,'[1 1 1]*ts');
        set_noise(pnoise,'ts');
    case 'Discrete Dryden (+q +r)'
        set_scale_length(blk,'1');
        replaceblock([blk '/Filters on velocities'],'Dryden Discrete Filters','aerolibwindfilters');
        set_p_subsystem(blk);
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(z) (+q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(z) (+r)','aerolibwindfilters');
        set_mask_help(blk,DDrydenstr);
        set_noise(vnoise,'[1 1 1]*ts');
        set_noise(pnoise,'ts');
    case 'Discrete Dryden (-q +r)'
        set_scale_length(blk,'1');
        replaceblock([blk '/Filters on velocities'],'Dryden Discrete Filters','aerolibwindfilters');
        set_p_subsystem(blk);
        replaceblock([blk '/Filters on angular rates/Hqgw'],'Hqgw(z) (-q)','aerolibwindfilters');
        replaceblock([blk '/Filters on angular rates/Hrgw'],'Hrgw(z) (+r)','aerolibwindfilters');
        set_mask_help(blk,DDrydenstr);
        set_noise(vnoise,'[1 1 1]*ts');
        set_noise(pnoise,'ts');
    otherwise
        error('aeroblks:aeroblkwindturb2:invalidmodel','model action not defined');
end

return
% ----------------------------------------------------------
function set_scale_length(blk,valuestr)

LvGainBlk = [blk, '/Turbulence scale lengths/Lv'];
LwGainBlk = [blk, '/Turbulence scale lengths/Lw'];

lvgainstr = get_param(LvGainBlk,'Gain');

if ~strcmp(lvgainstr,valuestr)
    set_param(LvGainBlk,'Gain',valuestr);
    set_param(LwGainBlk,'Gain',valuestr);
end

return
% ----------------------------------------------------------
function correct_scale_length(blk)

smode = get_param(blk,'spec');

if strcmp(smode,'MIL-F-8785C')
    set_scale_length(blk,'1');
else
    set_scale_length(blk,'0.5');
end
% ----------------------------------------------------------
function set_p_subsystem(blk)

smode = get_param(blk,'spec');

if strcmp(smode,'MIL-F-8785C')
    replaceblock([blk '/Filters on angular rates/Hpgw'],'Hpgw(z) (8785)','aerolibwindfilters');
else
    replaceblock([blk '/Filters on angular rates/Hpgw'],'Hpgw(z) (1797)','aerolibwindfilters');
end

return
% ----------------------------------------------------------
function set_noise(blk,power_str)

%  Mask type check added for linearization test
if strcmp(get_param(blk,'MaskType'),'Band-Limited White Noise.')
   m_v = get_param(blk,'MaskValues');

   if ~strcmp(m_v{1},power_str)
      set_param(blk,'MaskValues',{power_str;m_v{2};m_v{3};m_v{4}});
   end
end

return