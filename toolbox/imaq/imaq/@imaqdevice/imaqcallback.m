function imaqcallback(obj, event, varargin)
%IMAQCALLBACK Display event information for the event.
%
%    IMAQCALLBACK(OBJ, EVENT) displays a message which contains the 
%    type of the event, the time of the event and the name of the
%    object which caused the event to occur.  
%
%    If an error event occurs, the error message is also displayed.  
%
%    IMAQCALLBACK is an example callback function. Use this callback 
%    function as a template for writing your own callback function.
%
%    Example:
%       obj = videoinput('winvideo', 1);
%       set(obj, 'StartFcn', {'imaqcallback'});
%       start(obj);
%       wait(obj);
%       delete(obj);
%
%    See also IMAQHELP.
%

%    CP 10-01-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:17 $

% Define error identifiers.
errID = 'imaq:imaqcallback:invalidSyntax';
errID2 = 'imaq:imaqcallback:zeroInputs';

switch nargin
    case 0
        error(errID2, imaqgate('privateMsgLookup', errID2));
    case 1
        error(errID, imaqgate('privateMsgLookup', errID));
    case 2
        if ~isa(obj, 'imaqdevice') || ~isa(event, 'struct')
            error(errID, imaqgate('privateMsgLookup', errID));
        end   
        if ~(isfield(event, 'Type') && isfield(event, 'Data'))
            error(errID, imaqgate('privateMsgLookup', errID));
        end
end

% Determine the type of event.
EventType = event.Type;

% Determine the time of the error event.
EventData = event.Data;
EventDataTime = EventData.AbsTime;

% Create a display indicating the type of event, the time of the event and
% the name of the object.
name = get(obj, 'Name');
fprintf([EventType ' event occurred at ' datestr(EventDataTime,13),...
        ' for video input object: ' name '.\n']);

% Display the error string.
if strcmp(lower(EventType), 'error')
    fprintf([EventData.Message '\n']);
end
