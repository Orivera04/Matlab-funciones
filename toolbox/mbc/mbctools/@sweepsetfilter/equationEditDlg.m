function [OK, out1, out2, out3] = equationEditDlg(ssf, hParent, varargin)
%EQUATIONEDITDLG method to generate a dialog to edit an equation
%
%  OUT = EQUATIONEDITDLG(SSF, HPARENT, TYPE, INDEX)
%  
%   This function allows you to add, edit or delete the expression type defined
%   by type and referenced by expression type

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.6.3 $    $Date: 2004/04/12 23:34:58 $ 

data = struct('DISPLAY_LIST', false,...
    'DISPLAY_UNITS', false,...
    'DISPLAY_NOTES', false,...
    'ExpressionType', '',...
    'ExpressionField', '',...
    'ExpressionField2', '',...
    'TitleString', '',...
    'HelpString', '',...
    'ListString', '',...
    'HelpID', '',...
    'InitialIndex', [],...
    'InitialEquation', '',...
    'funcs', []);

% Iterate through the property value pairs
for i = 1:2:length(varargin)
    switch lower(varargin{i})
        case 'type'
            data.ExpressionType = varargin{i+1};
        case 'index'
            data.InitialIndex = varargin{i+1};
        case 'list'
            data.DISPLAY_LIST = strcmp(varargin{i+1}, 'on');
        case 'equation'
            data.InitialEquation = varargin{i+1};
        otherwise
            error('mbc:sweepsetfilter:InvalidProperty', 'Invalid Property');
    end
end

switch lower(data.ExpressionType)
    case 'filters'
        data.HelpString = strvcat('Specify an equation which is true for records you want to keep',...
            'e.g. to keep RPM greater than 1000 specify RPM > 1000');
        data.HelpID = 'xreg_filterEditor';
        data.TitleString = 'Filter Editor';
        data.ListString = 'Currently defined filters';
        data.ExpressionField{1} = 'filterExp';
        data.NewItemString = 'New Filter %d';
        data.funcs = struct('Add', @addFilter, 'Modify', @modifyFilter, 'Remove', @removeFilter, 'Args', 1);
    case 'variables'
        data.HelpString = strvcat('Specify the equation of the new variable',...
            'e.g. NEW_VAR = OLD_VAR * 3 + OLD_VAR_1');
        data.HelpID = 'xreg_variableEditor';
        data.TitleString = 'Variable Editor';
        data.ListString = 'Currently defined variables';
        data.ExpressionField{1} = 'varString';
        data.ExpressionField{2} = 'varUnit';
        data.NewItemString = 'New Variable %d';
        data.funcs = struct('Add', @addVariable, 'Modify', @modifyVariable, 'Remove', @removeVariable, 'Args', 2);
        data.DISPLAY_UNITS = true;
    case 'sweepnotes'
        data.HelpString = strvcat('Specify an equation which is true for tests you want to note',...
            'e.g. to note tests with mean(RPM) greater than 1000 specify mean(RPM) > 1000');
        data.HelpID = 'xreg_filterEditor';
        data.TitleString = 'Test Note Editor';
        data.ListString = 'Currently defined test notes';
        data.ExpressionField{1} = 'noteExp';
        data.ExpressionField{2} = 'noteString';
        data.ExpressionField{3} = 'noteColor';
        data.NewItemString = 'New Test Note %d';
        data.funcs = struct('Add', @addSweepNote, 'Modify', @modifySweepNote, 'Remove', @removeSweepNote, 'Args', 3);
        data.DISPLAY_NOTES = true;
    case 'sweepfilters'
        data.HelpString = strvcat('Specify an equation which is true for tests you want to keep',...
            'e.g. to keep tests with mean(RPM) greater than 1000 specify mean(RPM) > 1000');
        data.HelpID = 'xreg_filterEditor';
        data.TitleString = 'Test Filter Editor';
        data.ListString = 'Currently defined test filters';
        data.ExpressionField{1} = 'filterExp';
        data.NewItemString = 'New Test Filter %d';
        data.funcs = struct('Add', @addSweepFilter, 'Modify', @modifySweepFilter, 'Remove', @removeSweepFilter, 'Args', 1);
    otherwise
        error('mbc:sweepsetfilter:InvalidArgument', 'Unknown edit type');
