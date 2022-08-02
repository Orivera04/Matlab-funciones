function varargout = xregDefineTests(action,varargin)
%XREGDEFINETESTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.4 $  $Date: 2004/02/09 08:20:58 $


switch lower(action)
case 'create'
	[varargout{1:3}] = i_createFigure(varargin{:});
case 'variableclicked'
	i_variableClicked;
case 'celledited'
	i_cellEdited;
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [OK, ss, args] = i_createFigure(pf, ss, args)
fh = mvf('DefineTests');

if ~isempty(fh)
	delete(fh);
	%	return
end

if nargin < 2
	args = {};
end

f = xregGui.figure('visible','off',...
	'units','pixels',...
	'Name','Define Test Groupings',...
	'tag','DefineTests',...
    'pointer', 'watch',...
	'closerequestfcn',{@i_close 'cancel'},... 
	'renderer', 'painters',...
	'color',get(0,'defaultuicontrolbackgroundcolor'));

fh = double(f);
xregcenterfigure(fh, [700 600], pf);

% Add a property to define the close action
schema.prop(f, 'closeAction', 'string');

f.MinimumSize = [400 400];
f.ResourceLocation = xregrespath;

[mainLayout, ud] = i_createLayout(fh, ss);

btOK = xregGui.uicontrol('parent', fh,...
	'string', 'OK',...
	'callback', {@i_close 'ok'});

btCancel = xregGui.uicontrol('parent', fh,...
	'string', 'Cancel',...
	'callback', {@i_close 'cancel'});

btHelp = mv_helpbutton(fh, 'xreg_defineTestGroups');

layout = xreggridbaglayout(fh,...
	'dimension', [2 4],...
	'elements', {mainLayout [] [] btOK [] btCancel [] btHelp},...
	'mergeblock', {[1 1] [1 4]},...
	'gapx', 10,...
	'gapy', 10,...
	'rowsizes', [-1 25],...
	'colsizes', [-1 65 65 65],...
	'border', [3 3 3 3],...
	'packstatus', 'on');

f.LayoutManager = layout;
f.userdata = ud;

i_setInputArgs(args, ud);
set(f, 'visible', 'on', 'pointer', 'arrow');
OK = 0;
%f.windowstyle = 'modal';
waitfor(fh, 'visible', 'off');
switch f.closeAction
case 'ok'
	[ss, args] = i_defineSweepset;
	OK = 1;
end
delete(fh);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [layout, ud] = i_createLayout(fh, ss)

% Get default background color
bgcolor = get(0,'DefaultUIControlBackGroundColor');

varList = xregGui.uicontrol('style','list',...
	'parent',fh,...
	'background',[1 1 1],...
	'string', get(ss, 'name'),...
	'callback',@i_listClicked);

varText = axestext(fh,...
	'string', 'Variables:',...
	'verticalalignment', 'bottom');

popText = axestext(fh,...
	'string', 'Test number variable:',...
	'verticalalignment', 'bottom');
	
popAlias = xregGui.uicontrol('style', 'popup',...
	'parent', fh,...
	'background', [1 1 1],...
	'string', [{'none'} ;get(ss, 'name')],...
	'callback', @i_popupClicked);

reorderCheck = xregGui.uicontrol('style','check',...
	'parent',fh,...
	'callback', @i_reorderClicked,...
	'string', 'Reorder records');

origGroupCheck = xregGui.uicontrol('style','check',...
	'parent',fh,...
	'callback', @i_origGroupClicked,...
	'string', 'Show original');

onePerRecordCheck = xregGui.uicontrol('style','check',...
	'parent',fh,...
	'callback', @i_onePerRecordClicked,...
	'string', 'One test / record');

rightTopGrid = xreggridbaglayout(fh,...
	'dimension', [7 1],...
	'elements', {varText varList popText popAlias reorderCheck origGroupCheck onePerRecordCheck},...
	'gapy', 5,...
	'rowsizes', [10 -1 10 20 20 20 20]);

btAdd = xregGui.iconuicontrol('parent', fh,...
	'TooltipString', 'Add Variable',...
	'TransparentColor', [0 255 0],...
	'ImageFile', 'addObject.bmp',...
	'callback', {@i_addVariableClicked});

btRemove = xregGui.iconuicontrol('parent', fh,...
	'TooltipString', 'Remove Variable',...
	'TransparentColor', [0 255 0],...
	'ImageFile', 'removeObject.bmp',...
	'enable', 'off',...
	'callback', {@i_deleteVariable});

