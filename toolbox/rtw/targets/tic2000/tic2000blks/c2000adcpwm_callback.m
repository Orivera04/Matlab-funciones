function c2000adcpwm_callback (modelName)

% $RCSfile: c2000adcpwm_callback.m,v $
% $Revision: 1.1.6.1 $ 
% $Date: 2004/04/01 16:13:33 $
% Copyright 2004 The MathWorks, Inc.

ret = [];
sysinfo = [];
try
    sysinfo = getBasicSystemInfo (sysinfo);
    [ret,ADCblocks] = processADCblocks (ret, modelName, sysinfo);
    [ret,PWMblocks] = processPWMblocks (ret, modelName, sysinfo);
    ret = processADCPWMdependencies (ret, ADCblocks, PWMblocks);   
catch
    disp (lasterr)
end


%-------------------------------------------------------------------------------
function [ret,ADCblocks] = processADCblocks (ret, modelName, sysinfo)
ADCblocks = [];
ADCblocks = find_system(modelName,'FollowLinks','on','LookUnderMasks','on','MaskType',sysinfo.ADCblocktypes{1});
%process all ADC blocks
if (~isempty(ADCblocks)),
    ret.numADCs = length (ADCblocks);
    for i=1:length (ADCblocks),
        ret.ADC{i}.useModule = get_param (ADCblocks{i},'useModule');
        ret.ADC{i}.sourceSOC = get_param (ADCblocks{i},'sourceSOC');        
    end
else
    ret.numADCs = 0;
end


%-------------------------------------------------------------------------------
function [ret,PWMblocks] = processPWMblocks (ret, modelName, sysinfo)
PWMblocks = [];
PWMblocks = find_system(modelName,'FollowLinks','on','LookUnderMasks','on','MaskType',sysinfo.PWMblocktypes{1});
% process all PWM blocks
if (~isempty(PWMblocks)),
    ret.numPWMs = length (PWMblocks);
    for i=1:length (PWMblocks),
        ret.PWM{i}.useModule = get_param (PWMblocks{i},'useModule');                     
        ret.PWM{i}.adcstartEvent = get_param (PWMblocks{i},'adcstartEvent');             
    end
else
    ret.numPWMs = 0;
end


%-------------------------------------------------------------------------------
function ret = processADCPWMdependencies (ret, ADCblocks, PWMblocks)

%process all PWM blocks
for idxpwm=1:ret.numPWMs
    isfound=0;
    for idxadc=1:ret.numADCs
        if (strcmp(ret.PWM{idxpwm}.useModule, ret.ADC{idxadc}.useModule)) % found ADC that shares EV module
            isfound=1;
            if (strcmp(ret.PWM{idxpwm}.adcstartEvent, 'None'))
                set_param (ADCblocks{idxadc},'sourceSOC','Software');
            else
                set_param (ADCblocks{idxadc},'sourceSOC',ret.PWM{idxpwm}.adcstartEvent);
            end
        end
    end
    if (~isfound && ~strcmp(ret.PWM{idxpwm}.adcstartEvent, 'None'))
        warning (sprintf (['PWM block using module ' ret.PWM{idxpwm}.useModule ' generates an ADC start signal.\n' ...
                  'However, ADC block using the same module couldn''t be found in the model.']));
    end
end

%process all ADC blocks
for idxadc=1:ret.numADCs
    isfound=0;
    for idxpwm=1:ret.numPWMs
        if (strcmp(ret.ADC{idxadc}.useModule, ret.PWM{idxpwm}.useModule)) % found PWM that shares EV module
            isfound=1;
        end
    end
    if (~isfound && ~strcmp(ret.ADC{idxadc}.sourceSOC, 'Software'))
        warning (sprintf(['ADC block using module ' ret.ADC{idxadc}.useModule ' expects an ADC start signal.\n' ...
                  'However, PWM block using the same module couldn''t be found in the model.\n' ...
                  'The ADC will be reset to use software trigger.' ]));
        set_param (ADCblocks{idxadc},'sourceSOC','Software');        
    end
end





%-------------------------------------------------------------------------------
function sysinfo = getBasicSystemInfo (sysinfo)

% Get user Target Preferences and set attributes according to the chip used
tgtPrefs = getTargetPreferences_tic2000;
sysinfo.tgtPrefs = tgtPrefs;

% Set the masktype string for the system search according to the chip used
switch lower(tgtPrefs.getDSPBoard.getDSPChip.getDSPChipLabel)
    case {'ti tmc320c2401', 'ti tms320c2407'}
        sysinfo.ADCblocktypes = {'C24x ADC'};
        sysinfo.PWMblocktypes = {'C24x PWM'};
    case {'ti tms320c2810', 'ti tms320c2812'}
        sysinfo.ADCblocktypes = {'C28x ADC'};
        sysinfo.PWMblocktypes = {'C28x PWM'};
    otherwise
        error ('Unknown DSP chip label');
end

% [EOF] c2000adcpwm_callback.m
