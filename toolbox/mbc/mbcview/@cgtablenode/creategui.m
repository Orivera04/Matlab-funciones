function [LYT,TBLYT,d] = creategui(node, info)
%CREATEGUI Create the table view for the browser
%
%  {LYT, TB, DATA] = CREATEGUI(NODE, INFO) creates the table node's browser
%  display.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.4 $  $Date: 2004/04/12 23:35:08 $

cgb = info.browserH;
hFig = info.Figure;
menus = cgb.createmenu(guid(node),2);
set(menus,{'label'},{'&View';'Ta&ble'});

% Data fields
d = struct('Handles', [], ...
    'FeaturePointer', xregpointer, ...
    'ShownMessageID', [], ...
    'ComparisonPaneRequested', true, ...
    'SuppressViewUpdate', false);

% Create View Menu
vmenu.History = uimenu(menus(1), 'label', '&History', ...
    'callback', {@i_showhistory, cgb});
vmenu.CompPane = uimenu(menus(1), ...
    'label', 'Feature/Model &Comparison', ...
    'checked', 'on', ...
    'enable', 'off', ...
    'callback', {@i_opencomparison, cgb});
vmenu.RotateSurf = uimenu(menus(1), ...
    'label', '&Rotate Table Surface', ...
    'checked', 'on', ...
    'separator', 'on', ...
    'enable', 'off', ...
    'callback', {@i_seteditoreditstate, cgb, false});
vmenu.EditSurf = uimenu(menus(1), ...
    'label', '&Edit Table Surface', ...
    'enable', 'off', ...
    'callback', {@i_seteditoreditstate, cgb, true});
d.Handles.ViewMenu = vmenu;
d.Handles.ViewMenu.This = menus(1);

% Create Table Menu
tbmenu.Init = uimenu(menus(2), 'label', '&Initialize...', ...
    'callback', {@i_inittable, cgb});
tbmenu.Fill = uimenu(menus(2), 'label', '&Fill...', ...
    'callback', {@i_filltable, cgb});
tbmenu.Optimize = uimenu(menus(2), 'label', '&Optimize...', ...
    'callback', {@i_optimizetable, cgb});
tbmenu.Invert = uimenu(menus(2), 'label', 'Fill by I&nversion', ...
    'callback', {@i_inverttable, cgb});
tbmenu.MathEdit = uimenu(menus(2), 'label', 'Adjust Cell &Values...', ...
    'callback', {@i_mathedittable, cgb});
tbmenu.ExtrapMask = uimenu(menus(2), 'label', 'Extrapolation &Mask', ...
    'separator', 'on');
uimenu(tbmenu.ExtrapMask, 'label', '&Add Selection', ...
    'callback', {@i_addtomask, cgb});
uimenu(tbmenu.ExtrapMask, 'label', '&Remove Selection', ...
    'callback', {@i_remfrommask, cgb});
uimenu(tbmenu.ExtrapMask, 'label', '&Clear Mask', ...
    'callback', {@i_clearmask, cgb});
tbmenu.PEMask = uimenu(tbmenu.ExtrapMask, 'label', 'Generate From &PE', ...
    'separator', 'on', ...
    'callback', {@i_maskfromPE, cgb});
tbmenu.BoundaryMask = uimenu(tbmenu.ExtrapMask, 'label', 'Generate From &Boundary Model', ...
    'callback', {@i_maskfromcon, cgb});
tbmenu.Extrapolate = uimenu(menus(2), 'label', '&Extrapolate', ...
    'callback', {@i_extrapolate, cgb});
tbmenu.Locks = uimenu(menus(2), 'label', 'Table Cell &Locks', ...
    'separator', 'on');
uimenu(tbmenu.Locks, 'label', '&Lock Selection', ...
    'callback', {@i_addtolocks, cgb});
uimenu(tbmenu.Locks, 'label', '&Unlock Selection', ...
    'callback', {@i_remfromlocks, cgb});
uimenu(tbmenu.Locks, 'label', 'Lock Entire &Table', ...
    'callback', {@i_lockall, cgb});