btUp = xregGui.iconuicontrol('parent', fh,...
	'TooltipString', 'Move Variable Up',...
	'TransparentColor', [0 255 0],...
	'ImageFile', 'moveUp.bmp',...
	'enable', 'off',...
	'callback', {@i_move, -1});

btDown = xregGui.iconuicontrol('parent', fh,...
	'TooltipString', 'Move Variable Down',...
	'TransparentColor', [0 255 0],...
	'ImageFile', 'moveDown.bmp',...
	'enable', 'off',...	
	'callback', {@i_move, +1});

midTopGrid = xreggridbaglayout(fh,...
	'dimension', [5 1],...
	'elements', {[] btUp btDown btAdd btRemove},...
	'gapy', 5,...
	'rowsizes', [50 20 20 20 20]);

varTable = xregtable(fh,...
	'rows.number', 1,...
	'cols.number', 5,...
	'rows.size', 20,...
	'rows.spacing', 0,...
	'rows.fixed', 1,...
	'cols.size', 70,...
	'cols.spacing', 0,...
	'frame.box', 'on',...
	'frame.Hborder', [1 0],...
	'frame.Vborder', [1 0],...	
	'frame.backgroundcolor', [1 1 1],...
	'zeroindex', [2 1],...
	'defaultcelltype', 'uiedit');

set(varTable, 'cells.rowselection', [1 1],...
	'cells.string', {'Variable' 'Min' 'Max' 'Tolerance' 'Group By'},...
	'cells.type', 'uipushbutton');

topGrid = xreggridbaglayout(fh,...
	'dimension', [1 3],...
	'elements', {varTable midTopGrid rightTopGrid},...
	'gapx', 10,...
	'colsizes', [-1 20 -1],...
	'colratios', [351 0 200]);

topOuterGrid = xreggridbaglayout(fh,...
	'dimension', [1 2],...
	'elements', {topGrid []},...
	'gapx', 0,...
	'colsizes', [591 -1]);

topPanelLayout = xregpanellayout(fh,...
	'center', topOuterGrid,...
	'innerborder', [10 10 10 10]);

% Create uicontext menu for plotAxes
m = uicontextmenu('parent', fh);

XDataPerPixel = max(1, size(ss,1))/500;
plotAxes = xregGui.scrollaxes('parent', fh,...
	'uicontextmenu', m,...	
	'ZoomMode', 'x',...
	'XdataPerPixel', XDataPerPixel,...
    'units', 'pixels');
ud.pLegend = xregGui.RunTimePointer( ...
    mbcgraph.legend('Parent', plotAxes, ...
    'visible', 'off', ...
    'Location', 'SouthWest', ...
    'Interpreter', 'none', ...
    'MoveMode', 'boundtoaxes'));
ud.menu.showLegend = uimenu(m, 'Label', 'Show legend', 'callback', @i_swapShowLegend);
uimenu(m,'Label', 'Copy Plot to Figure', 'separator', 'on', 'callback', {@i_copyPlot plotAxes});

plotAxesLayout = xregpanellayout(fh,...
	'center', axiswrapper(plotAxes),...
	'innerborder', [30 20 40 30]);

layout = xregsplitlayout(fh,...
	'orientation', 'ud',...
	'dividerwidth', 4,...
	'dividerstyle', 'flat',...
	'top', topPanelLayout,...
	'bottom', plotAxesLayout,...
	'minwidth', [200 140]);

% Create a listener for changes to the position of plotAxes and set the YLim appropriately
schema.prop(plotAxes, 'positionListener', 'handle');
plotAxes.positionListener = handle.listener(plotAxes, plotAxes.findprop('position'), 'PropertyPostSet', @i_plotAxesPositionChanged);

