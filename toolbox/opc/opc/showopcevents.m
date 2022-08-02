function out = showopcevents(eventStruct, index)
%SHOWOPCEVENTS Display event log summary for OPC Toolbox events.
%   SHOWOPCEVENTS(Obj) displays a summary of the event log for the opcda
%   object specified by Obj.
%
%   SHOWOPCEVENTS(Obj,Index) displays a summary of the events with index,
%   Index.  Index can be the numerical index or a string or a cell array
%   of strings that specify the type of event. Valid events are
%   CancelAsync, Error, ReadAsync, Shutdown, and WriteAsync.
%
%   SHOWOPCEVENTS(Struct) and SHOWOPCEVENTS(Struct,Index) displays a
%   summary of the events with index, Index for the event structure,
%   Struct.  You can obtain an event structure from the object's EVENTLOG
%   property.
%
%   The display summary includes the event type, the local time the event
%   occurred, and additional event-specific information.
%
%   Examples
%       da = opcda('localhost','Matrikon.OPC.Simulation');
%       connect(da)
%       grp = addgroup(da);
%       set(grp, 'RecordsToAcquire',10);
%       itm = additem(grp,'Bucket Brigade.Real8');
%       start(grp);
%       wait(grp);
%       showopcevents(da);
%
%   See also OPCCALLBACK.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.6 $  $Date: 2004/03/24 20:43:52 $

% Arg checking
msg = nargchk(1, 2, nargin);
if ~isempty(msg),
    rethrow(mkerrstruct('opc:showopcevents:inargs', msg));
end
% Is eventStruct a struct?
if isempty(eventStruct),
    out = [];
    return;
end
if ~iseventstruct(eventStruct),
    rethrow(mkerrstruct('opc:showopcevents:eventstructarg'));
end
% Parse the index
eventTypes = {'CancelAsync', 'Error', 'ReadAsync', 'Shutdown', 'WriteAsync', 'DataChange', ...
    'Start', 'Stop', 'RecordsAcquired'};
if nargin<2,
    index = 1:length(eventStruct);
else
    allType = {eventStruct.Type};
    switch class(index)
        case 'char'
            % Just a single event type
            eInd = strcmp(index, eventTypes);
            if ~any(eInd),
                rethrow(mkerrstruct('opc:showopcevents:indexarg', ...
                    sprintf('Invalid event type ''%s'' specified.', index)));
            end
            index = find(strcmp(eventTypes{eInd}, allType));
        case 'cell'
            % Many event types
            if ~iscellstr(index),
                rethrow(mkerrstruct('opc:showopcevents:indexarg'));
            end
            ind = false(size(allType));
            for k=1:length(index)
                eInd = strcmp(index{k}, eventTypes);
                if ~any(eInd),
                    rethrow(mkerrstruc('opc:showopcevents:indexarg', ...
                        sprintf('Invalid event type ''%s'' specified.', index)));
                end
                ind = ind | strcmp(eventTypes{eInd}, allType);
            end
            index = find(ind);
        otherwise
            index = index(index<length(eventStruct));
            if any(index<1),
                rethrow(mkerrstruct('opc:showopcevents:indexrange'));
            end
    end
end
msg = {};
if ~isempty(index)
    % Construct the messages
    for k=index(:)'
        msg{end+1} = eventmessage(eventStruct(k));
    end
end
if nargout==1,
    out = msg;
else
    if strcmp(get(0,'FormatSpacing'), 'loose'),
        blankline = sprintf('\n');
    else
        blankline = '';
    end
    fprintf(blankline);
    for k=1:length(msg),
        fprintf('%s\n%s', msg{k}, blankline);
    end
end
        
%-----------------------------------------------------------
function is = iseventstruct(eStruct)
% True if the arg is an event structure
is = isstruct(eStruct);
if is,
    fn = fieldnames(eStruct);
    is = any(strcmp('Type', fn)) && any(strcmp('Data', fn));
    if is
        % Make sure there's a localeventtime in the Data
        for k=1:length(eStruct),
            is = isstruct(eStruct(k).Data) && ...
                any(strcmp('LocalEventTime', fieldnames(eStruct(k).Data)));
        end
    end
end

%-----------------------------------------------------------
function msg = eventmessage(event)
% Make a message string out of an event
% Make the specialised message first
switch event.Type
    case 'ShutDown'
        typeMsg = sprintf('\tReason: %s', event.Data.Reason);
    case {'ReadAsync', 'WriteAsync'}
        typeMsg = sprintf('\tTransaction ID: %d\n\tGroup Name: %s\n%s', ...
            event.Data.TransID, event.Data.GroupName, ...
            itemsmsg(event.Type, event.Data.Items));
    case {'Error', 'DataChange'}
        typeMsg = sprintf('\tGroup Name: %s\n%s', ...
            event.Data.GroupName, ...
            itemsmsg(event.Type, event.Data.Items));
    case 'CancelAsync'
        % Only one set of data here!
        typeMsg = sprintf('\t%s operation with ID %d on Group ''%s''.', ...
            event.Data.EventSource, ...
            event.Data.TransID, ...
            event.Data.GroupName);
    case {'Start', 'Stop', 'RecordsAcquired'}
        typeMsg = sprintf('\tGroup ''%s'': %d records acquired.', ...
            event.Data.GroupName, ...
            event.Data.RecordsAcquired);
    otherwise
        rethrow(mkerrstruct('opc:showopcevents:eventtype', ...
            sprintf('Unhandled event type ''%s'' encountered.', event.Type)));
end
% Now construct the actual message!
msg = sprintf('OPC %s event occurred at local time %s\n%s', ...
    event.Type, smartdatestr(event.Data.LocalEventTime), typeMsg);

%-----------------------------------------------------------
function str = itemsmsg(type, items)
% Format a display of multiple items
str = '';
switch type
    case 'Error'
        % Display each item's error message
        errItem = {items.ItemID};
        errMsg = {items.ErrorMessage};
        allStrs = [errItem; errMsg];
        str = sprintf('\t\t%s returned: ''%s''\n', allStrs{:});
%         str = sprintf('\t%d items had errors.', length(items));
    case 'ReadAsync'
        str = sprintf('\t%d items read.', length(items));
    case 'WriteAsync'
        str = sprintf('\t%d items written.', length(items));
end

%-----------------------------------------------------------
function s = smartdatestr(dv)
% Format a date without the y/m/s if it's within 24 hours of today
if abs(now-datenum(dv))<1,
    s = datestr(dv, 13);
else 
    s = datestr(dv, 31);
end
