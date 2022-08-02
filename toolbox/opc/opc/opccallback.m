function opccallback(obj, event)
%OPCCALLBACK Display event information for OPC Toolbox callbacks.
%   OPCCALLBACK(Obj,Event) displays a message that contains information
%   about an OPC Toolbox event. The type of event, the time the event
%   occurred, and the related data for that event is displayed in the
%   MATLAB Command Window.
%
%   Obj is the object associated with the event. Event is a structure that
%   contains the Type and Data fields. Type is the event type. Data is a
%   structure containing event-specific information.
%
%   OPCCALLBACK is an example callback function. Use this callback
%   function as a template for writing your own callback function. By
%   default a dagroup object's ReadAsyncFcn, WriteAsyncFcn, and
%   CancelAsyncFcn are set to @opccallback, and an opcda object's ErrorFcn
%   and ShutDownFcn is set to @opccallback.
%
%   See also SHOWOPCEVENTS.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $  $Date: 2004/02/01 22:06:51 $

% This function just calls showopcevents.
showopcevents(event)