ud.plotAxes = plotAxes;
ud.varTable = varTable;
ud.varList = varList;
ud.popAlias = popAlias;
ud.reorderCheck = reorderCheck;
ud.origGroupCheck = origGroupCheck;
ud.onePerRecordCheck = onePerRecordCheck;
ud.ss = ss;
ud.newss = ss;
ud.btUp = btUp;
ud.btDown = btDown;
ud.btRemove = btRemove;
ud.btAdd = btAdd;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setInputArgs(args, ud)
if ~isempty(args)
	vars = args{1};
	tols = args{2};
	for i = 1:length(vars)
		varName = vars{i};
		if strcmp(varName, '#rec')
			set(ud.onePerRecordCheck, 'value', 1);
			i_addVariable(ud.varTable, 'RECORD NO', 1, size(ud.ss, 1), 1);
		elseif ~isempty(find(ud.ss, varName)) 
			% Get the Min and Max values of the variable being added
			v = get(SetMinMax(ud.ss(:, varName)), {'min' 'max'});
			min = v{1}{1};
			max = v{2}{1};
			i_addVariable(ud.varTable, varName, min, max, tols(i));
		end
	end
    % LEGACY CHECK - is reorder a character string which indicates it's
    % been specifically set in ssf/loadobj. Need to change this to a
    % boolean
    if ischar(args{3})
        args{3} = true;
    end
	set(ud.reorderCheck, 'value', args{3});
	% Check args{4} exists
	if length(args) > 3 & ischar(args{4})
		ind = find(ud.ss, args{4});
      if isempty(ind)
         ind = 0;
      end
		set(ud.popAlias, 'value', ind + 1);
	end
	i_defineSweepset;
	i_update;
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_update
[fh, ud, f] = i_getThisHandle;
set(fh,'pointer','watch')
try
	i_updateButtons(fh, ud, f);
	i_updatePlot(fh, ud, f);
end
set(fh,'pointer','arrow')


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_updateButtons(fh, ud, f)
% Find the selected table row from the toggle button values
btValue = ud.varTable(:,1).value;
selected = find(btValue);
DELETE_ENABLED = 'off';
ADD_ENABLED = 'on';
MOVE_UP_ENABLED = 'off';
MOVE_DOWN_ENABLED = 'off';
if ~isempty(selected)
	DELETE_ENABLED = 'on';
	if selected < length(btValue)
		MOVE_DOWN_ENABLED = 'on';
	end
	if selected > 1
		MOVE_UP_ENABLED = 'on';
	end
end
if length(ud.varList.String) == 0
    ADD_ENABLED = 'off';
end
ud.btUp.enable = MOVE_UP_ENABLED;
ud.btDown.enable = MOVE_DOWN_ENABLED;
ud.btRemove.enable = DELETE_ENABLED;
ud.btAdd.enable = ADD_ENABLED;

	
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_updatePlot(fh, ud, f)

% Which variables have been selected
vars = ud.varTable(:,1).string;
% Lets not try and display 'RECORD NO' if it exists
validVars = find(~(ismember(vars, 'RECORD NO') & get(ud.onePerRecordCheck, 'value')));
vars = vars(validVars);
if isempty(vars)
	% Ensure that empty vars is numeric otherwise sweepset/find fails
	vars = [];
end
% Which sweepset to display
delete(ud.plotAxes.children);
[h, hLegend] = plot(ud.newss(:,vars),'*','CODE','SWEEPLINES', 'm-','FORCESWEEPLINES', 'parent', double(ud.plotAxes), 'markersize', 2);
ud.pLegend.info = hLegend;

if ud.origGroupCheck.value && strcmp(ud.origGroupCheck.enable, 'on')
	ud.plotAxes.nextPlot = 'add';
	plot(ud.ss(:,[]), 'CODE', 'SWEEPLINES', 'b-.', 'FORCESWEEPLINES', 'parent', double(ud.plotAxes), 'LEGEND', 'off');
	sl = findobj(double(ud.plotAxes), 'tag', 'TestDelimiters');
    
    % Add the original sweep lines to the legend
    str = hLegend.getStrings;
    hand = hLegend.getHandles;
    new_sl = setdiff(sl, hand);
    hLegend.refresh([hand(:); new_sl], ...
        [str(:); {'Original Test'}]);
end

% set all lines Hit test off so axes catches all mousebutton prersses for zooming.
set(findobj(double(ud.plotAxes),'type','line'),'HitTest','off');
numRec = size(ud.newss, 1);
% Make sure zoommode is still set
set(ud.plotAxes, 'ZoomMode', 'off');
set(ud.plotAxes, 'ZoomMode', 'x');
% Force a redraw by ensuring that YLim and XLim change
pos = ud.plotAxes.position;
set(ud.plotAxes, 'YLim', [0 2], 'XLim', [0 numRec]);
set(ud.plotAxes, 'YLim', [0 1], 'XLim', [1 numRec], 'Ydataperpixel', 1.15/pos(4));
% Ensure the axes text is drawn in black
set(ud.plotAxes, 'xcolor', [0 0 0],	'ycolor', [0 0 0]);
set(ud.plotAxes.title, 'string', [num2str(size(ud.newss, 3)) ' tests defined']);
set(ud.plotAxes.XLabel, 'string', 'Record No.');
if strcmp(get(ud.menu.showLegend, 'checked'), 'on')
    set(ud.pLegend.info, 'visible', 'on', ...
        'location', 'NorthWest', ...
        'MoveMode', 'boundtoaxes');
