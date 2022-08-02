function varargout = opcguiclientfn(varargin)
%OPCGUICLIENTFN OPCTOOL helper function for calling OPC client functions
%   [ErrStr,Node,Caller,Y1,Y2,...] =
%   OPCGUICLIENTFN(FunName,Node,Caller,X1,X2,...) calls the function
%   FunName passing the arguments X1, X2 etc. to it. OPCGUICLIENTFN returns
%   an error string, ErrStr, the tree node associated with this function,
%   Node, the name of this function and the outputs, Y1, Y2 etc. from the
%   function FunName. If FunName returns without error the ErrStr is empty.
%   If there was an error during the call to FunName, ErrStr contains the
%   error string.
%
%   This function is called by OPCTOOL and should not be called directly by
%   the user.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd
% $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:44:50 $

try
    % Assume initially that there is no error
    varargout{1} = '';
    % Extract the node from varargin and pass it back
    varargout{2} = varargin{1};
    % Extract the function name from varargin and pass it back
    varargout{3} = varargin{2};
    % Try to call the function passed by the GUI
    [varargout{4:nargout}] = feval(varargin{2:end});
catch
    % If there is an error, return the error in the first output
    varargout{1} = lasterr;
    % Return the balance of the outputs as empty
    if nargout > 3
        [varargout{4:nargout}] = deal([]);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hostList, loadStruct] = loadsession(fileName, opctoolClient)
%LOADSESSION Load OPCDA objects from a file
%  [HostList, LoadStruct] = LOADSESSION(FileName, Caller) loads the host
%  list and OPC Toolbox objects stored in the file named, FileName, and
%  returns the host list, HostList, and the objects, names and ItemIds in
%  the structure LoadStruct.

if ~exist(fileName,'file')
    errMsg.identifier = 'opc:loadsession:nofile';
    errMsg.message = sprintf('%s does not exist.', fileName);
    rethrow(errMsg);
end

% Try to load the file
try
    loadStruct = load(fileName,'-mat');
catch
    % Error if the file is not a valid MAT file
    errMsg.identifier = 'opc:loadsession:invalidosf';
    errMsg.message = sprintf('%s is not a valid OSF file.', fileName);
    rethrow(errMsg);
end

