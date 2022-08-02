function [OK, props] = plotPropertiesDlg(ss, parent, props)
%SWEEPPLOTPROPERTIESDLG property dialog for a sweepplot
%
%  [OK, PROPS] = PLOTPROPERTIESDLG(SS, PARENT, PROPS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/04/04 03:31:57 $ 

% Clear up any pre-existing figures
fh = mvf('sweepplotPlotPropertiesDlg');
if ~isempty(fh)
	delete(fh);
end

if nargin < 3
    props = [];
end

if nargin < 2
    parent = [];
end

f = xregdialog('Name','Change Plot Properties',...
	'tag','sweepplotPlotPropertiesDlg',...
	'closerequestfcn',{@i_close 'cancel'},... 
	'renderer', 'painters',...
    'resize', 'off');

fh = double(f);
xregcenterfigure(fh, [400 180], parent);

% Add a property to define the close action
schema.prop(f, 'closeAction', 'string');

[mainLayout, ud] = i_createLayout(fh, props);

% Add the OK and Cancel buttons
btOK = xregGui.uicontrol('parent', fh,...
	'string', 'OK',...
	'callback', {@i_close 'ok'});

btCancel = xregGui.uicontrol('parent', fh,...
	'string', 'Cancel',...
	'callback', {@i_close 'cancel'});

layout = xreggridbaglayout(fh,...
	'dimension', [2 3],...
	'elements', {mainLayout [] [] btOK [] btCancel},...
	'mergeblock', {[1 1] [1 3]},...
	'gapx', 10,...
	'gapy', 10,...
	'rowsizes', [-1 25],...
	'colsizes', [-1 65 65],...
	'border', [3 3 3 3],...
	'packstatus', 'on');

f.LayoutManager = layout;

ud.data.currentProps = props;

i_setCurrentProperties(ud);

OK = 0;
f.userdata = ud;

f.showDialog(btOK);

switch f.closeAction
case 'ok'
    props = i_updateProperties;
	OK = 1;
end
delete(fh);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [layout, ud] = i_createLayout(fh, props, pDataObject)

% Get default background color
bgcolor = get(0,'DefaultUIControlBackGroundColor');

[lineStyles, markStyles, propLineStyles, propMarkStyles] = i_getLineAndMarkStyles;

lineText = xregGui.uicontrol('style','text',...
	'parent',fh,...
    'string', 'Data Linestyle :',...
	'horizontal','right');

lineEdit = xregGui.uicontrol('style', 'popupmenu',...
    'parent', fh, ...
    'backgroundColor', 'w',...
    'string', lineStyles);

markerText = xregGui.uicontrol('style','text',...
	'parent',fh,...
    'string', 'Data Marker :',...
	'horizontal','right');

markerEdit = xregGui.uicontrol('style', 'popupmenu',...
    'parent', fh, ...
    'backgroundColor', 'w',...
    'value', 3,...
    'string', markStyles);

legendCheckbox = xregGui.uicontrol('style', 'checkbox',...
    'parent', fh, ...
    'horizontal','left',...
    'value', 1,...
    'string', 'Show Legend');

gridCheckbox = xregGui.uicontrol('style', 'checkbox',...
    'parent', fh, ...
    'horizontal','left',...
    'string', 'Show Grid');

reorderCheckbox = xregGui.uicontrol('style', 'checkbox',...
    'parent', fh, ...
    'horizontal','left',...
    'string', 'Reorder X Data');

baddataCheckbox = xregGui.uicontrol('style', 'checkbox',...
    'parent', fh, ...
    'horizontal','left',...
    'string', 'Show Bad Data');


bottomGrid = xreggridbaglayout(fh,...
    'dimension', [4 3],...
    'mergeblock', {[1 1] [2 3]},...
    'mergeblock', {[2 2] [2 3]},...
    'gap', 5,...
    'colsizes', [100 -1 -1],...
    'border', [0 8 0 8],...
    'packstatus', 'off',...
    'elements', {lineText, markerText, [], [],...
        lineEdit, markerEdit, reorderCheckbox, legendCheckbox,...
        [], [], gridCheckbox, baddataCheckbox});

bottomFrame = xregframetitlelayout(fh,...
    'title', 'Line and Marker Properties',...
    'center', bottomGrid);

layout = bottomFrame;

ud.hand.lineEdit = lineEdit;
ud.hand.markerEdit = markerEdit;
ud.hand.reorderCheckbox = reorderCheckbox;
ud.hand.legendCheckbox = legendCheckbox;
ud.hand.gridCheckbox = gridCheckbox;
ud.hand.baddataCheckbox = baddataCheckbox;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setCurrentProperties(ud)

props = ud.data.currentProps;
[lineStyles, markStyles, propLineStyles, propMarkStyles] = i_getLineAndMarkStyles;

try      
    ud.hand.lineEdit.value = find(strcmp(props.dataLineStyle, propLineStyles));
    ud.hand.markerEdit.value = find(strcmp(props.dataMarker, propMarkStyles));
    ud.hand.reorderCheckbox.value = strcmp(props.reorderData, 'on');
    ud.hand.legendCheckbox.value = strcmp(props.showLegend, 'on');
    ud.hand.gridCheckbox.value = strcmp(props.showGrid, 'on');
    ud.hand.baddataCheckbox.value = strcmp(props.showBadData, 'on');
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function props = i_updateProperties
[fh, ud, f] = i_getThisHandle;

[lineStyles, markStyles, propLineStyles, propMarkStyles] = i_getLineAndMarkStyles;
checkboxValues = {'off' 'on'};

% Get the current properties
props.dataLineStyle = propLineStyles{ud.hand.lineEdit.value};
props.dataMarker = propMarkStyles{ud.hand.markerEdit.value};
props.reorderData = checkboxValues{ud.hand.reorderCheckbox.value + 1};
props.showLegend = checkboxValues{ud.hand.legendCheckbox.value + 1};
props.showGrid = checkboxValues{ud.hand.gridCheckbox.value + 1};
props.showBadData = checkboxValues{ud.hand.baddataCheckbox.value + 1};

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [lineStyles, markStyles, propLineStyles, propMarkStyles] = i_getLineAndMarkStyles
lineStyles = {'none' 'solid (-)' 'Dot-Dashed (-.)' 'Dashed (--)' 'Dotted (:)'};
markStyles = {'none' 'Dot (.)' 'Circle (o)' 'Cross (x)' 'Plus (+)' 'Asterisk (*)' 'Square (s)' 'Diamond (d)'};
propLineStyles = {'none' '-' '-.' '--' ':'};
propMarkStyles = {'none' '.' 'o' 'x' '+' '*' 's' 'd'};

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_close(src, event, action)
[fh, ud, f] = i_getThisHandle;
f.closeAction = action;
f.visible = 'off';

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [fh, ud, f] = i_getThisHandle
fh = mvf('sweepplotPlotPropertiesDlg');
ud = get(fh,'userdata');
f = handle(fh);
