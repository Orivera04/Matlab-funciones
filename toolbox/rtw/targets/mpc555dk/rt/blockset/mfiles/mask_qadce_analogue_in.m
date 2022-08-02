function register = mask_qadce_analogue_in(module,channels,justification)
%MASK_QADCE_ANALOGUE_IN Mask initialization for the QADCE continuous scan analog input
%   Performs mask initialization for the QADCE continuous scan driver block
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

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:29:48 $

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
qadc64 = target.findConfigForClass('MPC555dkConfig.QADC64E');
if isempty(qadc64)
  % No config block found
  return
end

muxmodeA = qadc64.QADCE_A.Multiplex_Mode;
muxmodeB = qadc64.QADCE_B.Multiplex_Mode;

intmultstr = '0 = Internally multiplexed : 40 possible channels';
extmultstr = '1 = Externally multiplexed : 65 possible channels';

switch muxmodeA
    case intmultstr 
        a_multiplexing = false;
    case extmultstr
        a_multiplexing = true;
    otherwise
        error('Unknown multiplexing type.');
end

switch muxmodeB
    case intmultstr
        b_multiplexing = false;
    case extmultstr
        b_multiplexing = true;
    otherwise 
        error('Unknown multiplexing type.');
end

if ~a_multiplexing && ~b_multiplexing
    % no multiplexing
    permitted = [44:59 64:87];
elseif a_multiplexing && ~b_multiplexing
    % A only multiplexing    
    permitted = [0:31 48:51 55:59 64:87];
elseif ~a_multiplexing && b_multiplexing
    % B only multiplexing   
    permitted = [0:31 48:59 64:71 75:87];
elseif a_multiplexing && b_multiplexing
    % A & B multiplexing    
    permitted = [0:31 48:51 55:59 64:71 75:87];
else
    error('Unknown condition');
end;

newln = sprintf('\n');

if any( ~ismember(channels,permitted) )
  error(['At least one illegal channel number was specified. The current multiplex mode is:'...
         newln newln 'Module A ''' muxmodeA '''' newln 'Module B ''' muxmodeB ''''...
         newln newln 'which means that the permitted channel numbers are:' newln newln...
         num2str(permitted) newln newln 'Check that all channels are in this set, or that '...
         'the multiplex mode is specified correctly.']);
end