% Search through the variables extracting the OPCDA objects and the host
% list (if one exists)
hostList = {};
da = [];
varNames = fieldnames(loadStruct);
for k = 1:length(varNames)
    if strcmp(varNames{k},'guiHostList')
        hostList = loadStruct.(varNames{k});
    elseif strcmp(class(loadStruct.(varNames{k})),'opcda')
        daVar = loadStruct.(varNames{k});
        if isvalid(daVar)
            da = [da, daVar(:)'];
        end
    end
end

% Error if there is no host list or no da objects in the mat file.
if isempty(hostList) && isempty(da)
    errMsg.identifier = 'opc:loadsession:nodata';
    errMsg.message = sprintf('%s contains no valid OPC Toolbox data.', fileName);
    rethrow(errMsg);
end

if ~isempty(da)
    loadStruct = createloadhierarchy(da, opctoolClient);
else
    loadStruct = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadStruct = createloadhierarchy(da, opctoolClient)
%CREATELOADHIERARCHY Create a structure to assist in loading the object hierarchy

% Create a structure (tree) with the objects and object names (itemIDs)
% exposed
allClients = da;
for p = 1:length(allClients)
    client(p).object = allClients(p);
    client(p).name = allClients(p).Name;
    client(p).hostName = allClients(p).Host;
    client(p).serverID = allClients(p).ServerID;
    client(p).status = allClients(p).Status;
    allGroups = allClients(p).Group;
    group = [];
    for q = 1:length(allGroups)
        % Make sure that the callback functions call the GUI callbacks first and
        % then the user's callback
        thisGroup = allGroups(q);
        thisGroup.DataChangeFcn = ...
            {@opcguidcfn, opctoolClient, thisGroup.DataChangeFcn};
        thisGroup.RecordsAcquiredFcn = ...
            {@opcguirecacqfn, [], [], thisGroup.RecordsAcquiredFcn};
        thisGroup.StopFcn = ...
            {@opcguistopfn, [], [], thisGroup.StopFcn};
        group(q).object = thisGroup;
        group(q).name = thisGroup.Name;
        allItems = thisGroup.Item;
        item = [];
        for r = 1:length(allItems)
            item(r).object = allItems(r);
            item(r).name = allItems(r).ItemID;
        end
        group(q).item = item;
    end
    client(p).group = group;
end
loadStruct = client;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [da,name,host,serverID] = createclient(host,serverID)
%CREATECLIENT Create an OPC client object
%  [Obj, Name, Host, ServerID] = CREATECLIENT(Host, ServerID) creates an
%  OPCDA object Obj, with the given host name, Host and server ID,
%  ServerID, and returns the OPCDA object's name, Name, host name, Host,
%  and server ID, serverID.

% Create the client
da = opcda(host,serverID);
% Get the object's name
name = da.Name;
% Get the object's host name
host = da.Host;
% Get the object's serverId
serverID = da.ServerID;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [da,name,host,serverID] = createclientconnect(host,serverID)
%CREATECLIENTCONNECT Create an OPC client object and connect to the server
%  [Obj, Name, Host, ServerID] = CREATECLIENTCONNECT(Host, ServerID)
%  creates a cnnected OPCDA object Obj, with the given host name, Host and
%  server ID, ServerID, and returns the OPCDA object's name, Name, host
%  name, Host, and server ID, serverID.

% Create the client
da = opcda(host,serverID);
% Connect to the server
connect(da);
% Get the object's name
name = da.Name;
% Get the object's host name
host = da.Host;
% Get the object's serverId
serverID = da.ServerID;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [grp, grpName] = addgroupgetname(da, opctoolClient)
%ADDGROUPGETNAME Add a data access group to an opcda object
%  [Grp, GrpName] = ADDGROUPGETNAME(Obj, Caller) adds a group to the
%  opcda object Obj, configures the callback functions and returns the
%  group object, Grp, and its name, GrpName.

grp = addgroup(da);
% Make sure that the callback functions call the GUI callbacks first and
% then the user's callback
grp.DataChangeFcn = {@opcguidcfn, opctoolClient, grp.DataChangeFcn};
grp.RecordsAcquiredFcn = {@opcguirecacqfn, [], [], grp.RecordsAcquiredFcn};
grp.StopFcn = {@opcguistopfn, [], [], grp.StopFcn};

grpName = grp.Name;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [itmCell, itmNames] = additemgetname(grp,itmNames)
%ADDITEMGETNAME Add items to a group object.
%   [Itm, ItmName] = ADDITEMPGETNAME(Grp, ItmNames) adds items to the group
%   object GObj. ItmNames is either a fully qualified item ID or a cell
%   array of fully qualified item IDs. A cell array of item objects and a
%   cell array of item names is returned.

itm = additem(grp,itmNames);
% Put the objects in a cell array to process n java
for k = 1:length(itm)
    itmCell{k} = itm(k);
end

itmNames = itm.ItemID;
% Make sure that we return a cell array of item names
if ischar(itmNames)
    itmNames = {itmNames};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData,itemGetData] = setget(obj,propName,propValue)
%SETGET Set a property value and get all property values.
%   [GetData, ItmGetData] = SETGET(Obj,PropName,PropValue) sets the
%   PropName property of Obj to PropValue and returns the OPC Toolbox
%   object properties and values for the object Obj. If Obj is a group
%   object, itmGetData contains a structure containing the properties and
%   values for all the item objects associated with the group. 
%
%   The function deals with callback functions containing function handles
%   and cell arrays as well as callbacks used by the GUI.

% Deal with callbacks
allCallbacks = {'errorfcn','shutdownfcn','timerfcn','cancelasyncfcn', ...
    'datachangefcn','readasyncfcn','recordsacquiredfcn',...
    'startfcn','stopfcn','writeasyncfcn'};

