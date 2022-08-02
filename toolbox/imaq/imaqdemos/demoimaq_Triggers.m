%% Working With Triggers
%
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:39:32 $

%% Configuring Trigger Properties
% To obtain a list of configurable trigger settings, use the TRIGGERINFO
% function with the video input object. TRIGGERINFO will return all
% possible trigger configurations supported by the image acquisition device
% associated with the video input object. Possible configurations consists
% of a valid trigger type, trigger condition, and trigger source
% combination.
%
% Note: All image acquisition devices support immediate and manual
% trigger types. A hardware trigger type is available only if it is
% supported by the image acquisition device.

% Access an image acquisition device.
vidobj = videoinput('matrox', 1);

%%

% Display all valid trigger configurations.
triggerinfo(vidobj)

%%
% To configure the trigger settings for an image acquisition device, use the
% TRIGGERCONFIG function with the desired trigger type, trigger condition, 
% and trigger source.

triggerconfig(vidobj, 'hardware', 'fallingEdge', 'optoTrigger')

%%

% View the current trigger configuration.
currentConfiguration = triggerconfig(vidobj)

%%
% Note: Configuring trigger settings requires a unique configuration to be
% specified. If specifying the trigger type uniquely identifies a
% configuration, no further arguments need to be provided to TRIGGERCONFIG.
% 
% Hardware triggers are the only trigger type that typically have multiple 
% valid configurations.

%% Immediate Triggering
% By default, a video input object's trigger type is configured for
% immediate triggering. Immediate triggering indicates that data logging 
% is to begin as soon as the START function is issued.  

% Configure the trigger type.
triggerconfig(vidobj, 'immediate')

%%

% Initiate the acquisition.
start(vidobj)

%%

% Wait for acquisition to end.
wait(vidobj, 2)

%%

% Determine the number frames acquired.
frameslogged = get(vidobj, 'FramesAcquired')


%% Manual Triggering
% Manual triggering requires that the TRIGGER function be issued
% before data logging is to begin.

% Configure the trigger type.
triggerconfig(vidobj, 'manual')

%%

% Initiate the acquisition.
start(vidobj)

%%

% Verify no frames have been logged.
frameslogged = get(vidobj, 'FramesAcquired')

%%

% Trigger the acquisition.
trigger(vidobj)

%%

% Wait for the acquisition to end.
wait(vidobj, 2);

%%

% Determine the number frames acquired.
frameslogged = get(vidobj, 'FramesAcquired')

%% Hardware Triggering
% Hardware triggering begins logging data as soon as a trigger condition
% has been met via the trigger source. 
%
% In this example, we have connected an opto-isolated trigger source from a
% function generator to our image acquisition device. The image acquisition
% device will begin logging data upon detecting a falling edge signal from
% the source.

% Configure the trigger settings.
triggerconfig(vidobj, 'hardware', 'fallingEdge', 'optoTrigger')

%%
% Initially, no signal is sent from the source to the image acquisition device.

% Initiate the acquisition.
start(vidobj)

%%

% Verify nothing has been acquired.
frameslogged = get(vidobj, 'FramesAcquired')

%%
% A square wave signal will now be sent from the trigger source to the image
% acquisition device.

% Wait for the acquisition to end.
wait(vidobj, 10)

%%

% Verify frames were acquired.
frameslogged = get(vidobj, 'FramesAcquired')

%%

% Once the video input object is no longer needed, delete
% it and clear it from the workspace.
delete(vidobj)
clear vidobj

%%
% See also IMAQDEVICE/TRIGGERCONFIG, IMAQDEVICE/TRIGGERINFO,
% IMAQDEVICE/TRIGGER, IMAQDEVICE/START, IMAQDEVICE/GET, IMAQHELP.