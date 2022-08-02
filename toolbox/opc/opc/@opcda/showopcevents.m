function out = showopcevents(obj, varargin)
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
% $Revision: 1.1.6.6 $  $Date: 2004/03/24 20:43:41 $

% Arg checking
errMsg = nargchk(1, 2, nargin);
if ~isempty(errMsg),
    rethrow(mkerrstruct('opc:showopcevents:inargs', errMsg));
end
% Is struct a struct?
if ~isa(obj, 'opcda'),
    rethrow(mkerrstruct('opc:showopcevents:eventarg'));
end
% Obj must be a scalar
if length(obj)>1,
    rethrow(mkerrstruct('opc:showopcevents:vecnotsupported'));
end

% Pass the whole lot to the function showopcevents!
if nargin<2,
    args = {get(obj,'EventLog')};
    %showopcevents(get(obj, 'EventLog'));
else
    args = [{get(obj,'EventLog')}, varargin{:}];
    %showopcevents(get(obj, 'EventLog'), varargin{:});
end

if nargout == 1
    out = showopcevents(args{:});
else
    showopcevents(args{:});
end
