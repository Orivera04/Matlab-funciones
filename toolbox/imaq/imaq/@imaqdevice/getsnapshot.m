function snapshot = getsnapshot(obj)
%GETSNAPSHOT Immediately return a single image snapshot.
% 
%    FRAME = GETSNAPSHOT(OBJ) immediately returns one single image frame, 
%    FRAME, from the video input object, OBJ. The frame of data 
%    returned is independent of the FramesPerTrigger property, and has no 
%    effect on the FramesAvailable or FramesAcquired property.
% 
%    OBJ must be a 1x1 video input object.
% 
%    FRAME is returned as a H-by-W-by-B matrix, where 
%        
%         H   Image height, as specified in the ROIPosition property
%         W   Image width, as specified in the ROIPosition property
%         B   Number of color bands, as specified in the NumberOfBands property
%
%    FRAME is returned to the MATLAB workspace in its native data type using the 
%    color space specified by the ReturnedColorSpace property.
%
%    You can use the MATLAB IMAGE or IMAGESC function to view the returned 
%    data.
% 
%    If OBJ is Running but not Logging, and has been configured with
%    a hardware trigger, a timeout error will occur.
%    
%    It is possible to issue a ^C (Control-C) while GETSNAPSHOT is
%    blocking. This will return control to MATLAB.
%
%    Example:
%       % Construct a video input object associated 
%       % with a Matrox device at ID 1:
%       obj = videoinput('matrox', 1);
%
%       % Acquire and display a single image frame:
%       frame = getsnapshot(obj);
%       image(frame);
%
%       % Remove the video input object from memory:
%       delete(obj);
%
%    See also IMAQHELP, IMAQDEVICE/PEEKDATA, IMAQDEVICE/GETDATA.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:16 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:getsnapshot:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif (length(obj) > 1)
    errID = 'imaq:getsnapshot:OBJ1x1';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~isvalid(obj)
    errID = 'imaq:getsnapshot:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Get single frame.
try
    snapshot = getsnapshot(imaqgate('privateGetField', obj, 'uddobject'));
catch
    rethrow(lasterror);
end