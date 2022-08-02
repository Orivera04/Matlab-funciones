function [OK, ss] = xregImportDataStructure(data, filename, parent)
%XREGIMPORTDATASTRUCTURE dialog to convert a data structure to a sweepset
%
% [OK, SS] = XREGIMPORTDATASTRUCTURE(DataStructure, Filename)
%  
% Where the DataStructure is what would have been returned in the following
% DataStructure = load(filename).

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:32:47 $ 

if nargin < 3
    parent = [];
end

% Create a figure in which to draw the dialog.
f = xregdialog('Name', ['Loading Data from ' filename],...
	'visible','off',...
	'HandleVisibility','callback',...
	'Tag','workspaceimport');

xregcenterfigure(f, [800 450], parent);
f.MinimumSize = [750 300]; 

% Add some extra fields to the dialog to handle the data that we wish to
% attach to the figure etc.
schema.prop(f, 'Listeners', 'handle vector');
schema.prop(f, 'Sweepset', 'MATLAB array');
schema.prop(f, 'Treeview', 'handle');
schema.prop(f, 'Listview', 'handle');
schema.prop(f, 'btAdd', 'handle');
schema.prop(f, 'btRemove', 'handle');
schema.prop(f, 'btClear', 'handle');
schema.prop(f, 'CloseAction', 'string');

f.Treeview = i_createTreeView(f, filename, data);
f.Listview = i_createListView(f);

btAdd = xregGui.uicontrol('parent',f,...
    'string', '>',...
    'enable', 'off',...
    'callback', {@i_btAddClicked, f});

btRemove = xregGui.uicontrol('parent',f,...
    'string', '<',...
    'enable', 'off',...
    'callback', {@i_btRemoveClicked, f});

btClear = xregGui.uicontrol('parent',f,...
    'string', '<<',...
    'enable', 'off',...
    'callback', {@i_btRemoveAllClicked, f});

set(f, 'btAdd', btAdd, 'btRemove', btRemove, 'btClear', btClear);

btOK = xregGui.uicontrol('parent',f,...
    'style','push',...
    'callback', {@i_btOKClicked f},...
    'string','OK');

btCancel = xregGui.uicontrol('parent',f,...
    'style','push',...
    'callback', {@i_btCancelClicked f},...
    'string','Cancel');

btHelp = mv_helpbutton(f, 'xreg_data_importWorkspace');    

txResult = xregGui.uicontrol('Parent', f,...
    'style', 'text',...
    'horizontalalignment', 'left');

topLayout = xreggridbaglayout(f,...
    'dimension', [5 3],...
    'elements', {f.Treeview [] [] [] [] [] btAdd btRemove btClear [] f.Listview},...
    'gapx', 10,...
    'gapy', 5,...
    'rowsizes', [50 25 25 25 -1],...
    'colsizes', [-1 25 -1],...
    'colratios', [1 0 2],...
    'mergeblock', {[1 5] [1 1]},...
    'mergeblock', {[1 5] [3 3]});

resultPanel = xregframetitlelayout(f, ...
    'title', 'Result',...
    'center', txResult);

bottomLayout = xreggridbaglayout(f,...
    'dimension', [2 4],...
    'elements', {resultPanel [] [] btOK [] btCancel [] btHelp},...
    'gapx', 10,...
    'rowsizes', [-1 25],...
    'colsizes', [-1 65 65 65],...
    'mergeblock', {[1 2] [1 1]});

f.LayoutManager = xreggridbaglayout(f,...
    'dimension', [2 1],...
    'elements', {topLayout bottomLayout},...
    'gapy', 5,...
    'rowsizes', [-1 40],...
    'border', [10 10 10 10],...
    'packstatus', 'on');

% Listen for changes to the Sweepset property to update the tree correctly
f.Listeners = [...
        handle.listener(f, f.findprop('Sweepset'), 'PropertyPostSet', {@i_postSetSweepset, txResult});...
        handle.listener(f.Listview, 'KeyUp', @i_listviewKeyUp);...
        handle.listener(f.Listview, 'SweepsetChanged', @i_listviewSweepsetChanged);...
        handle.listener(f.Treeview, 'DblClick', @i_treeviewDoubleClick);...
        handle.listener(f.Treeview, 'NodeClick', {@i_treeviewNodeClick btAdd});...
    ];
% Set the callback target correctly
set(f.Listeners, 'CallbackTarget', f);
% Give the framework an initial sweepset to work with
f.Sweepset = sweepset;

f.showDialog(btOK);

OK = f;
% return
switch f.closeAction
    case 'ok'        
        ss = f.Sweepset;
        OK = true;
    otherwise
        ss = sweepset;
        OK = false;
