%% OPCDEMO_LOGGING
% This example demonstrates how to configure and execute a logging session,
% and how to retrieve data from that logging session.

% Copyright 2004 The MathWorks, Inc.

%% Step 1: Create the OPC Toolbox object hierarchy
% This example creates a hierarchy of OPC Toolbox objects for the Matrikon
% Simulation Server. To run this example on your system, you must have the
% Matrikon Simulation Server installed. Alternatively, you can replace the
% values used in the creation of the objects with values for a server you
% can access.
da = opcda('localhost','Matrikon.OPC.Simulation.1');
connect(da);
grp = addgroup(da,'CallbackTest');
itm1 = additem(grp,'Random.Real8');
itm2 = additem(grp,'Random.UInt2');
itm3 = additem(grp,'Random.Real4');

%% Step 2: Configure the logging duration
% This example sets the UpdateRate value to 0.2 seconds, and the
% RecordsToAcquire property to 40. 
set(grp,'UpdateRate',0.2);
set(grp,'RecordsToAcquire',40);

%% Step 3: Configure the logging destination
% In this example, data is logged to disk and memory. The disk file name is
% LoggingExample.olf. If the file name exists, the Toolbox engine must
% overwrite the file.
set(grp,'LoggingMode', 'disk&memory');
set(grp,'LogFileName', 'LoggingExample.olf');
set(grp,'LogToDiskMode','overwrite');

%% Step 4: Start the logging task
% Start the group object. Wait two seconds and show the last acquired value.
% Then wait for the logging task to complete.
start(grp)
pause(2)
sPeek = peekdata(grp, 1)
%%
% Display the item ID and values
disp({sPeek.Items.ItemID;sPeek.Items.Value});
%%
% Wait for the object to complete logging before continuing with the
% example.
wait(grp, inf)

%% Step 5: Retrieve the data
% You can retrieve data in structure format, or into seperate arrays.
% This example retrieves the first 20 records into a structure array.
sFirst = getdata(grp, 20);
%%
% The GETDATA function removes the records from the OPC Toolbox engine. You
% can exmine the available records using the RecordsAvailable property of
% the group
recAvail = grp.RecordsAvailable

%%
% This example retrieves the balance of the records into separate arrays.
% All values are converted to double-precision floating point numbers.
[exItmId, exVal, exQual, exTStamp, exEvtTime] = getdata(grp, recAvail, 'double');

%%
% Examine the contents of the workspace
whos ex*

%% 
% You can retrieving data from disk for a specific item, using the 'itemids'
% filter.
sReal8Disk = opcread('LoggingExample.olf', 'itemids', 'Random.Real8')

%%
% Examine the first record.
sReal8Disk(1).Items

%% Step 6: Clean up
% Always remove OPC Toolbox objects from memory, and the variables that
% reference them, when you no longer need them. Deleting the client object
% deletes the group and item objects also.
disconnect(da)
delete(da)
clear da grp itm1 itm2 itm3