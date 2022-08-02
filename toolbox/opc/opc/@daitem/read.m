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
% $Revision: 1.1.6.8 $  $Date: 2004/02/01 22:06:44 $

% validity check
I = isvalid(obj);
if all(~I)
    rethrow(mkerrstruct('opc:read:objinvalid'));
elseif any(~I)
    warning('opc:read:objinvalid','Read has not been applied to the invalid daitem objects.');
end

% Find valid objects
uddHandle = getudd(obj);
uddValid = uddHandle(I);

% Item must be part of a connected object
if ~strcmpi(get(get(uddValid(1).Parent,'Parent'),'Status'),'connected')
   rethrow(mkerrstruct('opc:read:parentdisconnected'));
end

% Check source, or make one.
if nargin==2
    if ~strcmpi(source,'cache') && ~strcmpi(source,'device')
         rethrow(mkerrstruct('opc:read:badsource'));
    end
else
    source = 'cache';
end

% For cache reads, check the active status
if strcmpi(source, 'cache'),
    if ~strcmpi(get(get(uddValid(1), 'Parent'), 'Active'), 'on'),
        rethrow(mkerrstruct('opc:read:parentinactive'));
    elseif any(strcmpi(get(uddValid,'Active'), 'off')),
        warning('opc:read:iteminactive', 'One or more items is inactive.');
    end
end

% Perform the read
try
    s = udread(uddValid, source);
catch
    rethrow(mkerrstruct(lasterror));
end
