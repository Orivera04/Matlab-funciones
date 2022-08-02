function out = isrunning(objects)
%ISRUNNING Determine if video input object is running.
%
%   OUT = ISRUNNING(OBJ) returns a logical array, OUT, that contains a 1
%   where the elements of OBJ are video input objects whose Running
%   property is set to 'on' and a 0 where the elements of OBJ are video
%   input objects whose Running property is set to 'off'. 
%
%   See also IMAQDEVICE/START, IMAQDEVICE/STOP, IMAQHELP.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/08 20:52:12 $

% Error checking.
% Check if there are any invalid video input objects.
if ~all(isvalid(objects)),
    % Find all invalid indexes 
    inval_OBJ_indexes = find(isvalid(objects) == false);

    % Generate an error message specifying the index for the first invalid
    % object found.
    errID = 'imaq:isrunning:invalidOBJ';
    errStr = sprintf('%s %s.',imaqgate('privateMsgLookup', errID), num2str(inval_OBJ_indexes(1)));
    error(errID, errStr);
end

% Get running state.
try
    udd = imaqgate('privateGetField', objects, 'uddobject');
    out = isrunning(udd);
catch
    rethrow(lasterror);
end
