function set_template_info(modelName,templateCat, templateName)
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
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.11.4.1 $
%   $Date: 2004/04/15 00:29:08 $

%Template Categories
%
%templateInfo.cFunctionTemplate      C Function Template and anything else the user puts in (.c)
%templateInfo.globalTemplate         Optional Global Declarations (.c)
%templateInfo.globalIncludeTemplate  Include (.h) file associated with global declarations
%templateInfo.filePrototypeTemplate  File function prototypes (.h)
%templateInfo.typeDefTemplate        Type definition file (.h)
%templateInfo.miscTemplate{..}       array of template definitions
%templateInfo.activeTemplateFullPath
scopeInfo = do_in_global([modelName,'_mpm_options'],'GlobalData.FileTemplates.set_template',templateCat,templateName);