uimenu(tbmenu.Locks, 'label', '&Clear All Locks', ...
    'callback', {@i_clearlocks, cgb});
tbmenu.ConvToModel = uimenu(menus(2), 'label', '&Convert To Model', ...
    'separator', 'on', ...
    'callback', {@i_convtomodel, cgb});
tbmenu.Props = uimenu(menus(2), 'label', '&Properties', ...
    'separator', 'on', ...
    'callback', {@i_properties, cgb});

d.Handles.TableMenu = tbmenu;
d.Handles.TableMenu.This = menus(2);

% Create context menu for table
tbluic = uicontextmenu('parent', hFig);
cmenu.MaskAddSel = uimenu(tbluic, 'label', '&Add to Extrapolation Mask', ...
    'callback', {@i_addtomask, cgb});
cmenu.MaskRemoveSel = uimenu(tbluic, 'label', '&Remove from Extrapolation Mask', ...
    'callback', {@i_remfrommask, cgb});
cmenu.MaskClear = uimenu(tbluic, 'label', '&Clear Extrapolation Mask', ...
    'callback', {@i_clearmask, cgb});
cmenu.LocksAddSel = uimenu(tbluic, 'label', '&Lock Selection', ...
    'separator', 'on', ...
    'callback', {@i_addtolocks, cgb});
cmenu.LocksRemoveSel = uimenu(tbluic, 'label', '&Unlock Selection', ...
    'callback', {@i_remfromlocks, cgb});
cmenu.LocksAddAll = uimenu(tbluic, 'label', 'Lock Entire &Table', ...
    'callback', {@i_lockall, cgb});
cmenu.LocksClear = uimenu(tbluic, 'label', 'Cl&ear All Locks', ...
    'callback', {@i_clearlocks, cgb});
cmenu.MathEdit = uimenu(tbluic, 'label', 'Adjust Cell &Values...', ...
    'separator', 'on', ...
    'callback', {@i_mathedittable, cgb});
d.Handles.TableContext = cmenu;
d.Handles.TableContext.This = tbluic;


% Create Toolbar
TBLYT = xregGui.uitoolbar('parent', hFig, ...
    'visible', 'off', ...
    'resourcelocation', cgrespath);
TBLYT.setRedraw(false);

tbar.Init = xregGui.uipushtool(TBLYT, ...
    'TransparentColor', [255 255 0], ...
    'ImageFile', 'reinitialise.bmp', ...
    'ToolTipString', 'Initialize Table', ...
    'ClickedCallback', {@i_inittable, cgb});
tbar.Fill = xregGui.uipushtool(TBLYT, ...
    'TransparentColor', [255 255 0], ...
    'ImageFile', 'fill.bmp', ...
    'ToolTipString', 'Fill Table', ...
    'ClickedCallback', {@i_filltable, cgb});
tbar.Optimize = xregGui.uipushtool(TBLYT, ...
    'TransparentColor', [255 255 0], ...
    'ImageFile', 'optimise.bmp', ...
    'ToolTipString', 'Optimize Table', ...
    'ClickedCallback', {@i_optimizetable, cgb});
tbar.Invert = xregGui.uipushtool(TBLYT, ...
    'TransparentColor', [255 255 0], ...
    'ImageFile', 'inversion.bmp', ...
    'ToolTipString', 'Fill by Inversion', ...
    'ClickedCallback', {@i_inverttable, cgb});
tbar.Extrapolate = xregGui.uipushtool(TBLYT, ...
    'separator', 'on', ...
    'TransparentColor', [0 255 0], ...
    'ImageFile', 'extrapolateNormal.bmp', ...
    'ToolTipString', 'Fill by Extrapolation', ...
    'ClickedCallback', {@i_extrapolate, cgb});
tbar.This = TBLYT;
d.Handles.Toolbar = tbar;
TBLYT.setRedraw(true);
TBLYT.drawToolBar;

% Create main UI components
d.Handles.Editor1D = cgtools.lookup1editor('parent', hFig, ...
    'TableContextMenu', tbluic, ...
    'visible', 'off');
