function refresh(obj, source)
%REFRESH Read all active items in a group.
%   REFRESH(GObj) asynchronously reads data for all active items contained
%   in the dagroup object specified by GObj. Any items whose Active
%   property is set to 'off' will not be read. The data is read from the
%   OPC server's cache. You can use REFRESH only if the Active property is
%   set to 'on' for GObj.
%
%   When the refresh operation completes, a data change event is generated
%   by the server. If an M-file callback function is specified for the
%   DataChangeFcn property, then the function executes when the event is
%   generated.
%
%   REFRESH is a special case of subscription that forces a data change
%   event for all active items even if the data has not changed. Note that
%   REFRESH ignores the Subscription property.
%
%   REFRESH(GObj,'Source') asynchronously reads data from the source
%   specified by Source. Source can be 'cache' or 'device'.  If Source is
%   'device', data is returned directly from the device. If Source is
%   'cache', data is returned from the OPC server's cache. Note that
%   reading data from the device can be slow.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       grp = addgroup(da, 'ExRefresh');
%       itm = additem(grp, 'Random.Real8');
%       set(grp, 'Subscription', 'off');
%       set(grp, 'DataChangeFcn', 'disp(grp.Item)')
%       refresh(grp)
%       refresh(grp)
%
%   See also DAGROUP/READ, DAGROUP/READASYNC, DAGROUP/WRITE, 
%            DAGROUP/WRITEASYNC.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.5 $  $Date: 2004/03/24 20:43:17 $

% Works only on scalars
if length(obj) ~= 1,
    rethrow(mkerrstruct('opc:refresh:vecnotsupported'));
end

% Group must be valid
if ~isvalid(obj)
    rethrow(mkerrstruct('opc:refresh:objinvalid'));
end

% Group must be connected
if ~strcmpi(get(get(obj,'Parent'),'Status'),'connected')
    rethrow(mkerrstruct('opc:refresh:parentdisconnected'));
end

% Group must contain items
if isempty(get(obj, 'Item')),
    rethrow(mkerrstruct('opc:refresh:emptygroup'));
end

% Check source param, or make one if not passed.
if nargin<2
    source = 'cache';
end
if ~strcmpi(source,'cache') && ~strcmpi(source,'device')
    rethrow(mkerrstruct('opc:refresh:badsource'));
end

% Error if group is inactive
if strcmp(get(obj,'Active'),'off')
    rethrow(mkerrstruct('opc:refresh:groupinactive'));
end

% Perform the refresh
try
    udrefresh(getudd(obj),source);
catch
    rethrow(mkerrstruct(lasterror));
end
