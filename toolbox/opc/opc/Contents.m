% OPC Toolbox
% Version 1.0 (R14) 05-May-2004
%
% OPC Toolbox Object Creation and Configuration.
%   opcda               - Construct an OPC data access client object.
%   addgroup            - Add a data access group to an opcda object.
%   additem             - Add data access items to a dagroup object.
%   opcda/connect       - Connect OPC data access (opcda) object to server.
%   opcda/disconnect    - Disconnect OPC data access (opcda) object from server.
%   opcroot/get         - Get OPC Toolbox object properties.
%   opcroot/set         - Configure or display OPC Toolbox object properties.
%   opcda/delete        - Remove OPC Toolbox objects from memory.
%   opcroot/isvalid     - True for OPC Toolbox objects that are not deleted.
% 
% Server Exploration Functions.
%   flatnamespace       - Flatten a hierarchical OPC namespace.
%   getnamespace        - Return or view the OPC server namespace.
%   opcserverinfo       - Return version, server, and status information.
%   serveritemprops     - Return property information for items in OPC server 
%                         namespace.
%   serveritems         - Query server or namespace for fully qualified item IDs.
%
% Data Access Functions.
%   cancelasync         - Cancel asynchronous read and write operations.
%   dagroup/read        - Read data synchronously from group or items.
%   dagroup/readasync   - Read data asynchronously from group or items.
%   dagroup/refresh     - Read all active items in a group.
%   dagroup/write       - Write values to group or items.
%   dagroup/writeasync  - Asynchronously write values to group or items.
%
% Logging and Buffering Functions.
%   dagroup/flushdata   - Remove all logged data associated with the dagroup 
%                         object.
%   dagroup/getdata     - Return logged records from OPC Toolbox engine to 
%                         MATLAB workspace.
%   opcread             - Return logged records from disk to MATLAB workspace.
%   opcstruct2array     - Convert OPC Data from structure to array format.
%   dagroup/peekdata    - Preview most recently acquired data.
%   dagroup/start       - Start a logging task.
%   dagroup/stop        - Stop a logging task.
%   dagroup/wait        - Suspend MATLAB execution until object has stopped
%                         logging.
% 
% General.
%   cleareventlog       - Clear the event log, discarding all events.
%   opcda/copyobj       - Make a copy of an OPC Toolbox object.
%   opc/private/load    - Load OPC Toolbox objects from a MAT-file.
%   opcda/obj2mfile     - Convert OPC Toolbox object to MATLAB code.
%   opccallback         - Display event information for OPC Toolbox callbacks.
%   opcfind             - Find OPC Toolbox objects with specific properties.
%   opchelp             - Return OPC Toolbox function and property help.
%   opcregister         - Install and register OPC Foundation Core Components.
%   opcreset            - Disconnect and delete all OPC Toolbox objects.
%   opctool             - OPC Toolbox Graphical User Interface.
%   opcroot/propinfo    - Return property information for OPC Toolbox objects. 
%   opc/private/save    - Save OPC Toolbox objects to a MAT-file.
%   showopcevents       - Display event log summary for OPC Toolbox events. 
%
%
% OPC Toolbox Demos
%   opcdemo_quickstart      - Quick start example.
%   opcdemo_browsing        - Locating and browsing OPC Servers.
%   opcdemo_objects         - Creating and configuring OPC Toolbox objects.
%   opcdemo_managing        - Managing OPC Toolbox objects.
%   opcdemo_readwrite       - Synchronous reading and writing.
%   opcdemo_logging         - Logging OPC data.
%   opcdemo_eventlog        - Viewing the event log.
%   opcdemo_defaultcallback - Using the default callback.
%   opcdemo_customcallback  - Using a custom callback.
%
%
% See also OPCDA, DAGROUP, DAITEM, OPCHELP

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% Generated from Contents.m_template revision 1.1.4.1 $Date: 2004/04/08 20:55:42 $
