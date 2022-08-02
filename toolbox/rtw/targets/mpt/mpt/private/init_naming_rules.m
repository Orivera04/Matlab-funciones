function init_naming_rules(modelName)
%INIT_NAMING_RULES Initialize the global variable nameRules
%
%   INIT_NAMING_RULES()
%   This function initializes the global naming rules for variables,
%   parameters and #defines.
%
%   INPUTS: 
%           none
%
%   OUTPUTS:
%           none
%

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.11.4.1 $
%   $Date: 2004/04/15 00:28:15 $


global nameRules;
set_name_rules(modelName,'VariableApproach', 'None');
set_name_rules(modelName,'VariableCaseType', 'No Change');
set_name_rules(modelName,'VariableNameCreateMFunction', '');
set_name_rules(modelName,'ParameterApproach', 'None');
set_name_rules(modelName,'ParameterCaseType', 'No Change');
set_name_rules(modelName,'ParameterNameCreateMFunction', '');
set_name_rules(modelName,'DefineApproach', 'None');
set_name_rules(modelName,'DefineCaseType', 'No Change');
set_name_rules(modelName,'DefineNameCreateMFunction', '');