end

% Run the equation editor
[OK, out1, out2, out3] = i_createDialog(ssf, hParent, data);

% --------------------------------------------------------------------
% Function i_createFigure
%
% --------------------------------------------------------------------
function [OK, out1, out2, out3] = i_createDialog(ssf, hParent, data, varargin)
% Check that the equation editor doesn't exist
fh = mvf('EquationEditor');
if ~isempty(fh)
    delete(fh)
end
% Create runtime pointers to hold relevent data
pHandles = xregGui.RunTimePointer;

f = xregGui.figure('visible', 'off',...
    'name', data.TitleString,...
    'units', 'pixels',...
    'tag', 'EquationEditor',...
    'pointer', 'watch',...
    'closerequestfcn', {@i_cancel, pHandles},...   
    'windowstyle', 'modal', ...
    'color', get(0,'defaultuicontrolbackgroundcolor'),...
    'minimumsize', [300 200]);

% Determine the size of the figure by looking to see if the list is being
% displayed
figureSize = [420 300];
if data.DISPLAY_LIST
    figureSize = figureSize + [200 0];
end
% Add extra height to sweep notes
if data.DISPLAY_NOTES
    figureSize = figureSize + [0 100];
end

% Center the figure on the parent figure
xregcenterfigure(f, figureSize, hParent);
f.MinimumSize = figureSize;

pHandles.LinkToObject(f);

% Set the default outputs correctly
f.userdata = struct('OK', false, 'out1', [], 'out2', [], 'out3', []);
if data.DISPLAY_LIST
    f.userdata.out1 = ssf;
end

% Create the layout (based on the data)
f.LayoutManager = i_createLayout(f, data, pHandles);
set(f.LayoutManager, 'packstatus', 'on');


% Fill in the data
i_updateData(ssf, pHandles, data, varargin{:});

% Set the visibility and wait for it to change
set(f, 'visible', 'on', 'pointer', 'arrow');
waitfor(f, 'visible', 'off');

% Get the return
OK = f.userdata.OK;
out1 = f.userdata.out1;
out2 = f.userdata.out2;
out3 = f.userdata.out3;

delete(f);

% --------------------------------------------------------------------
% Function i_createLayout
%
% --------------------------------------------------------------------
function layout = i_createLayout(fh, data, pHandles)

h.figure = handle(fh);

fh = double(fh);
txHelp = xregGui.uicontrol('parent', fh,...
    'style', 'text',...
    'string', data.HelpString,...
    'horizontal','left');

h.out1 = xregGui.uicontrol('parent',fh,...
    'style','edit',...
    'background', 'w',...
    'horizontal','left',...
    'callback', {@i_outEdited pHandles data});

% General name for the editing area
editor = h.out1;
editorHeight = 20;

h.out2 = [];
h.out3 = [];

% TO DO - Add extra features in here
if data.DISPLAY_UNITS || data.DISPLAY_NOTES
    h.out2 = xregGui.uicontrol('parent',fh,...
        'style','edit',...
        'background', 'w',...
        'horizontal','left',...
        'callback', {@i_outEdited pHandles data});
    
    if data.DISPLAY_NOTES
        out2Text = 'Test Note :';
        labelSize = 60;
    else
        out2Text = 'Variable Unit :';
        labelSize = 70;
    end
    
    txOut2 = xregGui.labelcontrol('parent', fh,...
        'LabelSizeMode', 'Absolute',...
        'ControlSizeMode', 'Relative',...
        'ControlSize', 1,...
        'LabelSize', labelSize,...
        'Control', h.out2,...
        'String', out2Text);
    
    % Need to add the color picker for sweep notes
    if data.DISPLAY_NOTES       
        h.out3 = xregGui.uicontrol('parent', fh,...
            'style', 'push',...
            'callback', {@i_out3Clicked pHandles data},...
            'backgroundcolor', [1 0 0]);
        
        txOut3 = xregGui.labelcontrol('parent', fh,...
            'LabelSizeMode', 'Relative',...
            'ControlSizeMode', 'Absolute',...
            'ControlSize', 20,...
            'LabelSize', 1,...
            'Control', h.out3,...
            'String', 'Note Colour :');
        
        editor = xreggridbaglayout(fh,...
            'dimension', [3 1],...
            'elements', {h.out1 txOut2 txOut3},...
            'gapy', 10);
        
        editorHeight = 80;
    else
        editor = xreggridbaglayout(fh,...
            'dimension', [2 1],...
            'elements', {h.out1 txOut2},...
            'gapy', 10);
        
        editorHeight = 50;
    end
