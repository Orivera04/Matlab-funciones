%% OPCDEMO_OBJECTS.M
% The OPC Toolbox uses three objects arranged in a strict hierarchy. This
% example shows you how to create and configure these three OPC Toolbox
% objects, and how to configure OPC TOolbox object properties.

% Copyright 2004 The MathWorks, Inc.

%% Creating client objects.
% You create a client using the OPCDA function. You need the host name and
% the server ID for the OPC Server associated with this client.
da = opcda('localhost', 'Matrikon.OPC.Simulation.1');
connect(da);

%% Adding groups to the client
% To add groups to the client you use the ADDGROUP function. The
% following code automatically assigns a name to the group.
grp1 = addgroup(da);

%%
% To assign your own name (which must be unique for all the groups in a
% client) you pass the name as an additional argument.
grp2 = addgroup(da, 'MyGroup');

%% 
% To view a summary of the group object, type the object name.
grp1

%% Adding item objects to the group
% Item objects are added to a group using the ADDITEM function. You specify
% the group object to add the item to, and the Item ID of the server item
% you want to monitor.
itm1 = additem(grp1, 'Random.Real8');

%%
% To specify a data type for the item (for storage of the value in MATLAB)
% you specify the data type as a string.
itm2 = additem(grp1, 'Random.UInt2', 'double');

%% 
% To view a summary of the object, type the name of the object.
itm1

%% Creating object vectors
% You can use object vectors to store references to multiple OPC Toolbox
% objects. The following example constructs an object vector from the items
% added to the group. A summary of the object vector shows information
% about each objects in the vector.
itmVec = [itm1, itm2]

%% Viewing object properties: Using GET
% To view a list of all properties supported by the object, use the GET
% function with no output arguments.
get(da)

%%
% To obtain a specific property, pass that property name to the GET function.
clientName = get(da,'Name')

%% 
% You can get information about a property using the PROPINFO function.
% Information includes whether the property is read only, and valid
% property values for properties that have a predefined set of values.
statusInfo = propinfo(da, 'Status')

%%
% To set the value of a property, use the SET function.
set(da, 'Timeout', 30)

%% Clean up
% When you are finished using OPC Toolbox objects, you should delete them
% from the OPC Toolbox engine. Deleting the client object deletes the group
% and item objects associated with that client.
disconnect(da)
delete(da)
clear da grp1 grp2 itm1 itm2 itmVec