end
delete(f);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function lv = i_createListView(f)
lv = xregdatagui.sweepsetlist('Parent', f,...
    'Editable', true,...
    'MultiSelect', true);
lv.setColumnHeaders({@mean @std}, {'Mean', 'Std. Dev'});

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function tv = i_createTreeView(f, filename, data)
% Create a treeview
tv = actxcontainer(xregGui.treeview([0 0 1 1], double(f)));
set(tv, 'indentation',20,...
   'hideselection', 0,...
   'labeledit', 1);
% Create the image list to be used in the treeview
imageList = xregGui.ILmanager;
imageList.IL.maskColor =  uint32(255*256);
bmp2ind(imageList, 'dataimport_root.bmp');
bmp2ind(imageList, 'dataimport_unknown.bmp');
bmp2ind(imageList, 'dataimport_vector_ok.bmp');
bmp2ind(imageList, 'dataimport_vector_notok.bmp');
bmp2ind(imageList, 'dataimport_array_ok.bmp');
bmp2ind(imageList, 'dataimport_array_notok.bmp');
bmp2ind(imageList, 'dataimport_struct_ok.bmp');
bmp2ind(imageList, 'dataimport_struct_notok.bmp');
bmp2ind(imageList, 'dataimport_cell_ok.bmp');
bmp2ind(imageList, 'dataimport_cell_notok.bmp');
tv.InsertImagelist(imageList.IL);
% Need to add a selectedNode property which is correctly updated when
% selectedItem changes
schema.prop(tv, 'RootNode', 'handle');
schema.prop(tv, 'SelectedNode', 'handle');
schema.prop(tv, 'Listeners', 'handle vector');
% Ensure that the next key function is initialised correctly
i_getNextKey(0);
% Create a root node
tv.RootNode = tv.Nodes.Add;
% Now add the required belgian chocolate
i_createRootNodeProperties(tv.RootNode, filename, data, tv.Nodes);
% Ensure that the first level is expanded
tv.RootNode.Expanded = true;
tv.RootNode.Selected = true;

% Listen for requests for the treeview SelectedNode property
tv.Listeners = [...
        handle.listener(tv, 'ObjectBeingDestroyed', @i_treeviewBeingDestroyed);...
        handle.listener(tv, tv.findprop('SelectedNode'), 'PropertyPreGet', @i_preGetSelectedNode);...
    ];
% Set the callback target correctly
set(tv.Listeners, 'CallbackTarget', tv);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_listviewKeyUp(f, event)
% First check no modifiers were pressed
if event.Shift == 0
    % Which key was pressed
    switch event.KeyCode
        case 46 % DELETE_KEY
            i_removeSelectedVariablesFromSweepset(f);
    end
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_listviewSweepsetChanged(f, event)
f.Sweepset = f.Listview.Sweepset;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_treeviewDoubleClick(f, event)
i_addSelectedVariableToSweepset(f);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_treeviewNodeClick(f, event, btAdd)
i_updateButtonState(f)

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_btAddClicked(src, event, f)
i_addSelectedVariableToSweepset(f);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_btRemoveClicked(src, event, f)
i_removeSelectedVariablesFromSweepset(f);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_btRemoveAllClicked(src, event, f)
f.Sweepset = sweepset;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_btOKClicked(src, event, f)
set(f, 'CloseAction', 'ok', 'visible', 'off');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_btCancelClicked(src, event, f)
set(f, 'CloseAction', 'cancel', 'visible', 'off');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_addSelectedVariableToSweepset(f)
% Get the selected node to return a sweepset struct
sst = feval(f.Treeview.SelectedNode.AddDataFcn, f.Treeview.SelectedNode, sweepset2struct(f.sweepset));
% Add to the framework
f.sweepset = struct2sweepset(sweepset, sst);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_removeSelectedVariablesFromSweepset(f)
% Which rows are being kept
rowsToKeep = setdiff(1:size(f.Sweepset, 2), f.Listview.SelectedRows);
% Update the sweepset - NOTE it's important to make the sweepset empty if
% there are no variables since it's the number of records that define an
% empty sweepset.
if isempty(rowsToKeep)
    f.Sweepset = sweepset;
else
    f.Sweepset = f.Sweepset(:, rowsToKeep);
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_updateButtonState(f)
% Can the current node be added to the sweepset
if f.Treeview.SelectedNode.CanAdd
    f.btAdd.Enable = 'on';
else
    f.btAdd.Enable = 'off';
