function wait(obj,timeout)
%WAIT Suspend MATLAB execution until object has stopped logging.
%   WAIT(GObj) suspends MATLAB execution until the group object GObj has
%   stopped logging. GObj must be a scalar dagroup object.
%
%   WAIT(GObj, TSec) will wait at most TSec seconds for all of the dagroup
%   objects in GObj to stop logging. If the group object is still logging
%   when the timeout value is exceeded, an error message is generated.
%
%   The WAIT function can be useful when you want to guarantee that data
%   is logged before another task is performed.
%
%   You can press Ctrl-C to interrupt the wait function. An error
%   message will be generated, and control will return to the MATLAB
%   command window.
%
%   Examples
%       da = opcda('localhost','Matrikon.OPC.Simulation');
%       connect(da)
%       grp = addgroup(da,'WaitExample');
%       itm = additem(grp, {'Random.Real8','Random.UInt4'});
%       set(grp, 'RecordsToAcquire',60, 'UpdateRate',1);
%       start(grp);
%       wait(grp)
%       disp('Acquisition complete');
%       [itmID,v,q,t]=getdata(grp, 'double');
%       plot(t(:,1),v(:,1), t(:,2), v(:,2));
%       legend(itmID);
%
%   See also DAGROUP/START, DAGROUP/STOP, DAGROUP/GETDATA.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:43:20 $

% Number of arguments
errorargmsg = nargchk(1,2,nargin);
if ~isempty(errorargmsg)
    rethrow(mkerrstruct('opc:wait:inargs',errorargmsg))
end
% Object must be a scalar
if length(obj) > 1
    rethrow(mkerrstruct('opc:wait:vecnotsupported'));
end    
% Group must be valid
if ~isvalid(obj)
    rethrow(mkerrstruct('opc:wait:objinvalid'));
end
% Additional arguments:
if nargin==1 || isempty(timeout),
    timeout = inf;
else
    % Timeout must be a double scalar
    if ~isreal(timeout) || length(timeout)>1 || timeout < 0
        rethrow(mkerrstruct('opc:wait:timeoutarg'));
    end
    timeout = double(timeout);
end
% Wait
try
    udwait(getudd(obj),timeout);
catch
    rethrow(mkerrstruct(lasterror));
end
