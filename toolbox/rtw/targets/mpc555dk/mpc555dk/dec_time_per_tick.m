function time_per_tick_str = dec_time_per_tick(modelName, units)
%DEC_TIME_PER_TICK  calculates the number of decrementer ticks per nanosecond.
%   TIME_PER_TICK = DEC_TIME_PER_TICK(MODELNAME,UNITS) looks for an MPC555 Resource
%   Configuration Block in MODELNAME and queries it to find the System_Clock.
%   From this information, it derives DEC_TIME_PER_TICK, the number of UNITS
%   for each decrementer tick. This information is required by execution profiling.

% Copyright 2002-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $
% $Date: 2004/04/19 01:26:35 $

  config_block = find_system(modelName,...
                             'followlinks','on', ...
                             'lookundermasks','on', ...
                             'tag','RTW CONFIGURATION BLOCK');
  
  if isempty(config_block)
    error(['The model ' modelName ' does not contain an MPC555 Resource Configuration block,']);
  end
  
  target = get_param(config_block,'userdata');
  target = target{1}; 
  system_clocks = target.findConfigForClass('MPC555dkConfig.SYSTEM_CLOCKS');
  sys_clock = system_clocks.System_clock;
  
  % The decrementer frequency is system clock divided by 16
  time_per_tick = 16 / units / sys_clock;
  
  % Round to nearest then convert to uint16
  time_per_tick_rounded = round(time_per_tick);
  time_per_tick_uint16 = double(uint16(time_per_tick_rounded));
  % Range checking
  if abs(time_per_tick_uint16-time_per_tick)/time_per_tick > 0.01
    warndlg(['The number of decrementer ticks per nanosecond has been rounded' ...
             ' from ' num2str(time_per_tick) ' to ' num2str(time_per_tick_uint16) ...
             ', which is an error of greater than 1%. If you are performing ' ...
             ' execution profiling using the decrementer then accuracy of display '...
             ' results may be affected accordingly']);
  end
  
  time_per_tick_str = num2str(time_per_tick_uint16);
            