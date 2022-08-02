% MPC5XX_GET_TARGET_VARIANT returns the target variant of the current subsystem
%
% Arguments
%      block - Find the target variant for the target subsystem in which
%              this block resides.
% Returns
%      '555' | '565' etc

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:27:12 $
function variant = mpc5xx_get_target_variant( block )
    t = RTWConfigurationCB('get_target' ,block);
    sc = t.findConfigForClass('MPC555dkConfig.SYSTEM_CLOCKS');
    variant = sc.MPC5xx_Variant;