d.Handles.Editor2D = cgtools.lookup2editor('parent', hFig, ...
    'TableContextMenu', tbluic, ...
    'visible', 'off');
d.Handles.FeatureComp = cgtools.featurecomp('parent', hFig, ...
    'visible', 'off');
d.Handles.InversionPane = cgtools.inversionpane(hFig);

% Attach listeners for refreshing display after changes
d.Handles.EditListeners = [ ...
    handle.listener(d.Handles.Editor1D, 'ValuesChanged', {@i_refreshcomparison, d.Handles.FeatureComp, cgb});...
    handle.listener(d.Handles.Editor2D, 'ValuesChanged', {@i_refreshcomparison, d.Handles.FeatureComp, cgb});...
    ];

% Attach listeners for controlling inversion
d.Handles.InversionListeners = [ ...
    handle.listener(d.Handles.InversionPane ,'InversionComplete', {@i_completeinversion, cgb}); ...
    handle.listener(d.Handles.InversionPane ,'InversionCancelled', {@i_completeinversion, cgb}); ...
    handle.listener(d.Handles.InversionPane ,'TableChanged', {@i_inversionchange, cgb}); ...
    ];


d.Handles.TopCard = xregcardlayout(hFig, ...
    'visible', 'off', ...
    'numcards', 2);
attach(d.Handles.TopCard, d.Handles.Editor1D, 1);
attach(d.Handles.TopCard, d.Handles.Editor2D, 2);
d.Handles.BottomCard = xregcardlayout(hFig, ...
    'visible', 'off', ...
    'numcards', 2);
attach(d.Handles.BottomCard, d.Handles.FeatureComp, 1);
attach(d.Handles.BottomCard, d.Handles.InversionPane, 2);

d.Handles.Split = xregsnapsplitlayout(hFig,...
    'visible','off',...
    'barstyle',1,...
    'orientation','ud',...
    'split',[0.5 0.5],...
    'style','tobottom',...
    'snapstyle','tozero',...
    'state', 'bottom', ...
    'splitenable', 'off', ...
    'minwidth',[150 150],...
    'callback',{@i_SnapSplitCallback, cgb}, ...
    'elements',{d.Handles.TopCard,d.Handles.BottomCard});
LYT = d.Handles.Split;



% Performs a fast refresh of the current data in the comparison pane
function i_refreshcomparison(src, evt, hComp, cgb)
hComp.refresh;
cgb.doDrawTree(cgb.CurrentNode, 'update');

function i_SnapSplitCallback(src, evt, cgb)
d = cgb.getViewData;
isClosed = strcmp(get(d.Handles.Split, 'state'), 'bottom');
if isClosed && d.ComparisonPaneRequested
    % Pane has been snapped shut
    set(d.Handles.ViewMenu.CompPane, 'checked', 'off');
    d.ComparisonPaneRequested = false;
    cgb.setViewData(d);
elseif ~isClosed && ~d.ComparisonPaneRequested
    % Pane has been snapped open
    set(d.Handles.ViewMenu.CompPane, 'checked', 'on');
    d.ComparisonPaneRequested = true;
    cgb.setViewData(d);
end

function i_opencomparison(src, evt, cgb)
d = cgb.getViewData;
d.ComparisonPaneRequested = ~d.ComparisonPaneRequested;
cgb.setViewData(d);
if d.ComparisonPaneRequested
    set(src, 'checked', 'on');
    set(d.Handles.Split, 'state', 'center');
else
    set(src, 'checked', 'off');
    set(d.Handles.Split, 'state', 'bottom');
end


function i_seteditoreditstate(src, evt, cgb, state)
d = cgb.getViewData;
set([d.Handles.ViewMenu.RotateSurf; d.Handles.ViewMenu.EditSurf], 'checked', 'off');
set(src, 'checked', 'on');
d.Handles.Editor2D.GraphEditingEnable = state;


function i_showhistory(src, evt, cgb)
pN = cgb.currentnode;
cghistorymanager('create',pN.getdata);


