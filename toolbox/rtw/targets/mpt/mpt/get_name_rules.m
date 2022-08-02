function nameRules = get_name_rules(modelName)
%GET_NAME_RULES will retrieve the name rules MPM configuration options.
%
%   GET_NAME_RULES retrieves the name rules MPM configuration options 
%   associated with a particular model.
%
%   INPUT:
%         modelName:     Name of model (without ".mdl")
%   OUTPUT:
%         nameRules:   Name rules MPM configuration options

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $  $Date: 2004/04/15 00:27:07 $

nameRules = do_in_global([modelName,'_mpm_options'],'NameRules.get_name_rules');