end

callbacks = '';
cols = {'Variable' 'Min' 'Max' 'Mean' 'Std. Dev.' 'Units'};
width = [100 50 50 50 50 50];
h.lvVars = xregGui.listview([10 10 1 1],fh,callbacks);
set(h.lvVars, 'View', 3, 'labeledit', 1, 'fullRowSelect', 1, 'gridlines', 1);
hCols = h.lvVars.ColumnHeaders;
for i = 1:length(cols)
    hItem = hCols.Add;
    hItem.Text = cols{i};
    hItem.Width = width(i);
end

h.COMListeners = [...
        handle.listener(h.lvVars, 'DblClick', {@i_listviewDoubleClick pHandles data});...
    ];

btOK = uicontrol('parent',fh,...
    'style','push',...
    'callback', {@i_close pHandles},...
    'position', [0 0 65 25],...
    'string','OK');

btCancel = uicontrol('parent',fh,...
    'style','push',...
    'callback', {@i_cancel pHandles},...
    'position', [0 0 65 25],...
    'string','Cancel');

btHelp = mv_helpbutton(fh, data.HelpID);

flowL = xregflowlayout(fh,...
    'orientation', 'right/center',...
    'elements', {btHelp btCancel btOK},...
    'gap', 10);

% Is the Left hand list being displayed?
if data.DISPLAY_LIST
    txList = uicontrol('parent', fh,...
        'style', 'text',...
        'string', data.ListString,...
        'horizontal','left');
    
    h.list = xregGui.listeditor(fh,...
        'AddItemMode', 'unboundlist',...
        'BackgroundColor', [1 1 1],...
        'NewItemTemplate', data.NewItemString,...
        'ListSelectionFcn', {@i_listSelection pHandles data},...
        'ListReorderFcn', {@i_listReorder pHandles data},...
        'AddItemFcn', {@i_listAddItem pHandles data},...
        'DeleteItemFcn', {@i_listDeleteItem pHandles data});
    
    layout = xreggridbaglayout(fh,...
        'dimension', [4 2],...
        'elements', {txList h.list [] [] txHelp editor actxcontainer(h.lvVars) flowL},...
        'gap', 10,...
        'border', [10 10 10 10],...
        'rowsizes', [30 editorHeight -1 30],...
        'colsizes', [200 -1],...
        'mergeblock', {[2 3] [1 1]});    
else
    layout = xreggridbaglayout(fh,...
        'dimension', [4 1],...
        'elements', {txHelp editor actxcontainer(h.lvVars) flowL},...
        'gap', 10,...
        'border', [10 10 10 10],...
        'rowsizes', [30 editorHeight -1 30]);
end

% Set the handle data
pHandles.info = h;

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_updateData(ssf, pHandles, data, varargin)

% First fill in the variables
ss = sweepset(ssf);
out = get(ss, {'name' 'units'});
names = out{1};
units = out{2};
ssData  = double(ss);
% Check that there actually is some data
if isempty(ssData)
    ssData = NaN*ones(1, length(names));
end
mn   = min(ssData, [], 1);
mx   = max(ssData, [], 1);
ave  = mean(ssData, 1);
stdev   = std(ssData, 0, 1);

for i = 1:length(names)
    item = pHandles.info.lvVars.ListItems.Add;
    i_setListItemInfo(item, names{i}, mn(i), mx(i), ave(i), stdev(i), units{i})
end

% Get the status for the ExpressionType
status = get(ssf, data.ExpressionType);

if data.DISPLAY_LIST && ~isempty(status)
    % Fill in the list
    list = pHandles.info.list;
    [strings{1:length(status)}] = deal(status.(data.ExpressionField{1}));
    list.ItemList = strings;
    list.Value = 1:length(strings);
    
    % Fill in the current equation
    if isempty(data.InitialIndex)
        data.InitialIndex = 1;
    end
    
    list.SelectedItem = data.InitialIndex;
    % Update the equation
    i_listSelection([], [], pHandles, data);
