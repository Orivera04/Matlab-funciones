function fqid = serveritems(ns, itemID)
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
%   FQID = SERVERITEMS(NS) and FQID = SERVERITEMS(NS,ItemID) searches the
%   namespace structure defined by NS, rather than querying the OPC server.
%   NS is the result of a call to GETNAMESPACE in either hierarchical or
%   flat format.
%   
%   Note that some servers may return Item IDs that cannot be created on
%   that server. These Item IDs are usually branches of the OPC server name
%   space.
%
%   SERVERITEMPROPS(Obj,'ItemID') can be used to return the property
%   information for items in the OPC server namespace. The properties of
%   the items in the sever namespace include the server item's canonical
%   datatype, limits, description, current value, etc.
%
%   See also OPCDA/GETNAMESPACE, OPCDA/SERVERITEMPROPS

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.2 $  $Date: 2004/02/01 22:07:14 $

if nargin<2 || isempty(itemID),
    itemID = '*';
end

% Additional argument checking:
% Namespace must be "proper"
if ~isstruct(ns),
    rethrow(mkerrstruct('opc:serveritems:namespacearg'));
elseif ~isfield(ns, 'FullyQualifiedID'),
    rethrow(mkerrstruct('opc:serveritems:namespacearg'));
end

% ItemID must be a char array (only wildcards, no cell arrays)
if ~ischar(itemID),
    rethrow(mkerrstruct('opc:serveritems:itemidarg'));
end

if isfield(ns, 'Nodes'),
    % This is a hierarchical structure
    ns = flatnamespace(ns);
end

% Now get the fqids from the struct
fqid = {ns.FullyQualifiedID}';

% And use a regexp if we have to
if ~strcmp(itemID, '*'),
    regexpStr = sprintf('^%s$', strrep(strrep(itemID, '.', '[.]'), '*','.*'));
    fqid = fqid(~cellfun('isempty',regexp(fqid, regexpStr)));
end
    
