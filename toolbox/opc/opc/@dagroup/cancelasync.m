function cancelasync(obj, dwTransID)
%CANCELASYNC Cancel asynchronous read and write operations.
%   CANCELASYNC(GObj) cancels all asynchronous read or write operations
%   that are in progress for the group object specified by GObj.  Note
%   that this function is asynchronous and does not block the MATLAB
%   command line.
%
%   After the in-progress asynchronous operations are cancelled, the OPC
%   server generates an CancelAsync event. If you specify an M-file
%   callback for the CancelAsyncFcn property, then the callback function
%   executes when this event occurs.
%
%   CANCELASYNC(GObj,TransID) cancels the asynchronous operation(s),
%   specified by the transaction IDs given by TransID. You can cancel
%   specific asynchronous requests using this syntax.
%
%   See also DAGROUP/READASYNC, DAGROUP/WRITEASYNC.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.7 $  $Date: 2004/02/01 22:05:51 $

% Object must be a scalar
if length(obj) > 1
    rethrow(mkerrstruct('opc:cancelasync:vecnotsupported'));
end    
    
% Group must be valid
if ~isvalid(obj)
    rethrow(mkerrstruct('opc:cancelasync:objinvalid'));
end

% Group must be connected
if ~strcmpi(get(get(obj,'Parent'),'Status'),'connected')
    rethrow(mkerrstruct('opc:cancelasync:parentdisconnected'));
end

try
    if (nargin == 2)
        % TransID must be valid: greater than 1, and an integer
        if any(dwTransID)<1 || any(rem(dwTransID,1)>0),
            rethrow(mkerrstruct('opc:cancelasync:transidinvalid'));
        end
        udcancelasync(getudd(obj), dwTransID);
    else % Cancel all transactions on this group
        udcancelasync(getudd(obj));
    end
catch
    rethrow(mkerrstruct(lasterror));
end
