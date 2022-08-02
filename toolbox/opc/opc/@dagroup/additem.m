function itm = additem(obj, fqn, varargin)
%ADDITEM Add data access items to a dagroup object.
%   IObj = ADDITEM(GObj,'IName') adds items to the group object GObj with
%   fully qualified item IDs given by IName. IObj is the created item
%   object(s). You specify IName as a single item ID or as a cell array of
%   item IDs.
%
%   The daitem object provides a connection to a data variable in the
%   physical device and returns information about the data variable such
%   as its value, quality, and time stamp. Note that you cannot add a
%   given item to the same group more than once. However, you can add the
%   same item to different groups.
%
%   By default, IObj is active, that is, if the group's Subscription
%   property is on, the item's Value, Quality and Timestamp properties
%   will be updated at the group's UpdateRate.
%
%   Servers often require item IDs to be specified in the correct case.
%   You can use the SERVERITEMS function to find valid item IDs.
%
%   IObj = ADDITEM(GObj,'IName','DataType') adds items to the group object
%   GObj with requested data type given by DataType. You specify DataType
%   as a cell array of strings, one for each item ID. DataType is the data
%   type in which the item's value will be stored in MATLAB. The supported
%   data types are: 'logical', 'int8', 'uint8', 'int16', 'uint16',
%   'int32', 'uint32', 'single', 'double', 'char' and 'date'. Note that if
%   the requested data type is rejected by the server, the item is not
%   added. The requested data type is stored in the DataType property. The
%   canonical data type (the data type used by the server to store the
%   item value) is stored in the CanonicalDataType property.
%
%   IObj = ADDITEM (GObj,'IName','DataType','Active') adds items to the
%   group object GObj with active status given by Active. You specify
%   Active as a cell array of strings, one for each item ID. Active can be
%   'on' or 'off'. The active status is stored in the Active property.
%
%   Examples
%       da = opcda('localhost', 'Matrikon.OPC.Simulation');
%       connect(da);
%       grp = addgroup(da, 'ExAddItem');
%       itm = additem(grp, {'Random.Real4', 'Random.Real8'})
%       itmDbl = additem(grp, 'Random.Int2', 'double')
%       itmInact = additem(grp, 'Random.UInt4', 'double', 'off')
%
%   See also OPCDA/GETNAMESPACE, SERVERITEMS.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.8 $  $Date: 2004/02/01 22:05:50 $

errorargmsg = nargchk(2,4,nargin);
if ~isempty(errorargmsg)
    rethrow(mkerrstruct('opc:additem:inargs',errorargmsg))
end
    
if length(obj)>1
    rethrow(mkerrstruct('opc:additem:vecnotsupported'));
end

if ~isa(obj,'dagroup') || ~isvalid(obj)
    rethrow(mkerrstruct('opc:additem:objinvalid'));
end

% if fully qualified name (fqn) is a string - convert it to a cell
if ischar(fqn)
    fqn = {fqn};
elseif ~iscell(fqn) || ~iscellstr(fqn)
    rethrow(mkerrstruct('opc:additem:itemidbad'));
end

% check that the list of new item ids contains no duplicates
if length(unique(fqn))~= length(fqn)
    rethrow(mkerrstruct('opc:additem:itemidrepeat'));
end

% check that the new group object contains no duplicate items
olditems = get(get(obj, 'Item'),'ItemID');
if (ischar(olditems) && length(unique({olditems fqn{:}}))<length(fqn)+1) || ...
       (iscell(olditems) && length(unique({olditems{:} fqn{:}}))<length(fqn)+length((olditems)))
    rethrow(mkerrstruct('opc:additem:itemiddup'));
end

% if datatype is a string - convert it to a cell
if nargin >= 3
    validdatatypes = {'logical', 'int8', 'int16', 'int32', 'double',...
            'single', 'char', 'uint8', 'uint16', 'uint32',...
            'currency', 'date', ''};
    datatype = varargin{1};
	if ischar(datatype)
        datatype = {datatype};
    elseif ~iscell(datatype) || ~iscellstr(datatype),
        rethrow(mkerrstruct('opc:additem:datatypearg'));
	end
    if length(datatype) ~= length(fqn)
        rethrow(mkerrstruct('opc:additem:datatypelength'));
    end
    for k=1:length(datatype)
        if ~any(strcmp(datatype{k},validdatatypes))
            rethrow(mkerrstruct('opc:additem:datatypeinvalid'));
        end
    end
end
if nargin >= 4
    activestatus = varargin{2};
	if ischar(activestatus)
        activestatus = {activestatus};
	end
    if ~iscell(activestatus)
        rethrow(mkerrstruct('opc:additem:activearg'));
    end
    if length(activestatus) ~= length(fqn)
        rethrow(mkerrstruct('opc:additem:activemismatch'));
    end
    for k=1:length(activestatus)
        if ~any(strcmp(activestatus{k},{'on','off'}))
            rethrow(mkerrstruct('opc:additem:activeinvalid'));
        end
    end
end

uddgrpobj = getudd(obj);

uddVec = [];
% add the items one at a time
failtoadd = 0;
for k=1:length(fqn)
    udditem = [];
    try
        if nargin==2
             udditem = opcmex('additem',uddgrpobj,fqn{k});
        elseif nargin==3
             udditem = opcmex('additem',uddgrpobj,fqn{k},datatype{k});
        elseif nargin==4
             udditem = opcmex('additem',uddgrpobj,fqn{k},datatype{k},activestatus{k});
        end
    catch
        failtoadd = failtoadd+1;
    end
    if ~isempty(udditem) && ishandle(udditem)
        % Add a representation of me to myself
        thisItmOOPS = daitem(udditem);
        udditem.udsetoops(thisItmOOPS);
        uddVec = [uddVec udditem];
    end   
end
if ~isempty(uddVec),
    itm = daitem(uddVec);
    % Add these to the parent's child property
    newItem = horzcat(get(uddgrpobj, 'Item'), itm);
    udsetchild(uddgrpobj, newItem);
end 

% check for failure and partial success
if failtoadd==length(fqn) % complete failure throw last error
    rethrow(mkerrstruct('opc:additem:additemfailed',lasterr));
elseif failtoadd>0 % partial success - warn
    warning('opc:additem:additemfailed', 'One or more items could not be added.')
end
