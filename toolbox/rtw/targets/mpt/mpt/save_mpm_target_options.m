function save_mpm_target_options(modelName,varargin)
%SAVE_MPM_TARGET_OPTIONS Save the MPM target optoins in the model.
%
%   SAVE_MPM_TARGET_OPTIONS(MODELNAME,VARARGIN)
%         Save the MPM target optoins in the model.
%
%   INPUT:
%         modelName: The model name.
%         varargin: options to save

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.6 $
%   $Date: 2002/04/14 17:39:30 $

if nargin == 2
    options = varargin{1};
else
    globalObject = [modelName,'_mpm_options'];
    str = ['global ',globalObject];
    eval(str);
    options = eval(globalObject);
end
targetData.GlobalData=options.GlobalData;
targetData.GlobalData_FileTempaltes=options.GlobalData.FileTemplates;
targetData.registeredType=options.registeredType;
targetData.NameRules = options.NameRules;
targetData.Miscellaneous = options.Miscellaneous;
set_param(modelName,'TargetProperties',targetData);
