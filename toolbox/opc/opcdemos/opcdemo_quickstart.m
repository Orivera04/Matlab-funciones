%% OPCDEMO_QUICKSTART.M
% This example illustrates the basic steps involved in using the OPC
% Toolbox to acquire data from an OPC Server. This example utilises the
% Matrikon OPC Simulation Server to log data from the Saw-toothed and
% Triangle Waves signals. The data is then retrieved and plotted to
% determine if the two signals are related in any way.

% Copyright 2004 The MathWorks, Inc.

%% Step 1: Locate the OPC Server
% In order to connect to an OPC Server, you need the HOSTNAME and SERVERID
% of that server. Your system administrator can provide you with this
% information, or you can query a host for the data. In this example, you
% query the local host for available OPC Servers.
hostInfo = opcserverinfo('localhost')

%%
% Examine the returned structure in more detail.
allServers = hostInfo.ServerID'

%%
% To connect to the Matrikon server, use the ID 'Matrikon.OPC.Simulation.1'

%% Step 2: Create an OPC Data Access Client Object
% Once you know the Host and ServerID of the OPC Server you want to connect
% to, you can create an opcda object associated with that server.
da = opcda('localhost', 'Matrikon.OPC.Simulation.1')

%%
% At this point, the client is not yet connected to the server.

%% Step 3: Connect to the Server
connect(da)

%%
% To confirm that the client is connected, display the client.
da

%% Step 4: Browse the Server Name Space
% To find the Fully Qualified ID of the items you wish to examine, you need
% to browse the server's name space. You can use a partial match to find all
% items containing the string 'Saw' and 'Triangle'

sawtoothItems = serveritems(da, '*Saw*')
triangleItems = serveritems(da, '*Triangle*')

%%
% This example uses use the Real8 items from the Saw-Toothed Waves and the
% Real8 and UInt2 items from the Triangle Waves. Make a cell array of item
% names.
itmIDs = {'Saw-toothed Waves.Real8', ...
    'Triangle Waves.Real8', ...
    'Triangle Waves.UInt2'};

%% Step 5: Create OPC Data Access Group Objects
% OPC Group objects contain many items that can be updated, logged, written
% to, and interacted with using a single object. In this example, a group
% is created in order to log data from all items simultaneously.
grp = addgroup(da, 'DemoGroup')

%% Step 6: Add Items to Groups
% Once the group object has been created, you can now add items to that
% group. The next example adds the three items identified in Step 4, using
% one command. The result is a vector of daitem objects.
itm = additem(grp, itmIDs)

%%
% View a summary of the first object in the object vector.
itm(1)

%% Step 7: Configure OPC Toolbox Object Properties
% You configure OPC Toolbox object properties using the SET command, and
% retrieve properties using the GET command. For this example, 2 minutes of
% data will be logged at 0.2 second intervals.
logDuration = 2*60;
logRate = 0.2;
numRecords = ceil(logDuration./logRate)

%%
% You can now configure the group object to acquire this amount of data.
set(grp, 'UpdateRate',logRate, 'RecordsToAcquire',numRecords);

%% Step 8: Acquire OPC Server Data
% To acquire the data, you issue a START function. Because you want all the
% data to be acquired before this example continues processing, call the
% WAIT function.
start(grp)
wait(grp)

%%
% Now that the data has been logged to memory, you need to retrieve it from
% the OPC Toolbox engine. Because this example uses the time series data,
% obtain the logged data into separate arrays.
[logIDs, logVal, logQual, logTime, logEvtTime] = getdata(grp, 'double');

%%
% Examine the workspace for the sizes of the data
whos log*

%% Step 9: Plot the Data
% You can now plot this data all on one axes. The DATETICK function
% converts the X-axis ticks into formatted date strings.
plot(logTime, logVal);
axis tight
datetick('x', 'keeplimits')
legend(logIDs)

%%
% The Value data does not provide the full picture. You should always
% examine the Quality of the data to determine the validity of the Value
% array. This example annotates the plot with markers where the quality is
% not Good. Bad quality is marked in red, and Repeat quality is marked in
% orange. 
hold on
isBadQual = strncmp(logQual, 'Bad', 3);
isRepeatQual = strncmp(logQual, 'Repeat', 6);
for k=1:size(logQual,2)
    badInd = isBadQual(:,k);
    plot(logTime(badInd, k), logVal(badInd, k), 'ro', ...
        'MarkerFaceColor','r', 'MarkerEdgeColor','k')
    repInd = isRepeatQual(:,k);
    plot(logTime(repInd, k), logVal(repInd, k), 'ro', ...
        'MarkerFaceColor',[0.8 0.5 0], 'MarkerEdgeColor','k')
end
hold off

%% Step 10: Clean up
% Once you have finished with the OPC Toolbox objects, you must delete
% them from the OPC Toolbox engine. Deleting the client object
% automatically deletes the group and item objects.
disconnect(da)
delete(da)

%%
% The objects are now invalid.
isvalid(grp)

%%
% You should clear the objects from the workspace.
clear da grp itm
