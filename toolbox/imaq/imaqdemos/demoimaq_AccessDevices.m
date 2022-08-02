%% Accessing Devices and Video Sources
%
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:39:16 $

%% Accessing an Image Acquisition Device
% A video input object represents the connection between MATLAB and an image 
% acquisition device. To create a video input object, use the VIDEOINPUT
% function and indicate what device the object is to be associated with.

% Access an image acquisition device.
vidobj = videoinput('dt', 1, 'RS170')

%% Identifying a Device's Video Source Object
% A video source object represents a collection of one or more physical data 
% sources that are treated as a single entity. For example, one video source
% object could represent the three physical connections of an RGB source 
% (red, green, and blue). 

%%
% The Source property of a video input object provides an array of the 
% device's available video source objects.

% Access the device's video sources that can be used for acquisition.
sources = vidobj.Source
%%
whos sources

%% Selecting a Video Source Object for Acquisition
% A video source object can be selected for acquisition by specifying its
% name.
set(vidobj, 'SelectedSourceName', 'VID2')
%%

% Notice that the corresponding video source has been selected.
sources
%%
% To obtain the video source object that is currently selected, use the
% GETSELECTEDSOURCE function.
selectedsrc = getselectedsource(vidobj)


%% Accessing a Video Source Object's Properties
% Each video source object provides a list of general and device specific
% properties.

% List the video source object's properties and their current values.
get(selectedsrc)

%%
% Note: Each video source object maintains its own property configuration.
% Modifying the selected video source is equivalent to selecting a new
% video source configuration.

%%

% Once the video input object is no longer needed, delete
% it and clear it from the workspace.
delete(vidobj)
clear vidobj

%%
% See also IMAQHWINFO, VIDEOINPUT, IMAQDEVICE/GETSELECTEDSOURCE, IMAQHELP,
% IMAQDEVICE/GET, IMAQDEVICE/PROPINFO.