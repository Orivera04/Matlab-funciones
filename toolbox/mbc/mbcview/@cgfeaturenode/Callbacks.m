function h = Callbacks(TP,subfunc,varargin)
%CALLBACKS  Various cgfeature GUI callbacks
%
%  CALLBACKS(TP, 'GetHandles') returns a cell array of function handles
%  to subfunctions available:
%
%  CALLBACKS(TP, FUNC, ARGS) executes the internal function FUNC and passes
%  it ARGS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.17.2.5 $  $Date: 2004/04/04 03:33:05 $

cgb = cgbrowser;
d = cgb.getViewData;
d = pMessage(d, '');
cgb.setViewData(d);

if ischar(subfunc)
    if strcmp(lower(subfunc),'gethandles')
        h=struct('HistoryEdit',@i_HistoryEdit,...
            'HistoryDetails',@i_HistoryDetails,...
            'HistoryLabelEdit', @i_HistoryLabelEdit,...
            'HistoryListClick', @i_HistoryListClick,...
            'Duplicate',@i_Duplicate,...
            'Delete',@i_Delete,...
            'Clear',@i_Clear,...
            'SelModel',@i_SelectModel,...
            'DeselModel',@i_DeselectModel,...
            'FeatureModel',@i_FeatureToModel,...
            'SLEdit',@i_SLEdit,...
            'SLClose',@i_SLClose,...
            'SLImport',@i_SLImport,...
            'SLUpdate',@i_SLUpdate,...
            'SLExport',@i_SLExport,...
            'Initialise',@i_Initialise,...
            'Fill', @i_Fill,...
            'Optimise',@i_Optimise,...
            'Expansion',@i_Expansion,...
            'SetupViewMenu', @i_SetupViewMenu,...
            'ToggleLibrary', @i_ToggleLibrary);
    else
        feval(subfunc,varargin{:});
        h=[];
    end
end

% ----------------------------------------------------------
function i_SetupViewMenu(src, evt, varargin)
% ----------------------------------------------------------
% This sets up the checks on the View menu depending on what
% libraries are currently open.

c = cgbrowser;
N = c.CurrentNode;
d = c.getViewData;

libs = pGetFeatureLibraries;
menus = d.Handles.LibMenu;

for n=1:size(libs,1)
    isopen = feval(libs{n,2}{3}, N.info);
    if isopen
        set(menus(n), 'Checked','on');
    else
        set(menus(n), 'Checked','off');
    end
end
%----------------------------------------------------------
function i_ToggleLibrary(src, evt)
%----------------------------------------------------------
% callback from library menu item
% src's userdata stores the functions to call

c = cgbrowser;
N = c.CurrentNode;

fcns = get(src, 'Userdata');
openCB = fcns{1};
closeCB = fcns{2};

oldState = get(src,'Checked');
switch oldState
    case 'on'
        feval(closeCB, N.info)
    case 'off'
        feval(openCB, N.info)
end

% ----------------------------------------------------------
function i_HistoryEdit(obj,nul,action)
% ----------------------------------------------------------
% callback from the Add and Remove buttons

if nargin==0
    action = get(gcbo,'string');
elseif nargin<3 && ~isempty(obj)
    action = get(obj,'string');
end

CGBH = cgbrowser;
d = CGBH.getViewData;
pFN = CGBH.CurrentNode;
pF = pFN.getdata;

if isempty(pF)
    return
end

switch action
    case 'Remove'
        d = pHistoryManager( pFN, d, 'remove' );
    case 'Add'
        d = pHistoryManager( pFN, d, 'add' );        
end
CGBH.setViewData( d )

%---------------------------------------------------------------------------------------
function i_HistoryDetails(obj,nul)
%---------------------------------------------------------------------------------------
% respond to a change in the details for a history item

CGBH = cgbrowser;
d=CGBH.getViewData;
pFN = CGBH.CurrentNode;
d = pHistoryManager( pFN, d, 'detailsedit' ); 
CGBH.setViewData( d );

% ----------------------------------------------------------
function i_HistoryLabelEdit(obj,varargin)
% ----------------------------------------------------------
% respond to a click on the listview
CGBH = cgbrowser;
d = CGBH.getViewData;
pFN = CGBH.CurrentNode;
newname = varargin{3};
d = pHistoryManager( pFN, d, 'rename', newname );
CGBH.setViewData( d );

% ----------------------------------------------------------
function i_HistoryListClick(obj,varargin)
% ----------------------------------------------------------
% respond to a click on the listview
CGBH = cgbrowser;
d = CGBH.getViewData;
pFN = CGBH.CurrentNode;
% just need to refresh 
d = pHistoryManager( pFN, d, 'refreshdetails' );
CGBH.setViewData( d );