elseif ~isempty(data.InitialIndex) && data.InitialIndex <= length(status)
    i_setEditor(pHandles, data, ssf, data.InitialIndex)
else
    % Set the initial equation
    set(pHandles.info.out1, 'string', data.InitialEquation);
end

% Need to add extra stuff for 
% --------------------------------------------------------------------
% Listview double clicked so add the text to the end of the out1 text
% --------------------------------------------------------------------
function i_setListItemInfo(item, name, min, max, ave, stdev, unit)
item.Text = name;
set(item, 'SubItems', 1, num2str(min));
set(item, 'SubItems', 2, num2str(max));
set(item, 'SubItems', 3, num2str(ave));
set(item, 'SubItems', 4, num2str(stdev));
set(item, 'SubItems', 5, char(unit));


% --------------------------------------------------------------------
% Listview double clicked so add the text to the end of the out1 text
% --------------------------------------------------------------------
function i_listviewDoubleClick(src, event, pHandles, data)
% Only respond to a double click if there is at least one object in the list
if ~data.DISPLAY_LIST || length(pHandles.info.list.ItemList) > 0
    out1 = handle(pHandles.info.out1);
    out1.string = [out1.String ' ' src.SelectedItem.Text];
    i_outEdited(src, event, pHandles, data);
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_listSelection(src, event, pHandles, data)
f = pHandles.info.figure;
list = pHandles.info.list;
% Disable move buttons except for variables
if ~strcmpi(data.ExpressionType, 'variables')
    set(list.pr_buttons(2:3), 'enable', 'off');
end
i_setEditor(pHandles, data, f.userdata.out1, list.SelectedItem);

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_setEditor(pHandles, data, ssf, index)
f = pHandles.info.figure;
if isempty(index) || index < 1 || isempty(get(ssf, data.ExpressionType))
    set(pHandles.info.out1, 'string', '', 'enable', 'off');
    set(pHandles.info.out2, 'string', '', 'enable', 'off');
    set(pHandles.info.out3, 'backgroundcolor', [1 0 0], 'enable', 'off');
else
    status = get(ssf, data.ExpressionType, index);
    set(pHandles.info.out1, 'string', status.(data.ExpressionField{1}), 'enable', 'on');
    if data.funcs.Args > 1
        set(pHandles.info.out2, 'string', status.(data.ExpressionField{2}), 'enable', 'on');
    end
    if data.funcs.Args > 2
        set(pHandles.info.out3, 'backgroundcolor', status.(data.ExpressionField{3}), 'enable', 'on');
    end
end


% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_listAddItem(src, event, pHandles, data)
f = pHandles.info.figure;
list = pHandles.info.list;
switch data.funcs.Args 
    case 1
        f.userdata.out1 = feval(data.funcs.Add, f.userdata.out1, '');
    case 2
        f.userdata.out1 = feval(data.funcs.Add, f.userdata.out1, '', '');
    case 3
        f.userdata.out1 = feval(data.funcs.Add, f.userdata.out1, '', '', '');
end
% Ensure the list is ordered first to last
list.Value = 1:length(list.Value);
% Update the equation
i_listSelection([], [], pHandles, data);

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_listDeleteItem(src, event, pHandles, data)
f = pHandles.info.figure;
% Might need to remove the variable from the list of available variables
if isequal(data.ExpressionType, 'variables')
    variableBefore = get(f.userdata.out1, 'variables', event.data.ItemDeleted);
    % Ensure the variable is flaged as bad after
    variableAfter.OK = false;
    % Update the Listview
    i_updateVariableInListview(f.userdata.out1, variableBefore, variableAfter, pHandles, data);
