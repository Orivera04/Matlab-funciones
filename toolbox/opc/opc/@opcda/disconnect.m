function disconnect(obj)
%DISCONNECT Disconnect OPC data access object from server.
%   DISCONNECT(Obj) disconnects the opcda object Obj from the server. Obj
%   can be an array of objects.
%
%   If Obj was successfully disconnected from the server, its Status
%   property is set to disconnected. You can reconnect Obj to the server
%   with the CONNECT function.
%
%   If Obj is an array of objects and one of the objects cannot be
%   disconnected from the server, the remaining objects in the array will
%   be disconnected from the server and a warning will be displayed. If no
%   objects could be disconnected from their server, an error will be
%   generated.
%
%   See also OPCDA/CONNECT, OPCDA/PROPINFO.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.8 $  $Date: 2004/03/24 20:43:10 $

I = isvalid(obj);
if ~any(I)
    rethrow(mkerrstruct('opcda:disconnect:objinvalid'));
elseif ~all(I)
    warning('opc:disconnect:objinvalid', 'One or more OPC Toolbox objects is invalid.')
end
uddHandle = getudd(obj);
uddValid = uddHandle(I);
failedMsg = {};
for uddThis=uddValid(:)'
    try
        uddThis.uddisconnect;
    catch
        failedMsg{end+1} = lasterr;
    end
end
if ~isempty(failedMsg),
    if length(failedMsg) == length(uddValid),
        rethrow(mkerrstruct('opc:disconnect:failed', sprintf('DISCONNECT failed:\n%s', ...
            sprintf('\t%s\n', failedMsg{:}))));
    else
        warning('opc:disconnect:failed', 'DISCONNECT failed for the following groups:\n%s', ...
            sprintf('\t%s\n', failedMsg{:}));
    end
end
