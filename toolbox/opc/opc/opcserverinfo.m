function opcstruc = opcserverinfo(varargin)
%OPCSERVERINFO Return version, server and status information.
%   Out = OPCSERVERINFO returns a structure, Out, that contains OPC
%   Toolbox and MATLAB information. The information includes MATLAB and
%   toolbox product version numbers.
%
%   Out = OPCSERVERINFO('Host') returns a structure, Out, that contains
%   OPC Server information associated with the host name or IP address
%   specified by Host. The information includes the ServerID you can use
%   to create a client associated with that server, and other information
%   about each server.
%
%   Out = OPCSERVERINFO(Obj) returns a structure, Out, that contains
%   information about the server associated with the opcda object Obj. Obj
%   must be a scalar, and must be connected to the server. The information
%   includes the current server status, as well as time information
%   related to the server.
%
%   Examples
%       opcserverinfo('localhost')
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       matrikonInfo = opcserverinfo(da)
%
%   See also OPCDA/CONNECT, OPCDA.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.5 $  $Date: 2004/02/01 22:06:56 $

errorargmsg = nargchk(0,1,nargin);
if ~isempty(errorargmsg)
    rethrow(mkerrstruct('opc:opcserverinfo:inargs',errorargmsg))
end
if nargin==0
    try
        opcstruc = opcmex('opcserverinfo');
    catch
        err = privateFixCOMError('opc:opcserverinfo:dll');
        rethrow(err)
    end
else
    try
        opcstruc = opcmex('opcserverinfo',varargin{1});
    catch
        err = privateFixCOMError('opc:opcserverinfo:noconnect');
        rethrow(err);
    end
end