else
    set(ud.pLegend.info, 'visible', 'off', ...
        'location', 'NorthWest', ...
        'MoveMode', 'boundtoaxes');
end
% Set table colors according to plot
for i = 1:length(h)
	ud.varTable(validVars(i),4).color = get(h(i), 'color');
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_plotAxesPositionChanged(src, event)
%[fh, ud, f] = i_getThisHandle;
plotAxes = event.affectedObject;
pos = plotAxes.position;
set(plotAxes, 'YLim', [0 1], 'Ydataperpixel', 1.15/pos(4));
%i_updatePlot(fh, ud, f);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_variableClicked
[fh, ud, f] = i_getThisHandle;
% Which toggle button was clicked?
gcboUD = get(gcbo, 'userdata');
% Get it's position in the scrollable table
[r, c] = scrollindex(ud.varTable, gcboUD.row, gcboUD.col);
sel = (ud.varTable(:, 1)~=0);
selectedRow = r(sel(r));
% Don't select this one
sel(r) = 0;
% Ensure all other buttons are up
ud.varTable(sel,1).value = 0;
i_updateButtons(fh, ud, f);
i_setSelectedHightlight(ud.varTable, selectedRow)

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_listClicked(src, event)
[fh, ud, f] = i_getThisHandle;
if strcmp(f.selectionType, 'open')
	i_addVariableClicked;
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_popupClicked(src, event)
i_defineSweepset;
i_update;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cellEdited
i_defineSweepset;
i_update;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_reorderClicked(src, event)
[fh, ud, f] = i_getThisHandle;
if get(src, 'value')
	ud.origGroupCheck.enable = 'off';
else
	ud.origGroupCheck.enable = 'on';
end	
i_defineSweepset;
i_update;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_copyPlot(src, event, axes)
newF = figure;
newax = copyobj(axes, newF);
pos = get(newF,'defaultaxesposition');
set(newax,'units','normalized',...
	'position',pos,...
	'color',[1 1 1],...
	'buttondownfcn','');
kids = get(newax,'children');
set(kids,'hittest','off','handlevisibility','off');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_swapShowLegend(src, event)
[fh, ud, f] = i_getThisHandle;
if strcmp(get(src, 'checked'), 'on')
	state = 'off';
else
	state = 'on';
end
set(src, 'checked', state);
set(ud.pLegend.info, 'visible', state);



%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_origGroupClicked(src, event)
i_update;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_onePerRecordClicked(src, event)
[fh, ud, f] = i_getThisHandle;
% Are we adding one record per sweep or removing
if get(src, 'value')
	i_addVariable(ud.varTable, 'RECORD NO', 1, size(ud.ss, 1), 1);
	i_defineSweepset;
	i_update;
else
	% Select the row called '#rec' and delete it
	vars = ud.varTable(:,1).string;
	[s, i] = intersect(vars, {'RECORD NO'});
	newValue = zeros(length(ud.varTable(:,1).value), 1);
	newValue(i) = 1;
	ud.varTable(:,1).value = newValue;
	i_deleteVariable;
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_addVariableClicked(src, event)
[fh, ud, f] = i_getThisHandle;

% Get the name of the variable being added
varAdded = ud.varList.string{ud.varList.value};
% If it's already in the list then ignore
if any(strcmp(varAdded, ud.varTable(:,1).string))
	return
end
% Get the Min and Max values of the variable being added
v = get(SetMinMax(ud.ss(:, ud.varList.value)), {'min' 'max'});
min = v{1}{1};
max = v{2}{1};
i_addVariable(ud.varTable, varAdded, min, max, (max - min)/100);
i_defineSweepset;
i_update;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_addVariable(table, varName, min, max, tol)
% Get the new row to add a new row to the table
nextRow = size(table, 1) + 1;
set(table, 'rows.number', nextRow);
% Add the toggle button as the first cell in the table
set(table, 'cells.rowselection',  [nextRow nextRow],...
	'cells.colselection', [1 1],...
	'cells.string', varName,...
	'cells.value',0,...
	'cells.type', 'uitogglebutton',...
	'cells.tooltipstring', 'Click to Select Row',...
	'cells.callback', [mfilename '(''variableClicked'')']);