end
% Can stuff be removed
if isempty(f.Sweepset)
    f.btRemove.Enable = 'off';
    f.btClear.Enable = 'off';
else
    f.btRemove.Enable = 'on';
    f.btClear.Enable = 'on';
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_postSetSweepset(f, event, txResult)
sz = size(f.Sweepset);
% Make sure that the tree nodes are up to date on the new sweepset
feval(f.Treeview.RootNode.CanAddFcn, f.Treeview.RootNode, f.Sweepset, sz(1));
txResult.string = [ 'Output data is : ' num2str(sz(1)) ' records x ' num2str(sz(2)) ' variables'];
% Make sure the listview is up-to-date
f.Listview.Sweepset = f.Sweepset;
% And the button state
i_updateButtonState(f);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_preGetSelectedNode(treeview, event)
treeview.SelectedNode = treeview.RootNode.find('-depth', Inf, 'Key', treeview.SelectedItem.Key);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_treeviewBeingDestroyed(treeview, event)
% Before the figure is destoryed we need to unlink the activeX nodes
i_unlinkNode(treeview.RootNode);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_unlinkNode(node)
% Disconnect this node
node.disconnect;
% And it's children
while ~isempty(node.down)
    i_unlinkNode(node.down)
end

%------------------------------------------------------------------------
%
% Code here is helper code for the interfaces used below in the node type
% code
%
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [type, typeName] = i_getDataType(data)
% Here are the rules - 
typeName = class(data);
if isnumeric(data) & ndims(data) == 2
    if any(size(data) == 1)
        type = 'VECTOR';
    else
        type = 'ARRAY';
    end
elseif isstruct(data) & numel(data) == 1
    if isSweepsetStruct(sweepset, data)
        type = 'SSSTRUCT';
        typeName = 'MBC data structure';
    else
        type = 'STRUCT';
end
elseif iscell(data)
    type = 'CELL';
else
    type = 'UNKNOWN';
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function name = i_getNamePrefix(node)
if isempty(node.name)
    name = '';
else
    name = [node.name '_'];
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function key = i_getNextKey(newKey)
% Hold a persistent reference to the next key
persistent nextKey
% Better try and initialise key if it's empty
if nargin == 1
    nextKey = newKey;
elseif isempty(nextKey)
    nextKey = 1;    
end
% Return a string
key = sprintf('K%d', nextKey);
% Increment the key
nextKey = nextKey + 1;

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_createRootNodeProperties(node, name, data, nodes)
% Get the key for the root node
node.Key = i_getNextKey;
% Run the general create on this node
i_createNode(node, '', data, nodes, 1);
% Now make modifications
set(node, 'Text', name,...
    'Type', 'ROOT',...
    'LocalData', data,...
    'CanAddFcn', @i_canAddDataROOT);
node.Listeners(1).Enable = 'off';

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_createNode(node, name, data, nodes, index)
% Add the required properties to this node
schema.prop(node, 'Type', 'string');
schema.prop(node, 'TypeName', 'string');
schema.prop(node, 'Size', 'MATLAB array');
schema.prop(node, 'Name', 'string');
schema.prop(node, 'ChildIndex', 'double');
schema.prop(node, 'LocalData', 'MATLAB array');
schema.prop(node, 'CanAdd', 'bool');
schema.prop(node, 'CanAddFcn', 'MATLAB callback');
schema.prop(node, 'AddDataFcn', 'MATLAB callback');
schema.prop(node, 'Listeners', 'handle vector');

% Fill out the new properties for the node
[node.Type, node.TypeName] = i_getDataType(data);
node.Size       = size(data);
node.Name       = name;
node.ChildIndex = index;
node.CanAddFcn  = str2func(['i_canAddData' node.Type]);
node.AddDataFcn = str2func(['i_addData' node.Type]);
sizeStr = num2str(node.Size(1));
for i = 2:length(node.Size)
    sizeStr = [sizeStr ' x ' num2str(node.Size(i))];
end
node.Text = [name '   (' sizeStr ' ' node.TypeName ')'];

% Now fill out the children of this node
childCreateFcn = str2func(['i_createChildrenOf' node.Type]);
feval(childCreateFcn, node, data, nodes);

% Listen for requests to the local data property
node.Listeners = [...
        handle.listener(node, node.findprop('LocalData'), 'PropertyPreGet', str2func(['i_preGetLocalData' node.Type]));...
    ];
set(node.Listeners, 'CallbackTarget', node);


