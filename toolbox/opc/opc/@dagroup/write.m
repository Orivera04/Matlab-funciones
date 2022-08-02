function write(obj, values)
%WRITE Write values to group or items.
%   WRITE(GObj,Values) and 
%   WRITE(IObj,Values) writes values to all the items contained in the
%   dagroup object GObj or to the vector of daitem objects specified by
%   IObj. Values is a cell array of values – one for each item. To ensure
%   that a specific value is written to the correct item object, you should
%   construct the Values cell array based on the order of the items
%   returned by the Item property.
%
%   The data types of the values do not need to match the canonical data
%   type of the associated items. However an error is returned if a data
%   type conversion cannot be performed.
%
%   Because the values are written to the device, this operation might be
%   slow. The function does not return until it verifies that the device
%   has actually accepted or rejected the data.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       grp = addgroup(da, 'ExWrite');
%       itm = additem(grp, {'Bucket Brigade.Real8', 'Bucket Brigade.String'});
%       write(grp, {23, 'Hello World!'})
%       r = read(grp)
%       write(itm(1), 15)
%       r2 = read(itm(1))
%
%   See also DAGROUP/READ, DAGROUP/READASYNC, DAGROUP/REFRESH, 
%            DAGROUP/WRITEASYNC.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd 
% $Revision: 1.1.6.9 $  $Date: 2004/03/24 20:43:21 $


% Object must be a scalar
if length(obj) > 1
   rethrow(mkerrstruct('opc:write:vecnotsupported'));
end

% Group must be valid
if ~isvalid(obj)
    rethrow(mkerrstruct('opc:write:objinvalid'));
end

% Group must be connected
if ~strcmpi(get(get(obj,'Parent'),'Status'),'connected')
    rethrow(mkerrstruct('opc:write:parentdisconnected'));
end

% Group must contain items
if isempty(get(obj, 'Item')),
    rethrow(mkerrstruct('opc:write:emptygroup'));
end

% Values must be a cell array or must be one item
if ~iscell(values) && length(get(obj,'Item'))>1,
    rethrow(mkerrstruct('opc:write:valuescell'));
end
if ~iscell(values),
    values = {values};
end
if length(values)~=length(get(obj,'Item')),
    rethrow(mkerrstruct('opc:write:valueslength'));
end

% Perform the write
try
    udwrite(getudd(obj),values);
catch
    rethrow(mkerrstruct(lasterror));
end
