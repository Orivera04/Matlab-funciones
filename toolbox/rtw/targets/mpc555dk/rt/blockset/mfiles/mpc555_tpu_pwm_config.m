function [varargout] = mpc555_tpu_pwm_config(action, block, varargin)
% MPC555_TPU_PWM_CONFIG implements mask callbacks and initialisation
% for MPC555 TPU PWM Out block
%
% action - see switch case below
%
% block - handle to the block

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.5.6.4 $
%   $Date: 2004/04/19 01:30:00 $

switch lower(action)
case 'block_period_callback'
   i_block_period_callback(block);
case 'timing_settings_callback'
   i_timing_settings_callback(block); 
case 'ideal_period_callback'
   i_ideal_period_callback(block);
case 'pwmper_callback'
   i_PWMPER_callback(block);
case 'model_initialisation'
   % note: no set_params are allowed in block initialisation callback
   varargout{1} = i_model_initialisation(block, varargin{1}, varargin{2});
otherwise
   error(['Action ' action ' not found!']);
end;

% note: no set_params should be done in this function
% this function ensures we update correctly at model initialisation time
% this handles workspace / mask variables etc
function PWMPER = i_model_initialisation(block, PWMPER, idealP)
   if ~i_maskProcessingEnabled(block)
       % do not process this if the PWMPER is an input!
       % don't care about value of PWMPER...
       return;
   end;
    timing_settings = get_param(block, 'timing_settings');
    switch timing_settings
        case 'on'
            % PWMPER is set manually in the mask
            % find the clock speeds for the appropriate TPU module
            target = RTWConfigurationCB('get_target', block);
            config = target.findConfigForClass('MPC555dkConfig.TPU');
            module = get_param(block, 'module');
            clock = eval(['config.TPU_' module '.TCR1.TCR1_Clock_Frequency']);
            
            % check value is in range
            if (PWMPER ~= castToPeriodInRange(PWMPER))
                i_invalidPWMPER;
            end;
        case 'off'
            % ideal period is set in the mask
            % derive PWMPER
            
            % find the clock speeds for the appropriate TPU module
            target = RTWConfigurationCB('get_target', block);
            config = target.findConfigForClass('MPC555dkConfig.TPU');
            module = get_param(block, 'module');
            clock = eval(['config.TPU_' module '.TCR1.TCR1_Clock_Frequency']);
            
            PWMPER = clock * idealP;
            % check range of PWMPER
            % NOTE: MATLAB integer casts now round instead of truncate!
            if (round(PWMPER) ~= castToPeriodInRange(PWMPER))
                i_invalidIdealPeriod(PWMPER);
            end;
            % now cast to unsigned int
            PWMPER = double(castToPeriodInRange(PWMPER));
    end;
return;

% utility function that checks whether the PWMPER is a block input
% or whether the value is derived from the mask
function mask_processing_enabled = i_maskProcessingEnabled(block)
    % do not run code that depends on a resource config object
    % when called from a library
    if (strcmp(get_param(bdroot(block),'BlockDiagramType'),'library'))
        mask_processing_enabled = 0;
        return;
    end; 

    block_period = get_param(block,'block_period');
    switch block_period
        case 'on'
            % PWM Period is a block input
            mask_processing_enabled = 0;
        case 'off'
            % PWM period is derived in the mask
            mask_processing_enabled = 1;
    end;
return;

% just handles how the mask looks
function i_block_period_callback(block)
   block_period = get_param(block,'block_period');
   switch block_period
	case 'on'
		simUtil_maskParam('hide', block, 'actual_period');
		simUtil_maskParam('hide', block, 'ideal_period'); 
		simUtil_maskParam('hide', block, 'PWMPER');
		simUtil_maskParam('hide', block, 'timing_settings');
	case 'off'
		simUtil_maskParam('show', block, 'actual_period');
		simUtil_maskParam('show', block, 'PWMPER');
		simUtil_maskParam('show', block, 'timing_settings');
		timing_settings = get_param(block,'timing_settings');
		switch timing_settings
			case 'on'
			case 'off'
				simUtil_maskParam('show', block, 'ideal_period');
		end;
   end;
return;

% just handles how the mask looks
function i_timing_settings_callback(block)
   timing_settings = get_param(block,'timing_settings');
   switch timing_settings
	case 'on'
		simUtil_maskParam('enable', block, 'PWMPER');
		simUtil_maskParam('disable', block, 'ideal_period'); 
	case 'off'
		block_period = get_param(block,'block_period');
		switch block_period
			case 'on'
			case 'off'
				simUtil_maskParam('enable', block, 'ideal_period');
		end;
		simUtil_maskParam('disable', block, 'PWMPER');
   end;
