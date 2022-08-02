function rtn_values = gpt_params(mode,f,timerName,arg3)
%GPT_PARAMS calculates C166 General Purpose Timer parameters
%   RTN_VALUES = GPT_PARAMS(MODE,F,TIMER,IDEAL) where MODE = 'SystemTimer' takes
%   the system frequency F, the GPT TIMER and IDEAL sample time in seconds and
%   calculates RTN_VALUES comprising RELOAD, PRESCALE, ACHIEVED,
%   NS_PER_TICK. Since the function is called from TLC all return values are
%   combined into a single vector. These value are PRESCALE be loaded into the
%   GPT register field TxI, the timer RELOAD value, the ACHIEVED sample rate and
%   NS_PER_TICK, the number of nanoseconds per system timer tick.
%   
%   RTN_VALUES = GPT_PARAMS(MODE,F,TIMER, STEPSIZE) where MODE =
%   'FreeRunningTimer' takes calculates RTN_VALUES comprising NS_PER_TICK and
%   PRESCALE. NS_PER_TICK is the maximum timer resolution in nanoseconds,
%   i.e. the time for one timer tick. Note that this value is rounded to the
%   nearest whole number. STEPSIZE is required in order to choose a free
%   running timer pre-scaler that give an appropriate timer range for the 
%   step size that must be measured.
%
%   See the C166 user manual and look up General Purpose Timer Units for further
%   details.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.2.6.3 $  $Date: 2004/04/19 01:17:40 $
  
scale = i_get_timer_scale(timerName);
t3i = [0:7]; % possible prescaler values
res = scale * 2.^t3i / f; % possible timer resolutions

if strcmp(mode, 'SystemTimer')
  ideal = arg3;
  reload_ideal = ideal ./ res;
  reload_rounded = round(reload_ideal);
  reload_achieved = max(min(2^16-1, reload_rounded), 1);
  error = abs( (reload_achieved .* res) - ideal);
  i = min(find(min(error)==error));
  
  % select the best parameters
  reload=reload_achieved(i);
  prescale=t3i(i);
  achieved=reload_achieved(i)*res(i);
  ns_per_tick = round(res(i) / 1e-9);
  
  % is the error acceptable
  if abs(achieved-ideal) > res(8)
    warndlg(['The requested sample rate was ' num2str(ideal) ' seconds, '...
             'but the achieved value is ' num2str(achieved) ' seconds. '...
             'If this difference is not acceptable, you must '...
             ' change the sample time or timer parameters ']);
  end
  
  rtn_values = [reload prescale achieved ns_per_tick];

elseif strcmp(mode,'FreeRunningTimer')
  step_size = arg3;
  min_range = step_size * 10; % Try to make sure the timer doesn't 
                              % wrap in short than this length of time
  tgt_res = min_range / (2^16); % Assume 16-bit counter
                                
  i = min(find(res>=(tgt_res-eps)));
  if (isempty(i))
    i=length(res);
    warndlg(['The free running timer resolution is greater than ' num2str(res(end)) ...
             ' per tick. '...
             'This is higher resolution than the system timer and could cause '...
             'incorrect results for execution profiling. You should try using different '...
             'timers for the system timer and free running timer or increase the base '...
             'sample rate.']);
  end
  
  res_actual = res(i);
  prescale=t3i(i);

  % Calculate the maximum resolution, i.e. with no pre-scaler
  ns_per_tick_unrounded = res_actual * 1e9;
  ns_per_tick = round(ns_per_tick_unrounded);
  rtn_values = [ns_per_tick prescale];
end

% Calculate the scaling that depends on which timer is used
function scale = i_get_timer_scale(timerName) 
switch timerName
 case {'T2','T3','T4'}
  scale=8;
 case {'T5','T6'}
  scale=4;
 otherwise
  error(['Unrecognized timer name ' timerName])
end
