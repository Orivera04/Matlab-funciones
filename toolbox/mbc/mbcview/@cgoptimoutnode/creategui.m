function [LYT, TBLYT, d] = creategui(CGND, info)
%CREATEGUI Browser GUI creation
%
% [LYT, TBLYT, ViewData] = creategui(CGND, info);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.13.6.3 $    $Date: 2004/04/04 03:33:51 $


cgb=info.browserH;
Fig = info.Figure;
d.Handles.Figure = Fig;
sc = xregGui.SystemColorsDbl;

% ---------------- Menu setup ------------------------------------------
menus=cgb.createmenu(guid(CGND),2);
set(menus,{'label'},{'&View';'&Solution'});
m = menus(1);
d.Handles.Menu.View(1) = uimenu(m , 'label' , '&Solution Graphs', ...
    'callback', {@i_menuchangeview, 1});
d.Handles.Menu.View(2) = uimenu(m , 'label' , '&Pareto Graphs', ...
    'callback', {@i_menuchangeview, 2});
d.Handles.Menu.View(3) = uimenu(m , 'label' , '&Weighted Pareto', ...
    'callback', {@i_menuchangeview, 3});
d.Handles.Menu.View(4) = uimenu(m , 'label' , 'S&elected Solution', ...
    'callback', {@i_menuchangeview, 4});
d.Handles.Menu.ShowConList = uimenu(m , 'label' , 'Constraint S&ummary', ...
    'callback', @i_switchconlist, 'separator', 'on');
d.Handles.Menu.ShowConGraphs = uimenu(m , 'label' , 'Constraint &Model Graphs', ...
    'callback', @i_switchcongraphs);
gs = uimenu(m , 'label' , '&Graph Size', ...
    'separator', 'on');
d.Handles.Menu.GraphSize(1) = uimenu(gs , 'label' , '&Small', ...
    'callback', {@i_changegraphsize, 50});
d.Handles.Menu.GraphSize(2) = uimenu(gs , 'label' , '&Medium', ...
    'checked', 'on', ...
    'callback', {@i_changegraphsize, 100});
d.Handles.Menu.GraphSize(3) = uimenu(gs , 'label' , '&Large', ...
    'callback', {@i_changegraphsize, 150});

m = menus(2);
mm = uimenu(m , 'label' , '&Selected Solution');
d.Handles.Menu.InitSol = uimenu(mm, 'label', '&Initialize...', ...
    'callback', @i_initselsol);
d.Handles.Menu.SelectSol = uimenu(mm, 'label', '&Select Current Solution', ...
    'enable', 'off', 'callback', @i_setselsol);
d.Handles.Menu.EditWeights = uimenu(m , 'label' , '&Edit Pareto Weights', ...
    'callback', @i_editweights);
d.Handles.Menu.ExportToDS = uimenu(m , 'label' , 'E&xport to Data Set', ...
    'separator', 'on', 'callback', @i_exportdataset);
d.Handles.Menu.FillTable = uimenu(m , 'label' , '&Fill Tables', ...
    'separator', 'on', 'callback', @i_filltables);

% ---------------- Toolbar setup ------------------------------------------
icons{1,1} = cgresload('optimsolution.bmp','bmp');
icons{2,1} = cgresload('optimpareto.bmp','bmp');
icons{3,1} = cgresload('optimweightpareto.bmp','bmp');
icons{4,1} = cgresload('optimbestsol.bmp','bmp');
icons{5,1} = cgresload('optimeditweights.bmp','bmp');
icons{6,1} = cgresload('optimselbest.bmp','bmp');
icons{7,1} = cgresload('optimexportds.bmp','bmp');

callbacks = {{@i_tbchangeview, 1};{@i_tbchangeview, 2};{@i_tbchangeview, 3};{@i_tbchangeview, 4};...
        @i_editweights; @i_setselsol; @i_exportdataset};
tooltips = {'Solution View';...
        'Pareto View';...
        'Weighted Pareto View'; ...
        'Selected Solution View'; ...
        'Edit Pareto Weights'; ...
        'Select Solution'; ...
        'Export to Data Set'};
transpclr = [0 255 0];
sep = {'off'; 'off'; 'off'; 'off'; 'on'; 'off'; 'on'};
[TBLYT, btns] = xregtoolbar(info.Figure, ...
    {'uitoggle','uitoggle','uitoggle','uitoggle','uipush', 'uipush', 'uipush'}, ... 
    {'Cdata'},icons,...
    {'ClickedCallback'},callbacks,...
    {'ToolTipString'},tooltips,...
    'TransparentColor',transpclr, ...
    {'Separator'}, sep);
