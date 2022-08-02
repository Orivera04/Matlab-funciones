function blocks = findSystem(model, CaseSensitive, Grammar, SearchAnnotation, SearchSignal, SearchBlock, SearchInport, SearchOutport, varargin)
% Given constraints, return found objects

% wrapper for find_system, make it more easier to use without construct
% regular expression externally

% we expect pass in arguments in pairs:
% i.e, findsystem(model, 'BlockType', 'gain', 'Name', 'xyz')

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

regstr = '';
filterregstr = ''; % hold translated regstr for use with regular expr
for i = 1:2:length(varargin)
    if isempty(varargin{i+1}) && strcmpi(Grammar, 'ContainsWord')
        % when value is empty and Grammar is 'ContainsWord', we match
        % everything contains that field
        regstr = [regstr '''' varargin{i} ''',' '''.*'','];  
        filterregstr = [filterregstr '''' varargin{i} ''',' '''.*'','];
    elseif strcmpi(Grammar, 'MatchWholeWord')
        regstr = [regstr '''' varargin{i} ''',' '''' varargin{i+1} ''','];
        filterregstr = [filterregstr '''' varargin{i} ''',' '''' regexpFilter(varargin{i+1}) ''','];
    else
        % Regular expression
        regstr = [regstr '''' varargin{i} ''',' '''' varargin{i+1} ''','];
        filterregstr = regstr;
    end
end

if CaseSensitive
    CaseSensitiveStr = ['''CaseSensitive'', ''on'''];
else
    CaseSensitiveStr = ['''CaseSensitive'', ''off'''];
end

if strcmpi(Grammar, 'ContainsWord')
    GrammarStr = ['''RegExp'', ''on'''];
    % very important, when regular expr is on, we need translate sfix(16)
    % into sfix\(16\) as (16) has special meaning in regular expression
    regstr = filterregstr;
    ContainSearch = 1;
elseif strcmpi(Grammar, 'MatchWholeWord')
    GrammarStr = ['''RegExp'', ''off'''];
    ContainSearch = 0;
elseif strcmpi(Grammar, 'RegularExpression')
    GrammarStr = ['''RegExp'', ''on'''];
    regstr = filterregstr;
    ContainSearch = 1;
else
    error('Incorrect Grammar used.');
    return
end


% eat last ','
if ~isempty(regstr)
    if strcmp(regstr(end), ',')
        regstr(end)='';
    end
    regstr = [', ' regstr];
end
% regstr debug info

tryagain = 0;
str = ['foundObjects = find_system(model, ''FindAll'', ''on'', ' CaseSensitiveStr ', '  GrammarStr regstr ');'];
try
    eval(str);
catch
    tryagain = 1;
end
% if the user accidentally closes the system, we will attempt to
% open it again
if tryagain
    open_system(model);
    eval(str);
end

% clear return values
blocks=[];
for i=1:length(foundObjects)
    objType = get_param(foundObjects(i), 'Type');
    switch objType
        case 'block'
            if SearchBlock
                blocks = [blocks; foundObjects(i)];
            end
        case 'annotation'
            if SearchAnnotation
                blocks = [blocks; foundObjects(i)];
            end
        case 'line'
            if SearchSignal
                blocks = [blocks; foundObjects(i)];
            end
        case 'port'
            if SearchInport && strcmpi(get_param(foundObjects(i), 'PortType'), 'inport')
                blocks = [blocks; foundObjects(i)];
            elseif SearchOutport && strcmpi(get_param(foundObjects(i), 'PortType'), 'outport')
                blocks = [blocks; foundObjects(i)];
            end
        otherwise 
    end
end

% translate to handle in case name returns from find_system
for i=1:length(blocks)
    blocks(i) = get_param(blocks(i), 'handle');
end

