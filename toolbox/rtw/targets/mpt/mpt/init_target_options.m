function init_target_options(modelName)
%INIT_TARGET_OPTIONS creates and initializes MPM configuration object.
%
%   INIT_TARGET_OPTIONS(MODELNAME) creates and initializes MPM configuration
%   objects.
%
%   INPUT:
%         modelName:  Name of model (without ".mdl")

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.6 $
%   $Date: 2002/04/14 17:42:44 $

objectName = [modelName,'_mpm_options'];
str = ['global ',objectName];
eval(str);
eval([objectName,' = typeContainer.userType;']);