btns(1).state = 'on';

d.Handles.Toolbar.View = btns(1:4);
d.Handles.Toolbar.SelectSol = btns(6);
d.Handles.Toolbar.EditWeights = btns(5);
d.Handles.Toolbar.ExportToDS = btns(7);


% ---------------- Main UI setup ------------------
ViewIndexCtrl= xregGui.clickedit(Fig,...
    'visible','off',...
    'style','leftright',...
    'max', Inf, ...
    'min', 1, ...
    'rule', 'int', ...
    'callback', @i_changeindex, ...
    'backgroundcolor', sc.WINDOW_BG);
d.Handles.ViewIndex = xregGui.labelcontrol('parent', Fig,...
    'visible', 'off', ...
    'string', 'Solution:', ...
    'labelalignment', 'right', ...
    'Control', ViewIndexCtrl);

d.SolImages = mbcfoundation.memImageStrip;
d.SolImages.readFromFile(cgrespath('optim_widget_vert.bmp'), 32);
d.OpPtImages = mbcfoundation.memImageStrip;
d.OpPtImages.readFromFile(cgrespath('optim_widget_horz.bmp'), 32);
d.Handles.progresswidget = xregGui.imagePlayer('parent', Fig,...
    'imageSource',d.SolImages, ...
    'min', 1);

d.Handles.Table = cgoptimgui.resultsTable('parent', Fig, ...
    'visible', 'off');
d.Handles.AlgStats = xregGui.infoPane('parent', Fig, ...
    'splitposition', 0.6, ...
    'visible', 'off');
d.Handles.FreeVars = xregGui.infoPane('parent', Fig, ...
    'visible', 'off');
d.Handles.ObjectiveGraphs = cgoptimgui.objectivegrid('parent', Fig, ...
    'visible', 'off', ...
    'graphsize', 100);
d.Handles.ParetoGraphs = cgoptimgui.paretogrid('parent', Fig, ...
    'visible', 'off', ...
    'graphsize', 100);
d.Handles.ConstraintList = cgoptimgui.constraintsTable('parent', Fig, ...
    'visible', 'off');
d.Handles.ConstraintGraphs = cgoptimgui.constraintgrid('parent', Fig, ...
    'visible', 'off', ...
    'graphsize', 100);


pnl1 = xregGui.panel('parent', Fig, ...
    'visible', 'off', ...
    'type', 'out');
pnl2 = xregGui.panel('parent', Fig, ...
    'visible', 'off');
tblpanel = xregpaneltitlelayout(Fig, ...
    'packstatus', 'off', ...
    'visible', 'off', ...
    'center', d.Handles.Table, ...
    'title', 'Optimization Output');
algpanel = xregpaneltitlelayout(Fig, ...
    'visible', 'off', ...
    'center', d.Handles.AlgStats, ...
    'title', 'Algorithm Statistics');
varpanel = xregpaneltitlelayout(Fig, ...
    'visible', 'off', ...
    'center', d.Handles.FreeVars, ...
    'title', 'Free Variable Values');
split  = xregsplitlayout(Fig, ...
    'visible', 'off', ...
    'dividerstyle', 'flat', ...
    'dividerwidth', 4, ...
    'orientation', 'ud', ...
    'top', algpanel, ...
    'bottom', varpanel, ...
    'split', [.4 .6], ...
    'minwidthunits', 'pixels', ...
    'minwidth', [23 23]);
snapsplit = xregsnapsplitlayout(Fig, ...
    'visible', 'off', ...
    'style', 'toright', ...
    'barstyle', 1, ...
    'minwidthunits', 'pixels', ...
    'split', [.7 .3], ...
    'minwidth', [0 50], ...
    'left', tblpanel, ...
    'right', split);
ctrl_strip = xreggridbaglayout(Fig, ...
    'dimension', [3 4], ...
    'rowsizes', [6 20 6], ...
    'colsizes', [32 10 150 -1], ...
    'mergeblock', {[1 3], [1 1]}, ...
    'elements', {d.Handles.progresswidget,[],[],...
        [],[],[],...
        [],d.Handles.ViewIndex});
top_strip = xregframetitlelayout(Fig, ...
    'visible', 'off', ...
    'center', ctrl_strip, ...
    'innerborder', [4 0 4 7]);
