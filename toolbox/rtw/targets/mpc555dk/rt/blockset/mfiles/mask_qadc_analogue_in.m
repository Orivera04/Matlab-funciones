function register = mask_qadc_analogue_in(module,channels,justification)
%MASK_QADC_ANALOGUE_IN Mask initialization for the QADC continuous scan analog input
%   Performs mask initialization for the QADC continuous scan driver block
%
%   [outputs] = FUNCTIONNAME(inputs) uses ... to do ...
%
%    module         -  'QADC_A'  'QADC_B'
%    channels       -  vector of channels
%    justification  -  The justification mode. A valid range of  1-3 
%
%   and returns ...
%
%   See also FUNCTION1, FUNCTION2, ...

%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.8.4.4 $
%   $Date: 2004/04/19 01:29:47 $

i_check_params(module, channels);
  
module = ['QADC_', module];

switch justification
case 1
  register = [module, '.RJURR[%<i>].R'];
case 2
  register = [module, '.LJURR[%<i>].R'];
case 3
  register = [module, '.LJSRR[%<i>].R'];
end

% Internal function to do parameter checking
function i_check_params(module, channels)

target = RTWConfigurationCB('get_target',gcb);
qadc64 = target.findConfigForClass('MPC555dkConfig.QADC64');
if isempty(qadc64)
  % No config block found
  return
end

if strcmp(module,'A')
  muxmode = qadc64.QADC_A.Multiplex_Mode;
elseif strcmp(module,'B')
  muxmode = qadc64.QADC_B.Multiplex_Mode;
else
  error(['unrecognized value for module: ' module]);
end

if strcmp(muxmode,'0 = Internally multiplexed : 16 possible channels')
  permitted = [0:3 48:59];
elseif strcmp(muxmode,'1 = Externally multiplexed : 41 possible channels')
  permitted = [0:31 48:51 55:59];
else
  error(['unrecognized value for muxmode: ' muxmode])
end

if any( ~ismember(channels,permitted) )
  error(['At least one illegal channel number was specified. The current multiplex mode is '...
         '''' muxmode ''', which means that the permitted channel numbers are '...
         num2str(permitted) '. Check that all channels are in this set, or that '...
         'the multiplex mode is specified correctly.']);
end
