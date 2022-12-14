function [optim, OK] = editweights(optim)
%EDITWEIGHTS Pareto weight editing dialog
%
%  [OPTIM, OK] = EDITWEIGHTS(OPTIM) edits the weights used in the weighted
%  pareto view of the optimization output.  The optimization must have been
%  run for this function to work.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.8.3 $    $Date: 2004/04/04 03:26:08 $

pModels = optim.outputWeightsColumns;
sModels = pveceval(pModels, 'getname');

fig = xregdialog('name','Pareto Weights Editor', 'resize', 'off');
xregcenterfigure(fig,[400 380]);

sc = xregGui.SystemColorsDbl;
udh = xregGui.RunTimePointer;
udh.LinkToObject(fig);

% Dataset used to offer the option of columns of output data as weights
oppt = cgoppoint;

ud.pDataset = xregpointer(cgoppoint);
ud.pDataset.info = ud.pDataset.addfactor(optim.outputColumns);
ud.pDataset.info = ud.pDataset.set('data', optim.outputData(:,:,1));

txt1 = uicontrol('parent', fig, ...
    'style', 'text', ...
    'enable', 'inactive', ...
    'horizontalalignment', 'left', ...
    'string', 'Objectives:');
hList = xreguicontrol('parent', fig, ...
    'style', 'listbox', ...
    'string', sModels, ...
    'value', 1, ...
    'backgroundcolor', sc.WINDOW_BG, ...
    'horizontalalignment', 'left', ...
    'callback', {@i_modelchange, udh});
ud.hWeightText = uicontrol('parent', fig, ...
    'style', 'text', ...
    'enable', 'inactive', ...
    'horizontalalignment', 'left', ...
    'string', ['Weights for ' sModels{1} ':']);
ud.hEditor = cgoptimgui.vectorEditor('parent', fig, ...
    'layoutstyle', 'narrow', ...
    'vector', optim.outputWeights(:,1), ...
    'dataset', ud.pDataset);
sol = xregGui.clickedit('parent', fig, ...
    'min', 1, ...
    'max', size(optim.outputData, 3), ...
    'value', 1, ...
    'rule', 'int', ...
    'backgroundcolor', sc.WINDOW_BG, ...
    'callback', {@i_solutionchange, udh});
ud.hSolution = xregGui.labelcontrol('parent', fig, ...
    'Control', sol, ...
    'ControlSize', 50, ...
    'String', 'Select data from solution:');

okbut=uicontrol('parent',fig,...
   'style','push',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');
cancbut=uicontrol('parent',fig,...
   'style','push',...
   'string','Cancel',...
   'callback','set(gcbf,''tag'',''cancel'',''visible'',''off'');');
helpbut = cghelpbutton(fig, 'CGOPTIMEDITPARETOWEIGHTS');

uppergrid = xreggridbaglayout(fig, 'packstatus', 'off', ...
    'dimension', [3 2], ...
    'gapx', 20, ...
    'colratios', [1 1], ...
    'rowsizes', [15 -1 20], ...
    'gapy', 3, ...
    'mergeblock', {[2 3], [1 1]}, ...
    'elements', {txt1, hList,[],  ud.hWeightText, ud.hEditor, ud.hSolution});
lyt = xreggridbaglayout(fig, 'packstatus', 'off', ...
    'dimension', [2 4], ...
    'gapx', 7, ...
    'gapy', 10, ...
    'border', [7 7 7 10], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 65 65], ...
    'mergeblock', {[1 1], [1 4]}, ...
    'elements', {uppergrid, [], [], okbut, [], cancbut, [], helpbut});

fig.LayoutManager = lyt;
set(lyt, 'packstatus', 'on');

ud.optimobj = optim;
ud.displayindex = 1;
udh.info = ud;

fig.showDialog(okbut);

tg = get(fig, 'tag');
OK = false;
if strcmp(tg, 'ok')
    % get the last set of weight changes
    i_modelchange(hList, [], udh);
    ud = udh.info;
    optim = ud.optimobj;
    OK = true;
end
freeptr(ud.pDataset);
delete(fig);



function i_modelchange(src, evt, udh);
ud = udh.info;
indModel = get(src, 'value');
strModel = get(src, 'string');
ud.optimobj.outputWeights(:,ud.displayindex) = ud.hEditor.Vector;
ud.hEditor.Vector = ud.optimobj.outputWeights(:,indModel);
ud.displayindex = indModel;
set(ud.hWeightText, 'string', ['Weights for ' strModel{indModel} ':']);
udh.info = ud;



function i_solutionchange(src, evt, udh)
ud = udh.info;
ud.pDataset.info = ud.pDataset.set('data', ud.optimobj.outputData(:,:,get(src, 'value')));
%Force the editor to notice the data change.
ud.hEditor.pSetDataset;