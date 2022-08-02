function argout = c166_can_enabled_check(block,type)
% C166_CAN_ENABLED_CHECK checks that the CAN module for this block is enabled
%   C166_CAN_ENABLED_CHECK(BLOCK,TYPE) throws an error if the CAN module
%   required by BLOCK is not enabled in the main resource configuration.
%   The TYPE must be set to either 'CAN' or 'TwinCAN'.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/19 01:17:36 $

  module_str = ['CAN_' get_param(gcb,'module')];
  
  % Find the resources object
  target = RTWConfigurationCB('get_target',block);
  
  switch type
   case 'CAN'
    config = target.findConfigForClass('c166Config.CAN_C166');
   case 'TwinCAN'
    config = target.findConfigForClass('c166Config.TwinCAN_C166');
   otherwise
    error('Invalid argument');
  end
  
  if ~ config.(module_str).Module_enabled
    error(['Attempt to use CAN module that is not enabled. This block requires '...
           'CAN module ' module_str ' but this module is not enabled in the C166 ' ...
           'Resource Configuration']);
  end
