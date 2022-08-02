%% OPCDEMO_CUSTOMCALLBACK
% This example demonstrates how to use a custom callback for the OPC
% Toolbox. The example makes use of the 
% <matlab:open('display_opcdata.m') display_opcdata> 
% function, which plots recently acquired data in a figure window.

% Copyright 2004 The MathWorks, Inc.

%%
% To run this example on your system, you must have the
% Matrikon Simulation Server installed. Alternatively, you can replace the
% values used in the creation of the objects with values for a server you
% can access.

%% Step 1: Create the OPC Toolbox object hierarchy
% This example creates a hierarchy of OPC Toolbox objects for the Matrikon
% Simulation Server. 
da = opcda('localhost','Matrikon.OPC.Simulation.1');
connect(da);
grp = addgroup(da,'CallbackTest');
itm1 = additem(grp,'Triangle Waves.Real8');
itm2 = additem(grp,'Saw-toothed Waves.UInt2');

%% Step 2: Configure property values
% This example sets the UpdateRate value to 0.2 seconds, and the
% RecordsToAcquire property to 200. The example also specifies as the value
% of the RecordsAcquiredFcn callback the event callback function
% display_opcdata. The object will execute the RecordsAcquiredFcn every 5
% records, as specified by the value of the RecordsAcquiredFcnCount
% property.
set(grp,'UpdateRate',0.5);
set(grp,'RecordsToAcquire',200);
set(grp,'RecordsAcquiredFcnCount',5);
set(grp,'RecordsAcquiredFcn',@display_opcdata);

%% Step 3: Acquire data
% Start the group object. Every time 5 records are acquired, the object
% executes the display_opcdata callback function. This callback function
% displays the most recently acquired records logged to the memory buffer. 
start(grp)
wait(grp)

%% Step 4: Clean up
% Always remove OPC Toolbox objects from memory, and the variables that
% reference them, when you no longer need them. Deleting the client object
% deletes the group and item objects also.
delete(da)
clear da grp itm1 itm2