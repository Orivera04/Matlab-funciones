function [obj, ok] = guiAddTable(obj)
%GUIADDTABLE Add an existing table to the tradeoff
%
%  [OBJ, OK] = GUIADDTABLE(OBJ) provides a dialog that lets the user choose
%  a pre-existing table from the cage session and add it to the tradeoff.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:36:29 $ 

% get all 2D tables in the project
PROJ = project(obj);
ud.pAllTables = gettables(PROJ, '2d');
ud.tradeoff = obj;

hFig = xregdialog('Name', 'Add Table', ...
    'MinimumSize', [205 110]);
xregcenterfigure(hFig, [250 350]);

pGUI = xregGui.RunTimePointer;
pGUI.LinkToObject(hFig);

% Checkbox for filtering out unsuitable ones
ud.hCheck = uicontrol('style', 'checkbox', ...
    'parent', hFig, ...
    'string', 'Only show tables that can be added', ...
    'callback', {@i_togglefilter, pGUI});

% List box for displaying list
ud.hList = cgtools.exprList('parent', hFig, ...
    'DisplayTypeColumn', false, ...
    'DisplayHeaderRow', false, ...
    'SelectionStyle', 'multiple', ...
    'Items', ud.pAllTables);
hSelList = handle.listener(ud.hList, 'SelectionChanged', {@i_changeselection, pGUI});
hDblClickList = handle.listener(ud.hList, 'Open', {@i_forceOK, pGUI});

% Control buttons
ud.hOK = uicontrol('style', 'pushbutton', ...
    'parent', hFig, ...
    'string', 'OK', ...
    'enable', 'off', ...
    'callback', 'set(gcbf, ''tag'', ''ok'', ''visible'', ''off'');');
hCancel = uicontrol('style', 'pushbutton', ...
    'parent', hFig, ...
    'string', 'Cancel', ...
    'callback', 'set(gcbf, ''visible'', ''off'');');
hHelp = cghelpbutton(hFig, 'CGTRADEOFFADDTABLE');
pGUI.info = ud;

hLayout = xreggridbaglayout(hFig, ...
    'packstatus', 'off', ...
    'dimension', [3 4], ...
    'rowsizes', [20 -1 25], ...
    'colsizes', [-1 65 65 65], ...
    'gapy', 10, ...
    'gapx', 7, ...
    'border', [7 7 7 7], ...
    'mergeblock', {[1 1], [1 4]}, ...
    'mergeblock', {[2 2], [1 4]}, ...
    'elements', {ud.hCheck, ud.hList, [], [], [], ud.hOK, ...
    [], [], hCancel, [], [], hHelp});

hFig.Layout = hLayout;
set(hLayout, 'packstatus', 'on');


hFig.showDialog(ud.hOK);
%  Dialog blocks execution here

tg = get(hFig, 'tag');
ok = false;
if strcmp(tg, 'ok')
    pSelTables = ud.hList.SelectedItems;
    if ~isempty(pSelTables)
        for n = 1:length(pSelTables)
            obj = addTable(obj, pSelTables(n), true);
        end
    ok = true;
    end
end
delete(hFig);


function i_changeselection(src, evt, pUD)
ud = pUD.info;
% Check the selected items to make sure they are compatible with the
% tradeoff and enable/disable the OK button accordingly.
pNewTable = ud.hList.SelectedItems;
DO_COMPAT_CHECK = ~get(ud.hCheck, 'value');
if isempty(pNewTable) || (DO_COMPAT_CHECK && ~canAddTable(ud.tradeoff, pNewTable))
    set(ud.hOK, 'enable', 'off');
else
    set(ud.hOK, 'enable', 'on');
end


function i_togglefilter(src, evt, pUD)
ud = pUD.info;
DO_FILTER = get(ud.hCheck, 'value');
if DO_FILTER
    hFig = get(src, 'Parent');
    set(hFig, 'pointer', 'watch');
    CanAdd = false(size(ud.pAllTables));
    for n = 1:numel(CanAdd)
        CanAdd(n) = canAddTable(ud.tradeoff, ud.pAllTables(n));
    end
    CanAdd = CanAdd & ~containsTable(ud.tradeoff, ud.pAllTables);
    ud.hList.Items = ud.pAllTables(CanAdd);
    set(hFig, 'pointer', 'arrow');
else
    ud.hList.Items = ud.pAllTables;
end


function i_forceOK(src, evt, pUD)
ud = pUD.info;
if strcmp(get(ud.hOK, 'enable'), 'on')
    set(src.Parent, 'tag', 'ok', 'visible', 'off');
end