function i_inittable(src, evt, cgb)
nd = cgb.CurrentNode;
pT = nd.getdata;
tbl = pT.info;
M = nd.get('managers');

if isempty(M.InitialisationManager)
    M.InitialisationManager = init(tbl);
end

if ~isempty(get(M.InitialisationManager))
    % If there are options to display
    [M.InitialisationManager,OK] = gui_setup(M.InitialisationManager,'figure', ...
        {'expanded', 1, 'title', 'Table Value Initialization Options'});
    drawnow('expose');
else
    OK = 1;
end

if OK
    nd.info = nd.set('managers', M);
    [tbl, cost, runOK, msg] = run(M.InitialisationManager,tbl,[]);
    if ~runOK
        h = errordlg(sprintf('There was a problem initializing the table:\n\n%s', msg), ...
            'Initialization Error', 'modal');
        waitfor(h);
    else % if everything is fine
        pT.info = tbl;
        i_message(cgb, sprintf('Initialized table %s', getname(tbl)));
    end
end
cgb.doDrawTree(nd, 'update');
i_quickrefresh(cgb.getViewData);



function i_filltable(src, evt, cgb)
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(cgb.Figure, 'watch');
i_message(cgb, 'Generating table filling options...');

nd = cgb.CurrentNode;
pT = nd.getdata;
tbl = pT.info;
M = nd.get('managers');
d = cgb.getViewData;

if isempty(M.FillManager)
    [M.FillManager, setupOK, msg] = fill(tbl, d.FeaturePointer);
else
    setupOK = true;
end

if ~setupOK
    h = errordlg(sprintf('Problem creating the fill options:\n\n%s', msg), ...
        'Table Filling Error', 'modal');
    waitfor(h);
    PR.stackRemovePointer(cgb.Figure, ptrID);
    return
end

if ~isempty(get(M.FillManager)) % if there are options to display
    [M.FillManager,OK] = gui_setup(M.FillManager,'figure', ...
        {'expanded', 1, 'title', 'Table Filling Options'});
    drawnow('expose');
else
    OK = true;
end

if ~OK
    PR.stackRemovePointer(cgb.Figure, ptrID);
    return
end

nd.info = nd.set('managers', M);

NewPtrs = null(xregpointer,0);
try
    i_message(cgb, 'Analyzing strategy to determine table effect...');
    % "solve" the feature for the table
    [tab, tableexpr, problem, NewPtrs] = solve(d.FeaturePointer.info,[],pT);

    if ~problem
        i_message(cgb, 'Filling table from model...');
        [tbl, cost,runOK, msg] = run(M.FillManager, tbl, [], tableexpr);
        if ~runOK
            h = errordlg(sprintf('There was a problem filling the table:\n\n%s', msg), ...
                'Table Filling Error', 'modal');
            waitfor(h);
        else
            % Successful fill
            pT.info = tbl;
            i_message(cgb, sprintf('Filled table %s', getname(tbl)));
            i_quickrefresh(d);
            cgb.doDrawTree(nd, 'update');
        end
    else
        % Filling not possible
        h = errordlg(['Unable to solve the strategy for the table.  ', ...
            'Try optimizing the table values.'], ...
            'Table Filling Error', 'modal');
        waitfor(h);
    end
catch
    i_message(cgb, '');
    h = errordlg(sprintf('Unknown error occurred during filling:\n\n%s', lasterr), ...
        'Table Filling Error', 'modal');
    waitfor(h);
end
freeptr(NewPtrs);
PR.stackRemovePointer(cgb.Figure, ptrID);


function i_optimizetable(src, evt, cgb)
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(cgb.Figure, 'watch');
i_message(cgb, 'Generating table optimization options...');

nd = cgb.CurrentNode;
pT = nd.getdata;
tbl = pT.info;
M = nd.get('managers');
d = cgb.getViewData;

if isempty(M.OptimisationManager)
    [M.OptimisationManager,setupOK, msg] = opt(tbl,d.FeaturePointer.info);
else
    setupOK = true;
end