%------------------------------------------------------------------------
%
% Code here is related to the node interface types specified in the 
% CreateNode function. Each defined type must implement the correct
% interface. The defined types are - 
%   ROOT is a special type indicating that this is the root node - it is
%        very similar to a STRUCT node and has the same methods.
%   ARRAY is an m x n numeric array
%   VECTOR is a 1 x m or m x 1 numeric array
%   SSSTRUCT is a 1 x 1 structure that returns true from isSweepsetStruct
%   STRUCT is any other 1 x 1 struct array
%   CELL is a cell array
%   UNKNOWN is everything else
%
% And the currently defined interface functions are - 
%   void = i_createChildrenOfTYPE(node, nodeData, nodes)
%   [bool, newNumRec] = i_canAddDataTYPE(node, sweepset, numRec)
%   ssstruct = i_addDataTYPE(node, ssstruct)
%   void = i_preGetLocalDataTYPE(node, event) 
%
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
% i_createChildrenOf TYPE
%
%------------------------------------------------------------------------
%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_createChildrenOfUNKNOWN(node, data, nodes)
% Do nothing

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_createChildrenOfVECTOR(node, data, nodes)
% Do nothing

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_createChildrenOfARRAY(node, data, nodes)
% Define the child node type
tvwChild = 4;
% Iterate over the columns of the array
for i = 1:size(data, 2)
    % Create a child node with no key and the appropriate text
    child = nodes.Add(node, tvwChild, i_getNextKey);
    % Connect the child in the heirarchy
    node.connect(child, 'down');
    % Fill that node with the right stuff
    childName = [i_getNamePrefix(node) num2str(i)];
    i_createNode(child, childName, data(:, i), nodes, i);
end

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_createChildrenOfSTRUCT(node, data, nodes)
% Get the field in the structure
fields = fieldnames(data);
% Define the child node type
tvwChild = 4;
% Iterate over each element and create it
for i = 1:length(fields)
    % Create a child node with no key and the appropriate text
    child = nodes.Add(node, tvwChild, i_getNextKey);
    % Connect the child in the heirarchy
    node.connect(child, 'down');
    % Fill that node with the right stuff
    childName = [i_getNamePrefix(node) fields{i}];
    i_createNode(child, childName, data.(fields{i}), nodes, i);
    % Add the local data to the child
    child.LocalData = data.(fields{i});
end

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_createChildrenOfCELL(node, data, nodes)
% Define the child node type
tvwChild = 4;
% Iterate over the columns of the array
for i = 1:numel(data)
    % Create a child node with no key and the appropriate text
    child = nodes.Add(node, tvwChild, i_getNextKey);
    % Connect the child in the heirarchy
    node.connect(child, 'down');
    % Fill that node with the right stuff
    childName = [i_getNamePrefix(node) num2str(i)];
    i_createNode(child, childName, data{i}, nodes, i);
    % Add the local data to the child
    child.LocalData = data{i};
end

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_createChildrenOfSSSTRUCT(node, data, nodes)
% Do nothing

%------------------------------------------------------------------------
%
% i_preGetLocalData TYPE
%
%------------------------------------------------------------------------
%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_preGetLocalDataUNKNOWN(node, event)
% Do nothing
node.LocalData = [];

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_preGetLocalDataVECTOR(node, event)
if isempty(node.LocalData)
    node.LocalData = node.up.LocalData(:, node.ChildIndex);
end
% Ensure it's a column vector of doubles
node.LocalData = double(node.LocalData(:));

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_preGetLocalDataARRAY(node, event)
% Ensure it's an array of doubles
node.LocalData = double(node.LocalData);

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_preGetLocalDataSTRUCT(node, event)
% Do nothing

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_preGetLocalDataCELL(node, event)
% Do nothing

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function i_preGetLocalDataSSSTRUCT(node, event)
% Do nothing

%------------------------------------------------------------------------
%
% i_canAddData TYPE
%
%------------------------------------------------------------------------
%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function [OK, newNumRec] = i_canAddDataROOT(node, ss, numRec)
[OK, newNumRec] = i_canAddDataSTRUCT(node, ss, numRec);
node.image = 1;

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function [OK, newNumRec] = i_canAddDataUNKNOWN(node, ss, numRec)
% Cannot add UNKNOWN data
OK = false;
newNumRec = -1;
node.CanAdd = OK;
node.image = 2;

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function [OK, newNumRec] = i_canAddDataVECTOR(node, ss, numRec)
% Can add a vector if the sweepset is empty or of the same number of
% records as in the data
newNumRec = length(node.LocalData);
if numRec == 0 | numRec == newNumRec
    OK = true; 
    icon = 3;
else
    OK = false; 
    icon = 4;
