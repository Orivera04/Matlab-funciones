function stop(obj)
%STOP Stop a logging task.
%   STOP(GObj) stops any logging tasks associated with dagroup object
%   GObj. GObj can be a scalar dagroup object, a vector of dagroup
%   objects, or a cell array containing dagroup objects. When a logging
%   task is stopped, GObj's Logging property is set to 'Off', and the
%   StopFcn callback is executed.
%
%   A dagroup object will also stop running when the requested records are
%   acquired. This occurs when RecordsAcquired equals RecordsToAcquire.
%
%   The Stop event is recorded in GObj's EventLog property.
%
%   See also DAGROUP/START, DAGROUP/WAIT.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/02/01 22:06:26 $

%TODO: Complete code review on this!
I = isvalid(obj);
if ~any(I)
    rethrow(mkerrstruct('opc:stop:objinvalid'));
elseif ~all(I)
    warning('opc:stop:objinvalid', 'One or more OPC Toolbox objects are invalid. Only stopping valid objects.');
end

uddHandle = getudd(obj);
uddValid = uddHandle(I);

failed = uddValid(1);failed(1)=[];
for uddThis=uddValid(:)'
    try
        uddThis.udstop;
    catch
        failed(end+1) = uddThis;
    end
end

% report any failures
if ~isempty(failed),
    if length(failed)==length(uddValid)
        rethrow(mkerrstruct('opcda:stop:stopfailed'));
    else
        warnstr = 'Failed to stop logging for:';
        for uddThis = failed(:)'
            warnstr = sprintf('%s\n\t%s', warnstr, uddThis.Name);
        end
        warning(warnstr);
    end
end
