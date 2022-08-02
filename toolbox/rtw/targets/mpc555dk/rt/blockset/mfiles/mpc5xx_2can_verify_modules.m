% MPC5XX_2CAN_VERIFY_MODULES verifies that the module selection for the specified block is correct 
%   Used to verify that the 'module' parameter of the
%   toucan driver block has been set correctly considering
%   the processor variant selection. MPC555 only has CAN
%   module A and B but the MPC56x family has A B and C
%
% Arguments
%     block - the toucan driver block to check.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/19 01:30:01 $
function modules = mpc5xx_2can_verify_modules(block)
% Verify the module selection is suited to the processor variant
target = RTWConfigurationCB('get_target',block);
if ~isempty(target)
  sys_res = target.findConfigForClass('MPC555dkConfig.SYSTEM_CLOCKS');
  variant = sys_res.MPC5xx_Variant;
else
  variant = '555';
end

module = get_param(block,'module');

if ~mpc555_module_available(variant, ['toucan_' lower(module)])    
   error(sprintf( ...
         '\nCAN Module %s is not supported for this variant\nTo use CAN Module %s change to another processor variant.', ...
         module, module));
end
