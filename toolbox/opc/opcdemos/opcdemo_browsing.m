%% OPCDEMO_BROWSING
% This example demonstrates how to use the OPC Toolbox to browse the
% network for OPC Servers, and use OPC Toolbox functions to query the
% server name space for server items and their properties.

% Copyright 2004 The MathWorks, Inc.

%% Browsing the Network for Servers
% You use the opcserverinfo function to query a host on the network for
% available OPC Servers. This example uses the local host.
hostInfo = opcserverinfo('localhost')

%%
% The returned structure provides information about each server:
hostInfo.ServerDescription'

%%
% and the Server ID you use to create a client object.
allID = hostInfo.ServerID'

%% Retrieving the Name Space of a Server
% To interact with a server, you must create an OPC Data Access Client
% Object (opcda client object). You use the host name and server ID found
% in the previous step.
da = opcda('localhost', 'Matrikon.OPC.Simulation.1')

%%
% You must also connect the client to the server.
connect(da);

%%
% You can retrieve the name space of the server with that client object.
ns = getnamespace(da)

%%
% Each element of the structure is a node in the server name space.
ns(1)

%% Finding Specific Items in the Name Space
% To find specific items in the name space, you can use the serveritems
% function. In this case, try to find all server items with ID containing
% the string 'Real'
realItems = serveritems(ns, '*Real*')

%% Querying server item properties
% Each server item has properties that describe the server item. Property
% IDs define which property of the server item you require. In this
% example, examine the Canonical Data Type (PropID = 1) and the Item Access
% Rights (PropID = 5) of the second item found.
canDT = serveritemprops(da, realItems{2}, 1)
accessRights = serveritemprops(da, realItems{2}, 5)

%% Clean up OPC Toolbox objects
% Once you have finished with OPC Toolbox objects, you must delete
% them from the OPC Toolbox engine and clear them from the workspace.
disconnect(da)
delete(da)
clear da
