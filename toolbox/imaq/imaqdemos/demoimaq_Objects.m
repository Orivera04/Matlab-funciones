%% Managing Image Acquisition Objects
%
% Copyright 2001-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/03/24 20:39:29 $

%% Finding Image Acquisition Objects in Memory
% To find image acquisition objects in memory, use the IMAQFIND function.
% IMAQFIND returns an array of video input objects.

%%
objects = imaqfind
%%

% Create video input objects.
vidobj1 = videoinput('matrox', 1, 'M_CCIR');
vidobj2 = videoinput('matrox', 1, 'M_PAL_RGB');
vidobj3 = videoinput('matrox', 1, 'M_NTSC_RGB');

% Find all valid objects.
objects = imaqfind

%% Removing Objects From Memory
% To delete a video input object from memory, use the DELETE function with
% the object.

% Delete the first object in the array.
delete(objects(1))

%%
% Find all remaining valid objects.
objects = imaqfind

%%
% Using the DELETE function with the object will remove the object from
% memory but not from the MATLAB workspace. To remove an object from the
% MATLAB workspace use the CLEAR function. To see what objects are in the
% MATLAB workspace, use the WHOS function.

% Display the current workspace.
whos

%%
% Since an object was deleted, it is no longer valid.
vidobj1

%%
% Clear the associated variable.
clear vidobj1

%%
% Display the current workspace.
whos

%% 
% To remove all image acquisition objects from memory and to reset the
% toolbox to its initial state, use the IMAQRESET function.
%
% Note: Using the IMAQRESET function will only delete objects from
% memory, not clear them from the MATLAB workspace.
imaqreset
%%
% Verify no objects remain.
objects = imaqfind
%%
% Variables associated with deleted objects still remain.
whos
%%
% Clear any remaining variables associated with deleted objects.
clear vidobj2 vidobj3
%%
% See also IMAQFIND, IMAQDEVICE/DELETE, IMAQ/PRIVATE/CLEAR,
% IMAQDEVICE/ISVALID.