function ert_auto_configuration(model, option)
% ERT_AUTO_CONFIGURATION - Configure model's RTW options
% according the the specified option.  This function is
% merely a gateway to ert_config_opt.m
%
% Arguments:
%   model  - Name of Simulink model.
%   option - Either 'optimized_fixed_point' or 'optimized_floating_point'

% Copyright 1996-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2003/12/31 19:42:53 $

  switch(option)
   case 'optimized_fixed_point'
    ert_config_opt(model,option);
   case 'optimized_floating_point'
    ert_config_opt(model,option);
   otherwise
    error(['Uknown ERT auto configuration option: ', option])
  end