return;

function i_ideal_period_callback(block)
   if ~i_maskProcessingEnabled(block)
       % do not process this if the PWMPER is an input!
       return;
   end;
   timing_settings = get_param(block,'timing_settings');
   switch timing_settings
	case 'on'
		% manual editing of register
		return;
	case 'off'
		% ideal period calculations
   end;

   % derive PWMPER
   idealP = str2num(get_param(block,'ideal_period'));
   if (isempty(idealP))
      % perhaps this is a mask variable
      % initialisation case will deal with this
      i_exitIdealPeriodCallback(block);
      return; 
   end;
  
   % find the clock speeds for the appropriate TPU module
   try
	   target = RTWConfigurationCB('get_target', block);
   catch
       % NOTE: we only end up here if there is no config
       % block in the model.
       % clean up, by setting the values we were planning on 
       % modifiying to null
       i_exitIdealPeriodCallback(block);
       rethrow(lasterror);
   end;
   config = target.findConfigForClass('MPC555dkConfig.TPU');
   module = get_param(block, 'module');
   clock = eval(['config.TPU_' module '.TCR1.TCR1_Clock_Frequency']);
   
   PWMPER = clock * idealP;
   % check range of PWMPER
   % NOTE: MATLAB integer casts now round instead of truncate!
   if (round(PWMPER) ~= castToPeriodInRange(PWMPER))
        i_invalidIdealPeriod(PWMPER);
   end;
   
   % now cast to unsigned int
   PWMPER = double(castToPeriodInRange(PWMPER));
   
   % set the PWMPER
   set_param(block, 'PWMPER', num2str(PWMPER));
   % set the actual period
   aPeriod = PWMPER / clock;
   set_param(block, 'actual_period', num2str(aPeriod));
return;

function i_PWMPER_callback(block)
   if ~i_maskProcessingEnabled(block)
       % do not process this if the PWMPER is an input!
       return;
   end;
   timing_settings = get_param(block,'timing_settings');
   switch timing_settings
	case 'on'
		% manual editing of register
	case 'off'
		% ideal period calculations
		return;
   end;

   % calculate the actual period
   PWMPER = str2num(get_param(block,'PWMPER'));
   if (isempty(PWMPER))
      % perhaps this is a mask variable
      % initialisation case will deal with this
      i_exitPWMPERCallback(block)
      return;
   end;
   
   % find the clock speeds for the appropriate TPU module
   try
	   target = RTWConfigurationCB('get_target', block);
   catch
      % NOTE: we only end up here if there is no config
      % block in the model.
      % clean up, by setting the values we were planning on 
      % modifiying to null
       i_exitPWMPERCallback(block);
       rethrow(lasterror);
   end;
   config = target.findConfigForClass('MPC555dkConfig.TPU');
   module = get_param(block, 'module');
   clock = eval(['config.TPU_' module '.TCR1.TCR1_Clock_Frequency']);
   
   % check value is in range
   if (PWMPER ~= castToPeriodInRange(PWMPER))
        i_invalidPWMPER;
   end;

   aPeriod = PWMPER / clock;
   set_param(block, 'actual_period', num2str(aPeriod));
return;

function i_invalidPWMPER
    error(['PWMPER parameter should be an integer in the range 0 <= PWMPER <= 32768.   '...
          'A value for PWMPER has been entered that is not in this range.   '...
          'To fix this error, enter a value for the PWMPER parameter that is in range.']);
return;

function i_invalidIdealPeriod(pwmper)
    error(['Ideal period caused invalid PWMPER parameter settings (PWMPER cannot be set to ' num2str(pwmper) ').   '...
           'The ideal period specified could not be achieved.   '...
           'To fix this error, enter an ideal period that does not cause the PWMPER parameter to go out of range']);
return;

% transforms the input into an in range
% period value
function periodInRange = castToPeriodInRange(input)
    % apply saturation
    if (input < 0)
        periodInRange = 0;
    elseif (input > 32768)
        periodInRange = 32768;
    else
        % cast to remove fractional part
        periodInRange = uint16(input);
    end;
return;

function i_exitIdealPeriodCallback(block)
    % mask failed --> set dependent params to null
    set_param(block, 'PWMPER', '');
    set_param(block, 'actual_period', '');
return;

function i_exitPWMPERCallback(block)
    % mask failed --> set dependent params to null
    set_param(block, 'actual_period', '');
return;
