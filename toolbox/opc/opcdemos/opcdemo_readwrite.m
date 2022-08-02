%% OPCDEMO_READWRITE
% This example demonstrates how to use the OPC Toolbox synchronous read and
% write operations to exchange data with an OPC Server.

% Copyright 2004 The MathWorks, Inc.

%% Connect to server and create objects
da = opcda('localhost', 'Matrikon.OPC.Simulation.1');
connect(da);
grp = addgroup(da);
itm1 = additem(grp, 'Random.Real8');

%% Synchronous read operations
% The default read operation gets values from the server cache.
r = read(itm1)
%%
% To read from the device (which may take long) specify the source of the
% read as 'device'.
r = read(itm1, 'device')

%% Synchronous write operations
% Add a writable item to the group.
itm2 = additem(grp, 'Bucket Brigade.Real8')

%%
% Write the value 10.
write(itm2, 10)

%%
% Read the value back into MATLAB.
r = read(itm2)

%% Reading from multiple items
% You can read data from multiple items using the group object.
r = read(grp)

%%
% Each element of the returned structure array contains information about
% each item. Extract the item information using indexing.
r(1)

%%
% To obtain the values, use concatenation of MATLAB list creation operations.
itmIDs = {r.ItemID}
vals = [r.Value]

%% Writing to multiple items
% You can also write to multiple items. However, you must pass the values
% for the items in the group as a cell array. This particular example will
% return a warning, since the first item will not allow you to write data
% to the item. However, the second item will have the value 5.432 written.
write(grp, {1.234, 5.432})

%%
% Read the value of the written item.
r = read(itm2)

%% Clean up
% Once you have finished with the OPC Toolbox objects, you must delete
% them from the OPC Toolbox engine. Deleting the client object
% automatically deletes the group and item objects.
disconnect(da)
delete(da)
clear da grp itm1 itm2