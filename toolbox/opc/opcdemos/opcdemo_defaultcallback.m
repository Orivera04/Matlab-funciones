%% OPCDEMO_DEFAULTCALLBACK
% This example demonstrates the use of callbacks during a logging task.

% Copyright 2004 The MathWorks, Inc.

%% Step 1: Configure OPC Toolbox Objects
% Start by creating objects for the Matrikon Simulation Server.
da = opcda('localhost', 'Matrikon.OPC.Simulation.1');
connect(da);
grp = addgroup(da, 'CallbackTest');
itm = additem(grp, {'Random.Real8', 'Saw-toothed Waves.UInt2'});

%% Step 2: Configure the Logging Task Properies
grp.RecordsToAcquire = 20;
grp.UpdateRate = 0.5;

%% Step 3: Configure the Callbacks
% This example uses the default callback, 
% <matlab:open('opccallback') opccallback> 
% to display how the start, records acquired and stop events are processed
% by MATLAB during a logging task.
grp.StartFcn = @opccallback;
grp.StopFcn = @opccallback;
grp.RecordsAcquiredFcn = @opccallback;
grp.RecordsAcquiredFcnCount = 5;

%% Step 4: Start the Logging Task
% When you start the logging task, the Start event will be generated.
% During the task, the RecordsAcquired event will be generated each time 5
% records have been logged. Finally, the Stop event will be generated when
% the logging task completes.
start(grp)
%%
% The WAIT function does not block the MATLAB command-line, so the events
% can be processed.
wait(grp)

%% Step 5: Clean Up
% Always remove OPC Toolbox objects from memory, and the variables that
% reference them, when you no longer need them.
disconnect(da)
delete(da)
clear da grp itm