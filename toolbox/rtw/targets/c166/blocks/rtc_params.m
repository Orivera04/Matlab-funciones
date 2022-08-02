function rtn_values = rtc_params(mode,f_osc,ideal)
%RTC_PARAMS calculates C166 Real Time Clock (RTC) parameters
%   RTN_VALUES = RTC_PARAMS(MODE, F_OSC, IDEAL) where MODE = 'SystemTimer' takes
%   the IDEAL sample time in seconds and external clock frequency F_OSC then
%   calculates RTN_VALUES comprising RELOAD_VALUE, ACHIEVED_SAMPLE_PERIOD and
%   NS_PER_TICK.  Since the function is called from TLC all return values are
%   combined into a single vector. The RELOAD_VALUE is the value to be placed
%   the the real-time clock reload register T14REL. The ACHIEVED_SAMPLE_PERIOD
%   is calculated based on the external clock frequency that drives the timer.
%   NS_PER_TICK is the number of nanoseconds per system timer tick.
% 
%   NS_PER_TICK = RTC_PARAMS(MODE, F_OSC) where MODE = 'FreeRunningTimer'
%   calculates the resolution in nanoseconds, i.e. the time for one timer
%   tick. 
%  
%   See the C166 user manual and look up Real Time Clock (RTC) for further
%   details.

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2003/07/31 18:02:02 $

  scale = 2^8; % fixed prescaler 
  res = scale / f_osc; % timer resolution
  
  if strcmp(mode,'SystemTimer')
    reload_ideal = ideal / res;
    reload_rounded = round(reload_ideal);
    reload_value = max(min(2^16-1, reload_rounded), 1);
    achieved_sample_period = reload_value * res;
    error = abs(achieved_sample_period - ideal);
    ns_per_tick = round(res / 1e-9);
    
    % is the error acceptable
    if error > res
      warndlg(['The requested sample rate was ' num2str(ideal) ' seconds, '...
               'but the achieved value is ' num2str(achieved_sample_period) ' seconds. '...
               'If this difference is not acceptable, you must '...
               ' change the sample time or timer parameters.']);
    end
    
    % The RTC always counts up
    reload_value = 2^16 - reload_value;
    
    rtn_values = [reload_value achieved_sample_period ns_per_tick];
  elseif strcmp(mode,'FreeRunningTimer')
    ns_per_tick_unrounded = 1e9 * res;
    ns_per_tick = round(ns_per_tick_unrounded);
    rtn_values = ns_per_tick;
  end

    