%---------------------------------------------------------------------------------------
function i_Duplicate(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
pFN = CGBH.CurrentNode;
pF = pFN.getdata;

%---------------------------------------------------------------------------------------
function i_Delete(obj,nul)
%---------------------------------------------------------------------------------------
i_Clear([],[]);
CGBH = cgbrowser;
pFN = CGBH.CurrentNode;
pF = pFN.getdata;
CGBH.setnewnode(pFN.Parent,xregpointer);
pFN.delete;
freeptr(pF);
doDrawTree(CGBH);

%---------------------------------------------------------------------------------------
function i_SelectModel(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;

pFN = CGBH.CurrentNode;
pF = pFN.getdata;
[newF, ok] = gui_setmodel(pF.info, address(pFN.project));
if ok
    pF.info = newF;
    CGBH.doDrawTree(pFN,'update');
    ViewNode(CGBH);
end

%---------------------------------------------------------------------------------------
function i_DeselectModel(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pFN = CGBH.CurrentNode;
pF = pFN.getdata;
pF.info = pF.set('model',[]);
CGBH.doDrawTree(pFN,'update');
ViewNode(CGBH);

%---------------------------------------------------------------------------------------
function i_FeatureToModel(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pFN = CGBH.CurrentNode;
pF = pFN.getdata;
 
eq = pF.get('equation');
if isempty( eq )
    i_error('Failed to create model because this feature has no strategy.');
    return;
else
    empties = pveceval(eq.getptrs, @isempty);
    if any([empties{:}])
        i_error('A model could not be created from this feature because it was empty or not properly initialized.');
        return;
    end
end
    
i.User = '';
i.Date = datestr(now);
i.Version = mbcver;
i.Parent = [];
i.Variables = {};
i.new = [];
e = cgexprmodel(pF,i);
[n,symbols,u] = nfactors(e);
if n > 0
    M = xregpointer(cgmodexpr(pF.getname,e));
    p = pFN.project;
    dd = getdd(p);
    inputPtrs = [];
    for i = 1:n
        [dd.info,thisPtr] = add(dd.info,symbols{i});
        inputPtrs = [inputPtrs;thisPtr];
    end
    M.info = M.set('ptrlist',inputPtrs);
    pFN.addtoproject(M);
    d = CGBH.getViewData;
    d = pMessage(d, sprintf( 'Feature %s successfully converted to model %s', pF.getname, M.getname ) );
    CGBH.setViewData(d);
else
    i_error('A model could not be created from this feature because it was empty or not properly initialized.');
end

%---------------------------------------------------------------------------------------
function i_SLEdit(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pFN = CGBH.CurrentNode;
d = CGBH.getViewData;
set([d.Handles.LibMenu d.Handles.ParseMenu],'enable','on');

[pFN.info, d.sys] = editstrategy( pFN.info );
d = pMessage(d, 'Double click on a blue outport to parse the required strategy');
CGBH.setViewData(d);

%---------------------------------------------------------------------------------------
function i_SLImport(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pFN = CGBH.CurrentNode;
pFN.importstrategy;
CGBH.doDrawTree;
CGBH.ViewNode;

%---------------------------------------------------------------------------------------
function i_SLUpdate(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pFN = CGBH.CurrentNode;
if isempty( obj )
    % this is a callback from the simulink diagram
    sys = get_param(gcs,'handle');
    block = get_param(gcb,'handle');
else
    % this is a menu callback
    d=CGBH.getViewData;
    sys = d.sys;
    if ~isempty( gcb )
        block = get_param(gcb,'handle');
    end
    if bdroot(block) ~= sys | ~strcmp(get_param(block,'blocktype'),'Outport')
        % gcb is the wrong block
        block = find_system(sys,'searchdepth',1,'BlockType','Outport');
        if length(block) == 0 | length(block) > 1
            return;
        end
    end
end

% Now we have the correct system and block, read the strategy in
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(CGBH.Figure, 'watch');
pFN.readstrategy( sys, block );
CGBH.doDrawTree;
CGBH.ViewNode;
PR.stackRemovePointer(CGBH.Figure, ptrID);


%---------------------------------------------------------------------------------------
function i_Clear(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
pFN = CGBH.CurrentNode;
pFN.clearstrategy;
CGBH.doDrawTree;
CGBH.ViewNode;

%---------------------------------------------------------------------------------------
function i_SLExport(obj,nul)
%---------------------------------------------------------------------------------------

CGBH = cgbrowser;
pFN = CGBH.CurrentNode;
pFN.exportstrategy;

%---------------------------------------------------------------------------------------
function i_Expansion(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;

if strcmp(get(d.Handles.expansionMenuCheck,'checked'),'on');
    set(d.Handles.expansionMenuCheck,'checked','off');
    d.Handles.equationview.ShortMode = 'on';
else
    set(d.Handles.expansionMenuCheck,'checked','on');
    d.Handles.equationview.ShortMode = 'off';
end

%---------------------------------------------------------------------------------------
function i_Initialise(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;

cnode = CGBH.currentnode;
feat = cnode.getdata;

% if the initialisation manager is empty, then (re)create it
if isempty(d.InitialisationManager)
    [d.InitialisationManager, setupOK, msg] = init(feat.info);
else
    setupOK = 1;
end

if ~setupOK
    d.InitialisationManager = [];
    CGBH.setViewData(d);
    i_error(['Cannot initialize this feature. ' msg]);
    return
end

d = pMessage(d, 'Creating the initialization option tree ...');
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(CGBH.Figure,'watch');
[d.InitialisationManager,OK] = gui_setup(d.InitialisationManager,'figure',{'expanded',1,'title', 'Feature Initialization Options'});
PR.stackRemovePointer(CGBH.Figure, ptrID);
d = pMessage(d, '');

if ~OK
    d.InitialisationManager = [];
    CGBH.setViewData(d);
else
    drawnow('expose');
    CGBH.setViewData(d); 
    try
        [feat.info, cost, runOK, msg] = run(d.InitialisationManager, feat.info, []);
        if ~runOK
            i_error(msg);
        else
            d = pMessage(d, sprintf('Initialized feature %s', feat.getname ) );
            CGBH.setViewData(d);
        end
        
        % Update icons on tree and the view
        CGBH.doDrawTree([], 'update');
        CGBH.ViewNode;
    catch
        i_error(['Unknown error occurred during feature initialization. ' lasterr]);
    end
    PR.stackClearAndReset(CGBH.Figure);
end


%---------------------------------------------------------------------------------------
function i_Fill(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
d = CGBH.getViewData;
cnode = CGBH.currentnode;
feat = cnode.getdata;

% if the fill manager is empty, then (re)create it
if isempty(d.FillManager)
    [d.FillManager, setupOK, msg] = fill(feat.info);
else
    setupOK = 1;
end

if ~setupOK
    d.FillManager = [];
    CGBH.setViewData(d);
    i_error(['Cannot fill this feature. ' msg]);
    return
end

d = pMessage(d, 'Creating the fill option tree ...');
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(CGBH.Figure,'watch');
[d.FillManager,OK] = gui_setup(d.FillManager,'figure',{'expanded',1,'title', 'Feature Filling Options'});
PR.stackRemovePointer(CGBH.Figure, ptrID);
d = pMessage(d, '');

if ~OK
    d.FillManager = [];
    CGBH.setViewData(d);
else
    drawnow('expose');
    CGBH.setViewData(d); 
    try
        [feat.info, cost, runOK, msg] = run(d.FillManager, feat.info, []);
        if ~runOK
            i_error(msg);
        else
            d = pMessage(d, sprintf('Filled feature %s', feat.getname ) );
            CGBH.setViewData(d);
        end
        
        % Update icons on tree and the view
        CGBH.doDrawTree([], 'update');
        CGBH.ViewNode;
    catch
        i_error(['Unknown error occurred during feature filling. ' lasterr]);
    end
    PR.stackClearAndReset(CGBH.Figure);
end



%---------------------------------------------------------------------------------------
function i_Optimise(obj,nul)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
d=CGBH.getViewData;
cnode = CGBH.currentnode;
feat = cnode.getdata;

% if the opt manager is empty, then (re)create it
if isempty(d.OptimisationManager)
    [d.OptimisationManager, setupOK, msg] = opt(feat.info);
else
    setupOK = 1;
end

if ~setupOK
    d.OptimisationManager = [];
    CGBH.setViewData(d);
    i_error(['Cannot optimize this feature. ' msg]);
    return
end

d = pMessage(d, 'Creating the optimization option tree ...');
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(CGBH.Figure,'watch');
[d.OptimisationManager,OK] = gui_setup(d.OptimisationManager,'figure',{'expanded',1,'title', 'Feature Optimization Options'});
PR.stackRemovePointer(CGBH.Figure, ptrID);
d = pMessage(d, '');

if ~OK
    d.OptimisationManager = [];
    CGBH.setViewData(d);
else
    drawnow('expose');
    CGBH.setViewData(d); 
    try
        [feat.info, cost, runOK, msg] = run(d.OptimisationManager, feat.info, []);
        if ~runOK
            i_error(msg);
        else
            d = pMessage(d, sprintf('Optimized feature %s', feat.getname ) );
            CGBH.setViewData(d);
        end
        
        % Update icons on tree and the view
        CGBH.doDrawTree([], 'update');
        CGBH.ViewNode;
    catch
        i_error(['Unknown error occurred during feature optimization. ' lasterr]);
    end
    PR.stackClearAndReset(CGBH.Figure);
end


%---------------------------------------------------------------------------------------
function i_error(str)
%---------------------------------------------------------------------------------------
uiwait(errordlg(str,'CAGE Error','modal'));


%--------------------------------------------------------------------------
function i_SLClose(src, evt)
%--------------------------------------------------------------------------
% CloseFcn of the main simulink model when editing or importing strategies
CGBH = cgbrowser;
if( CGBH.GUIExists )
    d = CGBH.getViewData;
    n = CGBH.CurrentNode;
    % Set menu disabled
    set([d.Handles.LibMenu, d.Handles.ParseMenu],'enable','off');
else
    % for testing only - need a feature node to pass to pToggleLibs
    n = cgfeaturenode;
end

% toggle the libraries closed
pToggleLibs(0, n);
