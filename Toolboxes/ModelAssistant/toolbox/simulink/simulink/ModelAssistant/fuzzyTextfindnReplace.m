function [foundObjects, foundParameters, origValue, newValue] = ...
    fuzzyTextfindnReplace(fuzzyValue, fuzzyReplaceValue, CaseSensitive, PreserveCase, ...
                          Grammar, SearchParamValue, SearchSignalName,varargin)
% fuzzyTextfind

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

blocks = varargin{:};
foundObjects = [];
foundParameters=[];
origValue = [];
newValue = [];

ruleString = '';
patternString = '';
if PreserveCase
    ruleString = [ruleString ', ''preservecase'''];
end
if ~CaseSensitive
    ruleString = [ruleString ', ''ignorecase'''];
end

if strcmpi(Grammar, 'ContainsWord')
    fuzzyValue = regexpFilter(fuzzyValue);
    fuzzyReplaceValue = regexpFilter(fuzzyReplaceValue);
    patternString = fuzzyValue;
elseif strcmpi(Grammar, 'MatchWholeWord')
    fuzzyValue = regexpFilter(fuzzyValue);
    fuzzyReplaceValue = regexpFilter(fuzzyReplaceValue);
    patternString = ['\<' fuzzyValue '\>'];
else
    % do nothing for regular exprssion case
    patternString = fuzzyValue;
end

for i=1:length(blocks)
    p=get_param(blocks(i), 'ObjectParameters');
    if SearchParamValue
        % search for Dialog Parameters prompt: that's special case needs
        % individual search.
        if isfield(p, 'DialogParameters')
            dp = get_param(blocks(i), 'DialogParameters');
            if ~isempty(dp)
                fnames = fieldnames(dp);
                for j=1:length(fnames)
                    fuzzyParamFound = 0; % marks whether this param valid
                    CompValue = get_param(blocks(i), fnames{j});
                    if isnumeric(CompValue) 
                        CompValue = num2str(CompValue);
                    end
                    % only compare if it's string %and one dimensional
                    if isstr(CompValue) %&& (length(size(CompValue))<2)
                        try
                            str = ['newStr = regexprep(CompValue, patternString, fuzzyReplaceValue ' ruleString ');'];
                            eval(str);
                            if ~strcmp(newStr, CompValue)
                                foundObjects(end+1) = blocks(i);
                                foundParameters{end+1}=fnames{j};
                                origValue{end+1} = CompValue;
                                newValue{end+1} = newStr;
                            end
                        catch
                        end
                    end
                end % end length(fnames)
            end
        end
    end % end SearchParamValue
    if SearchSignalName
        if strcmpi(get_param(blocks(i), 'Type'), 'line')
            CompValue = get_param(blocks(i), 'Name');
            try
                str = ['newStr = regexprep(CompValue, patternString, fuzzyReplaceValue ' ruleString ');'];
                eval(str);
                if ~strcmp(newStr, CompValue)
                    foundObjects(end+1) = blocks(i);
                    foundParameters{end+1}= 'Name';
                    origValue{end+1} = CompValue;
                    newValue{end+1} = newStr;
                end
            catch
            end
        end
    end %end SearchSignalName
end %end length(blocks)
