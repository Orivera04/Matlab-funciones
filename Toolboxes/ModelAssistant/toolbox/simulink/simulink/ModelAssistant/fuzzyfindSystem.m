function [foundObjects, foundParameters] = fuzzyfindSystem(fuzzySearch, fuzzyParameter, fuzzyValue, SearchScope, varargin)
% fuzzy search refinement
% given search objects in varargin, find valid objects and valid parameters
% SearchScope: 0  -  find all parameters
%              2  -  find parameters with dialog prompts only
%              1  -  find inside dialog prompts string.

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

blocks = varargin{:};
foundParameters=[];
fuzzyParameter = lower(fuzzyParameter);
fuzzyValue = lower(fuzzyValue);
idxTobeCopied = [];
if fuzzySearch
    for i=1:length(blocks)
        p=get_param(blocks(i), 'ObjectParameters');
        fp=fields(p);
        fuzzyFound = 0; %which marks whether this block valid or not
        if SearchScope==0 % search regular parameters
            for j=1:length(fp)
                fuzzyParamFound = 0; % marks whether this param valid
                CompParameter = lower(fp{j});
                if ~isempty(strfind(CompParameter, fuzzyParameter)) || isempty(fuzzyParameter)
                    if ~isempty(fuzzyValue)
                        CompValue = get_param(blocks(i), fp{j});
                        if isnumeric(CompValue) 
                            CompValue = num2str(CompValue);
                        end
                        % only compare if it's string %and one dimensional
                        if isstr(CompValue) %&& (length(size(CompValue))<2)
                            CompValue = lower(CompValue);
                            try
                                if ~isempty(strfind(CompValue, fuzzyValue))
                                    fuzzyFound = 1;
                                    fuzzyParamFound =1;
                                end
                            catch
                            end
                        end
                    else
                        % if fuzzyValue is empty, we just validate this block
                        % without compare value
                        fuzzyFound = 1;
                        fuzzyParamFound = 1;
                    end
                    if fuzzyParamFound
                        foundParameters{length(foundParameters)+1}=fp{j};
                    end
                end
            end % end length(fp)
        elseif SearchScope==1
            % search for Dialog Parameters prompt: that's special case needs
            % individual search.
            if isfield(p, 'DialogParameters')
                dp = get_param(blocks(i), 'DialogParameters');
                try
                    if ~isempty(dp)
                        fnames = fieldnames(dp);
                        for k=1:length(fnames)
                            tp = getfield(dp, fnames{k});
                            if (isfield(tp, 'Prompt'))
                                promptValue = lower(tp.Prompt);
                                try 
                                    if ~isempty(strfind(promptValue, fuzzyValue))
                                        fuzzyFound = 1;
                                        foundParameters{length(foundParameters)+1}=fnames{k};
                                    end
                                catch
                                end
                            end
                        end
                    end
                catch
                end
            end % if isfield
        elseif SearchScope==2  %find parameters with dialog prompts only
            if isfield(p, 'DialogParameters')
                dp = get_param(blocks(i), 'DialogParameters');
                if ~isempty(dp)
                    fnames = fieldnames(dp);
                    for j=1:length(fnames)
                        fuzzyParamFound = 0; % marks whether this param valid
                        CompParameter = lower(fnames{j});
                        if ~isempty(strfind(CompParameter, fuzzyParameter)) || isempty(fuzzyParameter)
                            if ~isempty(fuzzyValue)
                                CompValue = get_param(blocks(i), fnames{j});
                                if isnumeric(CompValue) 
                                    CompValue = num2str(CompValue);
                                end
                                % only compare if it's string %and one dimensional
                                if isstr(CompValue) %&& (length(size(CompValue))<2)
                                    CompValue = lower(CompValue);
                                    try
                                        if ~isempty(strfind(CompValue, fuzzyValue))
                                            fuzzyFound = 1;
                                            fuzzyParamFound =1;
                                        end
                                    catch
                                    end
                                end
                            else
                                % if fuzzyValue is empty, we just validate this block
                                % without compare value
                                fuzzyFound = 1;
                                fuzzyParamFound = 1;
                            end
                            if fuzzyParamFound
                                foundParameters{length(foundParameters)+1}=fnames{j};
                            end
                        end
                    end % end length(fnames)
                end
            end
        end % if SearchDialogPrompts
        % record valid blocks
        if fuzzyFound
            idxTobeCopied(length(idxTobeCopied)+1)=i;
        end
    end %end length(blocks)
    % copy block
    tempBlock = [];
    for i=1:length(idxTobeCopied)
        tempBlock(i) = blocks(idxTobeCopied(i));
    end
    blocks = tempBlock;
end % end fuzzySearch

foundObjects = blocks;
foundParameters = unique(foundParameters);
