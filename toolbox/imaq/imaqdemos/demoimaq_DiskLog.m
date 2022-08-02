%% Logging Data To Disk
%
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:39:23 $

%% Configuring Logging Mode
% Data acquired from an image acquisition device may be logged to memory,
% to disk, or both. By default, data is logged to memory. To change the
% logging mode, configure the video input object's LoggingMode property.

% Access an image acquisition device, using a grayscale video format.
vidobj = videoinput('winvideo', 1, 'Y800_640x480');

%%

% View the default logging mode.
currentLoggingMode = get(vidobj, 'LoggingMode')

%%

% List all possible logging modes.
set(vidobj, 'LoggingMode')

%%

% Configure the logging mode to disk.
set(vidobj, 'LoggingMode', 'disk')

%%

% Verify the configuration.
currentLoggingMode = get(vidobj, 'LoggingMode')

%% Configuring Disk Logging Properties
% In order to log to disk, a MATLAB AVIFILE object is required.
% AVIFILE is a MATLAB function, not a toolbox function. Once an 
% AVIFILE object is created and configured, it is provided 
% to the video input object's DiskLogger property.

%%
% Note: Any configurations to the AVI file object must be done before
% configuring the DiskLogger property. Configurations made to the AVI 
% file object afterwards will require the DiskLogger property to be
% re-configured.

% Create an AVI file object.
logfile = avifile('logfile.avi')

%%

% Select a codec for the AVI file.
logfile.Compression = 'MSVC';

% Since grayscale images will be acquired, a colormap is required.
logfile.Colormap = gray(256);

%%

% Configure the video input object to use the AVI file object.
vidobj.DiskLogger = logfile;

%%

% Start the acquisition.
start(vidobj)

%%

% Wait for the acquisition to finish.
wait(vidobj, 5)

%%

%%
% Note: When logging large amounts of data to disk, disk
% writing may lag behind the acquisition. To ensure that
% no additional writes are still in progress after the
% acquisition has completed, use the DiskLoggerFrameCount 
% property to determine if all frames have been writtern 
% to disk.

% Determine the number of frames acquired.
vidobj.FramesAcquired

%%

% Ensure that all aquired frames were written to disk.
vidobj.DiskLoggerFrameCount

%%

% Once all frames have been written, close the file.
aviobj = vidobj.Disklogger;
file = close(aviobj)

%%

% Once the video input object is no longer needed, delete
% it and clear it from the workspace.
delete(vidobj)
clear vidobj

%%
% See also AVIFILE, AVIFILE/CLOSE, IMAQDEVICE/PROPINFO.
