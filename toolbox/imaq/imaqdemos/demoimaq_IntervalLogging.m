%% Logging Data at Constant Intervals
% In certain applications, it may not be necessary to log every frame
% provided by an image acquisition device. In fact, it may be more
% practical and resoureful to log frames at certain intervals. 
%
% To log frames at a constant interval, configure the video input object's
% FrameGrabInterval property. Configuring the property to an integer value
% N specifies that every Nth frame should be logged, starting with the first
% frame.
%
% Note, specifying a FrameGrabInterval value does not modify the rate at 
% which a device is providing frames (device frame rate). It only specifies the 
% interval at which frames are logged.
%
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:39:27 $

%% Step 1: Access and Configure a Device.
% Create a video input object and configure the desired logging interval. The 
% logging interval is determined by the value of the FrameGrabInterval property.

% Access an image acquisition device.
vidobj = videoinput('winvideo', 1);
%%

% Configure the number of frames to log.
framesToLog = 9;
set(vidobj, 'FramesPerTrigger', framesToLog);

%%

% Configure the logging interval. This specifies that
% every 10th frame provided by the device is to be logged.
grabInterval = 10;
set(vidobj, 'FrameGrabInterval', grabInterval);

%%

% Access the device's video source and configure the device's frame rate. 
% FrameRate is a device specific property, therefore, it may not be supported by
% some devices.
frameRate = 30;
src = getselectedsource(vidobj);
set(src, 'FrameRate', num2str(frameRate));

%% Step 2: Log and Retrieve Data.
% Initiate the acquisition of images and retrieve the logged frames and
% their timestamps.

% Start the acquisition.
start(vidobj)

%%

% Wait for the acquisition to end.
wait(vidobj, 10)

%% 

% Retrieve the data.
[frames, timeStamp] = getdata(vidobj);

%% Step 3: Calculate the Time Difference Between Frames.
% Knowing the device's actual frame rate and the grab interval at 
% which frames were logged, the number of frames logged per second 
% can be calculated.

% Number of frames logged per second.
loggedPerSec = frameRate/grabInterval

%%
% Knowing the number of frames logged per second, the expected time 
% interval between each logged frame can be calculated and compared.

% Expected number of seconds between each logged frame.
loggingRate = 1/loggedPerSec

%%

% Actual time difference between each logged frame.
% Note that frames were logged at a constant interval.
diff(timeStamp')

%%

% Determine the average time difference between frames.
avgDiff = mean(diff(timeStamp'))

%%

percentError = ( abs(loggingRate-avgDiff) ) * 100

%%

% Once the video input object is no longer needed, delete
% it and clear it from the workspace.
delete(vidobj)
clear vidobj
