function start(obj)
%START Start a logging task.
%   START(GObj) starts a data logging task for dagroup object GObj. GObj
%   can be a scalar dagroup object, or a vector of dagroup objects. A
%   dagroup object must be active and contain at least one item for START
%   to succeed.
%
%   When logging is started, GObj performs the following operations:
%   1. Generates a Start event, and executes the StartFcn callback.
%   2. If Subscription is 'off', sets Subscription to 'on' and issues a
%      warning.
%   3. Removes all records associated with the object from the OPC Toolbox
%      engine.
%   4. Sets RecordsAcquired and RecordsAvailable to 0.
%   5. Sets the Logging property to 'on'.
%
%   The Start event is logged to the EventLog.
%
%   GObj will stop logging when a STOP command is issued, or when
%   RecordsAcquired reaches RecordsToAcquire.
%
%   See also DAGROUP/FLUSHDATA, DAGROUP/GETDATA, DAGROUP/PEEKDATA, 
%            DAGROUP/STOP, DAGROUP/WAIT.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.5 $  $Date: 2004/03/24 20:43:19 $

%TODO: Complete code review on this!
I = isvalid(obj);
if ~any(I)
    rethrow(mkerrstruct('opc:start:objinvalid'));
elseif ~all(I)
    warning('opc:start:objinvalid', 'One or more invalid OPC Toolbox objects. Only starting logging for valid objects')
end

uddHandle = getudd(obj);
uddValid = uddHandle(I);

failMsg = {};
for uddThis=uddValid(:)'
    try
        uddThis.udstart;
    catch
        failMsg{end+1} = sprintf('\t%s returned: ''%s''', uddThis.Name, lasterr);
    end
end

% report any failures
if ~isempty(failMsg),
    if length(failMsg)==length(uddValid)
        msg = sprintf('Logging failed for all groups:\n%s', ...
            sprintf('%s\n', failMsg{:}));
        rethrow(mkerrstruct('opc:start:startfailed', msg));
    else
        msg = sprintf('Failed to start logging for the following groups:\n%s', ...
            sprintf('%s\n', failMsg{:}));
        warning('opc:start:startfailed', warnstr);
    end
end
