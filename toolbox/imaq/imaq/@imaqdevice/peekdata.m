function data = peekdata(obj,frames)
%PEEKDATA Return most recent acquired image data.
% 
%    DATA = PEEKDATA(OBJ,FRAMES) returns DATA containing the latest number of
%    frames specified by FRAMES. If FRAMES is greater than the number of
%    frames currently acquired, all available frames will be returned
%    with a warning message stating that the requested number of frames
%    were not available. OBJ must be a 1-by-1 video input object.
% 
%    DATA is returned as a H-by-W-by-B-by-F matrix, where 
%        
%         H   Image height, as specified in the ROIPosition property
%         W   Image width, as specified in the ROIPosition property
%         B   Number of color bands, as specified in the NumberOfBands property
%         F   Number of frames
%
%    DATA is returned to the MATLAB workspace in its native data type using the 
%    color space specified by the ReturnedColorSpace property.
%
%    You can use the MATLAB IMAGE or IMAGESC function to view the returned 
%    data. Use IMAQMONTAGE to view multiple frames at once.
%    
%    PEEKDATA is a non-blocking function that immediately returns image
%    frames and execution control to the MATLAB workspace. Not all
%    requested data may be returned.
% 
%    OBJ's FramesAvailable property value will not be affected by the
%    number of frames returned by PEEKDATA. This means that PEEKDATA
%    only looks at the data, it does not remove the data from the image
%    acquisition engine.
% 
%    While OBJ's Running property is set to on, and it's Logging property
%    is set to off, PEEKDATA will be limited to one image frame.
%
%    The number of frames available to PEEKDATA will be determined by 
%    recalling the last frame returned by a previous PEEKDATA call, and 
%    the number of frames that were acquired since then.
%    
%    Example:
%       % Construct a video input object associated 
%       % with a Matrox device at ID 1:
%       obj = videoinput('matrox', 1);
%
%       % Initiate an acquisition and access some
%       % data without removing them from memory:
%       start(obj);
%       data = peekdata(obj, 5);
%
%       % Display each image frame:
%       imaqmontage(data);
%
%       % Remove the video input object from memory:
%       delete(obj);
%
%    See also IMAQHELP, IMAQMONTAGE, IMAQDEVICE/GETDATA, IMAQDEVICE/START, 
%             IMAQDEVICE/PROPINFO, IMAQDEVICE/GETSNAPSHOT.

%    RDD 8-01-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:28 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:peekdata:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif (length(obj) > 1)
    errID = 'imaq:peekdata:OBJ1x1';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~isvalid(obj)
    errID = 'imaq:peekdata:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif (nargin==1) || ~isnumeric(frames) || (length(frames)~=1)
    errID = 'imaq:peekdata:invalidFrames';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Get data.
try
    data = peekdata(imaqgate('privateGetField', obj, 'uddobject'),frames);
catch
    rethrow(lasterror);
end