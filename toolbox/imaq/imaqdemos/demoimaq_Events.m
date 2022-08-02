%% Viewing Events
%
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:39:24 $

%%
% Events occur during an acquisition at a particular time when a condition is met.
% These events include:
%
% * Error
% * FramesAcquired
% * Start
% * Stop
% * Timer
% * Trigger
%
% All acquisitions consist of at least 3 events:
%
% * Starting the device
% * Triggering the device
% * Stopping the device.

% Access an image acquisition device.
vidobj = videoinput('winvideo', 1);

%%

% Acquire data continuously.
vidobj.FramesPerTrigger = Inf;

%%

% Use a manual trigger to initiate data logging.
triggerconfig(vidobj, 'manual');

%%

% Start the acquisition.
start(vidobj)

%%

% Trigger the object to start logging.
trigger(vidobj)

%%

% Stop the acquisition
stop(vidobj)

%%
% To view event information for the acquisition, access the EventLog 
% property of the video input object. Events are recorded in chronological order.

% View the event log.
events = vidobj.EventLog

%%
% Each event provides information on the state of the object at the
% time the event ocurred.

% Display first event.
event1 = events(1)

%%

data1 = events(1).Data

%%

% Display second event.
event2 = events(2)

%%

data2 = events(2).Data

%%

% Display third event.
event3 = events(3)

%%

data3 = events(3).Data

%%

% Once the video input object is no longer needed, delete
% it and clear it from the workspace.
delete(vidobj)
clear vidobj

%%
% See also IMAQHELP, IMAQDEVICE/PROPINFO.
