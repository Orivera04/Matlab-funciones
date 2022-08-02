function templateInfo = get_template_info(modelName)
%GET_TEMPLATE_INFO Initialize the global variable templateInfo
%
%   [TEMPLATEINFO]=GET_TEMPLATE_INFO(MODELNAME)
%   This function will initialize the global template info and return this
%   information a structure in the form to the caller function.
%
%   INPUTS:
%            modelName    : Name of the input Model
%
%   OUTOUTS:
%            templateInfo : All information avaialble about the templates for a model.
%

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.10.4.1 $
%   $Date: 2004/04/15 00:28:12 $

templateInfo = do_in_global([modelName,'_mpm_options'],'GlobalData.FileTemplates.get_template');



 
