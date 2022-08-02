function value = get_template_file_name(modelName,templateType) 
%GET_TEMPLATE_FILE_NAME gets the proper template name per template type.
%
%   VALUE = GET_TEMPLATE_FILE_NAME(MODELNAME, TEMPLATETYPE) returns the proper
%   template file name associated with the template type from the specified
%   model.
%
%   INPUT:
%         modelName:  Name of model (without ".mdl")
%         templateType:  Type of template to retrieve.
%   OUTPUT:
%         value: Template name that is associated with template type

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.10.4.1 $  $Date: 2004/04/15 00:27:09 $

templateInfo = get_template_info(modelName);
switch(lower(templateType))
case 'globalincludetemplate'
    value = templateInfo.globalIncludeTemplate;
case 'basetemplate'
    value = 'baseert.tlc';
case 'basetemplatetemp'
    value = 'baseert_temp.tlc';
case 'globaltemplate'
    value = templateInfo.globalTemplate;
case 'cfunctiontemplate'
    value = templateInfo.cFunctionTemplate;
case 'globalincludetemplatetemp'
    value = templateInfo.globalIncludeTemplate;
    value = strtok(value,'.');
    value = [value,'_temp.tlc'];
case 'globaltemplatetemp'
    value = templateInfo.globalTemplate;
    value = strtok(value,'.');
    value = [value,'_temp.tlc'];
case 'cfunctiontemplatetemp'
    value = templateInfo.cFunctionTemplate;
    value = strtok(value,'.');
    value = [value,'_temp.tlc'];
otherwise
    value = '';
end