if any(strcmpi(propName,allCallbacks))
    % This property contains a callback
    % Remove insignificant white space from the property value
    propValue = strtrim(propValue);
    % If the property value is a string with efirst character as @, set the
    % value to a function handle. If the first character of the property
    % value is a {, set it to a cell array.
    if ~isempty(propValue)
        if strcmp(propValue(1),'@') || strcmp(propValue(1),'{')
            % The value is a function handle or cell array, so eval to get
            % the correct property value
            propValue = eval(propValue);
        end
    end
    
    % Now deal with each of the GUI callbacks. We need to set the value for
    % the user's callback function
    if any(strcmpi(propName, ...
            {'datachangefcn','recordsacquiredfcn','stopfcn'}))
        currentPropValue = obj.(propName);
        currentPropValue{end} = propValue;
        propValue = currentPropValue;
    end
end

set(obj,propName,propValue);
[getData, itemGetData] = getpropdata(obj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData,itemGetData] = setactiveget(grpObj, itemObj, active)
%SETACTIVEGET Sets the active property and gets property values
%   [GetData, ItemGetData] = SETACTIVEGET(GrpObj, ItemObj, Active) sets the
%   active property for the item ItemObj to the value contained in Active
%   and gets the property values for the parent object.

set(itemObj, 'Active', active);
[getData, itemGetData] = getpropdata(grpObj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData, itemGetData] = getpropdata(obj)
%GETPROPDATA Get all properties.
%  [GetData,itemGetData] = GETPROPDATA(Obj) returns the OPC Toolbox object
%  properties for the object Obj, as well as the properties of the items if
%  Obj is a dagroup object. The function deals with callback functions
%  containing function handles and cell arrays as well as callbacks used by
%  the GUI.

% Get the property data
getData = get(obj);

% Deal with callbacks
nonGUICallbacks = {'errorfcn','shutdownfcn','timerfcn','cancelasyncfcn', ...
    'readasyncfcn','startfcn','writeasyncfcn'};
guiCallbacks = {'datachangefcn','recordsacquiredfcn','stopfcn'};

% Search through properties to find callbacks
getFields = fieldnames(getData);
for k = 1:length(getFields)
    % Replace function handles and strings in non GUI callbacks
    if any(strcmpi(getFields{k},nonGUICallbacks))
        % This property is a non GUI callback
        thisValue = getData.(getFields{k});
        if ~(isempty(thisValue) || ischar(thisValue))
            % Convert the callback function to a string
            thisValue = tostring(thisValue);
        end
        getData.(getFields{k}) = thisValue;
    elseif any(strcmpi(getFields{k},guiCallbacks))
        % This property is a non GUI callback
        thisValue = getData.(getFields{k});
        % The property value is the last element in the cell array
        thisValue = thisValue{end};
        if ~(isempty(thisValue) || ischar(thisValue))
            % Convert the callback function to a string
            thisValue = tostring(thisValue);
        end
        getData.(getFields{k}) = thisValue;
    end
end

% The item data is necessary to update the item VQT in the group read/write
% panel
if isa(obj,'dagroup')
    itemGetData = get(obj.Item);
    if length(itemGetData) > 1
        % Sort the items into alphabetical order
        itemID = {itemGetData.ItemID};
        [y,ind] = sort(itemID);
        % Use the index to sort the structure
        itemGetData = itemGetData(ind);
    end
else
    itemGetData = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [newGroups,newItems] = connectremoveinvalid(obj)
%CONNECTREMOVEINVALID Connect to server and return valid objects
%  [Groups, Items] = CONNECTREMOVEINVALID(Obj) connects
%  the opcda object Obj to the OPC server. THe OPC server may reject some
%  of the groups and items being connected and therefore the function
%  returns a cell array of connected group names and a cell array of cells
%  (one for each connected group) containing the connected item names for
%  that group.

% Connect to the server
connect(obj);

% Get a list of all groups and items remaining after connection
newGroups = {};
newItems = {};
if length(obj.Group) > 0
    % Return a cell array of group names
    if length(obj.Group) == 1
        newGroups = {obj.Group.Name};
    else
        newGroups = obj.Group.Name;
    end
    % A cell array of cell arrays (each cell in newItems corresponds to a
    % group)
    for k = 1:length(obj.Group)
        if length(obj.Group(k).Item) == 1
            groupItem = {obj.Group(k).Item.ItemID};
        elseif length(obj.Group(k).Item) > 1
            groupItem = obj.Group(k).Item.ItemID;
        else
            groupItem = {};
        end
        newItems{k} = groupItem;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData,itemGetData] = cleareventlogget(obj)
