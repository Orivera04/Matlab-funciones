function fqid = serveritems(obj, itemID)
%SERVERITEMS Query server or namespace for fully qualified item IDs.
%   FQID = SERVERITEMS(Obj,ItemID) returns a cell array of all fully
%   qualified item IDs matching ItemID that are found on the OPC Server
%   defined by Obj. Obj must be a connected opcda object. ItemID is a
%   partial string to search for, and can contain the wildcard character
%   '*'. FQID is a string or cell array of strings. You can use FQID in a
%   call to ADDITEM to construct daitem objects.
%
%   FQID = SERVERITEMS(Obj) returns all fully qualified ItemIDs on the OPC
%   Server associated with Obj.
%
%   FQID = SERVERITEMS(NS) and
%   FQID = SERVERITEMS(NS,ItemID) searches the namespace structure defined
%   by NS, rather than querying the OPC server. NS is the result of a call
%   to GETNAMESPACE in either hierarchical or flat format.
%
%   Note that some servers may return Item IDs that cannot be created on
%   that server. These Item IDs are usually branches of the OPC server
%   name space.
%
%   For querying information on items in the OPC server name space, you
%   use SERVERITEMPROPS. The properties of the items in the sever
%   namespace include the server item's canonical data type, limits, and
%   description.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       realItmIDs = serveritems(da, '*Real*')
%       grp = addgroup(da, 'ServerItemsEx');
%       itm = additem(grp, serveritems(da, 'Random.*'));
%
%   See also OPCDA/GETNAMESPACE, OPCDA/SERVERITEMPROPS.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/02/01 22:06:58 $

if nargin<2 || isempty(itemID),
    itemID = '*';
end

% Additional argument checking:
% Object must be scalar, valid, connected.
if length(obj)>1,
    rethrow(mkerrstruct('opc:serveritems:vecnotsupported'));
elseif ~isvalid(obj),
    rethrow(mkerrstruct('opc:serveritems:objinvalid'));
elseif ~strcmp(get(obj, 'Status'), 'connected'),
    rethrow(mkerrstruct('opc:serveritems:disconnected'));
end

% We get the namespace and pass on to serveritems
fqid = serveritems(getnamespace(obj), itemID);
