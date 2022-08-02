function [varargout] = mask_mpc555_watchdog(action,block,varargin);
%MASK_MPC555_WATCHDOG generates code for MPC555 software watchdog
%
%   Standard Parameters
%
%   action   -  The action the function is to perform; must be one of
%               {rangecheck, initfcn}
%   block    -  The block the action is to perform on
%
%   Usage 'rangecheck'
% 
%   varargin - { timeout }
%       timeout is the requested watchdog timeout period in seconds
%
%   varargout - { achieved_timeout }
%
%   Usage 'initfcn'
%
%   varargin  - { timeout }
%       timeout is the requested watchdog timeout period in seconds
%
%   varargout - { model_init_function_code, subsystem_output_function_code }
%
%       model_init_function_code             - code to be run at initialization
%       subsystem_output_function_code - code go in the subsystem
%                                              outputs function
%

%   Copyright 2001-2003 The MathWorks, Inc.
%   $Revision: 1.9.4.3 $  $Date: 2004/04/19 01:29:44 $

% Find out the system clock
  target = RTWConfigurationCB('get_target',gcb);
  system_clocks = target.findConfigForClass('MPC555dkConfig.SYSTEM_CLOCKS');
  sys_clock=system_clocks.System_Clock;

  % unpack the input arguments
  timeout = varargin{1};
  
  % basic checks
  if ( length(timeout) ~=1 ) | ( ~isreal(timeout) )
    error(['The watchdog timeout value must be a real-valued scalar. You should change the watchdog timeout ' ...
           'value to an appropriate setting.'])
  end
  
  % Calculate watchdog counter value
  prescale = 2048; % always use pre-scaler
  SWTC = ceil(timeout*sys_clock/prescale);
  
  % Range checking for the counter value
  if ( SWTC > hex2dec('FFFF') ) | ( SWTC < 1 ) 
    error(['The specified watchdog timeout of ' num2str(timeout) ' seconds cannot be achieved. '...
	   'The maximum achievable value is (2^16-1) * 2048 / System_Clock = '...
	   num2str( (2^16-1) * 2048 / sys_clock )...
	   ' seconds, and the minimum achievable value is 2048 / System_Clock = '...
	   num2str( (1) * 2048 / sys_clock )...
	   ' seconds. You should change the watchdog timeout value so that it is within the allowed range '...
           'and note that the requested value is rounded up to the nearest multiple of '...
           ' 2048 / System_Clock = ' num2str( (1) * 2048 / sys_clock ) ' seconds.']);
  end
  
  
  switch action
   case 'rangecheck'
    achieved_timeout=SWTC*prescale/sys_clock;
    varargout = {achieved_timeout};
   case 'initfcn'
    % calculate value of SYPCR
    BMT = hex2dec('FF');
    BME = 1;
    SWF = 1;
    SWE = 1;
    SWRI = 1;
    SWP = 1;
    SYPCR = SWP + SWRI*2^1 + SWE*2^2 + SWF*2^3+BME*2^7 + BMT*2^8 + ...
            SWTC*2^16;
    SYPCR_address = '0x2FC004';
    
    
    model_init_function_code = sprintf([...
        '/* Initialize SYPCR to enable software watchdog timer */\n'...
        '{\n' ...
        '   USIU.SYPCR.R = (UINT32) 0x' dec2hex(SYPCR) ';\n' ...
        '}\n']);
    
    varargout = { model_init_function_code };
    otherwise
     error(['Invalid action ''' action ''' in call to ' mfilename]);
   end
