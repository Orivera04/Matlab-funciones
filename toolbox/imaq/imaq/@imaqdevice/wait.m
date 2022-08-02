function wait(objects, waittime, state)
%WAIT Wait for the video input object to stop running or logging.
%
%    WAIT(OBJ) blocks the MATLAB command line until the video input 
%    object OBJ stops running (Running = 'off'). OBJ can be either a 
%    single video input object or an array of video input objects. 
%    When OBJ is an array of objects, the WAIT function waits until
%    all objects in the array stop running. If OBJ is not 
%    running or is an invalid object, WAIT returns immediately.
%    
%    WAIT(OBJ, WAITTIME) blocks the MATLAB command line until the
%    video input object or array of objects OBJ stops running or 
%    until WAITTIME seconds have expired, whichever comes first. 
%    By default, WAITTIME is set to the value of the object's 
%    Timeout property. 
%
%    WAIT(OBJ, WAITTIME, STATE) blocks the MATLAB command line 
%    until the video input object or array of objects OBJ stops 
%    running or logging, or until WAITTIME seconds have expired, 
%    whichever comes first. STATE can be set to either of the 
%    following strings:
%    
%    'running' -- WAIT blocks until OBJ's 'Running' property turns off. 
%
%    'logging' -- WAIT blocks until OBJ's 'Logging' property turns off.
%
%    The WAIT function can be useful when you want to guarantee that 
%    data is acquired before another task is performed.
%
%    OBJ stops running or logging when one of the following
%    conditions is met:
%
%    1. The requested number of frames is acquired. This occurs when:
%    
%          FramesAcquired = FramesPerTrigger * (TriggerRepeat + 1).
%     
%       where FramesAcquired, FramesPerTrigger, and TriggerRepeat are
%       properties of OBJ.
%
%    2. A runtime error occurs.
%
%    3. The STOP function is invoked on OBJ
%
%    4. The object's TIMEOUT value is reached.
%
%   The Stop event is recorded in OBJ's EventLogProperty.
%
%   NOTE: The video input object's stop callback function (StopFcn) may  
%   not be called before the WAIT function returns.
% 
%   See also IMAQHELP, IMAQDEVICE/START, IMAQDEVICE/STOP,
%   IMAQDEVICE/TRIGGER, IMAQDEVICE/PROPINFO.
%

%    RDD 6-Dec-2002
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:39 $

% -----Error Checks-----
% Check number of input arguments
error(nargchk(1, 3, nargin, 'struct'));

% Check for video input object validity.
if ~isa(objects, 'imaqdevice'),
    errID = 'imaq:wait:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~all(isvalid(objects)),
    % Find all invalid indexes 
    inval_OBJ_indexes = find(isvalid(objects) == false);
       
    % Generate an error message specifying the index for the first invalid
    % object found.
    errID = 'imaq:wait:invalidOBJ';
    errStr = sprintf('%s %s.',imaqgate('privateMsgLookup', errID), num2str(inval_OBJ_indexes(1)));
    error(errID, errStr);
end

% Check that WAITTIME is numeric and scalar.
if (nargin < 2)
    waittime = inf;
elseif (nargin>1) && (~isnumeric(waittime) || numel(waittime) > 1)
    errID = 'imaq:wait:invalidWAITTIME';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif (waittime <= 0)
    % WAITTIME is a numeric scalar.
    % Check that WAITTIME's contains a positive value.
    errID = 'imaq:wait:nonPositiveWAITTIME';
    error(errID, imaqgate('privateMsgLookup', errID));
end

% Check that STATE is specified as a string.
if (nargin==3) && (~ischar(state) || isempty(state))
    errID = 'imaq:wait:nonStringSTATE';
    error(errID, imaqgate('privateMsgLookup', errID));
end

% Check that STATE contains a valid value.
% Valid STATE values are 'running' and 'logging'.
% Valid STATE values are also case insensitive and can contain partial
% strings that begins with 'running' or 'logging'.
% Example: WAIT(OBJ, 20, 'Run');
if (nargin == 3)
    state = lower(state);
    if strmatch(state, {'running', 'logging'})
        if (state(1) == 'r')
            state = 'running';
        else
            state = 'logging';
        end
    else
        errID = 'imaq:wait:invalidSTATE';
        error(errID, imaqgate('privateMsgLookup', errID));
    end
end
% -----End of Error Checks-----

try    
    % Call the WAIT method on the UDD object(s).
    udd = imaqgate('privateGetField', objects, 'uddobject');
    if (nargin == 1)
        wait(udd);
    elseif (nargin == 2)
        wait(udd, waittime);
    elseif (nargin == 3)
        wait(udd, waittime, state);
    end %if
catch
    rethrow(lasterror);
end %try