d.Handles.ObjPanel = xregpaneltitlelayout(Fig, ...
    'visible', 'off', ...
    'center', d.Handles.ObjectiveGraphs, ...
    'title', 'Objective Functions');
ParetoPanel = xregpaneltitlelayout(Fig, ...
    'visible', 'off', ...
    'center', d.Handles.ParetoGraphs, ...
    'title', 'Pareto Graphs');
d.Handles.ConPanel = xregpaneltitlelayout(Fig, ...
    'visible', 'off', ...
    'center', d.Handles.ConstraintGraphs, ...
    'title', 'Constraint Models');
d.Handles.ConListPanel = xregpaneltitlelayout(Fig, ...
    'visible', 'off', ...
    'center', d.Handles.ConstraintList, ...
    'title', 'Constraint Summary');
d.Handles.ConstraintLayout = xreggridbaglayout(Fig, ...
    'dimension', [1 1], ...
    'gapy', 2, ...
    'elements', {d.Handles.ObjPanel});
d.Handles.GraphCard = xregcardlayout(Fig, 'numcards', 2);
attach(d.Handles.GraphCard, d.Handles.ConstraintLayout, 1);
attach(d.Handles.GraphCard, ParetoPanel, 2);
toplayout = xreggridbaglayout(Fig, ...
    'dimension', [2 1], ...
    'rowsizes', [40 -1], ...
    'gapy', 2, ...
    'elements', {top_strip, snapsplit});
LYT = xregsplitlayout(Fig, ...
    'visible', 'off', ...
    'dividerstyle', 'flat', ...
    'dividerwidth', 4, ...
    'orientation', 'ud', ...
    'split', [.4 .6], ...
    'minwidthunits', 'pixels', ...
    'minwidth', [85 100], ...
    'top', toplayout, ...
    'bottom', d.Handles.GraphCard);


% Link progress widget to index input
d.ProgressLinks = [...
        handle.listener(ViewIndexCtrl, ViewIndexCtrl.findprop('min'), 'PropertyPostSet', {@i_setprogress, d.Handles.progresswidget});...
        handle.listener(ViewIndexCtrl, ViewIndexCtrl.findprop('max'), 'PropertyPostSet', {@i_setprogress, d.Handles.progresswidget});...
        handle.listener(ViewIndexCtrl, ViewIndexCtrl.findprop('value'), 'PropertyPostSet', {@i_setprogress, d.Handles.progresswidget});...   
    ];
d.TableCallback = [...
        handle.listener(d.Handles.Table, 'SolutionChange', @i_changesol) ; ...
        handle.listener(d.Handles.Table, 'OperatingPointChange', @i_changeoppoint) ; ...
    ];
d.CurrentView = 1;
d.ConListShowing = false;
d.ConGraphsShowing = false;
d.CurrentSolution = 0;
d.CurrentOpPoint = 0;

function i_setprogress(src, evt, hProgress)
set(hProgress, src.Name, evt.NewValue);

function i_changeindex(src, evt)
% Callback from the clickedit that scrolls through either solutions or
% operating points, depending on the current view
c = cgbrowser;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(c.Figure, 'watch');
d = c.getViewData;
pNode = c.CurrentNode;
if d.CurrentView==1 || d.CurrentView==4
    d.CurrentSolution = src.value;
else
    d.CurrentOpPoint = src.value;
end
d = view(pNode.info, c, d);
c.setViewData(d);
PR.stackRemovePointer(c.Figure, ptrID);

function i_changesol(src, evt)
% Solution change callback
c = cgbrowser;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(c.Figure, 'watch');
d = c.getViewData;
pNode = c.CurrentNode;
d.CurrentSolution = src.SolutionIndex;
d = view(pNode.info, c, d);
c.setViewData(d);
PR.stackRemovePointer(c.Figure, ptrID);

function i_changeoppoint(src, evt)
% Operating point change callback
c = cgbrowser;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(c.Figure, 'watch');
d = c.getViewData;
pNode = c.CurrentNode;
d.CurrentOpPoint = src.OpPointIndex;
if d.CurrentView==4
    % First thing to do in the custom solution view is to simultaneously
    % change the solution number
    pOptim = pNode.getdata;
    solnumber = getselectedsolnumber(pOptim.info, d.CurrentOpPoint);
    d.Handles.ViewIndex.Control.Value = solnumber;
    d.CurrentSolution = solnumber;
end
d = view(pNode.info, c, d);
c.setViewData(d);
PR.stackRemovePointer(c.Figure, ptrID);