end
% Remove the item from the sweepsetfilter
f.userdata.out1 = feval(data.funcs.Remove, f.userdata.out1, event.data.ItemDeleted);
% Update the equation
i_listSelection([], [], pHandles, data);

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_listReorder(src, event, pHandles, data)
f = pHandles.info.figure;
list = pHandles.info.list;
index = list.value;
% Get the state before
variablesBefore = get(f.userdata.out1, 'variables');
% Reorder the variables
f.userdata.out1 = reorderVariable(f.userdata.out1, index);
% Get the state after
variablesAfter = get(f.userdata.out1, 'variables');
% Reorder the Itemlist
list.ItemList = list.ItemList(index);
% Ensure the list is ordered first to last
list.Value = 1:length(list.Value);
% Update the Listview
i_updateVariableInListview(f.userdata.out1, variablesBefore, variablesAfter, pHandles, data);

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_updateVariableInListview(ssf, varsBefore, varsAfter, pHandles, data)
% Get the Listview
listview = pHandles.info.lvVars;
% Iterate over all variables sent in
for i = 1:length(varsBefore)
    before = varsBefore(i);
    after  = varsAfter(i);
    % Has anything changed?
    if isequal(before, after)
        continue
        % OK before - not OK after? Delete the before value
    elseif before.OK & ~after.OK
        % Find the variable to delete
        indexToDelete = i_findVariableInListview(before.varName, listview);
        % Remove the item
        listview.ListItems.Remove(indexToDelete);
        % OK after - need to add or modify an element
    elseif after.OK
        % Was it OK before or do we need to add a new item
        if before.OK
            [index, item] = i_findVariableInListview(before.varName, listview);
        else
            item = listview.ListItems.Add;
        end
        % Set its text and bail
        d = double(ssf.variableSweepset(:, after.varName));
        % Set the item text
        i_setListItemInfo(item, after.varName, min(d), max(d), mean(d), std(d), after.varUnit)
    end
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function [index, item] = i_findVariableInListview(varName, listview)
% Default return values if not found
index = [];
item = [];
% Get the ListItems
listitems = listview.ListItems;
% Go through the listview until we find the one match
for i = 1:listitems.Count
    if isequal(varName, listitems.Item(i).Text)
        index = i;
        item = listitems.Item(i);
        break
    end
end

% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_outEdited(src, event, pHandles, data)
f = pHandles.info.figure;
out1 = handle(pHandles.info.out1);
out2 = handle(pHandles.info.out2);
out3 = handle(pHandles.info.out3);
% Different behaviour when list is displayed
if data.DISPLAY_LIST
    list = pHandles.info.list;
    % Might need to remove the variable from the list of available variables
    if isequal(data.ExpressionType, 'variables')
        variableBefore = get(f.userdata.out1, 'variables', list.SelectedItem);
    end
    switch data.funcs.Args 
        case 1
            f.userdata.out1 = feval(data.funcs.Modify, f.userdata.out1, list.SelectedItem, out1.String);
        case 2
            f.userdata.out1 = feval(data.funcs.Modify, f.userdata.out1, list.SelectedItem, out1.String, out2.String);
        case 3
            f.userdata.out1 = feval(data.funcs.Modify, f.userdata.out1, list.SelectedItem, out1.String, out2.String, out3.BackgroundColor);            
    end
    % Update the list
    list.ItemList{list.SelectedItem} = out1.String;
    % Update the equation
    i_listSelection([], [], pHandles, data);
    % Might need to remove the variable from the list of available variables
    if isequal(data.ExpressionType, 'variables')
        variableAfter = get(f.userdata.out1, 'variables', list.SelectedItem);
        % Update the Listview
        i_updateVariableInListview(f.userdata.out1, variableBefore, variableAfter, pHandles, data);
    end
else
    f.userdata.out1  = out1.String;
    if data.funcs.Args > 1
        f.userdata.out2  = out2.String;
    end
    if data.funcs.Args > 2
        f.userdata.out3  = out3.BackgroundColor;
    end
end


% --------------------------------------------------------------------
%
% --------------------------------------------------------------------
function i_out3Clicked(src, event, pHandles, data)
% Get the new color
color = uisetcolor;
% Was OK clicked
if length(color) == 3
    % Update the button color
    set(src, 'backgroundcolor', color);
    % Update the outputs
    i_outEdited(src, event, pHandles, data);
end

% --------------------------------------------------------------------
% Function i_close
%
% --------------------------------------------------------------------
function i_close(src, event, pHandles)
f = pHandles.info.figure;
f.userdata.OK = true;
f.visible = 'off';

% --------------------------------------------------------------------
% Function i_cancel
%
% --------------------------------------------------------------------
function i_cancel(src, event, pHandles)
f = pHandles.info.figure;
f.userdata.OK = false;
f.visible = 'off';
