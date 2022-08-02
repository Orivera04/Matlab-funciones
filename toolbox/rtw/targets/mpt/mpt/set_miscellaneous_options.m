function set_miscellaneous_options(modelName,miscOptionCat, miscOptionValue)
%SET_TEMPLATE_INFO Set the global templateInfo
%
%   SET_TEMPLATE_INFO(MODELNAME,TEMPLATECAT, TEMPLATENAME)
%         Establish and populate the global templateInfo
%
%   INPUT:
%         modelName: Name of the model
%         templateCat: Template category
%         templateName: Template name
%

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $
%   $Date: 2002/06/18 01:35:09 $

%Template Categories
%
 
miscOptions = do_in_global([modelName,'_mpm_options'],'miscellaneous.set_misc_options',miscOptionCat,miscOptionValue);
