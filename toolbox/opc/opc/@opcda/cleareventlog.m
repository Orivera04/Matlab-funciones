function cleareventlog(obj)
%CLEAREVENTLOG Clear the event log, discarding all events.
%   CLEAREVENTLOG(Obj) clears the event log for opcda object Obj. Obj can
%   be an array of objects. Any events stored in the EventLog property of
%   the objects are discarded.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/02/01 22:06:13 $
    
% Only clear eventlogs of valid objects
I = isvalid(obj);
if ~any(I)
    rethrow(mkerrstruct('opc:cleareventlog:objinvalid'));
elseif ~all(I)
    warning('opc:cleareventlog:objinvalid', 'Some objects passed to CLEAREVENTLOG are invalid.')
end
% Now only get the valid ones
uddHandle = getudd(obj);
uddValid = uddHandle(I);

failed = uddValid(1);
failed(1) = [];
% Have to do this one at a time
for uddThis=uddValid(:)'
    try
        udcleareventlog(uddThis) 
    catch
        failed(end+1) = k;
    end
end

% report any failures
if length(failed)==length(uddValid)
    rethrow(mkerrstruct('opc:cleareventlog:failed', 'Could not clear Event Log(s)'));
elseif ~isempty(failed)
    warnstr = sprintf('Failed to clear Event Log(s) for:');
    for uddThis = failed(:)'
       warnstr = sprintf('%s\n\t%s', warnstr, uddThis.Name);
    end
    warning('opc:cleareventlog:failed', warnstr);
end
