function [pulse_width_register,init_code,input_scale,disp_str] = mask_mpwmsm(action,varargin)
%MASK_MPWMSM mask initialization for this block
%
% Parameters
%
%   action      -       'initfcn'  
%   varargin    - { PWM Module ,        -  string   
%                   Freeze Enable,      -  'on' | 'off'
%                   Transparent,        -  'on' | 'off'
%                   Polarity,           -   0 | 1
%                   Period              -   in seconds
%                   PWM Prescaler       -   integer 8 bit
%                   Pulse Period        -   integer 16 bit
%                   Use as Digital,     -   'on' | 'off'
%                   }
%
% Returns
%
%   pulse_width_register    -   A string to represent the output register
%   init_code               -   A string to to represent the initialization code
%                               for the port.
%   input_scale             -   Scaling of the input signal before being written to
%                               the register.
%   disp_str                -   A string to display on the mask

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $
%   $Date: 2004/04/19 01:29:45 $

   switch action
   case 'initfcn'
      module = varargin{1};  % Module
      FREN = varargin{2}-1;  % Freeze Enable
      TRSP = varargin{3}-1; % Transparent
      POL = varargin{4}-1; % Polarity
      period = varargin{5}; % period
      CP = varargin{6};  % PWM Prescaler
      PP = varargin{7};  % Pulse Period
      UAD = varargin{8}; % Use as digital

      scr = ['MIOS1.MPWMSM' module 'SCR' ];
      scrB = [ scr '.B' ];

      init_code = strvcat( ...
            [ scrB '.FREN = ' num2str(FREN) ';' ], ...
            [ scrB '.DDR = 1;' ]);

      switch UAD
      case 'on'
          % Use as digital output
          pulse_width_register = [ 'MIOS1.MPWMSM' module 'SCR.B.POL'];

          % Initialize the PWM Control Register for digital output
          init_code = strvcat(init_code, [ scrB '.EN = 0;' ]); 
          input_scale = 1;


          disp_str = ['MPWMSM' module '\n(Digital Out)'];
     

      case 'off'
          % Use as pwm output
          pulse_width_register = [ 'MIOS1.MPWMSM' module 'PULR.R'];
          pulse_period_register = [ 'MIOS1.MPWMSM' module 'PERR.R'];

          % Initialize the PWM Control Register for PWM output
          init_code = strvcat ( init_code , ...
              [ scrB '.EN = 1;' ] , ...
              [ pulse_period_register ' = 0x' dec2hex(min(PP,2^16-1)) ';'] , ...
              [ scrB '.POL = '  num2str(POL) ';' ] , ...
              [ scrB '.TRSP = ' num2str(TRSP) ';' ], ...
              [ scrB '.CP = ' num2str(CP) ';' ] );
          input_scale = PP;

          disp_str = ['MPWMSM' module '\n(Period = ' num2str(period) ' s)' ];

      end

   otherwise
      error([action ' is not supported. ']);
   end
         

