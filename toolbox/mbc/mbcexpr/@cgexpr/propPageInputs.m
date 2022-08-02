function hInfo = propPageInputs(obj, hPropDialog)
%PROPPAGEINPUTS Create the Inputs property tab
%
%  INFO = PROPPAGEINPUTS(OBJ, HPROPDIALOG) creates the info object that
%  represents the Inputs tab in a property dialog.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/04/12 23:34:35 $ 

hInfo = xregGui.propertyPageInfo('Inputs');
hInfo.HelpHandler = 'cghelptool';
hInfo.HelpCode = 'CGEXPRPROPPAGEINPUTS';

hTitle1 = uicontrol('style', 'text', ...
    'parent', hPropDialog.Figure, ...
    'visible', 'off', ...
    'enable', 'inactive', ...
    'horizontalalignment', 'left', ...
    'string', 'Immediate inputs:');
hTitle2 = uicontrol('style', 'text', ...
    'parent', hPropDialog.Figure, ...
    'visible', 'off', ...
    'enable', 'inactive', ...
    'horizontalalignment', 'left', ...
    'string', 'All variable dependencies:');

hList1 = cgtools.exprList('parent', hPropDialog.Figure, ...
    'Visible', 'off', ...
    'Items', getinputs(obj));
hList2 = cgtools.exprList('parent', hPropDialog.Figure, ...
    'Visible', 'off', ...
    'Items', getinports(obj));

divl = xregGui.dividerline('parent', hPropDialog.Figure, ...
    'visible', 'off');

hGrid = xreggridbaglayout(hPropDialog.Figure, ...
    'dimension', [9 1], ...
    'rowsizes', [15 2 -1 10 2 10 15 2 -1], ...
    'gapx', 10, ...
    'border', [10 10 10 10], ...
    'elements', {hTitle1, [], hList1, [], divl, [], hTitle2, [], hList2});

hInfo.TabComponent = hGrid;