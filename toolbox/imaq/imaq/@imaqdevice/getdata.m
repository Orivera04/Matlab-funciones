function [frames,times,meta] = getdata(obj, varargin)
%GETDATA Return acquired image frames to MATLAB workspace.
% 
%    DATA = GETDATA(OBJ) returns DATA containing the number of frames 
%    specified in the FramesPerTrigger property of video input object OBJ.
%    OBJ must be a 1-by-1 video input object.
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
%    DATA = GETDATA(OBJ, N) returns N frames of data associated
%    with video input object OBJ.
%
%    DATA = GETDATA(OBJ, N, TYPE) returns N frames of data associated
%    with video input object OBJ, where TYPE specifies the data type
%    used to store the returned data. TYPE can be any of these strings:
%
%        'uint8'  - unsigned 8-bit integer
%        'uint16' - unsigned 16-bit integer
%        'uint32' - unsigned 32-bit integer
%        'double' - double precision
%        'native' - data returned in it's native data type
%    
%    If TYPE is not specified, 'native' is used as the default. Note, if
%    there is no MATLAB data type that matches OBJ's native data type,  
%    GETDATA chooses a MATLAB data type that preserves numerical accuracy,
%    as much as possible. For example, the components of 12-bit RGB color 
%    data would each be returned as uint8 data.
%
%    DATA = GETDATA(OBJ, N, TYPE, FORMAT) returns N frames of data
%    associated with video input object OBJ, where FORMAT 
%    specifies the MATLAB format of DATA. FORMAT can either be:
%
%        'numeric' - DATA is returned as a H-by-W-by-B-by-F matrix. This is
%                    the default format if none is specified.
%        'cell'    - DATA is returned as a Fx1 cell array of H-by-W-by-B 
%                    matrices.
%
%    [DATA, TIME] = GETDATA(...) returns TIME, an F-by-1 matrix, where F
%    is the number of frames returned in DATA. Each element of TIME indicates
%    the relative time, in seconds, of the corresponding frame in DATA, 
%    relative to the first trigger.
%    
%    [DATA, TIME, METADATA] = GETDATA(...) returns METADATA, an
%    F-by-1 array of structures, where F is the number of frames returned
%    in DATA. Each structure contains information about the corresponding
%    frame in DATA. The metadata structure contains these fields:
%
%       AbsTime             The absolute time the frame was acquired, 
%                           expressed as a time vector.
%       FrameNumber   		A number identifying the N'th frame since the 
%                           START command was issued
%       RelativeFrame		A number identifying the N'th frame relative to 
%                           the start of a trigger.
%       TriggerIndex        The number of the trigger in which this frame 
%                           was acquired.
%
%    GETDATA is a blocking function that returns execution control to the
%    MATLAB workspace after the requested number of frames become available
%    within the period specified by the object's Timeout property.
%    The object's FramesAvailable property is automatically reduced by the
%    number of frames returned by GETDATA. If the requested number of frames
%    is greater than the frames to be acquired, GETDATA returns an error.
%
%    TIME=0 is defined as the point at which data logging begins, i.e., OBJ's
%    Logging property is set to 'On'. TIME is measured continuously with
%    respect to 0 until the acquisition is stopped, i.e., OBJ's Running
%    property is set to 'Off'.
%    
%    It is possible to issue a ^C (Control-C) while GETDATA is blocking. This 
%    will not stop the acquisition but will return control to MATLAB.
%    
%    Example:
%       % Construct a video input object associated 
%       % with a Matrox device at ID 1:
%       obj = videoinput('matrox', 1);
%
%       % Initiate an acquisition and access the buffered data:
%       start(obj);
%       data = getdata(obj);
%
%       % Display each image frame acquired:
%       imaqmontage(data);
%
%       % Remove the video input object from memory:
%       delete(obj);
%
%    See also IMAQHELP, IMAQMONTAGE, IMAQDEVICE/PEEKDATA, 
%             IMAQDEVICE/PROPINFO, IMAQDEVICE/GETSNAPSHOT.

%    RDD 7-17-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:14 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:getdata:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif (length(obj) > 1)
    errID = 'imaq:getdata:OBJ1x1';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~isvalid(obj)
    errID = 'imaq:getdata:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Input argument error checking.
nin = nargin;
if nin>1 && ~isnumeric(varargin{1}),
    errID = 'imaq:getdata:invalidNInput';
    error(errID, imaqgate('privateMsgLookup',errID));    
end

if nin>2 && ~ischar(varargin{2}),
    errID = 'imaq:getdata:invalidTypeInput';
    error(errID, imaqgate('privateMsgLookup',errID));    
end

if nin>3 && ~ischar(varargin{3}),
    errID = 'imaq:getdata:invalidFormatInput';
    error(errID, imaqgate('privateMsgLookup',errID));    
end

if nin>4
    errID = 'imaq:getdata:tooManyInputs';
    error(errID, imaqgate('privateMsgLookup',errID));    
end

% Get data.
try
    if (nargout==0) || (nargout==1)
        frames = getdata(imaqgate('privateGetField', obj, 'uddobject'),varargin{:});
    elseif (nargout==2)
        [frames times] = getdata(imaqgate('privateGetField', obj, 'uddobject'),varargin{:});
    else
        [frames times meta] = getdata(imaqgate('privateGetField', obj, 'uddobject'),varargin{:});
    end
catch
    rethrow(lasterror);
end