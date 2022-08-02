function rtn_values = rtc_xc_params(mode,f_osc,ideal)
%RTC_XC_PARAMS calculates C166 Real Time Clock (RTC) parameters for XC167CI
%   RTN_VALUES = RTC_XC_PARAMS(MODE, F_OSC, IDEAL) where MODE = 'SystemTimer'
%   takes the IDEAL sample time in seconds and external clock frequency F_OSC
%   then calculates RTN_VALUES comprising RELOAD_VALUE, ACHIEVED_SAMPLE_PERIOD,
%   NS_PER_TICK and RTC_CON_PRE.  Since the function is called from TLC all
%   return values are combined into a single vector. The RELOAD_VALUE is the
%   value to be placed the the real-time clock reload register T14REL. The
%   ACHIEVED_SAMPLE_PERIOD is calculated based on the external clock frequency
%   that drives the timer.  NS_PER_TICK is the number of nanoseconds per system
%   timer tick. RTC_CON_PRE is the pre-scaler enable bit in RTC CON register.
% 
%   NS_PER_TICK = RTC_XC_PARAMS(MODE, F_OSC) where MODE = 'FreeRunningTimer'
%   calculates the resolution in nanoseconds, i.e. the time for one timer
%   tick. 
%  
%   See the C166 user manual and look up Real Time Clock (RTC) for further
%   details.

%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2003/07/31 18:02:03 $

  if strcmp(mode,'SystemTimer')
    scale = [1 8]; % possible pre-scaler values
    res = scale / f_osc; % timer resolution
    reload_ideal = ideal ./ res;
    reload_rounded = round(reload_ideal);
    reload_achieved = max(min(2^16-1, reload_rounded), 1);
    error = abs(reload_achieved.*res - ideal);
    i = min(find(min(error)==error));

    % select the best parameters
    reload = reload_achieved(i);
    achieved_sample_period = reload * res(i);
    ns_per_tick = round(res(i) / 1e-9);
     
    % is the error acceptable
    if abs(achieved_sample_period-ideal) > res
      warndlg(['The requested sample rate was ' num2str(ideal) ' seconds, '...
               'but the achieved value is ' num2str(achieved_sample_period) ' seconds. '...
               'If this difference is not acceptable, you must '...
               ' change the sample time or timer parameters.']);
    end
    
    % The RTC always counts up
    reload = 2^16 - reload;
    
    % Setting of pre-scaler bit in control register
    if scale(i) == 1
      rtc_con_pre = 0;
    elseif scale(i) == 8
      rtc_con_pre = 1;
    end
    
    rtn_values = [reload achieved_sample_period ns_per_tick rtc_con_pre];
  elseif strcmp(mode,'FreeRunningTimer')
    scale = [8]; % reset value of RTC_CON is to set pre-scaler enabled
    res = scale / f_osc; % timer resolution
    ns_per_tick_unrounded = 1e9 * res;
    ns_per_tick = round(ns_per_tick_unrounded);
    rtn_values = ns_per_tick;
  end

    