if ~setupOK
    h = errordlg(sprintf('Problem creating the optimization options:\n\n%s', msg), ...
        'Table Optimization Error', 'modal');
    waitfor(h);
    PR.stackRemovePointer(cgb.Figure, ptrID);
    return
end

if ~isempty(get(M.OptimisationManager)) % if there are options to display
    [M.OptimisationManager,OK] = gui_setup(M.OptimisationManager,'figure', ...
        {'expanded', 1,'title', 'Table Optimization Options'});
    drawnow('expose');
else
    OK = 1;
end

if ~OK
    PR.stackRemovePointer(cgb.Figure, ptrID);
    return
end

nd.info = nd.set('managers', M);

try
    i_message(cgb, 'Optimizing...');
    [tbl,cost,runOK, msg] = run(M.OptimisationManager,tbl,[],d.FeaturePointer.info,pT);
    if ~runOK
        h = errordlg(sprintf('There was a problem optimizing the table:\n\n%s', msg), ...
            'Table Optimization Error', 'modal');
        waitfor(h);
    else
        % if everything is fine
        pT.info = tbl;
        i_message(cgb, sprintf('Optimized table %s', getname(tbl)));
        i_quickrefresh(d);
        cgb.doDrawTree(nd, 'update');
    end
catch
    i_message(cgb, '');
    h = errordlg(sprintf('Unknown error occurred during optimization:\n\n%s', lasterr), ...
        'Table Optimization Error', 'modal');
    waitfor(h);
end
PR.stackRemovePointer(cgb.Figure, ptrID);


