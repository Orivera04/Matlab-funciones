function out = islogging(objects)
%ISLOGGING Determine if video input object is logging.
%
%   OUT = ISLOGGING(OBJ) returns a logical array, OUT, that contains a 1
%   where the elements of OBJ are video input objects whose Logging
%   property is set to 'on' and a 0 where the elements of OBJ are video
%   input objects whose Logging property is set to 'off'. 
%
%   See also IMAQDEVICE/TRIGGERCONFIG, IMAQDEVICE/TRIGGERINFO, IMAQHELP.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/08 20:52:11 $

% Error checking.
% Check if there are any invalid video input objects.
if ~all(isvalid(objects)),
    % Find all invalid indexes 
    inval_OBJ_indexes = find(isvalid(objects) == false);

    % Generate an error message specifying the index for the first invalid
    % object found.
    errID = 'imaq:islogging:invalidOBJ';
    errStr = sprintf('%s %s.',imaqgate('privateMsgLookup', errID), num2str(inval_OBJ_indexes(1)));
    error(errID, errStr);
end

% Get logging state.
try
    udd = imaqgate('privateGetField', objects, 'uddobject');
    out = islogging(udd);
catch
    rethrow(lasterror);
end