end
node.CanAdd = OK;
node.image = icon;

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function [OK, newNumRec] = i_canAddDataARRAY(node, ss, numRec)
nextChild = node.down;
% Iterate over each child
while ~isempty(nextChild)
    i = nextChild.childIndex;
    % Update the child
    feval(nextChild.canAddFcn, nextChild, ss, numRec);
    % Get the nextChild
    nextChild  = nextChild.right;
end
% Can add an array if the sweepset is empty or of the same number of
% records as in the data
newNumRec = size(node.LocalData, 1);
if numRec == 0 | numRec == newNumRec
    OK = true; 
    icon = 5;
else
    OK = false; 
    icon = 6;
end
node.CanAdd = OK;
node.image = icon;

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function [OK, newNumRec] = i_canAddDataSTRUCT(node, ss, numRec)
% Default starting position
newNumRec = -1;
icon = 8;
nextChild = node.down;
childOK = false;
% Iterate over each child
while ~isempty(nextChild)
    i = nextChild.childIndex;
    % Ask the child
    [childOK(i), childNumRec(i)] = feval(nextChild.canAddFcn, nextChild, ss, numRec);
    % Get the nextChild
    nextChild  = nextChild.right;
end
OK = all(childOK) && all(childNumRec == childNumRec(1));
node.CanAdd = OK;
if OK
    newNumRec = childNumRec(1);
    icon = 7;
end
node.image = icon;

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function [OK, newNumRec] = i_canAddDataCELL(node, ss, numRec)
% Default starting position
newNumRec = -1;
icon = 10;
nextChild = node.down;
childOK = false;
% Iterate over each child
while ~isempty(nextChild)
    i = nextChild.childIndex;
    % Ask the child
    [childOK(i), childNumRec(i)] = feval(nextChild.canAddFcn, nextChild, ss, numRec);
    % Get the nextChild
    nextChild  = nextChild.right;
end
OK = all(childOK) && all(childNumRec == childNumRec(1));
node.CanAdd = OK;
if OK
    newNumRec = childNumRec(1);
    icon = 9;
end
node.image = icon;

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function [OK, newNumRec] = i_canAddDataSSSTRUCT(node, ss, numRec)
% Can add a sweepset structure if the sweepset is empty or of the same number of
% records as in the data
newNumRec = size(node.LocalData.data, 1);
if numRec == 0 | numRec == newNumRec
    OK = true;
    icon = 5;
else
    OK = false;
    icon = 6;
end
node.CanAdd = OK;
node.image = icon;

%------------------------------------------------------------------------
%
% i_addData TYPE
%
%------------------------------------------------------------------------
%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function sst = i_addDataUNKNOWN(node, sst)
% Do nothing

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function sst = i_addDataVECTOR(node, sst)
% Can this node be added
if node.CanAdd
    sst.varNames = generateValidUniqueNames([sst.varNames {node.Name}]);
    sst.varUnits = [sst.varUnits {''}];
    sst.data     = [sst.data node.LocalData];
end

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function sst = i_addDataARRAY(node, sst)
% Can this node be added
if node.CanAdd
    % Get the child node names
    nextChild = node.down;
    % Iterate over each child
    for i = 1:size(node.LocalData, 2)
        childNames{i} = nextChild.name;
        % Get the nextChild
        nextChild  = nextChild.right;
    end
    sst.varNames = generateValidUniqueNames([sst.varNames childNames]);
    sst.varUnits = [sst.varUnits repmat({''}, size(childNames))];
    sst.data     = [sst.data node.LocalData];
end

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function sst = i_addDataSTRUCT(node, sst)
% Can this node be added
if node.CanAdd
    nextChild = node.down;
    % Iterate over each child
    while ~isempty(nextChild)
        % Ask the child to add it's data
        sst = feval(nextChild.addDataFcn, nextChild, sst);
        % Get the nextChild
        nextChild  = nextChild.right;
    end    
end

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function sst = i_addDataCELL(node, sst)
% Can this node be added
if node.CanAdd
    nextChild = node.down;
    % Iterate over each child
    while ~isempty(nextChild)
        % Ask the child to add it's data
        sst = feval(nextChild.addDataFcn, nextChild, sst);
        % Get the nextChild
        nextChild  = nextChild.right;
    end    
end

%------------------------------------------------------------------------
% 
%------------------------------------------------------------------------
function sst = i_addDataSSSTRUCT(node, sst)
% Can this node be added
if node.CanAdd
    sst.varNames = generateValidUniqueNames([sst.varNames node.LocalData.varNames]);
    sst.varUnits = [sst.varUnits node.LocalData.varUnits];
    sst.data     = [sst.data node.LocalData.data];
end
