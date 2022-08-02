function foundObjs = findsfSystem(model, CaseSensitive, Grammar, varargin)
% Given constraints, return found objects

% we expect pass in arguments in pairs:
% i.e, findsystem(model, 'BlockType', 'gain', 'Name', 'xyz')

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

regstr = '';
filterregstr = ''; % hold translated regstr for use with regular expr
for i = 1:2:length(varargin)
    if strcmpi(varargin{i}, 'DataType')
        if isempty(varargin{i+1})
            continue
        else
            regstr = [regstr '''' varargin{i} ''',' '''' varargin{i+1} ''','];
            filterregstr = [filterregstr '''' varargin{i} ''',' '''' regexpFilter(varargin{i+1}) ''','];        
            continue
        end
    end
    if strcmpi(Grammar, 'ContainsWord')
        if isempty(varargin{i+1})
            % when value is empty and Grammar is 'ContainsWord', we match
            % everything, in fact, we skip this condition
            continue;
        end
        if CaseSensitive
            regstr = [regstr '''-regexp'', '  '''' varargin{i} ''',' '''.*' varargin{i+1} '.*'','];
            filterregstr = [filterregstr '''-regexp'', ' '''' varargin{i} ''',' '''.*' regexpFilter(varargin{i+1}) '.*'','];
        else
            regstr = [regstr '''-regexp'', '  '''' varargin{i} ''',' '''.*' locTrans2CaseInsensitiveRegexprStr(varargin{i+1}) '.*'','];
            filterregstr = [filterregstr '''-regexp'', ' '''' varargin{i} ''',' '''.*' locTrans2CaseInsensitiveRegexprStr(regexpFilter(varargin{i+1})) '.*'','];
        end
    elseif strcmpi(Grammar, 'MatchWholeWord')
        %exact match
        % in this case, we'll always match case
        regstr = [regstr  '''' varargin{i} ''',' '''' varargin{i+1} ''','];
        filterregstr = [filterregstr '''' varargin{i} ''',' '''' regexpFilter(varargin{i+1}) ''','];
    else % regular expression
        regstr = [regstr  '''' varargin{i} ''',' '''' varargin{i+1} ''','];
        filterregstr = regstr;
    end
    
%    if isempty(varargin{i+1}) && strcmpi(Grammar, 'ContainsWord')
%        % when value is empty and Grammar is 'ContainsWord', we match
%        % everything, in fact, we skip this condition
%    else
%        regstr = [regstr '''' varargin{i} ''',' '''' varargin{i+1} ''','];
%        filterregstr = [filterregstr '''' varargin{i} ''',' '''' regexpFilter(varargin{i+1}) ''','];
%    end
end

if strcmpi(Grammar, 'ContainsWord')
    % very important, when regular expr is on, we need translate sfix(16)
    % into sfix\(16\) as (16) has special meaning in regular expression
    regstr = filterregstr;
elseif strcmpi(Grammar, 'RegularExpression')
    regstr = ['''-regexp'', ', regstr];
end
    
% eat last ','
if ~isempty(regstr)
    if strcmp(regstr(end), ',')
        regstr(end)='';
    end
    regstr = [', ' regstr];
end

foundObjs = [];
objects = [];
sfBlocks = find_system(model, 'MaskType', 'Stateflow');
for i=1:length(sfBlocks)
    blkHandle = get_param(sfBlocks{i}, 'handle');
    subsystemObj=get_param(blkHandle, 'Object');
    chartObj = subsystemObj.getHierarchicalChildren;
    
    str = ['objects = chartObj.find(''-isa'', ''Stateflow.Data'' ' regstr ');'];
    eval(str);
    foundObjs = [foundObjs objects];
end

foundObjs = foundObjs(:);
% translate to handle in case name returns from find_system
for i=1:length(foundObjs)
    foundObjs(i) = foundObjs(i).handle;
end

% we need tis function as find method don't have native case sensitive
% support
function output = locTrans2CaseInsensitiveRegexprStr(input)
output = '';
for i=1:length(input)
    if ismember(input(i), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
        output = [output '[' lower(input(i)) upper(input(i)) ']'];
    else
        output = [output input(i)];
    end
end
