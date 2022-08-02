function set_name_rules(modelName, nameRuleCat, nameRuleValue)
%SET_NAME_RULES Set the global scopeInfo
%
%   SET_NAME_RULES(MODELNAME, NAMERULECAT, NAMERULEVALUE)
%         Set the global scopeInfo
%
%   INPUT:
%         modelName: Name of the model
%         nameRuleCat: Name rule category
%         nameRuleValue: Name rule value

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.6 $
%   $Date: 2002/04/14 17:39:15 $

%Template Categories
%
%
scopeInfo = do_in_global([modelName,'_mpm_options'],'NameRules.set_name_rules',nameRuleCat,nameRuleValue);
