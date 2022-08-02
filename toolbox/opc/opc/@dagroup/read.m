function s = read(obj, source)
%READ Read data synchronously from OPC groups or items
%   S = READ(GObj) and 
%   S = READ(Iobj) reads data for all the items contained in the dagroup
%   object, GObj, or for the vector of daitem objects, IObj. The data is
%   read from the OPC server's cache. S is a structure array containing
%   data for each item in the following fields:
%       'ItemID' - Fully qualified item name, as a string.
%       'Value' - Value, in the data format defined by the Item.
%       'Quality' - Quality of the value, as a string.
%       'TimeStamp' - The time (as a MATLAB date vector) that the value and
%           quality was obtained by the device (if this is available) or
%           the time the server updated or validated the value and quality
%           in its cache.
%       'Error' - Any error message returned by the server for this item, 
%           as a string.
%
%   You can synchronously read from the cache only if the Active property
%   is set to on for both the item and the group that contains the item. A
%   warning is issued if any of the objects passed to READ are inactive.
%   An inactive item is still returned in S, but the Quality is set to
%   'BAD: Out of Service'
%
%   S = READ(GObj,'Source') and S = READ(IObj,'Source') reads data from
%   the source specified by Source. Source can be 'cache' or 'device'. If
%   Source is 'device', data is returned directly from the device. If
%   Source is 'cache', data is returned from the OPC server's cache, which
%   contains a copy of the device data. Note that the Active property is
%   ignored when reading from 'device'. Note also, that reading data from
%   the device can be slow.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       grp = addgroup(da, 'ExRead');
%       set(grp, 'UpdateRate', 20);
%       itm = additem(grp, 'Random.Real8');
%       v1 = read(grp)
%       v2 = read(grp)
%       v3 = read(grp, 'device')
%       v4 = read(grp, 'device')
%
%   See also DAGROUP/READASYNC, DAGROUP/REFRESH, DAGROUP/WRITE, 
%            DAGROUP/WRITEASYNC.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.9 $  $Date: 2004/03/24 20:43:15 $

% Object must be a scalar
if length(obj) > 1
    rethrow(mkerrstruct('opc:read:vecnotsupported'));
end  

% Group must be valid
if ~isvalid(obj)
    rethrow(mkerrstruct('opc:read:objinvalid'));
end

% Group must be connected
if ~strcmpi(get(get(obj,'Parent'),'Status'),'connected')
    rethrow(mkerrstruct('opc:read:parentdisconnected'));
end

% Group must contain items
if isempty(get(obj, 'Item')),
    rethrow(mkerrstruct('opc:read:emptygroup'));
end

% Check second argument, or make one if we don't have it.
if nargin<2
    source = 'cache';
end
if ~strcmpi(source,'cache') && ~strcmpi(source,'device')
    rethrow(mkerrstruct('opc:read:badsource'))
end

% For cache reads, check the active status
if strcmpi(source, 'cache'),
    if ~strcmpi(get(obj, 'Active'), 'on'),
        rethrow(mkerrstruct('opc:read:groupinactive'));
    elseif any(strcmpi(get(get(obj,'Item'),'Active'), 'off')),
        warning('opc:read:iteminactive', 'One or more items is inactive.');
    end
end

% perform the read
try
    s = udread(getudd(obj),source);
catch
    rethrow(mkerrstruct(lasterror));
end
