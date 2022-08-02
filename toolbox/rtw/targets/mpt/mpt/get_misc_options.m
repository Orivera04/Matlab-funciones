function miscOptions = get_misc_options(modelName)
%GET_MISC_OPTIONS will retrieve the miscellaneous MPM configuration options.
%
%   GET_MISC_OPTIONS retrieves the miscellanous MPM configuration options 
%   associated with a particular model.
%
%   INPUT:
%         modelName:     Name of model (without ".mdl")
%   OUTPUT:
%         miscOptions:   Miscellaneous MPM configuration options


%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.6 $  $Date: 2002/04/14 17:43:48 $

miscOptions = do_in_global([modelName,'_mpm_options'],'Miscellaneous.get_misc_options');
