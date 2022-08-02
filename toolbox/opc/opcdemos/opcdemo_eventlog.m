%% OPCDEMO_EVENTLOG
% This example demonstrates the use of the event log. A logging task is
% started, and the event log is examined to determine the start and stop
% times for the logging task.

% Copyright 2004 The MathWorks, Inc.

%% Step 1: Create the OPC Toolbox hierarchy
% This example creates a hierarchy of OPC Toolbox objects for the Matrikon
% Simulation Server. To run this example on your system, you must have the
% Matrikon Simulation Server installed. Alternatively, you can replace the
% values used in the creation of the objects with values for a server you
% can access.
da = opcda('localhost','Matrikon.OPC.Simulation.1');
connect(da);
grp = addgroup(da,'CallbackTest');
itm1 = additem(grp,'Triangle Waves.Real8');

%% Step 2: Start the logging task
% Start the group object. By default, the object acquires 120 records at
% 0.5 second intervals, and then stops. 
start(grp)

%%
% Wait for the object to stop logging data.
wait(grp)

%% Step 3: View the event log
% Access the EventLog property of the client object. The execution of the
% group logging task generated two events: start, and stop. Thus the value
% of the EventLog property is a 1–by–2 array of event structures.
events = da.EventLog

%%
% To list the events that are recorded in the EventLog property, examine
% the contents of the Type field.
{events.Type}

%%
% To get information about a particular event, access the Data field in
% that event structure. The example retrieves information about the stop
% event. 
stopdata = events(2).Data

%% Step 4: Clean up
% Always remove OPC Toolbox objects from memory, and the variables that
% reference them, when you no longer need them. Deleting the client object
% deletes the group and item objects also.
disconnect(da)
delete(da)
clear da grp itm1