% Add Min, Max and Tolerance values
set(table, 'cells.rowselection',  [nextRow nextRow],...
	'cells.colselection', [2 4],...
	'cells.value', [min max tol],...
	'cells.enable', 'off',...
 	'cells.backgroundcolor', [1 1 1],...
	'cells.callback', [mfilename '(''cellEdited'')']);
% Add display only check box
set(table, 'cells.rowselection',  [nextRow nextRow],...
	'cells.colselection', [5 5],...
	'cells.value',1,...
 	'cells.backgroundcolor', [1 1 1],...
	'cells.type', 'uicheckbox',...
	'cells.callback', [mfilename '(''cellEdited'')']);
% Enable editing of the Tolerance value
table(end,4).enable = 'on';

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_deleteVariable(src, event)
[fh, ud, f] = i_getThisHandle;
% Find the selected table row from the toggle button values
selected = find(ud.varTable(:,1).value);
% If selected is the special 'RECORD NO' button then turn off the one test check box
if strcmp(ud.varTable(selected,1).string, 'RECORD NO')
	set(ud.onePerRecordCheck, 'value', 0)	
end
% How many variable rows are there
numRows = length(ud.varTable(:,1).value);
% generate a new row order such that the row to be deleted is at the end
newOrder = [1:selected-1 selected + 1:numRows selected];
i_reorder(ud.varTable, newOrder);
ud.varTable(end,:).delete;
% Resize the table
set(ud.varTable, 'rows.number', size(ud.varTable, 1)-1);
i_defineSweepset;
i_update;
i_setSelectedHightlight(ud.varTable, [])

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_move(src, event, dirn)
[fh, ud, f] = i_getThisHandle;
% Find the selected table row from the toggle button values
sel = find(ud.varTable(:,1).value);
newSel = sel + dirn;
% How many variable rows are there
numRows = length(ud.varTable(:,1).value);
% If none are selected or we try to move beyond the edge then return
if isempty(sel) | newSel < 1 | newSel > numRows
	return
end
% Get the smaller and larger of i and i + dirn
low = min([sel newSel]);
high = max([sel newSel]);
% Reorder the arrays
newOrder = [1:low-1 high low high+1:numRows];
i_reorder(ud.varTable, newOrder);
i_defineSweepset;
i_update;
i_setSelectedHightlight(ud.varTable, newSel)

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_reorder(table, newRowOrder)
% Internal function to reorder the rows in the table
oldStr = table.string;
oldVal = table.value;
table.string = oldStr(newRowOrder,:);
table.value = oldVal(newRowOrder,:);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setSelectedHightlight(table, selectedRows)
% How many variable rows are there
numRows = length(table(:,1).value);
unselectedRows = setxor(1:numRows, selectedRows);
table(unselectedRows,2:end).backgroundcolor = [1 1 1];
table(selectedRows,2:end).backgroundcolor = [0.8 0.8 1];

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [ss, args] = i_defineSweepset
[fh, ud, f] = i_getThisHandle;
% Get variable names to define sweepset on
vars = ud.varTable(:,1).string;
% Ensure that vars is a cell array
if ~iscell(vars)
	vars = {vars};
end
% Do we have a variable called 'RECORD NO' in vars
if get(ud.onePerRecordCheck, 'value')
	vars(ismember(vars, {'RECORD NO'})) = {'#rec'};
end
% Get the tolerance on the variables
tol = ud.varTable(:, 4).value;
% Which variables are we grouping by
groupBy = (ud.varTable(:,5)~=0);
tol = tol(groupBy);
vars = vars(groupBy);
% Is record reordering allowed
reorder = ud.reorderCheck.value;
% Define test alias
testAlias = ud.popAlias.value;
testAliasStr = ud.popAlias.string;
if testAlias > 1
	testAlias = testAliasStr{testAlias};
else
	testAlias = 0;
end
% Define the function arguments for the output
args = {vars tol reorder testAlias};
% Redefine the sweepset
ss = DefineSweepSet(ud.ss, args{:});
ud.newss = ss;
% Update the userdata
f.userdata = ud;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_close(src, event, action)
[fh, ud, f] = i_getThisHandle;
f.closeAction = action;
f.visible = 'off';
%delete(fh);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [fh, ud, f] = i_getThisHandle
fh=mvf('DefineTests');
ud=get(fh,'userdata');
f = handle(fh);
