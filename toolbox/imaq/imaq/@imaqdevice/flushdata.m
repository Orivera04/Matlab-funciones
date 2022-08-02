function flushdata(obj, varargin)
%FLUSHDATA Remove buffered image frames from memory.
% 
%    FLUSHDATA(OBJ) removes all buffered image frames from 
%    memory. OBJ can be a single video input object or an 
%    array of video input objects.
% 
%    FLUSHDATA(OBJ,MODE) removes all buffered image frames from 
%    memory where MODE can be either of the following values:
%
%    'all'       Removes all data from the object and sets the
%                FramesAvailable property to 0 for the video  
%                input object, OBJ. This is the default mode 
%                when none is specified, FLUSHDATA(OBJ).
%
%    'triggers'  Removes all the data acquired during one 
%                trigger. TriggerRepeat must be greater than  
%                0 and FramesPerTrigger must not be set to Inf.
% 
%    See also IMAQHELP, IMAQDEVICE/GETDATA, IMAQDEVICE/PEEKDATA, 
%             IMAQDEVICE/PROPINFO.

%    RDD 8-02-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:12 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:flushdata:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~all(isvalid(obj)),
    % There are invalid objects.
    % Find all invalid indexes.
    inval_OBJ_indexes = find(isvalid(obj) == false);

    % Generate an error message specifying the index for the first invalid
    % object found.
    errID = 'imaq:flushdata:invalidOBJ';
    errStr = sprintf('%s %s.',imaqgate('privateMsgLookup', errID), num2str(inval_OBJ_indexes(1)));
    error(errID, errStr);
elseif nargin>1 && ~ischar(varargin{1}),
    errID = 'imaq:flushdata:invalidMode';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% flush data.
try
    flushdata(imaqgate('privateGetField', obj, 'uddobject'),varargin{:});
catch
    rethrow(lasterror);
end