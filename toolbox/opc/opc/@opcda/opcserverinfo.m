function out = opcserverinfo(obj)
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
% $Revision: 1.1.6.7 $  $Date: 2004/02/01 22:06:21 $

if length(obj)~=1
    rethrow(mkerrstruct('opc:opcserverinfo:vecnotsupported'));
end
if ~isvalid(obj)
    rethrow(mkerrstruct('opc:opcserverinfo:objinvalid'));
end
try
    out = udopcserverinfo(getudd(obj));
catch
    rethrow(mkerrstruct(lasterror));
end  
