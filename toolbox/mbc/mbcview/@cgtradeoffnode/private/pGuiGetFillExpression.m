function [pNewFill, ok] = pGuiGetFillExpression(obj, pT)
%PGUIGETFILLEXPRESSION Display dialog for choosing a table's fill item
%
%  [PEXPR, OK] = PGUIGETFILLEXPRESSION(OBJ) displays a modal dialog
%  for choosing a new filling item.  The pointer to the selected item is
%  returned.
%
%  [PEXPR, OK] = PGUIGETFILLEXPRESSION(OBJ, PT) specifies that the
%  expression associated with table PT should initially be selected in the
%  dialog.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:36:39 $ 

if nargin<2
    pT = xregpointer;
    TblName = '';
else
    TblName = [pT.getname ' '];
end
idx = (pT==obj.Tables);

% get all models and variables in the project
PROJ = project(obj);
ud.pAllModels = getmodels(PROJ);
ud.pAllVar = getvars(PROJ, 'nonconstant');
ud.UsedVar = obj.FillExpressions;
ud.UsedVar(idx) = [];
ud.tradeoff = obj;

hFig = xregdialog('Name', 'Select Filling Item', ...
    'MinimumSize', [205 110]);
xregcenterfigure(hFig, [300 350]);

pGUI = xregGui.RunTimePointer;
pGUI.LinkToObject(hFig);

% Text telling the user to select a filling item
hText = uicontrol('style', 'text', ...
    'parent', hFig, ...
    'string', ['Select the item you want to fill table ' TblName 'with:'], ...
    'horizontalalignment', 'left');

% Checkbox for filtering out used items
ud.hCheck = uicontrol('style', 'checkbox', ...
    'parent', hFig, ...
    'string', 'Only show items that are not filling another table', ...
    'value', 1, ...
    'callback', {@i_refilter, pGUI});

% Radio buttons for selecting which item type to list
ud.hRadio = xregGui.rbgroup('parent', hFig, ...
    'nx', 1, 'ny', 3, ...
    'string', {'Display models'; 'Display variables'; 'Display all items'}, ...
    'value', [1;0;0], ...
    'callback', {@i_refilter, pGUI});

% List box for displaying list of items
ud.hList = cgtools.exprList('parent', hFig, ...
    'DisplayTypeColumn', true, ...
    'DisplayHeaderRow', true, ...
    'SelectionStyle', 'single', ...
    'ItemColumnWidth', 0.6);
hDblClickList = handle.listener(ud.hList, 'Open', @i_forceOK);

% Control buttons
hOK = uicontrol('style', 'pushbutton', ...
    'parent', hFig, ...
    'string', 'OK', ...
    'callback', 'set(gcbf, ''tag'', ''ok'', ''visible'', ''off'');');
hCancel = uicontrol('style', 'pushbutton', ...
    'parent', hFig, ...
    'string', 'Cancel', ...
    'callback', 'set(gcbf, ''visible'', ''off'');');
hHelp = cghelpbutton(hFig, 'CGTRADEOFFSETFILL');
pGUI.info = ud;

optsgrid = xreggridbaglayout(hFig, ...
    'packstatus', 'off', ...
    'dimension', [2 1], ...
    'rowsizes', [60 20], ...
    'gapy', 10, ...
    'elements', {ud.hRadio, ud.hCheck});
hOptsFrame = xregframetitlelayout(hFig, ...
    'title', 'List options', ...
    'innerborder', [10 5 5 5], ...
    'center', optsgrid);   
hLayout = xreggridbaglayout(hFig, ...
    'dimension', [4 4], ...
    'rowsizes', [15 -1 110 25], ...
    'colsizes', [-1 65 65 65], ...
    'gapy', 10, ...
    'gapx', 7, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 4]}, ...
    'mergeblock', {[2 2], [1 4]}, ...
    'mergeblock', {[3 3], [1 4]}, ...
    'elements', {hText, ud.hList, hOptsFrame, [], ...
    [], [], [], hOK, ...
    [], [], [], hCancel, ...
    [], [], [], hHelp});

hFig.Layout = hLayout;
set(hLayout, 'packstatus', 'on');

% Find out if the current fill expression exists in one of the lists
if ~isnull(pT)
    pFill = getFillExpression(obj, pT);
    if pFill~=0
        if ismember(pFill, ud.pAllVar)
            % Start of set to the variable list
            ud.hRadio.Selected = 2;
        end
        % Set current fill item as selected initially (if possible)
        ud.hList.SelectedItem = pFill;
    end
end

% Initialise list
i_refilter([], [], pGUI)

hFig.showDialog(hOK);
%  Dialog blocks execution here

tg = get(hFig, 'tag');
ok = false;
if strcmp(tg, 'ok')
    pNewFill = ud.hList.SelectedItem;
    if ~isempty(pNewFill)
        ok = true;
    else
        pNewFill = xregpointer;
    end
else
    pNewFill = xregpointer;
end
delete(hFig);



function i_refilter(src, evt, pUD)
ud = pUD.info;
group = ud.hRadio.Selected;
removeused = get(ud.hCheck, 'value');

switch group
    case 1
        pItems = ud.pAllModels;
    case 2
        pItems = ud.pAllVar;
    case 3
        pItems = [ud.pAllModels, ud.pAllVar];
end
if removeused
    pItems = setdiff(pItems, ud.UsedVar);
end
ud.hList.Items = pItems;


function i_forceOK(src, evt)
set(src.Parent, 'tag', 'ok', 'visible', 'off');
