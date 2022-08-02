function name = get_template_name(modelName)
%GET_TEMPLATE_NAME get active template full path name associated with model.
%
%   NAME = GET_TEMPLATE_NAME(MODELNAME) will retrieve the active full path name
%   associated with the model.
%
%   INPUT:
%         modelName:  Name of model (without ".mdl")
%   OUTPUT:
%         name:  Full path name of template file

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.9.4.1 $
%   $Date: 2004/04/15 00:27:10 $

global mpmModelName;
modelName = mpmModelName;
templateInfo = get_template_info(modelName);
name = templateInfo.activeTemplateFullPath;
clear mpmModelName;
