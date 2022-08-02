function outstruc = serveritemprops(obj, itemid, propnum)
%SERVERITEMPROPS Return property information for items in OPC server namespace.
%   S = SERVERITEMPROPS(Obj,'ItemID') returns all property information for
%   the OPC server items specified by ItemID. ItemID is a single fully
%   qualified ItemID specified as a string. Obj is an opcda object
%   connected to the OPC server. S is a structure array with the following
%   fields:
%       'PropID' - The property number.
%       'PropDescription' - A description of that item property.
%       'PropValue' - The value of that property.
%
%   The number of properties returned by the server may be different for
%   different Item IDs.
%
%   Item properties include the item's canonical data type, limits, and
%   description.
%
%   S = SERVERITEMPROPS(Obj,'ItemID',PropID) returns property information
%   for the property IDs contained in PropID. PropID is a vector of
%   integers. If PropID contains IDs that do not exist for that property,
%   a warning is issued and any remaining property information is returned.
%
%   Note that this function is not intended to allow efficient access to
%   large amounts of data. Instead, it is intended to allow you to easily
%   browse and read small amounts of additional information specific to a
%   particular Item ID.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       p = serveritemprops(da, 'Random.Real4');
%       p(1)
%       p(3)
%
%   See also SERVERITEMS.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.4 $  $Date: 2004/02/01 22:06:57 $

errorargmsg = nargchk(2,3,nargin);
if ~isempty(errorargmsg)
    rethrow(mkerrstruct('opc:serveritemprops:inargs',errorargmsg));
end

% Object checking: Must be scalar, valid, connected.
if length(obj)>1
    rethrow(mkerrstruct('opc:serveritemprops:vecnotsupported'));
elseif ~isvalid(obj)
    rethrow(mkerrstruct('opc:serveritemprops:objinvalid'));
elseif ~strcmp(get(obj,'Status'),'connected')
    rethrow(mkerrstruct('opc:serveritemprops:disconnected'));
end

% ItemID checking: Must be a character array
if ~ischar(itemid) || isempty(itemid),
    rethrow(mkerrstruct('opc:serveritemprops:itemidarg'));
end

% Now if no properties specified...
if nargin<3 || isempty(propnum),
    % Get the property IDs
    propnum = udserveritempropids(getudd(obj), itemid);
elseif ~isa(propnum, 'double')
        rethrow(mkerrstruct('opc:serveritemprops:propidarg'));
end
try
    outstruc = udserveritemprops(getudd(obj), itemid, propnum);
catch
    rethrow(mkerrstruct(lasterror));
end