function i_inverttable(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.currentnode;
pT = nd.getdata;

msg = d.Handles.InversionPane.startup(nd, pT);

if ~isempty(msg)
    h = errordlg(sprintf('An error occurred during inversion initialisation:\n\n%s', ...
        msg), 'Inversion Error', 'modal');
    waitfor(h);
else
    % Disable all menus and the toolbar
    i_setmenustatus(cgb, 'off');

    % Flick to the inversion card and make sure the bottom split is open
    set(d.Handles.BottomCard,'CurrentCard',2);
    set(d.Handles.Split,'state','center','splitenable','off');
end

function i_completeinversion(src, evt, cgb)
% Reset ui state
cgb.ShowNode;
cgb.ViewNode;
cgb.doDrawTree(cgb.CurrentNode, 'update');
d = cgb.getViewData;
set(d.Handles.BottomCard, 'currentcard', 1);

function i_inversionchange(src, evt, cgb)
% Update current editor display
i_quickrefresheditor(cgb.getViewData);


function i_mathedittable(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.currentnode;
pT = nd.getdata;

% get the current region
[rowsel, colsel] = i_getselection(d);
selectedregion = false( size( get( pT.info, 'values' ) ) );
selectedregion = i_setblockstovalue(selectedregion, rowsel, colsel, true);

% pass these on to the gui
[newT, ok] = cgtableoperationgui( pT.info, selectedregion );
if ok
    % set the newvalues back into the table + update the gui
    pT.info = newT;
    i_quickrefresh(d);
    cgb.doDrawTree(nd, 'update');
end


function i_convtomodel(src, evt, cgb)
nd = cgb.CurrentNode;
PROJ = project(nd.info);
pT = nd.getdata;
tbl = pT.info;

if isempty(tbl)
    h = errordlg(['You must initialise this table before it can be converted to' ...
        ' a model.'], 'Model Conversion Error', 'modal');
    waitfor(h);
else
    s.User = '';
    s.Date = datestr(now);
    s.Version = mbcver;
    s.Parent = [];
    s.Variables = {};
    s.new = [];
    e = cgexprmodel(pT,s);
    [n,symbols,u] = nfactors(e);
    if n > 0
        M = xregpointer(cgmodexpr(getname(tbl),e));
        pDD = getdd(PROJ);
        DD = pDD.info;
        inputPtrs = null(xregpointer, n, 1);
        for nn = 1:n
            [DD, inputPtrs(nn)] = add(DD,symbols{nn});
        end
        M.info = M.set('ptrlist',inputPtrs);
        addtoproject(PROJ, M);
        i_message(cgb, sprintf( 'Created model %s from table %s', M.getname, getname(tbl)));
    else
        % Free the expression model to ensure copied pointers are freed
        freeptr(e);
        h = errordlg(['A model could not be created from this table because ', ...
            'it was empty or not properly initialized'], ...
            'Model Conversion Error', 'modal');
        waitfor(h);
    end
end


function i_properties(src, evt, cgb)
nd = cgb.CurrentNode;
pT = nd.getdata;
prec = pT.get('precision');
size = [400 375];
figpos = get(cgb.Figure,'position');
pos = [figpos(1:2)+(figpos(3:4)-size)./2 size];  % center in parent
pr = precedit(prec,pos);
if ~isempty(pr)
    pT.info = pT.setprecision(pr);
    i_quickrefresh(cgb.getViewData);
end


% ------- Extrapolation Mask functions -------
function i_addtomask(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.CurrentNode;
pT = nd.getdata;
[rowsel, colsel] = i_getselection(d);
if ~isempty(rowsel) ...
        && ~pT.allExtrapolationMask([min(rowsel(:,1)), max(rowsel(:,2))], ...
        [min(colsel(:,1)), max(colsel(:,2))])
    pT.info = pT.addRectToExtrapolationMask(rowsel, colsel);
    i_quickrefresheditor(d);
end

function i_remfrommask(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.CurrentNode;
pT = nd.getdata;
[rowsel, colsel] = i_getselection(d);
if ~isempty(rowsel) ...
        && pT.anyExtrapolationMask([min(rowsel(:,1)), max(rowsel(:,2))], ...
        [min(colsel(:,1)), max(colsel(:,2))])
    pT.info = pT.removeRectFromExtrapolationMask(rowsel, colsel);
    i_quickrefresheditor(d);
end

function i_clearmask(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.CurrentNode;
pT = nd.getdata;
if pT.anyExtrapolationMask
    pT.info = pT.clearExtrapolationMask;
    i_quickrefresheditor(d);
end

function i_maskfromPE(src, evt, cgb)
nd = cgb.currentnode;
pT = nd.getdata; % table pointer
d = cgb.getViewData;

if ~pT.hasinportperaxis
    waitfor(errordlg('Table must have a single independent variable for each input axis.',...
        'Generate Extrapolation Mask','modal'));
    return
end
if isempty(d.FeaturePointer)
    waitfor(errordlg('No model is available from which to generate the extrapolation mask.',...
        'Generate Extrapolation Mask','modal'));
    return
end

model = d.FeaturePointer.get('model');
if isempty(model)
    waitfor(errordlg('No model is associated with this feature.',...
        'Generate Extrapolation Mask', 'modal'));
elseif ~model.pevcheck
    waitfor(errordlg('The model associated with this feature does not support PE calculations.',...
        'Generate Extrapolation Mask', 'modal'));
else
    [tbl, ok] = createExtrapolationMaskFromPEV(pT.info, model.info, 'interactive');
    if ok
        pT.info = tbl;
        i_quickrefresheditor(d);
    else
        waitfor(errordlg('Unknown error occurred while creating mask from PE.',...
            'Generate Extrapolation Mask', 'modal'));
    end
end

function i_maskfromcon(src, evt, cgb)
nd = cgb.currentnode;
pT = nd.getdata; % table pointer
d = cgb.getViewData;

if ~pT.hasinportperaxis
    waitfor(errordlg('Table must have a single independent variable for each input axis.',...
        'Generate Extrapolation Mask','modal'));
    return
end
if isempty(d.FeaturePointer)
    waitfor(errordlg('No model is available from which to generate the extrapolation mask.',...
        'Generate Extrapolation Mask','modal'));
    return
end

model = d.FeaturePointer.get('model');
if isempty(model)
    waitfor(errordlg('No model is associated with this feature.',...
        'Generate Extrapolation Mask', 'modal'));
elseif ~model.concheck
    waitfor(errordlg('No boundary is defined for the model associated with this feature.',...
        'Generate Extrapolation Mask', 'modal'));
else
    [tbl, ok] = createExtrapolationMaskFromBoundary(pT.info, model.info);
    if ok
        pT.info = tbl;
        i_quickrefresheditor(d);
    else
        waitfor(errordlg('Unknown error occurred while creating mask from boundary values.',...
            'Generate Extrapolation Mask', 'modal'));
    end
end

function i_extrapolate(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.CurrentNode;
pT = nd.getdata;
if pT.anyExtrapolationMask
    pT.info = pT.extrapolate;
    i_quickrefresh(d);
end


% ------- Cell locks functions -------
function i_addtolocks(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.CurrentNode;
pT = nd.getdata;
[rowsel, colsel] = i_getselection(d);
if ~isempty(rowsel)
    tbl = pT.info;
    for n = 1:size(rowsel,1)
        tbl = MaskManager(tbl, rowsel(n,1):rowsel(n,2), colsel(n,1):colsel(n,2), 'lock');
    end
    pT.info = tbl;
    i_quickrefresheditor(d);
end

function i_remfromlocks(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.CurrentNode;
pT = nd.getdata;
[rowsel, colsel] = i_getselection(d);
if ~isempty(rowsel)
    tbl = pT.info;
    for n = 1:size(rowsel,1)
        tbl = MaskManager(tbl, rowsel(n,1):rowsel(n,2), colsel(n,1):colsel(n,2), 'unlock');
    end
    pT.info = tbl;
    i_quickrefresheditor(d);
end

function i_lockall(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.CurrentNode;
pT = nd.getdata;
pT.info = MaskManager(pT.info, 0, 0, 'lock');
i_quickrefresheditor(d);

function i_clearlocks(src, evt, cgb)
d = cgb.getViewData;
nd = cgb.CurrentNode;
pT = nd.getdata;
pT.info = MaskManager(pT.info, 0, 0, 'unlock');
i_quickrefresheditor(d);



function [rowblocks, colblocks] = i_getselection(d)
rowblocks = [];
colblocks = [];
% Get selection from current card
cc = get(d.Handles.TopCard, 'currentcard');
if cc==1
    sel_blocks = d.Handles.Editor1D.getSelectedRects;
    rowblocks = cat(1, sel_blocks{:,1});
    colblocks = ones(size(rowblocks));
elseif cc==2
    sel_blocks = d.Handles.Editor2D.getSelectedRects;
    rowblocks = cat(1, sel_blocks{:,1});
    colblocks = cat(1, sel_blocks{:,2});
end

function mask = i_setblockstovalue(mask, rowsel, colsel, val)
for n = 1:size(colsel, 1)
    mask(rowsel(n,1):rowsel(n,2), colsel(n,1):colsel(n,2)) = val;
end

function i_quickrefresh(d)
i_quickrefresheditor(d);
d.Handles.FeatureComp.refresh;

function i_quickrefresheditor(d)
if get(d.Handles.TopCard, 'CurrentCard')==1
    d.Handles.Editor1D.update;
else
    d.Handles.Editor2D.update;
end

function i_updatenode(cgb)
cgb.doDrawTree(cgb.CurrentNode, 'update');


function i_message(cgb, msg)
d = cgb.getViewData;
if ~isempty(d.ShownMessageID)
    cgb.removeStatusMsg(d.ShownMessageID);
end
if ~isempty(msg)
    d.ShownMessageID = cgb.addStatusMsg(msg);
else
    d.ShownMessageID = [];
end
cgb.setViewData(d);


function i_setmenustatus(cgb, state)
if strcmp(state, 'on')
    % Use the show method to correctly set up the menus
    cgb.ShowNode;
else
    % Set all items off
    d = cgb.getViewData;
    set(get(d.Handles.ViewMenu.This, 'children'), 'enable', 'off');
    set(get(d.Handles.TableMenu.This, 'children'), 'enable', 'off');
    set(get(d.Handles.Toolbar.This, 'children'), 'enable', 'off');
    set(get(d.Handles.TableContext.This, 'children'), 'enable', 'off');
end