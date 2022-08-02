function start(obj, event)
%START Obtain exclusive use of an image acquisition device.
%
%    START(OBJ) obtains exclusive use of the image acquisition device 
%    associated with the video input object OBJ and locks the device's
%    configuration. Starting an object is a necessary first step to acquire
%    image data, but it does not control when data is logged. Data logging is 
%    controlled with the TriggerType property. 
%
%    OBJ can either be a 1x1 video input object, or an array of video
%    input objects.
%
%    If OBJ's TriggerType property is set to:
%        'immediate' - data logging occurs immediately.
%        'manual'    - data logging occurs upon calling TRIGGER.
%        'hardware'  - data logging occurs when OBJ's TriggerCondition is met
%                      via the TriggerSource.
%    Use the TRIGGERCONFIG function to configure OBJ's trigger settings.
%
%    When an acquisition is started, OBJ performs the following operations:
%        1. Transfers OBJ's configuration to the associated hardware.
%        2. Executes OBJ's StartFcn callback.
%        3. Sets OBJ's Running property to 'on'.
% 
%    If OBJ's StartFcn errors, the hardware is never started and the Running 
%    property remains 'off'. 
%  
%    The Start event is recorded in OBJ's EventLog property.
% 
%    OBJ will stop running only under one of the following conditions:
%        1. A STOP command is issued.
%        2. The requested number of frames have been acquired. This occurs 
%           when:
%               FramesAcquired = FramesPerTrigger * (TriggerRepeat + 1)
%           where FramesAcquired, FramesPerTrigger, and TriggerRepeat are
%           properties of OBJ.
%        3. A runtime error occurs.
%        4. OBJ's Timeout value is reached.
% 
%    See also IMAQHELP, IMAQDEVICE/STOP, IMAQDEVICE/TRIGGERCONFIG,
%             IMAQDEVICE/TRIGGER, IMAQDEVICE/GETSNAPSHOT, IMAQDEVICE/PROPINFO.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:32 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:start:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~all(isvalid(obj))
    errID = 'imaq:start:invalidOBJ';
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

% Call start on each UDD object.  Keep looping even 
% if one of the objects could not be opened.  
for i=1:length(uddObjects),
   try
      start(uddObjects(i));
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
        warnID = 'imaq:start:noStart';
        warning(warnID, imaqgate('privateMsgLookup',warnID));
        warning(warnState);
    end
end
