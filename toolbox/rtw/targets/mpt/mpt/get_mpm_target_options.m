function options = get_mpm_target_options(modelName)
%GET_MPM_TARGET_OPTIONS retrieves the MPM configuration options from the model
%
%   OPTIONS = GET_MPM_TARGET_OPTIONS(MODELNAME) retrieves the MPM configuration
%   options associated with a given model name. The configuration options are
%   associated with the "TargetProperties" model attribute.
%
%   INPUT:
%         modelName:  Name of model (without ".mdl")
%   OUTPUT:
%         options:    MPM configuration options retrived from the model

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.6 $
%   $Date: 2002/04/14 17:43:40 $

globalObject = [modelName,'_mpm_options'];
str = ['global ',globalObject];
eval(str);
options = get_param(modelName,'TargetProperties');
eval([globalObject,' = options;']);