function i_menuchangeview(src, evt, idx)
c = cgbrowser;
d = c.getViewData;
if idx ~= d.CurrentView
    i_changeview(idx);
end

function i_tbchangeview(src, evt, idx)
c = cgbrowser;
d = c.getViewData;
if idx ~= d.CurrentView
    i_changeview(idx);
else
    % reselect button
    set(src, 'state', 'on');
end


function i_changeview(idx)
c = cgbrowser;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(c.Figure, 'watch');
d = c.getViewData;
pNode = c.CurrentNode;
% Deselect old items and select new ones
set(d.Handles.Menu.View(d.CurrentView), 'checked', 'off');
set(d.Handles.Toolbar.View(d.CurrentView), 'state', 'off');
set(d.Handles.Menu.View(idx), 'checked', 'on');
set(d.Handles.Toolbar.View(idx), 'state', 'on');
if idx==1 || idx==4
    set(d.Handles.GraphCard, 'currentcard', 1);
else
    set(d.Handles.GraphCard, 'currentcard', 2);
end
d.CurrentView = idx;
if idx==4
    % Switch solution to the selected one
    pOptim = pNode.getdata;
    d.CurrentSolution = getselectedsolnumber(pOptim.info, d.CurrentOpPoint);
end
pInitIndexControls(d, pNode.getdata);
pEnableViews(d, pNode.getdata);
d = view(pNode.info, c, d);
c.setViewData(d);
PR.stackRemovePointer(c.Figure, ptrID);


function i_editweights(src, evt)
c = cgbrowser;
d = c.getViewData;
pNode = c.CurrentNode;
pOptim = pNode.getdata;
[pOptim.info, OK] = editweights(pOptim.info);
if OK && d.CurrentView==3
    pForceRefresh(d);
end


function i_changegraphsize(src, evt, newsize)
c = cgbrowser;
d = c.getViewData;
d.Handles.ObjectiveGraphs.GraphSize = newsize;
d.Handles.ConstraintGraphs.GraphSize = newsize;
d.Handles.ParetoGraphs.GraphSize = newsize;
set(d.Handles.Menu.GraphSize, 'checked', 'off');
set(src, 'checked', 'on');


function i_exportdataset(src, evt)
c = cgbrowser;
d = c.getViewData;
pNode = c.CurrentNode;

hOptim = info(pNode.getdata);
dsname = '';
optimname = getname(hOptim);
% Truncate optimname if too long for any of the data set names
solsz = getsolutionsize(hOptim);
maxlensolstr = length('_sol') + length(num2str(solsz(2)));
maxlenptstr = length('_pt') + length(num2str(solsz(1)));
maxlenselsolstr = length('_selectedsol');
mincharreserve = max([maxlensolstr, maxlenptstr, maxlenselsolstr]);
maxlenoptname = namelengthmax - mincharreserve;
if length(optimname) > maxlenoptname
    optimname = optimname(1:maxlenoptname);
end

switch d.CurrentView
    case 1
        [dData, nul, pItems] = getsolution(hOptim, d.CurrentSolution);
        dsname = [optimname, '_sol', num2str(d.CurrentSolution)];
    case 2
        [dData, nul, pItems] = getparetosolution(hOptim, d.CurrentOpPoint);
        dsname = [optimname, '_pt', num2str(d.CurrentOpPoint)];
    case 3
        % Cannot export the weighted pareto dataset
        dData = [];
    case 4
        [dData, nul, pItems] = getselectedsolution(hOptim);
        dsname = [optimname, '_selectedsol'];
end
if ~isempty(dData)
    pDS = xregpointer(cgoppoint(pItems, dData));
    ftype = pDS.get('factor_type');
    indsin = find(ftype==1);
    pDS.info = pDS.set(indsin, 'grid_flag', repmat(7, 1, length(indsin)));
    pDS.info = pDS.setname(dsname);
    pDSNode=cgnode(pDS.info,[],pDS,1);
    hProj = pNode.project;
    addnodestoproject(hProj, pDSNode);    
    c.addTimedStatusMsg('New Data Set created.', 10);
else
    c.addTimedStatusMsg('No data to export.', 10);
end

function i_filltables(src, evt)

% Get CAGE project
c = cgbrowser;
cgp = c.rootnode;
pN = c.currentnode;
pO = pN.getdata;

% Choose tables and optimization results to fill them
otf = cgoptimtablefiller;
[otf, OK] = guiSetUp(otf, cgp, pO);

