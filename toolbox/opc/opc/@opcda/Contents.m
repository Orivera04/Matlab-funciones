% OPCDA Functions and Properties.
%
% OPCDA Construction and Configuration Functions.
%   opcda               - Construct an OPC data access client object.
%   addgroup            - Add an OPC data access group object to the
%                         client.
%   get                 - Get value of OPC Toolbox object property.
%   set                 - Set value of OPC Toolbox object property.
%   delete              - Remove OPC Toolbox objects from memory.
%   isvalid             - True for OPC Toolbox objects that are not deleted.
%
% Server Exploration Functions.
%   getnamespace        - Return or view the OPC server namespace.
%   opcserverinfo       - Return version, server, and status information.
%   serveritems         - Query server or namespace for fully qualified 
%                         item IDs.
%   serveritemprops     - Return property information for items in OPC 
%                         server namespace.
%
% General Functions.
%   cleareventlog       - Clear the event log, discarding all events.
%   connect             - Connect OPC data access client (opcda) object to 
%                       - server.
%   disconnect          - Disconnect OPC data access client (opcda) object 
%                         from server.
%   obj2mfile           - Convert OPC Toolbox object to MATLAB code.
%   opcfind             - Find OPC Toolbox objects with specific properties.
%   opchelp             - Return OPC Toolbox function and property help.
%   propinfo            - Return property information for OPC Toolbox 
%                         objects. 
%   showopcevents       - Display event log summary for OPC Toolbox events. 
%
% OPCDA PROPERTIES.
% General Properties.
%       Group           - Data Access group array.
%       Name            - Descriptive name for OPC Toolbox object.
%       Tag             - Label to associate with the OPC Toolbox object. 
%       Type            - OPC Toolbox object type.
%       UserData        - Data you want to associate with the OPC Toolbox 
%                         object.
% 
% Callback Function and Event Properties.
%       ErrorFcn        - M-file callback function to execute when an error 
%                         event occurs.
%       EventLog        - Event information log.
%       EventLogMax     - Maximum number of events to store in the event 
%                         log. 
%       ShutDownFcn     - M-file callback function to execute when the OPC 
%                         server shuts down. 
%       TimerFcn        - M-file callback function to execute whenever a 
%                         predefined period of time passes. 
%       TimerPeriod     - Period of time between timer events. 
% 
% Server Connection Properties.
%       Host            - DNS name or IP address of server.
%       ServerID        - Server identity.
%       Status          - Status of the connection to the OPC server.
%       TimeOut         - Maximum time to wait for completion of an 
%                         instruction to the server.
% 
% 
% See also DAGROUP, DAITEM.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.1 $  $Date: 2004/02/09 08:39:56 $