%CLEAREVENTLOGGET Clear the event log and get all properties.
%  [GetData, ItmGetData] = CLEAREVENTLOGGET(Obj) clears the event log for
%  opcda object Obj and returns the OPC Toolbox object properties.

cleareventlog(obj);
[getData, itemGetData] = getpropdata(obj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = vieweventlog(obj)
%VIEWEVENTLOG Get the contents of the event log.
%  Data = VIEWEVENTLOG(Obj) retrieves the contents of the event log.

if isempty(obj.EventLog)
    errMsg.identifier = 'opc:vieweventlog:norecords';
    errMsg.message = 'No records are available.';
    rethrow(errMsg);
end
sopcEvt = showopcevents(obj);
data = sprintf('%s\n',sopcEvt{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData,itemGetData] = readget(obj)
%READGET Read data synchronously from OPC items and get all properties.
%  [GetData, ItmGetData] = READGET(Obj) reads data, from the device, for
%  the item Obj, and returns the OPC Toolbox object properties.

read(obj,'device');
[getData, itemGetData] = getpropdata(obj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData,itemGetData,lastWriteString] = writereadget(obj,value)
%WRITEREADGET Write values synchronously to items and get all properties.
%   [GetData, ItmGetData, WriteString] = WRITEREADGET(Obj, Value) writes
%   data to the item Obj. Value is the value string which is eval'ed before
%   writing. The function returns the OPC Toolbox object properties as well
%   as the Value string.

% Call eval on the value to convert from a string to a number or to a valid
% string
evalValue = eval(value);
write(obj,evalValue);
read(obj,'device');
[getData, itemGetData] = getpropdata(obj);
lastWriteString = value;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function writerefresh(grpObj,itemObj,itemValue)
%WRITEREFRESH Write values asynchronously to items refresh the group.
%  WRITEREFRESH(GrpObj,ItemObj,ItemValue) writes data to the items ItemObj
%  and calls refresh on the group GrpObj. ItemValue is a string containing
%  the value to be written. ItemValue is eval'ed before writing the value.

% Call eval on the value to convert from a string to a number or to a valid
% string
for k = 1:length(itemObj)
    evalValue = eval(itemValue{k});
    writeasync(itemObj{k},evalValue);
end
refresh(grpObj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deleteallobj(varargin)
%DELETEALLOBJ Delete all OPCDA objects
%  DELETEALLOBJ(Obj1, Obj2, ...) deletes all OPCDA objects passed to the
%  function.

delete([varargin{:}]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savesession(fileName,varargin)
%SAVESESSION Save host list and OPCDA objects in a mat file
%  SAVESESSION(FileName,Host1,...,Hostn,Obj1,...,Objm) save the hosts Host1
%  through Hostn and the OPCDA clients Obj1 through Objm to a mat file
%  FileName, so that the host list and objects can be loaded later.

% Create a vector of host and a vector of opcda objects
guiHostList = {};
daList = [];
for k = 1:length(varargin)
    if ischar(varargin{k})
        guiHostList{end+1} = varargin{k};
    elseif isa(varargin{k},'opcda')
        daList = [daList, copyobj(varargin{k})];
    end
end

% Remove GUI callback properties from the group objects
for m = 1:length(daList)
    da = daList(m);
    groups = da.Group;
    for n = 1:length(groups)
        grp = groups(n);
        dataChangeFcn = grp.DataChangeFcn;
        grp.DataChangeFcn = dataChangeFcn{end};
        recAcqFcn = grp.RecordsAcquiredFcn;
        grp.RecordsAcquiredFcn = recAcqFcn{end};
        stopFcn = grp.StopFcn;
        grp.StopFcn = stopFcn{end};
    end
end
        
% Get the version in case we change this file definition
opcVersion = opcmex('version');

% Save the objects to a mat file
save(fileName,'guiHostList','daList','opcVersion');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saveanddelete(fileName,varargin)
%SAVEANDDELETE Write opcda objects to an m-file and then delete them
%   SAVEANDDELETE(FileName,Obj1, Obj2, ...) saves OPCDA objects Obj1, Obj2,
%   etc to the MAT-file called FileName and then deletes Obj1, Obj2, etc
%   from memory.

% Create a vector of host and a vector of opcda objects
guiHostList = {};
daList = [];
deleteDaList = [];
for k = 1:length(varargin)
    if ischar(varargin{k})
        guiHostList{end+1} = varargin{k};
    elseif isa(varargin{k},'opcda')
        daList = [daList, copyobj(varargin{k})];
        deleteDaList = [deleteDaList, varargin{k}];
    end
end

% Remove GUI callback properties from the group objects
for m = 1:length(daList)
    da = daList(m);
    groups = da.Group;
    for n = 1:length(groups)
        grp = groups(n);
        dataChangeFcn = grp.DataChangeFcn;
        grp.DataChangeFcn = dataChangeFcn{end};
        recAcqFcn = grp.RecordsAcquiredFcn;
        grp.RecordsAcquiredFcn = recAcqFcn{end};
        stopFcn = grp.StopFcn;
        grp.StopFcn = stopFcn{end};
    end
end

opcVersion = opcmex('version');

% Save the objects to a mat file
save(fileName,'guiHostList','daList','opcVersion');

% Delete the objects
delete(deleteDaList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exporttoworkspace(varName,varargin)
%EXPORTTOWORKSPACE Copy OPC Toolbox objects to the workspace
%   EXPORTTOWORKSPACE(VarName, Obj1, Obj2, ...) creates a vector, called
%   VarName, in the base workspace containing copies of OPCDA objects Obj1,
%   Obj2, etc.

% Create the vector of opcda objects
daList = [varargin{:}];
% Create a copy of the vector of opcda objects
daCopyList = copyobj(daList);

% Connect where the object was previously connected and remove GUI callback
% properties from the group objects
for m = 1:length(daCopyList)
    da = daCopyList(m);
    if strcmp(daList(m).Status,'connected')
        connect(da);
    end
    groups = da.Group;
    for n = 1:length(groups)
        grp = groups(n);
        dataChangeFcn = grp.DataChangeFcn;
        grp.DataChangeFcn = dataChangeFcn{end};
        recAcqFcn = grp.RecordsAcquiredFcn;
        grp.RecordsAcquiredFcn = recAcqFcn{end};
        stopFcn = grp.StopFcn;
        grp.StopFcn = stopFcn{end};
    end
end

% Create a copy in the base workspace
assignin('base',varName,daCopyList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exporttomatfile(varName,fileName,varargin)
%EXPORTTOMATFILE Copy OPC Toolbox objects to a MAT file
%   EXPORTTOMATFILE(VarName, FileName, Obj1, Obj2, ...) saves a vector,
%   called VarName, in the MAT-file, called FileName, containing copies of
%   OPCDA objects Obj1, Obj2, etc.

% Create the vector of opcda objects
daList = [varargin{:}];
% Create a copy of the vector of opcda objects
daCopyList = copyobj(daList);

% Connect where the object was previously connected and remove GUI callback
% properties from the group objects
for m = 1:length(daCopyList)
    da = daCopyList(m);
    if strcmp(daList(m).Status,'connected')
        connect(da);
    end
    groups = da.Group;
    for n = 1:length(groups)
        grp = groups(n);
        dataChangeFcn = grp.DataChangeFcn;
        grp.DataChangeFcn = dataChangeFcn{end};
        recAcqFcn = grp.RecordsAcquiredFcn;
        grp.RecordsAcquiredFcn = recAcqFcn{end};
        stopFcn = grp.StopFcn;
        grp.StopFcn = stopFcn{end};
    end
end

eval([varName, '= daCopyList;']);
% Save a copy in a MAT file
save(fileName,varName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function exporttomfile(fileName,varargin)
%EXPORTTOMFILE Copy OPC Toolbox objects to an m-file
%   EXPORTTOMFILE(VarName,FileName,Obj1, Obj2, ...) saves a vector, called
%   VarName, in the m-file, called FileName, containing copies of OPCDA
%   objects Obj1, Obj2, etc.

% Create the vector of opcda objects
daList = [varargin{:}];
% Create a copy of the vector of opcda objects
daCopyList = copyobj(daList);

% Connect where the object was previously connected and remove GUI callback
% properties from the group objects
for m = 1:length(daCopyList)
    da = daCopyList(m);
    if strcmp(daList(m).Status,'connected')
        connect(da);
    end
    groups = da.Group;
    for n = 1:length(groups)
        grp = groups(n);
        dataChangeFcn = grp.DataChangeFcn;
        grp.DataChangeFcn = dataChangeFcn{end};
        recAcqFcn = grp.RecordsAcquiredFcn;
        grp.RecordsAcquiredFcn = recAcqFcn{end};
        stopFcn = grp.StopFcn;
        grp.StopFcn = stopFcn{end};
    end
end

% Save a copy in a MAT file
obj2mfile(daCopyList,fileName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hostList, loadStruct] = importfromworkspace(opctoolClient)
%IMPORTFROMWORKSPACE Load all OPCDA objects in the base workspace
%   [HostList, LoadStruct] = IMPORTFROMWORKSPACE(Caller) loads all OPCDA
%   objects in the base workspace into the OPC GUI. The data passed to the
%   GUI consists of a list of host names and structure containing the
%   object hierarchy.

% Get all the variables in the base workspace
wsVars = evalin('base','whos');
da = [];
for m = 1:length(wsVars)
    if strcmp(wsVars(m).class,'opcda')
        % Extract the opcda objects
        thisDa = evalin('base',[wsVars(m).name,';']);
        if isvalid(thisDa)
            % Create a copy
            copyThisDa = copyobj(thisDa);
            for n = 1:length(copyThisDa)
                % Connnect where the object is connected in the workspace
                if strcmp(thisDa(n).Status,'connected')
                    connect(copyThisDa(n));
                end
            end
            % Add the copy to the list
            da = [da,copyThisDa(:)'];
        end
    end
end

if isempty(da)
    errMsg.identifier = 'opc:importfromworkspace:noclients';
    errMsg.message = 'No valid clients have been defined in the workspace.';
    rethrow(errMsg);
end

hostList = [];
loadStruct = createloadhierarchy(da, opctoolClient);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hostList, loadStruct] = importfrommatfile(fileName, opctoolClient)
%IMPORTFROMMATFILE Load all OPCDA objects in a specified MAT-file
%   [HostList, LoadStruct] = IMPORTFROMMATFILE(FileName, Caller) loads all
%   OPCDA objects in the MAT-file, called FileName, into the OPC GUI. The
%   data passed to the GUI consists of a list of host names and structure
%   containing the object hierarchy.

[hostList, loadStruct] = loadsession(fileName, opctoolClient);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startlogging(grp, node, loggingPanel)
%STARTLOGGING Configure callback functions and start logging
%   Data = STARTLOGGING(Obj, GroupLoggingPanel, Node,) sets the records
%   acquired function and stop function and starts the logging process.

% Update the status panel every 2.5 seconds or at least 20 times
grp.RecordsAcquiredFcnCount = max(min(2.5/grp.UpdateRate,grp.RecordsToAcquire/20), 1);
% Make sure that the records acquuired and stop functions are passed the
% correct parameters
thisRecAcqFn = grp.RecordsAcquiredFcn;
thisRecAcqFn{2} = node;
thisRecAcqFn{3} = loggingPanel;
grp.RecordsAcquiredFcn = thisRecAcqFn;
thisStopFn = grp.StopFcn;
thisStopFn{2} = node;
thisStopFn{3} = loggingPanel;
grp.StopFcn = thisStopFn;

% Start the logging session
start(grp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stoplogging(grp)
%STOPLOGGING Stop logging
%   Data = STOPLOGGING(Obj) stops logging.

stop(grp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData,itemGetData] = flushget(obj)
%FLUSHGET Flush the logged data and get all properties.
%   [GetData, ItemGetData] = FLUSHGET(Obj) flushes the data from the engine
%   for group object Obj and returns the OPC Toolbox object properties.

flushdata(obj);
[getData, itemGetData] = getpropdata(obj);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData,itemGetData] = exportloggeddata(grp,numRec,useStruct,varNameDataType,arrayVarNames)
%EXPORTLOGGEDDATA Get data from the OPC Toolbox Engine
%   [GetData, ItmGetData] = EXPORTLOGGEDDATA(Obj, NumRec, UseStruct,
%   VarDataType, ArrayNames) gets the NumRec records of data data from the
%   OPC Toolbox engine using peekdata and saves the data to the base
%   workspace. The data can be saved either as a structure or as an array
%   with given variables names.

recAvail = grp.RecordsAvailable;
if recAvail == 0
    errMsg.identifier = 'opc:exportloggeddata:norecords';
    errMsg.message = 'No records are available.';
    rethrow(errMsg);
end

if numRec == -1  
    % Use all records
    numRec = recAvail;
end

if numRec > recAvail
    warning('opc:exportloggeddata:insufficientrecords',...
        'You requested %n records, but there are currently only %d records available. Using %d records',...
        numRec, recAvail, recAvail)
    numRec = recAvail;
end

% Call peekdata to retrieve data
lastRecords = peekdata(grp, numRec);

if useStruct
    % Export the data in the form of a struct
    assignin('base',varNameDataType,lastRecords);
else
    % Export the data as an array
    [i, v, q, t, et] = opcstruct2array(lastRecords,varNameDataType);

    % Assign the data in the workspace
    assignin('base',arrayVarNames{1},i);
    assignin('base',arrayVarNames{2},v);
    assignin('base',arrayVarNames{3},q);
    assignin('base',arrayVarNames{4},t);
    assignin('base',arrayVarNames{5},et);
end
[getData, itemGetData] = getpropdata(grp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [getData,itemGetData] = plotloggeddata(grp,numRec,oneAxes,markBad,markRepeat)
%PLOTLOGGEDDATA Plots data retrieved from the OPC Toolbox Engine
%   [GetData, ItmGetData] = PLOTLOGGEDDATA(Obj, NumRec, OneAxes, MarkBad,
%   MarkRepeated)  plots NumRec records, logged by the OPC Toolbox engine.
%   The data can be plotted either all in the same axes or as subplots.

recAvail = grp.RecordsAvailable;
if recAvail == 0
    errMsg.identifier = 'opc:plotloggeddata:norecords';
    errMsg.message = 'No records are available.';
    rethrow(errMsg);
end

if numRec == -1  
    % Use all records
    numRec = recAvail;
end

if numRec > recAvail
    warning('opc:plotloggeddata:insufficientrecords',...
        'You requested %n records, but there are currently only %d records available. Using %d records',...
        numRec, recAvail, recAvail)
    numRec = recAvail;
end

% Call peekdata to retrieve data
lastRecords = peekdata(grp, numRec);
[i, v, q, t, et] = opcstruct2array(lastRecords);

if oneAxes
    % Must put all plots in one axis
    plot(t, v);
    axis tight
    datetick x keeplimits
    legend(i);
    hold on
    if markBad
        % Must show bad quality
        isBad = strncmp('Bad', q, 3);
        for k = 1:length(i)
            h = plot(t(isBad(:,k),k), v(isBad(:,k),k), 'o');
            set(h,'MarkerEdgeColor','k', 'MarkerFaceColor','r')
        end
    end
    if markRepeat
        % Must show repeat quality
        isRep = strncmp('Repeat', q, 6);
        for k = 1:length(i)
            h = plot(t(isRep(:,k),k), v(isRep(:,k),k), '*');
            set(h,'MarkerEdgeColor',[0.75, 0.75, 0]);
        end
    end
    hold off
else
    % Must put the plots in multiple axes
    for k = 1:length(i)
        subplot(length(i),1,k)
        plot(t(:,k), v(:,k));
        axis tight
        datetick x keeplimits
        title(i{k});
        hold on
        if markBad
            % Must show bad quality
            isBad = strncmp('Bad', q, 3);
            h = plot(t(isBad(:,k),k), v(isBad(:,k),k), 'o');
            set(h,'MarkerEdgeColor','k', 'MarkerFaceColor','r')
        end
        if markRepeat
            % Must show repeat quality
            isRep = strncmp('Repeat', q, 6);
            h = plot(t(isRep(:,k),k), v(isRep(:,k),k), '*');
            set(h,'MarkerEdgeColor',[0.75, 0.75, 0]);
        end
        hold off
    end
end

% Update the properties
[getData, itemGetData] = getpropdata(grp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hostList, loadStruct] = savedeleteopen(opctoolClient,saveFileName,openFileName,varargin)
%SAVEDELETEOPEN Save opcda objects, delete them and load new objects
%   [HostList, LoadStruct] = SAVEDELETEOPEN(Caller, SaveFileName, OpenFileName,
%   Obj1, Obj2, ...) saves OPCDA objects Obj1, Obj2, etc to the MAT-file
%   called SaveFileName, deletes Obj1, Obj2, etc from memory and then loads
%   the host list and OPCDA objects stored in OpenFileName.

% Create a vector of host and a vector of opcda objects
guiHostList = {};
daList = [];
deleteDaList = [];
for k = 1:length(varargin)
    if ischar(varargin{k})
        guiHostList{end+1} = varargin{k};
    elseif isa(varargin{k},'opcda')
        daList = [daList, copyobj(varargin{k})];
        deleteDaList = [deleteDaList, varargin{k}];
    end
end

% Remove GUI callback properties from the group objects
for m = 1:length(daList)
    da = daList(m);
    groups = da.Group;
    for n = 1:length(groups)
        grp = groups(n);
        dataChangeFcn = grp.DataChangeFcn;
        grp.DataChangeFcn = dataChangeFcn{end};
        recAcqFcn = grp.RecordsAcquiredFcn;
        grp.RecordsAcquiredFcn = recAcqFcn{end};
        stopFcn = grp.StopFcn;
        grp.StopFcn = stopFcn{end};
    end
end

opcVersion = opcmex('version');

% Save the objects to a mat file
save(saveFileName,'guiHostList','daList','opcVersion');

% Delete the objects
delete(deleteDaList);
% Load the new data
[hostList, loadStruct] = loadsession(openFileName, opctoolClient);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hostList, loadStruct] = deleteopen(opctoolClient,openFileName,varargin)
%DELETEOPEN Delete OPC objects and load new objects
%   [HostList, LoadStruct] = DELETEOPEN(Caller, OpenFileName, Obj1, Obj2, ...)
%   deletes Obj1, Obj2, etc from memory and then loads the host list and
%   OPCDA objects stored in OpenFileName.

% Create a vector of opcda objects
da = [varargin{:}];
% Delete the objects
delete(da);
% Load the new data
[hostList, loadStruct] = loadsession(openFileName, opctoolClient);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [servers,hostNode,hostName,serverID,mustConnect,caller,hostList,clientVector,currentClient] = getinstalledservers(hostNode, hostName, serverID, mustConnect,caller,hostList,clientVector,currentClient)
%GETINSTALLEDSERVERS Get all servers installed on a host
%   [servers, ...] = GETINSTALLEDSERVERS(HostNode, HostName, ServerID,
%   MustConnect) returns a list of all installed servers. The function also
%   returns input data required by the GUI.

opcSI = opcserverinfo(hostName);
servers = opcSI.ServerID;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function outData = tostring(inData)
% TOSTRING Convert a function handle or a cellarray containing function handles
% and other data types to a string.

if isa(inData,'function_handle')
    outData = ['@', func2str(inData)];
elseif iscell(inData)
    outData = '{';
    for k = 1:length(inData)
        outData = [outData, tostring(inData{k}), ','];
    end
    % Replace the unnecessary comma with a }
    outData(end) = '}';
elseif ~ischar(inData)
    % Convert numbers to eval'able strings
    outData = mat2str(inData);
else
    % Put the strings in quotes
    outData = ['''',inData,''''];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function editfile(cbFun)
%EDITFILE Open the callback function in the editor
%  EDITFILE(CallbackFcn) if possible, opens the callback function in the
%  editor.

% cbFun is passed as a string
% Remove insignificant whitespace from the callback string
cbFun = strtrim(cbFun);
% If the value is a string with the first character as @, set the
% value to a function handle. If the first character of the property
% value is a {, set it to a cell array.
if ~isempty(cbFun)
    if strcmp(cbFun(1),'@') || strcmp(cbFun(1),'{')
        % The value is a function handle or cell array, so eval to get
        % the correct property value
        cbFun = eval(cbFun);
    end
end
% Now open in the edito if possible
if isa(cbFun,'function_handle')
    edit(func2str(cbFun));
elseif iscell(cbFun)
    edit(cbFun{1});
elseif isempty(cbFun)
    edit('Untitled.m');
elseif ischar(cbFun)
    edit(cbFun);
end