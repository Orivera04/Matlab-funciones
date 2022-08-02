%% Working With Properties
%
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:39:31 $

%% Accessing Properties
% To access a complete list of an object's properties and their current
% values, use the GET function with the object.

% Create a video input object.
vidobj = videoinput('winvideo', 1);
%%

% List the video input object's properties and their current values.
get(vidobj)

%%

% Access the currently selected video source object
src = getselectedsource(vidobj);

%%

% List the video source object's properties and their current values.
get(src)

%%
% To access a specific property value, use the GET function with the object
% and property name.

framesPerTriggerValue = get(vidobj, 'FramesPerTrigger')
%%
brightnessValue = get(src, 'Brightness')

%%
% Alternatively, we can access a specific property value by using the
% dot (.) notation.

framesPerTriggerValue = vidobj.FramesPerTrigger
%%
brightnessValue = src.Brightness

%% Configuring Properties
% Enumerated properties have a defined set of possible values. To list the
% enumerated values of a property, use the SET function with the object and
% property name.  The property's default value is listed in braces.
set(vidobj, 'LoggingMode')

%%
% To access a complete list of an object's configurable properties, use the
% SET function with the object.

% List the video input object's configurable properties.
set(vidobj)

%%

% List the video source object's configurable properties.
set(src)

%%
% To configure an object's property value, use the SET function with the
% object, property name, and property value.

set(vidobj, 'TriggerRepeat', 2)
%%
set(src, 'Contrast', 100)

%%
% Alternatively, we can configure a specific property value by using the
% dot (.) notation.

vidobj.TriggerRepeat = 2;
%%
src.Contrast = 100;

%% Getting Property Help and Other Information
% To obtain a property's description, use the IMAQHELP function with the
% object and property name. IMAQHELP can also be used for function help.
imaqhelp(vidobj, 'LoggingMode')

%%
% To obtain information on a property's attributes, use the PROPINFO function with the object
% and property name.
propinfo(vidobj, 'LoggingMode')

%%
% When an image acquisition object is no longer needed, remove it from memory and clear the MATLAB 
% workspace of the associated variable.
delete(vidobj);
clear vidobj

%%
% See also IMAQDEVICE/GET, IMAQDEVICE/SET, IMAQDEVICE/PROPINFO, IMAQHELP.