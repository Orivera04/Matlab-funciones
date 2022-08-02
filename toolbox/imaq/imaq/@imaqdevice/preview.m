function preview(obj)
%PREVIEW Activate a live video preview window.
% 
%    PREVIEW(OBJ) immediately activates a live video preview window for 
%    video input object OBJ. The size of the previewed images reflects 
%    the ROIPosition property configuration. The preview window 
%    remains active until it is closed with CLOSEPREVIEW.
%
%    The behavior of the preview window depends on the object's current
%    state and trigger configuration.
%
%    While an object is stopped (Running=off), the preview window 
%    shows a live view of the image being acquired from the device, for 
%    all trigger types. The image is updated to reflect changes made to
%    configurations of object properties. (The FrameGrabInterval 
%    property is ignored until a trigger occurs.)
%
%    When an object is started (Running=on), the behavior of the preview
%    preview window depends on the trigger type. If the trigger type is
%    set to immediate or manual, the preview window continues to update
%    the image displayed. If the trigger type is set to hardware, the 
%    preview window stops updating the image displayed until a trigger 
%    occurs.
%
%    While an object is logging (Logging=on), the preview window may 
%    drop some data frames, but this will not affect the frames logged
%    to memory or disk.
% 
%    Upon deleting OBJ with DELETE, any associated preview windows will be 
%    closed.
% 
%    See also IMAQHELP, IMAQDEVICE/CLOSEPREVIEW, IMAQDEVICE/GETSNAPSHOT, 
%             IMAQDEVICE/START, IMAQDEVICE/TRIGGER, IMAQDEVICE/DELETE.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:29 $

% Error checking.
if ~isa(obj, 'imaqdevice'),
    errID = 'imaq:preview:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~all(isvalid(obj)),
    errID = 'imaq:preview:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Open preview window.
try
    preview(imaqgate('privateGetField', obj, 'uddobject'));
catch
    rethrow(lasterror);
end