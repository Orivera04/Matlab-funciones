function [varargout] = mask_pwm_config(action,block,varargin)
%MASK_PWM_CONFIG implements ask callbacks for the MIOS PWM Out block
%   
% action - one of {timing_settings, period}
%   
% block  - handle to the block
%   
% varargin
%   if action == 'update_period'
%      varargin{1} - period
%      varargin{2} - cp
%      varargin{3} - pp
%   
% varargout
%   if action == 'update_period'
%      varargout{1} - updated value of period
%      varargout{2} - updated value of cp
%      varargout{3} - updated value of pp_out


%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.11.4.2 $
%   $Date: 2004/04/19 01:29:46 $

  switch lower(action)
    
   case 'timing_settings'
    ts = get_param(block,'timing_settings');
    switch ts
     case 'on'  % Manual Register Settings
            enable_manual_params(block);
     case 'off' % Auto Register Settings
      enable_auto_params(block)
    end
    
    
   % Calculate period settings and do range checking; note that this may be 
   % called from inside the mask initialisation therefore this case must 
   % not contain any set_param calls
   case 'period_calc'
    period = varargin{1};
    cp = varargin{2};
    pp = varargin{3};
    period_out = period;
    cp_out = cp;
    pp_out = pp;
       
    target = RTWConfigurationCB('get_target',block);
    mios1 = target.findConfigForClass('MPC555dkConfig.MIOS1');

    if isempty(mios1)
      % We are in a library model so there
      % is no configuration block. Set empty return arguments and return.
      varargout={[],[],[]};
      return;
    end
    
    ts = get_param(block,'timing_settings');
    switch ts
     case 'on' %Manual Register Settings
      cp_t = 256 - cp; 
      
      if (cp < 0) | (cp > 255)
	error(['The clock pre-scaler parameter is out of range. '...
	       'The allowed range for this parameter is 0 to 255. You ' ...
	       'must change this parameter to a value that in in this range']);
      end
      
      if (pp > 2^16-1) | pp < 0
	error(['The parameter for number of clock ticks per period is out of range. '...
	       'The allowed range for this parameter is 0 to 65535.'...
	       ' You must change this parameter to a value that is in this range.']);
      end
      
      mios_counter_clock_freq = mios1.CounterClock;
      period_out =  pp  *  cp_t  / mios_counter_clock_freq;
      
     case 'off' %Auto Register Settings
      % Generate the register values
      mios_counter_clock_freq = mios1.CounterClock;
      x = fix(mios_counter_clock_freq * period );
      
      if x>0 & x<2^24
	% vector of all the possible 8-bit pre-scaler values
	pre_scaler = 1:256;
	
	% calculate corresponding period register values
	period_count = min(round(x./pre_scaler),(2^16-1));
	
	% calculate error between desired and achieved period
	period_error = abs(x-period_count.*pre_scaler);
	
	% use the first set of values that give the smallest error
	% between the desired and achieved period
	idx = min(find(period_error==min(period_error)));
	
	% set the block parameters
	cp_out = 256-pre_scaler(idx);
	pp_out = period_count(idx);
      else
	% couldn't achieve requested period - set default values and error out
	
	cp_t = (256 - slresolve('cp',gcb));
	pp = slresolve('pp',gcb);
	period = pp*cp_t/mios_counter_clock_freq;
	error(['Could not achieve this pulse period. With a MIOS Counter Clock ' ...
	       'of ' num2str(mios_counter_clock_freq) ', the maximum period is ' ...
	       num2str((2^24-1)/mios_counter_clock_freq) ' seconds, and the resolution is '...
	       num2str(1/mios_counter_clock_freq) ' seconds. You may be able to achieve '...
	       'the desired pulse period by changing the MIOS Counter Clock '...
	       'prescaler in the MPC555 Resource Configuration block.']);
      end
    end
    varargout = {period_out, cp_out, pp_out};

   % Update the block parameters associated with PWM period; note that all set_param
   % calls must be in this section; set_param calls are allowed here because this 
   % callback is not used during the mask initialisation.
   case 'period_update'
    period = eval(get_param(gcb,'period'),'[]');
    cp = eval(get_param(gcb,'cp'),'[]');
    pp = eval(get_param(gcb,'pp'),'[]');
    
    ts = get_param(block,'timing_settings');
    switch ts
     case 'on' %Manual Register Settings
    if ~any([isempty(cp) isempty(pp)])
      % If eval returns empty, then it may be that a variable was
      % specified rather than a numeric value. We can only do the update 
      % check at this point if a numeric value was entered.
      [period, cp, pp] = mask_pwm_config('period_calc',gcb,period,cp,pp);
    else
      period = []; % cannot calc value here because either pp or cp are strings
    end
    set_param(gcb,'period',num2str(period));
  
    case 'off' % Auto register settings
     if ~isempty(period)
       % If eval returns empty, then it may be that a variable was
       % specified rather than a numeric value. We can only do the update 
       % check at this point if a numeric value was entered.
       [period, cp, pp] = mask_pwm_config('period_calc',gcb,period,cp,pp);
     else
       cp = []; % cannot calc value here because either period is a string
       pp = [];
     end
    set_param(gcb,'cp',num2str(cp));
    set_param(gcb,'pp',num2str(pp));
    end
  
  end         % switch 
  
  
function enable_manual_params(block)
    simUtil_maskParam('disable',block,'period');
    simUtil_maskParam('enable',block,{'cp' 'pp'});

function enable_auto_params(block)
    simUtil_maskParam('enable',block,'period');
    simUtil_maskParam('disable',block,{'cp' 'pp'});