if OK
    
    % Get the output data for this optimization
    [outdata, notneeded, outfactors] = getsolutioncube(pO.info);
    outweights = getparetoweights(pO.info);
    optimname = pO.getname;

    % Fill all the tables
    DOWAITBAR = true;
    fillstat = fill(otf, outdata, outfactors, outweights, optimname, DOWAITBAR);

    % Check to see if all the tables have been filled correctly. Inform the
    % user either way.
    indbad = [];
    indbad = find(~fillstat);
    if ~isempty(indbad)
        % Inform the user which tables were not filled.
        pTabs = getTables(otf);
        pNotFillTabs = pTabs(indbad);
        i_warnUserNonFill(pNotFillTabs);
    else
        % All OK tell the user.
        uiwait(msgbox('All tables filled successfully','Table Filling from Optimization','help','modal'));
    end
end

%--------------------------------------------------------------------------
function i_warnUserNonFill(pNotFillTabs)
%--------------------------------------------------------------------------

dh= xregdialog('name','Table Filling from Optimization Results', ...
    'resize', 'off');
h= cgbrowser;
xregcenterfigure(dh,[350 200],h.Figure);

txt=uicontrol('parent',dh,...
    'style','text',...
    'horizontalalignment','left',...
    'string',['The following tables have encountered problems whilst filling', char(13), '(All other selected tables have filled successfully):']);

listbox = cgtools.exprList('parent', dh, ...
    'displaytypecolumn', false, ...
    'itemheadertext', 'Table');

listbox.Items= pNotFillTabs;

cls=uicontrol('parent',dh,...
    'style','pushbutton',...
    'string','Close',...
    'callback','set(gcbf,''visible'',''off'');');

lyt=xreggridbaglayout(dh,'dimension',[3 2],...
    'rowsizes',[45 -1 25],...
    'colsizes',[-1 65],...
    'mergeblock',{[1 1],[1 2]},...
    'mergeblock',{[2 2],[1 2]},...
    'gapy',10,...
    'border',[10 10 10 10],...
    'packstatus','off',...
    'elements',{txt,listbox,[],[],[],cls});
dh.LayoutManager=lyt;
set(lyt,'packstatus','on');
dh.showDialog(cls);


function i_initselsol(src, evt)
c = cgbrowser;
pNode = c.CurrentNode;
pOptim = pNode.getdata;
[hOptim, ok] = gui_initselsolution(pOptim.info);
if ok
    pOptim.info = hOptim;
    d = c.getViewData;
    if d.CurrentView==4
        % Reshow view
        d.CurrentSolution = getselectedsolnumber(pOptim.info, d.CurrentOpPoint);
        pInitIndexControls(d, pOptim);
        d = view(pNode.info, c, d);
        c.setViewData(d);
    else
        % Update enable statuses
        pEnableViews(d, pOptim);
    end
end


function i_setselsol(src, evt)
c = cgbrowser;
d = c.getViewData;
pNode = c.CurrentNode;
pOptim = pNode.getdata;
if d.CurrentView==1 || d.CurrentView==2
    pOptim.info = setselectedsolution(pOptim.info, d.CurrentOpPoint, d.CurrentSolution);
end


function i_switchconlist(src, evt)
c = cgbrowser;
d = c.getViewData;
if d.ConListShowing
    set(src, 'checked', 'off');
    % Remove constraint list from the solutions layout
    d.ConListShowing = false;
    d.Handles.ConstraintList.OptimizationObject = [];
else
    set(src, 'checked', 'on');
    d.ConListShowing = true;
    % update list
    PR = xregGui.PointerRepository;
    ptrID = PR.stackSetPointer(c.Figure, 'watch'); 
    d.Handles.ConstraintList.initializeData( c.CurrentNode.getdata, ...
        d.CurrentSolution, ...
        d.CurrentOpPoint);
    PR.stackRemovePointer(c.Figure, ptrID);
end
c.setViewData(d);
pSetupConLayout(d);


function i_switchcongraphs(src, evt)
c = cgbrowser;
d = c.getViewData;
if d.ConGraphsShowing
    set(src, 'checked', 'off');
    d.ConGraphsShowing = false;
    d.Handles.ConstraintGraphs.OptimizationObject = [];
else
    set(src, 'checked', 'on');
    d.ConGraphsShowing = true;
    % update graphs
    d.Handles.ConstraintGraphs.initializeData( c.CurrentNode.getdata, ...
        d.CurrentSolution, ...
        d.CurrentOpPoint);
end
c.setViewData(d);
pSetupConLayout(d);
