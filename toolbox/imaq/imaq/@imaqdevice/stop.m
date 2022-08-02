function stop(obj, event)
% STOP Stop video input object running and logging. 
%
%    STOP(OBJ) halts an acquisition associated with video input object
%    OBJ. OBJ can be either a single or an array of video input objects.
%
%    When an acquisition is halted, OBJ performs the following operations:
%        1. Configures OBJ's Running property to 'Off'.
%        2. Configures OBJ's Logging property to 'Off' if needed.
%        3. Executes OBJ's StopFcn callback.
%    
%    OBJ can also stop running under one of the following conditions:
%        1. When the requested number of frames are acquired. This occurs 
%           when:
%                FramesAcquired = FramesPerTrigger * (TriggerRepeat + 1)
%           where FramesAcquired, FramesPerTrigger, and TriggerRepeat are
%           properties of OBJ.
%        2. A runtime error occurs.
%        3. OBJ's Timeout value is reached.
% 
%    The Stop event is recorded in OBJ's EventLog property.
% 
%    STOP may be called by a video input object's event callback e.g.,
%    obj.TimerFcn = {'stop'};
% 
%    See also IMAQHELP, IMAQDEVICE/START, IMAQDEVICE/TRIGGER, 
%             IMAQDEVICE/PROPINFO.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:33 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:stop:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~all(isvalid(obj))
    errID = 'imaq:stop:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Verify the second input is the event structure.
if nargin == 2
   if ~(isfield(event, 'Type') && isfield(event, 'Data'))
      error(nargchk(1, 1, nargin, 'struct'));
   end
end

% Initialize variables.
errorOccurred = false;
uddObjects = imaqgate('privateGetField', obj, 'uddobject');

% Call stop on each UDD object.  Keep looping even 
% if one of the objects could not be opened.  
for i=1:length(uddObjects),
   try
      stop(uddObjects(i));
   catch
   	  errorOccurred = true;	    
   end   
end   

% Report error if one occurred.
if errorOccurred
    if length(uddObjects) == 1
		rethrow(lasterror);
    else
        warnState = warning('backtrace', 'off');
        warnID = 'imaq:stop:noStop';
        warning(warnID, imaqgate('privateMsgLookup',warnID));
        warning(warnState);
    end
end
