function funOption = get_mpt_fun_option(handle)
%GET_MPT_FUN_OPTION will get Stateflow specified function options.
%
% FUNOPTION = GET_MPT_FUN_OPTION(HANDLE) will return options configured for
% a specific Stateflow graphical function or chart.
%
%   INPUT:
%         handle:        Handle or ID of Stateflow Chart or Graphical
%                        Function
%   OUPPUT:
%         funOption:     Configuration options associated with function

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.3 $  
%   $Date: 2002/07/26 05:48:01 $

if isempty(handle) == 0
    funOption = sf('get',handle,'.tag');
    if isempty(funOption) == 1
        funOption.genReplace = 'Gen';
        funOption.exportFrom = 'off';
        funOption.genUnique = 'off';
        funOption.exportHeader = '';
        funOption.internalFileName = '';
        funOption.replaceHeader = '';
        funOption.internalNameOverride = 'off';
    else
        %need to validate fields exist for future growth
        if isfield(funOption,'genReplace') == 0
            funOption.genReplace = 'Gen';
        end
        if isfield(funOption,'exportFrom') == 0
            funOption.exportFrom = 'off';
        end
        if isfield(funOption,'genUnique') == 0
            funOption.genUnique = 'off';
        end
        if isfield(funOption,'exportHeader') == 0
            funOption.exportHeader = '';
        end
        if isfield(funOption,'internalFileName') == 0
            funOption.internalFileName = '';
        end
        if isfield(funOption,'replaceHeader') == 0
            funOption.replaceHeader = '';
        end
        if isfield(funOption,'internalNameOverride') == 0
            funOption.internalNameOverride = 'off';
        end
    end
end