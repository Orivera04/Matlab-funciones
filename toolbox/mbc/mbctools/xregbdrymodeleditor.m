function varargout = xregbdrymodeleditor( varargin )
%XREGBDRYMODELEDITOR
%
%   FIGH = XREGBDRYMODELEDITOR(ROOT) 
%   XREGBDRYMODELEDITOR(SRC,EVT...) for activeX callbacks
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.23.8.5 $    $Date: 2004/04/04 03:32:48 $ 

error(nargchk(1,1,nargin, 'struct'));

if isa( varargin{1}, 'xregbdrynode' ),
    varargout{1} = i_creategui( varargin{:} );
elseif isequal( varargin{1}, 'EditSlice' ),
    i_editslice;
else
    error('mbc:xregbdrymodeleditor:InvalidArgument', 'Input must be the root xregbdrynode');
end

return

%---------------------------------|--------------------------------------------|
% Creation routines
function o_________CREATE_FUNCTIONS   
%---------------------------------|--------------------------------------------|
function figh = i_creategui( root )

% check for existing gui-- what should we do if there is one?
figh=i_lookforhandle;
if ~isempty(figh)
   figh=handle(figh);
   % delete the window and start again
   delete(figh);
end

ud.Figure=xregfigure( ...
    'position', [520  690  831  420], ...
    'tag', i_hash_fig_tag, ...
    'visible', 'off',...
    'renderer', 'zbuffer',...
    'name', 'Boundary Constraint Editor',...
    'keypressfcn', 'figure( gcbf )',...
    'pointer', 'watch',...
    'closerequestfcn', @i_close );
ud.Figure.MinimumSize = [777  402];
xregpersistfigpos( ud.Figure );
xregmoveonscreen( ud.Figure );

% Store root node of boundary modeling tree
ud.root = address( root );

% Create pointers 
ud.sbar= xregGui.RunTimePointer;
ud.sbar.LinkToObject(ud.Figure);
ud.view= xregGui.RunTimePointer;
ud.view.LinkToObject(ud.Figure);
ud.menus= xregGui.RunTimePointer;
ud.menus.LinkToObject(ud.Figure);

% Create status bar
i_createstatusbar(ud);

% Create menus and toolbar
i_createmenus(ud);

% Create View area
i_createview(ud);

% bind together GUI elements
figh=ud.Figure;

lyt=xreggridbaglayout(figh,...
   'dimension',[3 1],...
   'rowsizes',[31 -1 19],...
   'gapy',2,...
   'elements',{ud.menus.info.Toolbar.Layout, ud.view.info.layout, ud.sbar.info.panel});

figh.LayoutManager = lyt;
set( lyt, 'visible', 'on' , 'packstatus', 'on');

% set all the values, etc, for the given model
i_setinitial( ud );

% make GUI visible
set(figh,'visible','on','userdata',ud,'pointer','arrow');

return

%---------------------------------|--------------------------------------------|
function i_createstatusbar(allud)
figh=allud.Figure;
p=allud.sbar;
thisud.Figure = figh;
thisud.panel = xregGui.statusbar('parent',figh);
thisud.panel.addMessage('Ready');
thisud.pointer=xregGui.PointerRepository;
p.info=thisud;
return

%---------------------------------|--------------------------------------------|
function i_createmenus(allud)
figh = allud.Figure;
p = allud.menus;

%%pm    = allud.model;
psbar = allud.sbar;
pview = allud.view;

% Top level menus
menuFile  = uimenu('parent',figh,'label','&File','callback','figure(gcbf)');
menuEdit = uimenu('parent',figh,'label','&Edit','callback','figure(gcbf)');
menuView  = uimenu('parent',figh,'label','&View', 'callback','figure(gcbf)');

% Add tools menu if required
ext = xregtools.extensions;
BdryTools = ext.BoundaryEditorTools;
mbccreateaddonmenus(BdryTools, figh);

% Add window menu
xregwinlist(double(figh));

% Add help menu
mv_helpmenu(figh, {'&Boundary Editor Help', 'xreg_bdrymodeleditor'} );   

% File Menu items
ud.File.New = uimenu('parent',menuFile,...
    'label','&New Boundary Constraint',...
    'enable','on',...
    'callback',{@i_newmodel,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off', ...
    'accelerator', 'N');
ud.File.Settings = uimenu('parent',menuFile,...
    'label','&Fit Boundary Constraint...',...
    'enable','on',...
    'callback',{@i_settings,allud.root,allud.sbar,allud.view,allud.menus},...
    'separator','on',...
    'interruptible','off');
ud.File.Close = uimenu('parent',menuFile,...
    'label','&Close',...
    'separator','on',...
    'accelerator','w',...
    'callback','close(gcbf)',...
    'interruptible','off');

% Edit Menu items
ud.Edit.Copy = uimenu('parent',menuEdit,... 
    'label','D&uplicate',... 
    'enable','on',... 
    'callback',{@i_copymodel,allud.root,allud.sbar,allud.view,allud.menus},... 
    'interruptible','off'); 
ud.Edit.Delete = uimenu('parent',menuEdit,...
    'label','&Delete',...
    'enable','on',...
    'callback',{@i_deletemodel,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');

ud.Edit.SetBest = uimenu('parent',menuEdit,...
    'label','Assign &Best',...
    'enable','on',...
    'separator','on',...
    'callback',{@i_setbestmodel,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');
ud.Edit.AddBest = uimenu('parent',menuEdit,...
    'label','&Add to Best',...
    'enable','on',...
    'callback',{@i_addbestmodel,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');
ud.Edit.RemoveBest = uimenu('parent',menuEdit,...
    'label','&Remove from Best',...
    'enable','on',...
    'callback',{@i_removebestmodel,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');

% View Menu items
ud.View.View1d = uimenu('parent',menuView,...
    'label','&1D Slice',...
    'enable','on',...
    'accelerator','1',...
    'callback',{@i_view1d,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');
ud.View.View2d = uimenu('parent',menuView,...
    'label','&2D Slice',...
    'enable','on',...
    'accelerator','2',...
    'callback',{@i_view2d,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');
ud.View.View3d = uimenu('parent',menuView,...
    'label','&3D Slice',...
    'enable','on',...
    'accelerator','3',...
    'callback',{@i_view3d,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');
ud.View.ViewPairwise = uimenu('parent',menuView,...
    'label','&Pairwise',...
    'enable','on',...
    'callback',{@i_viewpairwise,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');

ud.View.BoundaryPoints = uimenu('parent',menuView,...
    'label','&Highlight Boundary Points',...
    'separator','on',...
    'enable','off',...
    'callback',{@i_boundarypoints,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');
ud.View.ViewModel = uimenu('parent',menuView,...
    'label','&Constraint Description',...
    'enable','on',...
    'callback',{@i_viewmodel,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');
ud.View.CheckConstraints = uimenu('parent',menuView,...
    'label','Constraint &Information',...
    'enable','on',...
    'callback',{@i_checkconstraints,allud.root,allud.sbar,allud.view,allud.menus},...
    'interruptible','off');


%                                                                          %
% Toolbar                                                          Toolbar %
%                                                                          %
tb = xregGui.uitoolbar('parent', figh, ...
    'ResourceLocation',xregrespath);
tb.setRedraw(0);
ud.Toolbar.Layout = xregpanellayout(figh, 'packstatus', 'off', ...
    'innerborder', [0 0 0 0], ...
    'center', tb);

tcol=[0 255 0]; % transparent color

% New
ud.Toolbar.NewModel = xregGui.uipushtool(tb,...
   'clickedcallback',{@i_newmodel,allud.root,allud.sbar,allud.view,allud.menus},...
   'tooltip','New Boundary Constraint',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'imagefile','bdryNew.bmp');

% Delete
ud.Toolbar.DeleteModel = xregGui.uipushtool(tb,...
   'clickedcallback',{@i_deletemodel,allud.root,allud.sbar,allud.view,allud.menus},...
   'tooltip','Delete Boundary Constraint',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'imagefile','delete.bmp');

% Fit Boundary Constraint
ud.Toolbar.ModelSettings = xregGui.uipushtool(tb,...
   'clickedcallback',{@i_settings,allud.root,allud.sbar,allud.view,allud.menus},...
   'tooltip','Fit Boundary Constraint',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'imagefile','fitOptions.bmp');

% View 1D

ud.Toolbar.View3d = [];
ud.Toolbar.View1d = xregGui.uitoggletool(tb,...
   'clickedcallback',{@i_view1d,allud.root,allud.sbar,allud.view,allud.menus},...
   'tooltip','1D Slice',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'imagefile','bdry1Dgraph.bmp',...
   'Separator','on');

% View 2D
ud.Toolbar.View2d = xregGui.uitoggletool(tb,...
   'clickedcallback',{@i_view2d,allud.root,allud.sbar,allud.view,allud.menus},...
   'tooltip','2D Slice',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'imagefile','bdry2Dgraph.bmp');

% View 3D
ud.Toolbar.View3d = xregGui.uitoggletool(tb,...
   'clickedcallback',{@i_view3d,allud.root,allud.sbar,allud.view,allud.menus},...
   'tooltip','3D Slice',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'imagefile','bdry3Dgraph.bmp');

% View Pairwise
ud.Toolbar.ViewPairwise = xregGui.uitoggletool(tb,...
   'clickedcallback',{@i_viewpairwise,allud.root,allud.sbar,allud.view,allud.menus},...
   'tooltip','Pairwise View',...
   'interruptible','off',...
   'transparentcolor',tcol,...
   'imagefile','bdryPairwise.bmp');

% Toggle Boundary Points
ud.Toolbar.BoundaryPoints = xregGui.uitoggletool(tb,...
   'clickedcallback', {@i_boundarypoints,allud.root,allud.sbar,allud.view,allud.menus},...
   'tooltip', 'Highlight Boundary Points',...
   'interruptible', 'off',...
   'transparentcolor', tcol,...
   'imagefile', 'bdryPoints.bmp', ...
   'separator', 'on');

% Help
mv_helptoolbutton( tb, 'xreg_bdrymodeleditor' );

tb.setRedraw(1);
tb.drawToolBar;

p.info=ud;
return

%---------------------------------|--------------------------------------------|
function i_createview(allud)
figh=allud.Figure;
p=allud.view;

% get symbol list, nfactors
broot = allud.root.info;
model = getfriend( broot );
symbols  = get( model, 'Symbol' );
nfactors = get( model, 'NFactors' );

% tree view
thisud.currentnode = xregpointer;
thisud.treeview = treeview( broot, 'create', [1 1 10 10], double( figh ), ...
    i_TreeviewCallbacks );
thisud.treeview.border = 0;
thisud.treeview.appearance = 0;
lytTree = xregpaneltitlelayout( figh,...
    'center', actxcontainer( thisud.treeview ),...
    'title','Boundary Tree');

% property pane for model description
thisud.description = xregGui.infoPane('parent', figh, 'SplitPosition', .6);
thisud.properties = xregpaneltitlelayout( figh,...
    'center', thisud.description,...
    'title','Properties');

% get the test selection controls
[lytTestSelect, udTestSelect] = i_createtestselector( allud );
thisud.testselect = udTestSelect;
lytTestSelect = xregframetitlelayout( figh,...
    'innerborder', [0 0 0 0], ...
    'center', lytTestSelect );

% get the interval selection controls
lytInterval = i_createslicecontrols( allud );
thisud.intervals = lytInterval;

% get the factor selection controls
thisud.factors = i_createfactorcontrols( allud );
lytFactor = xreggridbaglayout( figh,...
    'Dimension', [4, 1], ...
    'RowSizes', [21, 21, 21, 20], ...
    'GapY', 5, ...
    'border',[7 7 7 7],...
    'elements',{...
        thisud.factors.lctrlXFactor, ...
        thisud.factors.lctrlYFactor, ...
        thisud.factors.lctrlZFactor, ...
        thisud.factors.lctrlResolution} );
lytFactor = xregframetitlelayout( figh,...
    'innerborder', [0 0 0 0], ...
    'center', lytFactor );

% set up view for only one variable
[lyt1d, ud] = i_createlyt1dview( figh, allud );
thisud.view1d = ud;

% set up axes for 2d plot
[lyt2d, ud] = i_createlyt2dslice( figh, allud );
thisud.view2d = ud;

% set up axes for 3d plot
[lyt3d, ud] = i_createlyt3dslice( figh, allud );
thisud.view3d = ud;

% set up pairwise projections
[lytpw, ud] = i_createlytpairwise( figh, allud );
thisud.viewpw = ud;

% setup cards to handle the axes
thisud.cards = xregcardlayout( figh,...
	'Visible','on',...
	'NumCards', 4,...
	'CurrentCard', 2 );
attach( thisud.cards, lyt1d, 1 );
attach( thisud.cards, lyt2d, 2 );
attach( thisud.cards, lyt3d, 3 );
attach( thisud.cards, lytpw, 4 );

% set up the treeview/ properties layout
lytLeft = xregsplitlayout( figh,...
    'Split', [0.75, 0.25], ...
    'ORIENTATION', 'ud', ...
    'Top', lytTree, ...
    'Bottom', thisud.properties, ...
    'DividerWidth', 4, ...
    'DividerStyle', 'Flat' );

% set up the model view area
lytRight = xreggridbaglayout( figh,...
    'Dimension', [3, 2], ...
    'RowSizes', [85, -1, 112], ...
    'ColSizes', [210, -1], ...
    'GapX', 2, 'GapY', 2, ...
    'MergeBlock', {[1,3], [2,2]}, ...
    'Elements', { ...
        lytTestSelect, thisud.cards; ... 
        lytInterval,   []; ... 
        lytFactor,     [] } );

% setup the overall layout
lyt = xregsplitlayout( figh, ...
    'Split', [0.25, 0.75], ...
    'ORIENTATION', 'lr', ...
    'Left', lytLeft, ...
    'Right', lytRight, ...
    'dividerwidth', 4, ...
    'DividerStyle', 'Flat' );

thisud.layout = lyt;
p.info=thisud;

return
%---------------------------------|--------------------------------------------|
function [lyt, ud] = i_createlyt1dview( figh, allud )

broot = allud.root;
model = broot.getfriend;
symbols = get( model, 'Symbol' );

switch broot.getnumstages,
    case 1, % One-stage boundary modeling
        ud.cards = xregcardlayout( figh,...
            'Visible', 'On',...
            'NumCards', 1,...
            'CurrentCard', 1 );
        
        [lyt, ud.ud(1)] = i_createlyt1dviewsingle( figh, allud, symbols );
        attach( ud.cards, lyt, 1 );
        
    case 2, % Two-stage boundary modeling
        R = broot.getdata( 'Response' );
        L = broot.getdata( 'Local' );
        G = broot.getdata( 'Global' );
        
        nf  = size( R, 2 );
        nlf = size( L, 2 );
        ngf = size( G, 2 );
        
        ud.cards = xregcardlayout( figh,...
            'Visible', 'On',...
            'NumCards', 3,...
            'CurrentCard', 1 );
        
        [lyt, ud.ud(1)] = i_createlyt1dviewsingle( figh, allud, symbols );
        attach( ud.cards, lyt, 1 );
        [lyt, ud.ud(2)] = i_createlyt1dviewsingle( figh, allud, symbols(1:nlf) );
        attach( ud.cards, lyt, 2 );
        [lyt, ud.ud(3)] = i_createlyt1dviewsingle( figh, allud, symbols((nlf+1):nf) );
        attach( ud.cards, lyt, 3 );

otherwise, % Only one- and two-stage boundary modeling are supported.
    error( 'Invalid number of stages for bounary modeling' );
end
lyt = ud.cards;

return

%---------------------------------|--------------------------------------------|
function [lyt, thisud] = i_createlyt1dviewsingle( figh, allud, symbols )

nf = numel( symbols );
el = cell( 1, nf ); % elements of layout
thisud.axes    = cell( 1, nf );
thisud.dots    = cell( 1, nf );
thisud.rings   = cell( 1, nf );
thisud.regions = cell( 1, nf );
for i = 1:nf,
    thisud.axes{i} = xregaxes( double( figh ), ...
        'Box', 'on', ...
        'YGrid', 'off', ...
        'YLimMode', 'Manual', ...
        'YLim', [0, 1], ...
        'YTick', [] );
    set( get( thisud.axes{i}, 'YLabel' ), ...
        'String', symbols{i}, ...
        'Rotation', 0, ...
        'HorizontalAlignment', 'Right' );

    thisud.dots{i} = i_bigblackdots( thisud.axes{i} );
    set( thisud.dots{i}, ...
        'ButtonDownFcn', {@i_viewdot,allud.root,allud.sbar,allud.view,allud.menus} );

    thisud.rings{i} = i_bigredrings( thisud.axes{i} );

    el{i} = xregaxesinput( figh, thisud.axes{i} );
end
if nf >= 1,
    lyt = xreglistctrl( figh, ...
        'Visible', 'off', ...
        'Controls', el, ...
        'InnerBorder', 10, ...
        'FixNumCells', min( 4, nf ) );
    %%  'CellHeight', 75 ); %% FIX ME! It is better to specify the cell height
    %%  rather than the number of fixed (viewed) cells
else,
    lyt = [];
end
return

%---------------------------------|--------------------------------------------|
function [lyt2d, thisud] = i_createlyt2dslice( figh, allud )
thisud.axes2d = xregaxes(...
    'parent',figh,...
    'units','pixels',...
    'Box', 'on',...
    'XLimMode','manual',...
    'YLimMode','manual',...
    'XGrid','on',...
    'YGrid','on' );
thisud.dots2d = i_bigblackdots( thisud.axes2d );
set( thisud.dots2d, 'ButtonDownFcn', {@i_viewdot,allud.root,allud.sbar,allud.view,allud.menus} );
thisud.rings2d = i_bigredrings( thisud.axes2d );
thisud.lines = {}; % this is where the 2d constraint boundary will go
axw = axiswrapper(thisud.axes2d);
set(axw, 'border', [50 40 20 20]);
lyt2d = xregpanellayout(figh,...
    'Center', axw, ...
    'InnerBorder', [0 0 0 0] );
return
%---------------------------------|--------------------------------------------|
function [lyt3d, thisud] = i_createlyt3dslice( figh, allud )
thisud.axes3d = xregaxes(...
    'parent',figh,...
    'units','pixels',...
    'view',[-37.5,30],...
    'Box', 'on',...
    'XLimMode','auto',...
    'YLimMode','auto',...
    'ZLimMode','auto',...
    'XGrid','on',...
    'YGrid','on',...
    'ZGrid','on',...
    'cameraposition',[1 -3 2] );
thisud.dots3d = i_bigblackdots( thisud.axes3d );
thisud.rings3d = i_bigredrings( thisud.axes3d );
thisud.surface = xregpatch(...
    'Parent',thisud.axes3d,...
    'Faces', [], ...
    'Vertices', [], ...
    'Visible','off',...
    'EdgeColor','none',...
    'FaceColor',[0 .4 1],...
    'FaceLighting','gouraud',...
    'BackFaceLighting','unlit',...
    'AmbientStrength',.3,...
    'DiffuseStrength',.6,...
    'SpecularStrength',.9,...
    'SpecularExponent',10,...
    'SpecularColorReflectance',.8,...
    'LineStyle','none');
thisud.caps = xregpatch(...
    'Parent',thisud.axes3d,...
    'Faces', [], ...
    'Vertices', [], ...
    'Visible','off',...
    'EdgeColor','none',...
    'FaceColor',[0 .4 1],... % ,[.8 .6 .8],...
    'FaceLighting','gouraud',...
    'BackFaceLighting','unlit',...
    'AmbientStrength',.3,...
    'DiffuseStrength',.6,...
    'SpecularStrength',.9,...
    'SpecularExponent',10,...
    'SpecularColorReflectance',.8,...
    'LineStyle','none');
light( 'Parent', thisud.axes3d, 'Position', [0,0,100]);
mv_rotate3d( thisud.axes3d, 'On' );
axw = axiswrapper(thisud.axes3d);
set(axw, 'border', [50 40 30 20]);
lyt3d = xregpanellayout(figh,...
    'Center', axw, ...
    'InnerBorder', [0 0 0 0] );
return
%---------------------------------|--------------------------------------------|
function [lyt, ud] = i_createlytpairwise( figh, allud )

broot = allud.root;
model = broot.getfriend;
symbols = get( model, 'Symbol' );

broot = allud.root;
model = broot.getfriend;
symbols = get( model, 'Symbol' );

switch broot.getnumstages,
    case 1, % One-stage boundary modeling
        ud.cards = xregcardlayout( figh,...
            'Visible', 'On',...
            'NumCards', 1,...
            'CurrentCard', 1 );
        
        [lytpw, ud.ud(1)] = i_createlytsinglepairwise( figh, allud, symbols );
        attach( ud.cards, lytpw, 1 );
        
    case 2, % Two-stage boundary modeling
        R = broot.getdata( 'Response' );
        L = broot.getdata( 'Local' );
        G = broot.getdata( 'Global' );
        
        nf  = size( R, 2 );
        nlf = size( L, 2 );
        ngf = size( G, 2 );
        
        ud.cards = xregcardlayout( figh,...
            'Visible', 'On',...
            'NumCards', 3,...
            'CurrentCard', 1 );
        
        [lytpw, ud.ud(1)] = i_createlytsinglepairwise( figh, allud, symbols );
        attach( ud.cards, lytpw, 1 );
        [lytpw, ud.ud(2)] = i_createlytsinglepairwise( figh, allud, symbols(1:nlf) );
        attach( ud.cards, lytpw, 2 );
        [lytpw, ud.ud(3)] = i_createlytsinglepairwise( figh, allud, symbols((nlf+1):nf) );
        attach( ud.cards, lytpw, 3 );
        
    otherwise, % Only one- and two-stage boundary modeling are supported.
        error( 'Invalid number of stages for bounary modeling' );
end
lyt = ud.cards;
return
%---------------------------------|--------------------------------------------|
function [lytpw, thisud] = i_createlytsinglepairwise( figh, allud, symbols )

proot  = allud.root;
psbar  = allud.sbar;
pview  = allud.view;
pmenus = allud.menus;

nf = size( symbols, 1 );

thisud.axes    = cell( nf-1, nf-1 );
thisud.dots    = cell( nf-1, nf-1 );
thisud.rings   = cell( nf-1, nf-1 );
thisud.regions = cell( nf-1, nf-1 ); % multiple patches for a single axes
thisud.hilight = cell( nf-1, nf-1 ); % must be stored in row vectors
for i = 2:nf,
    for j = 1:i-1,
        thisud.axes{i-1,j} = xregaxes(...
            'parent',figh,...
            'units','pixels',...
            'Box', 'on',...
            'XLimMode','manual',...
            'YLimMode','manual',...
            'XGrid','on',...
            'YGrid','on', ...
            'UserData', [j, i], ...
            'ButtonDownFcn', {@i_hilight,proot,psbar,pview,pmenus,i,j} );
        if i ~= nf,
            set( thisud.axes{i-1,j}, 'XTickLabel', [] );
        else
            set( get( thisud.axes{i-1,j}, 'XLabel' ), 'String', ...
                symbols{j} );
        end
        if j ~= 1,
            set( thisud.axes{i-1,j}, 'YTickLabel', [] );
        else
            set( get( thisud.axes{i-1,j}, 'YLabel' ), 'String', ...
                symbols{i} );
        end
        thisud.dots{i-1,j}  = i_bigblackdots( thisud.axes{i-1,j} );
        thisud.rings{i-1,j} = i_bigredrings(  thisud.axes{i-1,j} );
    end
end

thisud.hilightline = [];
thisud.hilightdata = struct( ...
    'Factors', [1, 2], ...
    'Min', [0.0, -1.0], ...
    'Max', [0.5, -0.5] );

lyt = xreggridbaglayout( figh,...
    'Dimension', [nf-1, nf-1], ...
    'ColSizes', repmat( -1, nf-1, 1 ), ...
    'RowSizes', repmat( -1, nf-1, 1 ), ...
    'GapY', 1, ...
    'GapX', 1, ...
    'border',[2 2 2 2],...
    'elements', { thisud.axes{:} });
lytpw = xregpanellayout(figh,...
    'Center', lyt, ...
    'InnerBorder', [20 20 40 50] );
return

%------------------------------------------------------------------------------|
function [lyt, ud] = i_createtestselector( allud )
figh = allud.Figure;

ud.radiogroup = xregGui.rbgroup( ...
    'parent', figh,...
    'visible', 'off',...
    'nx', 1,...
    'ny', 2,...
    'string', {'Response'; 'Local'},...  % What is good here?
    'value', [0; 1], ...
    'callback', {@i_viewgloballocal,allud.root,allud.sbar,allud.view,allud.menus} );

edtctrl = xregGui.clickedit('parent', figh, ...
    'visible', 'off', ...
    'Rule', 'List', ...
    'Style', 'leftright', ...
    'callback', {@i_viewtest,allud.root,allud.sbar,allud.view,allud.menus});
ud.clickedit = xregGui.labelcontrol('parent',  figh, ...
    'Visible', 'off', ...
    'String', 'Test:', ...
    'Control', edtctrl, ...
    'controlsize', 60);
ud.button = xreguicontrol(...
    'parent',figh,...
    'style','pushbutton',...
    'string','Select Test...',...
    'interruptible','off',...
    'callback', {@i_selecttest,allud.root,allud.sbar,allud.view,allud.menus} );

lyt = xreggridbaglayout( figh,...
    'Dimension', [5, 2], ...
    'RowSizes', [-1, 5, 2, 20, 3], ...
    'ColSizes', [-1, 85], ...
    'GapX', 5, ...
    'border',[7 7 7 7],...
    'MergeBlock', {[1, 1], [1, 2]}, ...
    'MergeBlock', {[3, 5], [2, 2]}, ...
    'elements', { ...
        ud.radiogroup, []; ...
        [],            []; ...
        [],            ud.button; ...
        ud.clickedit, []; ...
        [],           [] } );
return

%------------------------------------------------------------------------------|
function lyt = i_createslicecontrols( allud )

figh   = allud.Figure;
proot = allud.root;
psbar  = allud.sbar;
pview  = allud.view;
pmenus = allud.menus;

% get symbol list, nfactors
model = proot.getfriend;
symbols  = get( model, 'Symbol' );
nf = get( model, 'NFactors' );

for i = 1:nf, 
    c{i} = xregclicktolinput( double( figh ), ...
        'Visible', 'off', ...
        'Name', sprintf('%s:', symbols{i}), ...
        'Value', 0, ...
        'Tolerance', 0.2, ...
        'Min', -1, ...
        'Max', 1, ...
        'ClickIncrement', 0.1 ); 
end
lyt = xreglistctrl( figh, ...
    'Visible', 'off', ...
    'Controls', c, ...
    'CellHeight', 20, ...
    'Callback', [ mfilename, '( ''EditSlice'' )';]  );
return

%------------------------------------------------------------------------------|
function ud = i_createfactorcontrols( allud, symbols )
figh=allud.Figure;
symbols = get( allud.root.getfriend, 'Symbols' );

ud.popXFactor = xreguicontrol( ...
    'parent', figh,...
    'style', 'popup',...
    'string',symbols,...
    'interruptible', 'off',...
    'BackgroundColor', 'w',...
    'callback',{@i_factorx,allud.root,allud.sbar,allud.view,allud.menus});
ud.lctrlXFactor = xregGui.labelcontrol(...
    'parent', figh,...
    'Control', ud.popXFactor,...
    'string', 'X-axis factor:',...
    'enable', 'on',...
    'ControlSize', 1, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 1, ...
    'LabelSizeMode', 'relative');

ud.popYFactor = xreguicontrol( ...
    'parent', figh,...
    'style', 'popup',...
    'string',symbols,...
    'interruptible', 'off',...
    'BackgroundColor', 'w',...
    'callback',{@i_factory,allud.root,allud.sbar,allud.view,allud.menus} );
ud.lctrlYFactor = xregGui.labelcontrol(...
    'parent', figh,...
    'Control', ud.popYFactor,...
    'string', 'Y-axis factor:',...
    'enable', 'on',...
    'ControlSize', 1, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 1, ...
    'LabelSizeMode', 'relative');

ud.popZFactor = xreguicontrol( ...
    'parent', figh,...
    'style', 'popup',...
    'string',symbols,...
    'interruptible', 'off',...
    'BackgroundColor', 'w',...
    'callback',{@i_factorz,allud.root,allud.sbar,allud.view,allud.menus} );
ud.lctrlZFactor = xregGui.labelcontrol(...
    'parent', figh,...
    'Control', ud.popZFactor,...
    'string', 'Z-axis factor:',...
    'enable', 'on',...
    'ControlSize', 1, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 1, ...
    'LabelSizeMode', 'relative');

ud.editResolution = xregGui.clickedit( ...
    'parent', figh,...
    'dragging', 'off', ...
    'rule', 'int', ...
    'min', 2, ...
    'max', 100, ...
    'callback',{@i_resolution,allud.root,allud.sbar,allud.view,allud.menus} );
ud.lctrlResolution = xregGui.labelcontrol(...
    'parent', figh,...
    'Control', ud.editResolution,...
    'string', 'Resolution',...
    'enable', 'on',...
    'ControlSize', 1, ...
    'ControlSizeMode', 'relative',...
    'LabelSize', 1, ...
    'LabelSizeMode', 'relative');

return

%---------------------------------|--------------------------------------------|
% Model properties display update
function o_________________INFO_API
%---------------------------------|--------------------------------------------|
function i_infoupdate( proot, psbar, pview, pmenus )
ud = pview.info;
p = i_currentnode( pview );

ud.description.ListText = p.properties;
set( ud.properties, 'title', ['Properties - ' p.name] );

%---------------------------------|--------------------------------------------|
% callbacks
function o________________CALLBACKS
%---------------------------------|--------------------------------------------|
function  i_close(figh,evt)
delete( figh )
return

%---------------------------------|--------------------------------------------|
function i_updatetext( proot, psbar, pview, pmenus )
ud = pview.info;

% title on the model properties box
p = i_currentnode( pview );
set( ud.properties, 'title', ['Properties - ', p.name] );

return

%---------------------------------|--------------------------------------------|
function  i_hilight(src,evt,proot,psbar,pview,pmenus,i,j)
WindowButtonUpFcn = get( gcbf, 'WindowButtonUpFcn' );
point1 = get(src,'CurrentPoint');    % button down detected
set( gcbf, 'WindowButtonUpFcn', {@i_hilight2, proot,psbar,pview,pmenus, point1(1,1), point1(1,2)} )
finalRect = rbbox;                   % return figure units
set( gcbf, 'WindowButtonUpFcn', WindowButtonUpFcn )
return
%---------------------------------|--------------------------------------------|
function  i_hilight2(figh,evt, proot,psbar,pview,pmenus, x1, x2 )

stages = i_currentstagescard( proot, pview );
viewpw = pview.info.viewpw.ud(stages);

point2 = get(gca,'CurrentPoint');    % button up detected
point2 = point2(1,1:2);

point1 = [x1, x2];
p1 = min(point1,point2);             % calculate locations
offset = abs(point1-point2);         % and dimensions
x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];

if ~isempty( viewpw.hilightline ),
    delete( viewpw.hilightline );
end

viewpw.hilightline = line( 'Parent', gca, ...
    'XData', x, ...
    'YData', y, ...
    'LineStyle', '-', ...
    'Color', 'r', ...
    'LineWidth', 1 );          % draw box around selected region
viewpw.hilightdata = struct( ...
    'Factors', get( gca, 'UserData' ), ...
    'Min', [p1(1), p1(2)], ...
    'Max', [p1(1)+offset(1), p1(2)+offset(2)], ...
    'HitTest', 'off' );

pview.info.viewpw.ud(stages) = viewpw;
i_draw( proot, psbar, pview, pmenus );

return

%---------------------------------|--------------------------------------------|
function  i_export(src,evt,proot,psbar,pview,pmenus)
pbdev = i_currentnode( pview );
pbdev.gui_export;
return

%---------------------------------|--------------------------------------------|
function  i_settings(src,evt,proot,psbar,pview,pmenus)

bdev = i_currentnode( pview );
if ~bdev.isa( 'xregbdrydev' ),
    xregerror( 'Constraint Settings', 'Cannot edit settings at root node' );
    return
end

msgID = i_addmessage( psbar, 'Editing model...' );
if bdev.istwostage,
    con = bdev.getconstraint;
    if isempty( con ),
        con = bdev.newconstraint;
    end
    [con, ok] = gui_setup( con );
    if ok,
        bdev.setmodel( con );
    end
else
    symbols = i_currentsymbols( proot, pview );
    [bdev.info, ok] = gui_setup( bdev.info, 'Create', symbols );
end
i_deletemessage( psbar, msgID);

if ok,
    msgID = i_addmessage( psbar, 'Fitting model...' );
    ptrID = i_setpointer( psbar, 'watch');
    
    [new, ok] = fitmodel( bdev.info, 'All' );
    
    i_deletemessage( psbar, msgID);
    i_deletepointer( psbar, ptrID );
    if ok>0
        bdev.info = new;
        i_enableboundarypoints(proot,psbar,pview,pmenus);
        i_draw(proot,psbar,pview,pmenus);
    end
end

i_infoupdate( proot, psbar, pview, pmenus );

return

%---------------------------------|--------------------------------------------|
function  i_checkconstraints(src,evt,proot,psbar,pview,pmenus)
msgID = i_addmessage( psbar, 'Checking constraints...' );
bdev = i_currentnode( pview );
data = i_currentdata( proot, pview, 1 );

if ~bdev.isa( 'xregbdrydev' ),
    xregerror( 'Constraint Modeling', 'Can''t check constraints at root node' );
else,
    bdev.check( data );
end
i_deletemessage( psbar, msgID);
return

%---------------------------------|--------------------------------------------|
function  i_newmodel(src,evt,proot,psbar,pview,pmenus)
cn = i_currentnode( pview );
bd = cn.makechildren;
if ~isempty( bd ),
    pdb = address( bd );
    broot = cn.AddChild( bd );
    proot.treeview( 'Refresh', pview.info.treeview );
    pdb.treeview( 'Select', pview.info.treeview );
    i_changecurrentnode( proot, psbar, pview, pmenus );
    i_infoupdate( proot, psbar, pview, pmenus );
else
    xregerror( 'New Model', 'No more children allowed for this node' );
end

return

%---------------------------------|--------------------------------------------|
function  i_copymodel(src,evt,proot,psbar,pview,pmenus)
cn = i_currentnode( pview );
if cn.isa( 'xregbdryroot' ),
    xregerror( 'Copy Boundary Model', 'Cannont copy root node' );
    return
end
new = cn.duplicate;
newname = proot.uniquename( name( new ) );
new = name( new, newname );

proot.treeview( 'Refresh', pview.info.treeview );
cn.treeview( 'Select', pview.info.treeview );
return

%---------------------------------|--------------------------------------------|
function  i_deletemodel(src,evt,proot,psbar,pview,pmenus)
cn = i_currentnode( pview );
if isequal( cn, proot ),
    xregerror( 'Delete Boundary Model', 'Cannont delete root node' );
    return
end
p = cn.Parent;
p.removebest( cn );
p = cn.delete;
proot.treeview( 'Refresh', pview.info.treeview );
p.treeview( 'Select', pview.info.treeview );

i_changecurrentnode(proot,psbar,pview,pmenus);
return

%---------------------------------|--------------------------------------------|
function i_setbestmodel( src, evt, proot, psbar, pview, pmenus );
cn = i_currentnode( pview );
pn = cn.Parent;
if isequal( cn, proot ),
    xregerror( 'Set Best Boundary Model', 'Can not set root as best boundary model.' );
    return
end
pn.setbest( cn );
proot.treeview( 'Refresh', pview.info.treeview );
cn.treeview( 'Select', pview.info.treeview );
return

%---------------------------------|--------------------------------------------|
function i_addbestmodel( src, evt, proot, psbar, pview, pmenus );
cn = i_currentnode( pview );
pn = cn.Parent;

if isequal( cn, proot ),
    xregerror( 'Add Best Boundary Model', 'Cannot add root to list of best boundary models.' );
    return
end
pn.addbest( cn );
proot.treeview( 'Refresh', pview.info.treeview );
cn.treeview( 'Select', pview.info.treeview );
return

%---------------------------------|--------------------------------------------|
function i_removebestmodel( src, evt, proot, psbar, pview, pmenus );
cn = i_currentnode( pview );
pn = cn.Parent;

if isequal( cn, proot ),
    xregerror( 'Remove Best Boundary Model', 'Cannont remove root from list of best boundary models.' );
    return
end
pn.removebest( cn );
proot.treeview( 'Refresh', pview.info.treeview );
cn.treeview( 'Select', pview.info.treeview );
return

%---------------------------------|--------------------------------------------|
function  i_renamenode( src, evt, proot, psbar, pview, pmenus, cancel, newstring );
treeview = pview.info.treeview;

if ~cancel,
    if ~isempty( deblank( newstring ) ),
        % find current pointer
        p = i_currentnode( pview );
        % update mtree name
        p.name( newstring );
        % set label string
        treeview.SelectedItem.Text = newstring;
        % update view title string
        i_updatetext( proot, psbar, pview, pmenus );
    else
        src.CancelNextLabelEdit = 1;
    end
end

return

%---------------------------------|--------------------------------------------|
function  i_viewmodel(src,evt,proot,psbar,pview,pmenus)

con     = i_currentconstraint( pview );
symbols = i_currentsymbols( proot, pview );

if isempty( con ),
    xregerror( 'Constraint Modeling', 'No constraint model defined' );
else
    h = view( con, 'Figure', symbols );
    set(h, 'windowstyle', 'modal');
    waitfor(h);
end
return

%---------------------------------|--------------------------------------------|
function  i_viewdot(dots,evt,proot,psbar,pview,pmenus)
cp = get(gca,'currentpoint');

axh = get( dots, 'Parent' );
ud  = get( dots, 'UserData' );
symbols = strvcat( ud{1} );
data = ud{2};

xdata = get( dots, 'XData' )';
ydata = get( dots, 'YData' )';
zdata = get( dots, 'ZData' )';
friend = proot.getfriend;

[bnds, g, tgt] = getcode( friend );
tgt(:,1) = -1; 
tgt(:,2) =  1; 
friend = setcode( friend, bnds, g, tgt );

factnum = i_currentfactors( proot, pview );

star = i_currentconstraint( pview );

if isempty( zdata ), 
    % 2d axis is showing
    % find data point closest to cp(1,[1,2])
    cp = cp(1,1:2);
    
    rsq = sum( ([xdata,ydata] - repmat( cp, size(xdata,1), 1 )).^2, 2 );
    [null,ind] = min( rsq );
    data = data(ind,:);
    codeddata = code( friend, data, factnum );
    
    space = repmat( blanks(1), size(data,2), 1 );
    txt = [space, symbols, space, space, num2str( data' ), space ];
    
    if ~isempty( star ),
        dist = constraindist( star, codeddata ); 
        txt = strvcat( txt, ['Distance: ' num2str( dist )] );
    end
    
    i_textpatch( axh, txt, cp );
else, 
    % 3d axis is showing
    % find data point cloest to the line defined by cp
    % currently disabled because it seems to give the rotate3d some problems
end

return

%---------------------------------|--------------------------------------------|
function  i_viewgloballocal( src, evt, proot, psbar, pview, pmenus )

mode = find( get( pview.info.testselect.radiogroup, 'Value' ) );
switch mode,
    case 1,
        set( pview.info.testselect.clickedit, 'enable', 'off' );
        set( pview.info.testselect.button,    'enable', 'off' );
    case 2,
        set( pview.info.testselect.clickedit, 'enable', 'on' );
        set( pview.info.testselect.button,    'enable', 'on' );
end
i_setfactors( proot, pview );
i_enableintervals( proot, pview );
i_enablemenus( proot, psbar, pview, pmenus );

if mode == 1, % global
    i_draw( proot, psbar, pview, pmenus );
else % if mode == 2, % local
    i_viewtest( src, evt, proot, psbar, pview, pmenus );
end

return

%---------------------------------|--------------------------------------------|
function  i_viewtest( src, evt, proot, psbar, pview, pmenus )

friend = proot.getfriend;
% Set the global factors in the interval select pane
intervals = get( pview.info.intervals, 'elements' );
nf   = nfactors( friend );
test = get( pview.info.testselect.clickedit.control, 'Value' );
data = double( proot.getdata( 'Global' , false) );
ngf  = size( data, 2 );
nlf  = nf - ngf;
%data = invcode( friend, data(test,:), (nlf+1):nf );
data = data(test,:);
for i = 1:ngf,
    set( intervals{i+nlf}, 'value', data(i) ); 
end
% Draw the new picture
i_draw( proot, psbar, pview, pmenus )
return

%---------------------------------|--------------------------------------------|
function  i_selecttest(src,evt,proot,psbar,pview,pmenus)
% Popup a dialog for the user to select a test from a list of possible
% tests.
% Put the chosen test number into test click edit widget and call
% i_viewtest to display the new test

clickedit = pview.info.testselect.clickedit.control;
value = get( clickedit, 'Value' );

if strcmpi( get( clickedit, 'Rule' ), 'List' ),
    list = get( clickedit, 'List' );
    value = find( list == value );
else
    min = get( clickedit, 'Min' );
    max = get( clickedit, 'Max' );
    inc = get( clickedit, 'ClickIncrement' );
    list = min:inc:max;
end

[value, ok] = mv_listdlg( 'ListString', num2str( list(:) ), ...
    'SelectionMode', 'Single', ...
    'InitialValue', value, ...
    'Name', 'Test Selector', ...
    'OkString', 'OK', ...
    'uh', 25, ...
    'ffs', 3 );
    
if ok,
    set( clickedit, 'Value', value );
end

i_viewtest( src, evt, proot, psbar, pview, pmenus )
return

%---------------------------------|--------------------------------------------|
function  i_view1d( src, evt, proot, psbar, pview, pmenus )

set( pmenus.info.Toolbar.View1d, 'State', 'on' );
if ~strcmpi( get( pmenus.info.View.View1d, 'Checked' ), 'on' ),
    i_switch2d(       proot, psbar, pview, pmenus, 'off'  );
    i_switch3d(       proot, psbar, pview, pmenus, 'off' );
    i_switchpairwise( proot, psbar, pview, pmenus, 'off' );

    i_draw1d( proot, psbar, pview, pmenus );
    
    set( pview.info.cards, 'CurrentCard', 1 );
    stages = i_currentstagescard( proot, pview );
    set( pview.info.view1d.cards, 'CurrentCard', stages );
    
    i_switch1d(  proot, psbar, pview, pmenus, 'on'  );
end
i_enableintervals( proot, pview );
i_enableboundarypoints( proot, psbar, pview, pmenus );
return

%---------------------------------|--------------------------------------------|
function  i_view2d(src,evt,proot,psbar,pview,pmenus)

set( pmenus.info.Toolbar.View2d, 'State', 'on' );
if ~strcmpi( get( pmenus.info.View.View2d, 'Checked' ), 'on' ),
    i_switch1d(       proot, psbar, pview, pmenus, 'off'  );
    i_switch3d(       proot, psbar, pview, pmenus, 'off' );
    i_switchpairwise( proot, psbar, pview, pmenus, 'off' );

    set( pview.info.cards, 'CurrentCard', 2 );
    i_draw2d(proot,psbar,pview,pmenus);
    
    i_switch2d(  proot, psbar, pview, pmenus, 'on'  );
end
i_enableintervals( proot, pview );
i_enableboundarypoints( proot, psbar, pview, pmenus );
return

%---------------------------------|--------------------------------------------|
function  i_view3d(src,evt,proot,psbar,pview,pmenus)

set( pmenus.info.Toolbar.View3d, 'State', 'on' );
if ~strcmpi( get( pmenus.info.View.View3d, 'Checked' ), 'on' ),
    i_switch1d(       proot, psbar, pview, pmenus, 'off'  );
    i_switch2d(       proot, psbar, pview, pmenus, 'off' );
    i_switchpairwise( proot, psbar, pview, pmenus, 'off' );

    i_draw3d(proot,psbar,pview,pmenus);
    set( pview.info.cards, 'CurrentCard', 3 );
   
    i_switch3d(  proot, psbar, pview, pmenus, 'on'  );
end
i_enableintervals( proot, pview );
i_enableboundarypoints( proot, psbar, pview, pmenus );
return

%---------------------------------|--------------------------------------------|
function  i_viewpairwise( src, evt, proot, psbar, pview, pmenus )

set( pmenus.info.Toolbar.ViewPairwise, 'State', 'on' );
if ~strcmpi( get( pmenus.info.View.ViewPairwise, 'Checked' ), 'on' ),
    i_switch1d( proot, psbar, pview, pmenus, 'off'  );
    i_switch2d( proot, psbar, pview, pmenus, 'off' );
    i_switch3d( proot, psbar, pview, pmenus, 'off'  );
    
    i_drawpairwise(proot,psbar,pview,pmenus);
    
    set( pview.info.cards, 'CurrentCard', 4 ); 
    stages = i_currentstagescard( proot, pview );
    set( pview.info.viewpw.cards, 'CurrentCard', stages );
    
    i_switchpairwise( proot, psbar, pview, pmenus, 'on' );
end
i_enableintervals( proot, pview );
i_enableboundarypoints( proot, psbar, pview, pmenus );
return

%---------------------------------|--------------------------------------------|
function  i_switch1d( proot, psbar, pview, pmenus, state )
ind = i_currentstagescard( proot, pview );

view1d = pview.info.view1d.ud;
if proot.getnumstages == 1,
    set( [  view1d(1).dots{:}, ...
            view1d(1).rings{:}, ...
            view1d(1).regions{:} ], 'Visible', 'Off' );   
else, % if proot.getnumstages == 2,
    set( [  view1d(1).dots{:}, ...
            view1d(2).dots{:}, ...
            view1d(3).dots{:}, ...
            view1d(1).rings{:}, ...
            view1d(2).rings{:}, ...
            view1d(3).rings{:}, ...
            view1d(1).regions{:}, ...
            view1d(2).regions{:}, ...
            view1d(3).regions{:} ], 'Visible', 'Off' );   
end

if strcmpi( state, 'on' ),
    set( pview.info.factors.lctrlXFactor, 'Enable', 'off' );
    set( pview.info.factors.lctrlYFactor, 'Enable', 'off' );
    set( pview.info.factors.lctrlZFactor, 'Enable', 'off' );
else
    set( [view1d(ind).rings{:}],       'Visible', 'off' );
end
set( pmenus.info.Toolbar.View1d, 'State', state );
set( pmenus.info.View.View1d,    'Checked', state );

set( [view1d(ind).dots{:}],     'Visible', state );   
set( [view1d(ind).regions{:}],  'Visible', state );
return

%---------------------------------|--------------------------------------------|
function  i_switch2d( proot, psbar, pview, pmenus, state )
if strcmpi( state, 'on' ),
    set( pview.info.factors.lctrlXFactor, 'Enable', 'on' );
    set( pview.info.factors.lctrlYFactor, 'Enable', 'on' );
    set( pview.info.factors.lctrlZFactor, 'Enable',  'off' );
else
    set( pview.info.view2d.rings2d,       'Visible', 'off' );
end
set( pmenus.info.Toolbar.View2d, 'State', state );
set( pmenus.info.View.View2d,  'Checked', state );
set( pview.info.view2d.dots2d, 'Visible', state );   
set( pview.info.view2d.lines,  'Visible', state );
return
   
%---------------------------------|--------------------------------------------|
function  i_switch3d( proot, psbar, pview, pmenus, state )
if strcmpi( state, 'on' ),
    set( pview.info.factors.lctrlXFactor, 'Enable', 'on' );
    set( pview.info.factors.lctrlYFactor, 'Enable', 'on' );
    set( pview.info.factors.lctrlZFactor, 'Enable', 'on' );
else
    set( pview.info.view3d.rings3d, 'Visible', 'off' );
end
set( pmenus.info.Toolbar.View3d, 'State',  state );
set( pmenus.info.View.View3d,   'Checked', state );
set( pview.info.view3d.dots3d,  'Visible', state );   
set( pview.info.view3d.surface, 'Visible', state );   
set( pview.info.view3d.caps,    'Visible', state );   
return

%---------------------------------|--------------------------------------------|
function  i_switchpairwise( proot, psbar, pview, pmenus, state )
ind = i_currentstagescard( proot, pview );

viewpw = pview.info.viewpw.ud;
if proot.getnumstages == 1,
    set( [  viewpw(1).dots{:}, ...
            viewpw(1).rings{:}, ...
            viewpw(1).regions{:}, ...
            viewpw(1).hilight{:}, ...
            viewpw(1).hilightline ], 'Visible', 'Off' );   
else, % if proot.getnumstages == 2,
    set( [  viewpw(1).dots{:}, ...
            viewpw(2).dots{:}, ...
            viewpw(3).dots{:}, ...
            viewpw(1).rings{:}, ...
            viewpw(2).rings{:}, ...
            viewpw(3).rings{:}, ...
            viewpw(1).regions{:}, ...
            viewpw(2).regions{:}, ...
            viewpw(3).regions{:}, ...
            viewpw(1).hilight{:}, ...
            viewpw(2).hilight{:}, ...
            viewpw(3).hilight{:}, ...
            viewpw(1).hilightline, ...
            viewpw(2).hilightline, ...
            viewpw(3).hilightline ], 'Visible', 'Off' );   
end

if strcmpi( state, 'on' ),
    set( pview.info.factors.lctrlXFactor, 'Enable',  'off' );
    set( pview.info.factors.lctrlYFactor, 'Enable',  'off' );
    set( pview.info.factors.lctrlZFactor, 'Enable',  'off' );
else
    set( [viewpw(ind).rings{:}], 'Visible', 'off' );
end
set( pmenus.info.Toolbar.ViewPairwise, 'State',   state );
set( pmenus.info.View.ViewPairwise,    'Checked', state );
set( [viewpw(ind).dots{:}],    'Visible', state );   
set( [viewpw(ind).regions{:}], 'Visible', state );   
set( [viewpw(ind).hilight{:}], 'Visible', state );   
set(  viewpw(ind).hilightline, 'Visible', state );   
return

%---------------------------------|--------------------------------------------|
function  i_boundarypoints(src,evt,proot,psbar,pview,pmenus)

tb = pmenus.info.Toolbar.BoundaryPoints; % toolbar button
mi = pmenus.info.View.BoundaryPoints;    % menu item

% The 'State' of the boundary point toolbar button stores the state of the
% viewing of the boundary points
state = get( tb, 'State' );    

% If this function is being called from the menu then we need to reverse
% the state as returned by the toolbar button.
if isequal( src, mi ),
    if strcmpi( state, 'on' ),
        state = 'Off';
    else,
        state = 'On';
    end
end

% Set the status of the toolbar button and the menu item
set( mi, 'Checked', state );
set( tb, 'State', state );

% Turn plots of the boundary points on or off as appropriate
i_enableboundarypoints(proot,psbar,pview,pmenus);
return

%---------------------------------|--------------------------------------------|
function  i_factorsel( A, B, C )
% A    is the selected the popup control
% B,C  are the other popup controls
%   if there are less than 3 factors, then it is C that is unchanged.
a = get( A, 'Value' );
b = get( B, 'Value' );
c = get( C, 'Value' );
symbols = get( A, 'String' );
n = numel( symbols );
if n < 2,
    % leave them as be
elseif n < 3,
    % ignore z factor
    if a == b,
        if a == 1,
            set(B,'Value',2);
        else,
            set(B,'Value',1);
        end
    end
else   
    candidates = setdiff( 1:n, [a, b, c] );
    if a == b,
        set(B,'Value', candidates(1) );
        b = candidates(1);
        candidates(1) = [];
    end
    if a == c,
        set(C,'Value', candidates(1) );
        b = candidates(1);
        candidates(1) = [];
    end
    if b == c,
        set(C,'Value', candidates(1) );
    end
end
return

%---------------------------------|--------------------------------------------|
function  i_factorx(src,evt,proot,psbar,pview,pmenus)
i_factorsel( ...
    pview.info.factors.popXFactor, ...
    pview.info.factors.popYFactor, ...
    pview.info.factors.popZFactor  );
i_draw(proot,psbar,pview,pmenus);
i_enableintervals(proot,pview);
return

%---------------------------------|--------------------------------------------|
function  i_factory(src,evt,proot,psbar,pview,pmenus)
i_factorsel( ...
    pview.info.factors.popYFactor, ...
    pview.info.factors.popXFactor, ...
    pview.info.factors.popZFactor );
i_draw(proot,psbar,pview,pmenus);
i_enableintervals(proot,pview);
return

%---------------------------------|--------------------------------------------|
function  i_factorz(src,evt,proot,psbar,pview,pmenus)
i_factorsel( ...
    pview.info.factors.popZFactor, ...
    pview.info.factors.popXFactor, ...
    pview.info.factors.popYFactor );
i_draw(proot,psbar,pview,pmenus);
i_enableintervals(proot,pview);
return

%---------------------------------|--------------------------------------------|
function  i_resolution(src,evt,proot,psbar,pview,pmenus)
i_draw(proot,psbar,pview,pmenus);
return

%---------------------------------|--------------------------------------------|
function  i_editslice(src,evt,proot,psbar,pview,pmenus)
if nargin < 1,
    src = gcbo;
    ud = get( get(src, 'Parent'), 'UserData' );

    proot  = ud.root;
    psbar  = ud.sbar;
    pview  = ud.view;
    pmenus = ud.menus;
end

switch lower( get( src, 'Style' ) )
    case 'leftright',
        % slice editing requires total redraw
        i_draw(proot,psbar,pview,pmenus);
    case 'edit',
        % width editing only affects dots
        i_drawdots(proot,psbar,pview,pmenus);
end
return
%---------------------------------|--------------------------------------------|
function  OLD_i_editSlice(src,evt,proot,psbar,pview,pmenus)
table = pview.info.intervals;
row = evt.Row;
col = evt.Column;

friend = proot.info.friend;
[LB,UB]= range(friend);

value = table(row,col).value;
if isempty( value ) | ~isfinite( value )
    value = table(row,col).value; 
elseif col == 2,  % col == 2 ==> width change
    if value < 0,
        value = 0; 
    elseif value > (UB(row) - LB(row));
        value = UB(row) - LB(row); 
    end
elseif col == 1, % col == 1 ==> slice change
    if value < UB(row),
        value = UB(row);
    elseif value > LB(row),
        value = LB(row);
    end
end
table(row,col).string = num2str( value );
table(row,col).value  = value;

if col == 1,
    % slice editing requires total redraw
    i_draw(proot,psbar,pview,pmenus);
elseif col == 2,
    % width editing only affects dots
    i_drawdots(proot,psbar,pview,pmenus);
end
return

%---------------------------------|--------------------------------------------|
% Active X callbacks
function o________ACTIVEX_CALLBACKS
%---------------------------------|--------------------------------------------|
function  cb = i_TreeviewCallbacks
cb = { ...
        'AfterLabelEdit', @i_activex; ...
        'NodeClick', @i_activex; ...
        'KeyUp', @i_activex; ...
        'MouseMove', 'MotionManager'; ...
    };
return

%---------------------------------|--------------------------------------------|
function i_activex( src, evt, varargin )

% get the figure and user data
figh = get( src, 'Parent' );
ud = get( figh, 'UserData' );
proot  = ud.root; 
psbar  = ud.sbar; 
pview  = ud.view;
pmenus = ud.menus;

% fire the required callback
switch varargin{end},
    case 'KeyUp'
        % Key press event
        switch double( varargin{1} ), % key code
            case {16,17},  % shift and control keys
                return
            case 45, % Insert
                i_newmodel( src, evt, proot, psbar, pview, pmenus );
            case 46, % Delete
                i_deletemodel( src, evt, proot, psbar, pview, pmenus );
            case 113, % F2 edit
                src.StartLabelEdit;
        end
    case 'NodeClick', 
        i_changecurrentnode( proot, psbar, pview, pmenus );
    case 'AfterLabelEdit', 
        cancel = varargin{1};
        newstring = varargin{2};
        i_renamenode( src, evt, proot, psbar, pview, pmenus, cancel, newstring );
    otherwise
        disp( sprintf( 'Unhandled event %s', varargin{end} ) );
end
return

%---------------------------------|--------------------------------------------|
function  i_template( figh, evt, proot, psbar, pview, pmenus )
return

%---------------------------------|--------------------------------------------|

%---------------------------------|--------------------------------------------|
%  Functions that draw the pictures
function o__________________DRAWING  
%---------------------------------|--------------------------------------------|
function  i_draw(proot,psbar,pview,pmenus)
% Calls the appropriate draw function (2d or 3d) for the current view
switch get( pview.info.cards, 'CurrentCard' ),
    case 1,
        i_draw1d(proot,psbar,pview,pmenus); 
    case 2,
        i_draw2d(proot,psbar,pview,pmenus);
    case 3,
        i_draw3d(proot,psbar,pview,pmenus);
    case 4,
        i_drawpairwise(proot,psbar,pview,pmenus);
    otherwise
        % there should be one case for each card!
end
return

%---------------------------------|--------------------------------------------|
function  i_drawdots(proot,psbar,pview,pmenus)
% Calls the appropriate dot drawing routine (2d or 3d) for the current view
switch get( pview.info.cards, 'CurrentCard' ),
case 1,
    i_draw1ddots(proot,psbar,pview,pmenus);
case 2,
    i_draw2ddots(proot,psbar,pview,pmenus);
case 3,
    i_draw3ddots(proot,psbar,pview,pmenus);
otherwise
    % there should be one case for each card!
end
return

%---------------------------------|--------------------------------------------|
function  i_draw1d( proot, psbar, pview, pmenus )
msgID = i_addmessage( psbar, 'Drawing 1D plots...' );
ptrID = i_setpointer( psbar, 'watch');

% ensure the correct card is visible
mode = i_currentstagescard( proot, pview );
if get( pview.info.view1d.cards, 'CurrentCard' ) ~= mode,
    i_switch1d( proot, psbar, pview, pmenus, 'on' );
    set( pview.info.view1d.cards, 'CurrentCard', mode );
end

% Get all the view data 
view = pview.info.view1d.ud(mode);

% Factor numbers; symbols not required
factnum = i_currentfactors( proot, pview );
nf = numel( factnum );

% Friend mode and coding info
friend = proot.getfriend;
[LB,UB]= range(friend);
[Bnds,g,Tgt]= getcode(friend);
Tgt(:,1)= -1; Tgt(:,2)= 1; 
[mdl]= setcode(friend, Bnds,g,Tgt);

LB= LB(factnum);
UB= UB(factnum);

% Get the constraint from the current node
con = i_currentconstraint( pview );

% Draw the one-d dots 
i_draw1ddots( proot, psbar, pview, pmenus );

% Axis labels are fixed for 1d slices

% Axis limits
for i = 1:nf,
    set( view.axes{i}, 'XLim', [LB(i), UB(i)] );
end

% Plot resolution
resolution = get( pview.info.factors.editResolution, 'Value' );

if ~isempty( con ),
    % get the intervals and evaluation point
    intervals = get( pview.info.intervals, 'elements' );
    mid   = cell( 1, nf );
    for i = 1:nf,
        mid{i} = code(mdl, get( intervals{factnum(i)}, 'value' ), factnum(i)) ;
    end
    
    for i = 1:nf,
        x = linspace( -1, 1, resolution )';
        xx = mid;
        xx{i} = x;
        y = cgrideval( con, xx );
        p = i_drawcontours1d( view.axes{i}, linspace( LB(i), UB(i), resolution )', y, 0 );
        
        if ~isempty( view.regions{i} ), 
            delete( view.regions{i} ); 
        end
        view.regions{i} = p;

    end
else
    set( [view.regions{:}], 'Visible', 'off' )
end

% Store new view info
tmpview = pview.info;
tmpview.view1d.ud(mode) = view;
pview.info = tmpview;

i_deletemessage( psbar, msgID);
i_deletepointer( psbar, ptrID );
return

%---------------------------------|--------------------------------------------|
function  i_draw2d(proot,psbar,pview,pmenus)
msgID = i_addmessage( psbar, 'Drawing 2D graph...' );
ptrID = i_setpointer( psbar, 'watch');

% Only one card for 2d slices

% View info
view   = pview.info;
axes2d = view.view2d.axes2d;
dots2d = view.view2d.dots2d;

% Factor numbers and symbols
factnum = i_currentfactors( proot, pview );
symbols = i_currentsymbols( proot, pview );
nf = length( factnum );

% Friend model and coding
friend = proot.getfriend;
[LB,UB]= range(friend);
LB= LB(factnum);
UB= UB(factnum);

[Bnds,g,Tgt]= getcode(friend);
Tgt(:,1)= -1; Tgt(:,2)= 1; 
[mdl]= setcode(friend, Bnds,g,Tgt);

% Get the constraint from the current node
star = i_currentconstraint( pview );

% Factor selection and resolution
x_val = get( view.factors.popXFactor, 'value' );
y_val = get( view.factors.popYFactor, 'value' );
resolution = get( view.factors.editResolution, 'Value' );

% set the axes labels
set( get( axes2d, 'XLabel' ), 'string', symbols(x_val,:) );
set( get( axes2d, 'YLabel' ), 'string', symbols(y_val,:) );

% set the axes limits
set( axes2d, 'XLim', [LB(x_val), UB(x_val)] );
set( axes2d, 'YLim', [LB(y_val), UB(y_val)] );

% draw dots and rings
i_draw2ddots( proot, psbar, pview, pmenus );
    
% plot the boundary
if ~isempty( star ),
    x = linspace( LB(x_val), UB(x_val), resolution );
    y = linspace( LB(y_val), UB(y_val), resolution );
    %% [xx,yy] = meshgrid( x, y );
    [xx,yy] = meshgrid( linspace( -1, 1, resolution ) );
    npts = resolution * resolution;
    evalpts = zeros( npts, nf );
    intervals = get( pview.info.intervals, 'elements' );
    for i=1:nf,
        switch i,
            case x_val, 
                evalpts(:,i) = xx(:);
            case y_val, 
                evalpts(:,i) = yy(:);
            otherwise
                %% evalpts(:,i) = get( intervals{i}, 'value' );
                evalpts(:,i) = code(mdl, get( intervals{factnum(i)}, 'value' ), factnum(i)) ;
        end
    end
    %% Z = constraindist( star, code( friend, evalpts, factnum ) );
    Z = constraindist( star, evalpts );
    newlines = i_drawcontours( axes2d, x, y, ...
        reshape( -Z, resolution, resolution ), 0, [0.5, 0.5, 1] );

    if ~isempty( view.view2d.lines ), 
        delete( view.view2d.lines ); 
    end
    view.view2d.lines = newlines;
else
    % the model is empty
    set( view.view2d.lines, 'Visible', 'Off' )
end

% Store new view info
pview.info = view;

i_deletemessage( psbar, msgID);
i_deletepointer( psbar, ptrID );
return

%---------------------------------|--------------------------------------------|
function  i_drawpairwise(proot,psbar,pview,pmenus)
msgID = i_addmessage( psbar, 'Drawing pairwise plots...' );
ptrID = i_setpointer( psbar, 'watch');

% Ensure correct card is visible
mode = i_currentstagescard( proot, pview );
if get( pview.info.viewpw.cards, 'CurrentCard' ) ~= mode,
    i_switchpairwise( proot, psbar, pview, pmenus, 'on' );
    set( pview.info.viewpw.cards, 'CurrentCard', mode );
end

% Get view info
view   = pview.info;
viewpw = view.viewpw.ud(mode);
axh    = viewpw.axes;

% Factor numbers and symbols
factnum = i_currentfactors( proot, pview );
symbols = i_currentsymbols( proot, pview );
nf = length( factnum );

% Friend model and coding info
friend = proot.getfriend;
[LB,UB]= range(friend);
LB= LB(factnum);
UB= UB(factnum);

[Bnds,g,Tgt]= getcode(friend);
Tgt(:,1)= -1; Tgt(:,2)= 1; 
[mdl]= setcode(friend, Bnds,g,Tgt);

% Current constraint
star = i_currentconstraint( pview );

% Factor selection and resolution
resolution = get( view.factors.editResolution, 'Value' );
resolution = min( resolution, floor( 810000^(1/nf) ) );
set( view.factors.editResolution, 'Value', resolution );

% Axis labels and limits are fixed for pairwise projections

% Dots and rings
i_drawpairwisedots( proot, psbar, pview, pmenus );

% Main evalution and drawing
if ~isempty( star ),
    % generate evaluation points
    evalvec = cell( 1, nf );
    evalpts = cell( 1, nf );
    for i = 1:nf,
        evalvec{i} = linspace( LB(i), UB(i), resolution );
    end
    [evalpts{:}] = ndgrid( linspace( -1 , 1, resolution ) );
    for i = 1:nf,
        evalpts{i} = evalpts{i}(:);
    end
    evalpts= [evalpts{:}];
    % evaluate
    msgID_eval = i_addmessage( psbar, 'Evaluating model...' );
    dist = constraindist( star, evalpts  );
    dist = reshape( dist, repmat( resolution, 1, nf ) );
    i_deletemessage( psbar, msgID_eval);

    % make highlight mask
    hld = viewpw.hilightdata; 
    hl_factnum = factnum(hld.Factors); 
    hl_min = code( mdl, hld.Min, hl_factnum ); 
    hl_max = code( mdl, hld.Max, hl_factnum ); 
    hilightmask = evalpts(:,hld.Factors(1)) > hl_min(1) ... 
        & evalpts(:,hld.Factors(1)) < hl_max(1) ... 
        & evalpts(:,hld.Factors(2)) > hl_min(2) ... 
        & evalpts(:,hld.Factors(2)) < hl_max(2); 
    hilightmask = reshape( hilightmask, repmat( resolution, 1, nf ) ); 

    ii = isfinite( dist );
    minz = min( dist(ii) );
    maxz = max( dist(ii) );
    pad = maxz + 1e4*(maxz - minz);
    if isempty( pad ) || ~isfinite( pad ),
        pad = realmax;
    end
            
    hldist = dist;
    hldist(~hilightmask) = pad; % realmax;

    % display the boundaries
    for i = 2:nf,
        for j = 1:i-1,,
            z = dist;
            x = evalvec{j};
            y = evalvec{i};
            
            hlz = hldist;
            for k = 1:nf,
                if k ~= i && k ~= j,
                    z = min( z, [], k );
                    hlz = min( hlz, [], k );
                end
            end
            z = squeeze( z );
            hlz = squeeze( hlz );
            
            % delete old patches
            if ~isempty( viewpw.regions{i-1,j} ),
                delete( viewpw.regions{i-1,j} );
            end
            % find new patches from contours
            viewpw.regions{i-1,j} = i_drawcontours( ...
                axh{i-1,j}, x, y, -z', 0, [0.5, 0.5, 1] );
            
            % draw the highlighted region
            % delete old patches
            if ~isempty( viewpw.hilight{i-1,j} ),
                delete( viewpw.hilight{i-1,j} );
            end
            % find new patches from contours
            viewpw.hilight{i-1,j} = i_drawcontours( ...
                axh{i-1,j}, x, y, -hlz', 0, [1, 1, 0] );
        end
    end
else
    % no model, turn off graphics
    set( [viewpw.rings{:}],   'Visible', 'Off' );   
    set( [viewpw.regions{:}], 'Visible', 'Off' );   
    set( [viewpw.hilight{:}], 'Visible', 'Off' );   
    set(  viewpw.hilightline, 'Visible', 'Off' );   
end

% set the axes limits
for i = 2:nf,
    for j = 1:i-1,
        set( axh{i-1,j}, 'XLim', [LB(j), UB(j)] );
        set( axh{i-1,j}, 'YLim', [LB(i), UB(i)] );
    end
end

% Store new view info
view.viewpw.ud(mode) = viewpw;
pview.info = view;

i_deletemessage( psbar, msgID);
i_deletepointer( psbar, ptrID );
return

%---------------------------------|--------------------------------------------|
function  i_draw3d(proot,psbar,pview,pmenus)
msgID = i_addmessage( psbar, 'Drawing 3D graph...' );
ptrID = i_setpointer( psbar, 'watch');

% Ensure correct card is visible

% Get view info
view    = pview.info;
axes3d  = view.view3d.axes3d;
dots3d  = view.view3d.dots3d;
rings3d = view.view3d.rings3d;
surface = view.view3d.surface;
caps    = view.view3d.caps;

% Get factor numbers and symbols
factnum = i_currentfactors( proot, pview );
symbols = i_currentsymbols( proot, pview );
nf = length( factnum );

% Friend model and coding
friend = proot.getfriend;
[LB,UB]= range(friend);
LB= LB(factnum);
UB= UB(factnum);
[Bnds,g,Tgt]= getcode(friend);
Tgt(:,1)= -1; Tgt(:,2)= 1; 
[mdl]= setcode(friend, Bnds,g,Tgt);
% Get current constraint
con = i_currentconstraint( pview );

% Factor selection and resolution
x_val = get( view.factors.popXFactor, 'value' );
y_val = get( view.factors.popYFactor, 'value' );
z_val = get( view.factors.popZFactor, 'value' );
resolution = get( view.factors.editResolution, 'Value' );

% Axis labels
set( get( axes3d, 'XLabel' ), 'string', symbols(x_val,:) );
set( get( axes3d, 'YLabel' ), 'string', symbols(y_val,:) );
set( get( axes3d, 'ZLabel' ), 'string', symbols(z_val,:) );

% Axis limits
set( axes3d, 'XLim', [LB(x_val), UB(x_val)], ...
    'YLim', [LB(y_val), UB(y_val)], ...
    'ZLim', [LB(z_val), UB(z_val)] );

% Draw dots and rings
i_draw3ddots(proot,psbar,pview,pmenus);

% turn visible property of all graphics to off (while computation
% performed)
ringsvisible = get( rings3d, 'Visible' );
set( axes3d,  'Visible', 'off' );
set( dots3d,  'Visible', 'off' );
set( rings3d, 'Visible', 'off' );
set( surface, 'Visible', 'off' );
set( caps,    'Visible', 'off' );

% plot the boundary
if ~isempty( con ),  
    x = linspace( LB(x_val), UB(x_val), resolution );
    y = linspace( LB(y_val), UB(y_val), resolution );
    z = linspace( LB(z_val), UB(z_val), resolution );
    [xx, yy, zz] = meshgrid( linspace( -1, 1, resolution ) );
    npts = resolution*resolution*resolution;
    evalpts = zeros( npts, nf );
    intervals = get( pview.info.intervals, 'elements' );
    for i=1:nf,
        switch i,
        case x_val, 
            evalpts(:,i) = xx(:);
        case y_val, 
            evalpts(:,i) = yy(:);
        case z_val, 
            evalpts(:,i) = zz(:);
        otherwise
            evalpts(:,i) = code(mdl, get( intervals{factnum(i)}, 'value' ), factnum(i)) ;
        end
    end
    
    % Evaluate the distance to the constraint from every point on a the
    % grid
    msgID3 = i_addmessage( psbar, 'Evaluating constraint...' );
    Z = constraindist( con, evalpts );
    Z = reshape( Z, resolution, resolution, resolution );
    i_deletemessage( psbar, msgID3);

    ii = isfinite( Z );
    if any( ii(:) ),
        % Remove any infinte elements from Z and replace them instead with
        % a very large number 
        minz = min( Z(ii) );
        maxz = max( Z(ii) );
        pad = maxz + 1e4*(maxz - minz);
        if ~isfinite( pad ),
            pad = realmax;
        end
        Z(~ii) = pad;
        
        % Isosurface constraint
        msgID3 = i_addmessage( psbar, 'Isosurfacing constraint...' );
        [FV1] = isosurface( x, y, z, -Z, 0 );
        [FV2] = isocaps(    x, y, z, -Z, 0 );
        i_deletemessage( psbar, msgID3);
        
        set( surface, 'Vertices', FV1.vertices, 'Faces', FV1.faces );
        set( caps,    'Vertices', FV2.vertices, 'Faces', FV2.faces );
    else
        set( surface, 'Vertices', [], 'Faces', [] );
        set( caps,    'Vertices', [], 'Faces', [] );
    end
end

% Set the visible property of all graphics 
% The axes and dots are ever present
set( axes3d,  'Visible', 'on' );
set( dots3d,  'Visible', 'on' );
if ~isempty( con ),  
    set( rings3d, 'Visible', ringsvisible );
    set( surface, 'Visible', 'on' );
    set( caps,    'Visible', 'on' );
else
    set( rings3d, 'Visible', 'Off' );
    set( surface, 'Visible', 'Off' );
    set( caps,    'Visible', 'Off' );
end

% Don't need to save new view info as all the old handles are used.

% finish
i_deletemessage( psbar, msgID);
i_deletepointer( psbar, ptrID );
return

%-------------------------------------------------------------------
function p = i_drawcontours1d( axh, x, y, v )
x = x(:);
y = y(:);
n = size( x );

ii = isfinite( y );
if ~any( ii ),
    p = [];
    return
end

ylim = get( axh, 'YLim' );
xlim = get( axh, 'XLim' );

yi = y < v; 
up   = find( diff( yi ) < 0 ); % up crossings
down = find( diff( yi ) > 0 ); % down crossings

y = y - v;

ends = [];
if isempty( up ) && isempty( down )
    if yi(1),
        ends = xlim;
        k = 2;
    end
else
    ends = zeros( 0, 2 );
    k = 1;
    if ~isempty( up ) && ( isempty( down ) || up(1) < down(1) ),
        % first patch is hard up against the left border
        x0 = i_xintercept( x(up(1)+(0:1)), y(up(1)+(0:1)) );
        ends(k,:) = [xlim(1), x0];
        k = k+1;
        % remove this from list of up crossing
        up(1) = [];
    end
    
    if ~isempty( down ) && ( isempty( up ) || up(end) < down(end) ),
        % last patch is hard up against the right border
        x0 = i_xintercept( x(down(end)+(0:1)), y(down(end)+(0:1)) );
        ends(k,:) = [x0, xlim(2)];
        k = k+1;
        % remove this from list of down crossing
        down(end) = [];
    end
    
    for i = 1:numel( up ),
        a = i_xintercept( x(down(i)+(0:1)), y(down(i)+(0:1)) );
        b = i_xintercept( x(up(i)+(0:1)), y(up(i)+(0:1)) );
        ends(k,:) = [a, b];
        k = k+1;
    end
end

if ~isempty( ends ),
    p = patch( ends(:,[1, 1, 2, 2, 1])', ylim(ones( k-1, 1 ),[1, 2, 2, 1, 1])', ...
        [0.5, 0.5, 1], 'parent', axh, ...    
        'LineWidth', 2, ...
        'EdgeColor', 'k', ...
        'HitTest', 'off' );
else,
    p = [];
end

return

%-------------------------------------------------------------------
function x0 = i_xintercept( x, y )
% Write the line as x = m*y + c
% The the x-interpcept if c
% Set up a system of equations (2x2) to solve for the parameters of the
% line

i = ~isfinite( y );
y(i) = [];
x(i) = [];
if isempty( x ),
    x0 = mean( x );
else
    b = [y(:), ones( numel( y ), 1)]\x(:);
    x0 = b(2);
end
return

%---------------------------------|--------------------------------------------|
function p = i_drawcontours( axh, x, y, z, v, color )
[m, n] = size( z );

ii = isfinite( z );
if ~any( ii(:) ),
    p = [];
    return
end

% pading with a very large negative value is an easy way of getting the
% caps from contours 
minz = min( z(ii) );
maxz = max( z(ii) );
pad = minz - 1e4*(maxz - minz);
if ~isfinite( pad ),
    pad = -realmax;
end
z(~ii) = pad;


z = [ 
    repmat( pad, 1, m + 2 );       
    repmat( pad, n, 1 ), z,  repmat( pad, n, 1 );
    repmat( pad, 1, m + 2 );
];     

x = [2*x(1)-x(2), x, 2*x(end)-x(end-1)];
y = [2*y(1)-y(2), y, 2*y(end)-y(end-1)];

% find the contours
C = contours( x, y, z, [v, v] );

% find patches from contours
p = xregcontours2patches( C, axh, ...
    'LineWidth', 2, ...
    'EdgeColor', 'k', ...
    'FaceColor', color, ... % light blue
    'HitTest', 'off' );

return

%---------------------------------|--------------------------------------------|
function out = i_draw1ddots( proot, psbar, pview, pmenus )

stages = i_currentstagescard( proot, pview );
view   = pview.info.view1d.ud(stages);

symbols = i_currentsymbols( proot, pview );
factnum = i_currentfactors( proot, pview );
data    = i_currentdata(    proot, pview , false);
ndata = size( data, 1 );
nf    = size( data, 2 );

% get the intervals
intervals = get( pview.info.intervals, 'elements' );

% need to select which centers to plot
mid   = zeros( 1, nf );
width = zeros( 1, nf );
for i = 1:nf,
    j = factnum(i);
    mid(i)   = get( intervals{j}, 'value' );
    width(i) = get( intervals{j}, 'tolerance');
end
low = mid - width;
hi  = mid + width;
low = repmat( low, ndata, 1 );
hi  = repmat( hi,  ndata, 1 );
inside = double(data) >= low & double(data) <= hi;

% get the indices for the rings to plot
bdev = i_currentnode( pview );
if isempty( bdev ) | ~bdev.isa( 'xregbdrydev' ),
    bdry = [];
else
    % get the boundary indices
    bdry = bdev.getbdrypoints;
end

for i = 1:nf,
    % find the points that are inside all the intervals, ignoreing the i-th
    % interval
    ind = find( all( inside(:,[1:(i-1),(i+1):nf]), 2 ) ); 
    
    % find those currently plotted points that are on the boundary
    if ischar( bdry ) && strcmpi( ':', bdry ),
        bind = ind;
    else
        bind = intersect( ind, bdry );
    end

    % set the coordinates for the plotted points
    set( view.dots{i}, ...
        'XData', double(data(ind,i)), ...
        'YData', repmat( 0.5, size( ind ) ) );
    set( view.rings{i}, ...
        'XData', double(data(bind,i)), ...
        'YData', repmat( 0.5, size( bind ) ) );
    
    % set the data for the i_viewdot callback
    set( view.dots{i}, 'UserData', { symbols, data(ind,:) } );
end
return

%---------------------------------|--------------------------------------------|
function out = i_draw2ddots(proot,psbar,pview,pmenus)
view   = pview.info;

friend = proot.getfriend;

dots2d  = view.view2d.dots2d;
rings2d = view.view2d.rings2d;

bdev = i_currentnode( pview );
star = bdev.getconstraint;

symbols = i_currentsymbols( proot, pview );
data = i_currentdata( proot, pview, false);
nf = size( data, 2 );
factnum = i_currentfactors( proot, pview );

x_ind = get( view.factors.popXFactor, 'value' );
y_ind = get( view.factors.popYFactor, 'value' );

x_data = data(:,x_ind);
y_data = data(:,y_ind);

% plot the dots
if nf < 3,
    % only two variables to worry about, no intervals so plot all points
    ind = 1:size(data,1);
else
    % need to set up eval for the right values and select which centers to plot
    ndata = size( data, 1 );
    % get the intervals
    intervals = get( view.intervals, 'elements' );
    bind = setdiff( 1:nf, [x_ind, y_ind] );  % bound indices
    mid = [];
    width = [];
    for i = factnum(bind),
        mid   = [ mid,   get( intervals{i}, 'value' ) ];
        width = [ width, get( intervals{i}, 'tolerance' ) ];
    end
    low = mid - width;
    hi  = mid + width;
    low = repmat( low, ndata, 1 );
    hi  = repmat( hi,  ndata, 1 );
    bdata = data(:,bind);
    ind = find( all( bdata >= low & bdata <= hi, 2 ) );
end
    
% get the indices for the rings to plot
if isempty( bdev ) | ~bdev.isa( 'xregbdrydev' ),
    bind = [];
else
    % get the boundary indices
    bdry = bdev.getbdrypoints;
    % find those currently plotted points that are on the boundary
    if ischar( bdry ) && strcmpi( ':', bdry ),
        bind = ind;
    else
        bind = intersect( ind, bdry );
    end
end

% set the coordinates for the plotted points
set( dots2d,  'XData', x_data(ind), ...
    'YData', y_data(ind) );
set( rings2d, 'XData', x_data(bind), ...
    'YData', y_data(bind) );

% set the data for the i_viewdot callback
set( dots2d, 'UserData', { symbols, data(ind,:) } );

return

%---------------------------------|--------------------------------------------|
function out = i_draw3ddots(proot,psbar,pview,pmenus)
% Set the [XYZ]Data for the 3d dots and rings
% The setting of the data is done last and the dots and rings
% are set together so there is only a small delay between anys dots
% disappearing and their associated rings disappearing
msgID = i_addmessage( psbar, 'Drawing 3D dots and rings...' );
ptrID = i_setpointer( psbar, 'watch');

view   = pview.info;

friend = proot.getfriend;
bdev   = i_currentnode( pview );

dots3d  = view.view3d.dots3d;
rings3d = view.view3d.rings3d;

symbols = i_currentsymbols( proot, pview );
data = i_currentdata( proot, pview , false);
nf = size( data, 2 );
factnum = i_currentfactors( proot, pview );

x_val = get( view.factors.popXFactor, 'value' );
y_val = get( view.factors.popYFactor, 'value' );
z_val = get( view.factors.popZFactor, 'value' );

x_data = data(:,x_val);
y_data = data(:,y_val);
z_data = data(:,z_val);

% get the indices for the dots to plot
if nf < 4,
    % only there variables to worry about, no intervals so all points are to be 
    % plotted
    ind = 1:size(data,1);
else
    % need to set up eval for the right values and select which centers to plot
    ndata = size( data, 1 );
    % get the intervals
        %% intervals = view.intervals;
    intervals = get( view.intervals, 'elements' );
    bind = setdiff( 1:nf, [x_val, y_val, z_val] );  % bound indices
    mid = [];
    width = [];
    for i = factnum(bind),
        mid   = [ mid,   get( intervals{i}, 'value' ) ];
        width = [ width, get( intervals{i}, 'tolerance' ) ];
    end
    low = repmat( mid - width, ndata, 1 );
    hi  = repmat( mid + width, ndata, 1 );
    data = data(:,bind);
    ind = find( all( data >= low & data <= hi, 2 ) );
end

% get the indices for the rings to plot
if isempty( bdev ) | ~bdev.isa( 'xregbdrydev' ),
    bind = [];
else
    % get the boundary indices
    bdry = bdev.getbdrypoints;
    % find those currently plotted points that are on the boundary
    if ischar( bdry ) && strcmpi( ':', bdry ),
        bind = ind;
    else
        bind = intersect( ind, bdry );
    end
end

% set the coordinates for the plotted points
set( dots3d, 'XData', x_data(ind), ...
    'YData', y_data(ind), ...
    'ZData', z_data(ind) );
set( rings3d, 'XData', x_data(bind), ...
    'YData', y_data(bind), ...
    'ZData', z_data(bind) );

% set the user data for the dots
set( dots3d, 'UserData', { symbols, data(ind,:) } );

% finish
i_deletemessage( psbar, msgID);
i_deletepointer( psbar, ptrID );
return

%---------------------------------|--------------------------------------------|
function out = i_drawpairwisedots(proot,psbar,pview,pmenus)
% Set the [XYZ]Data for the 3d dots and rings
% The setting of the data is done last and the dots and rings
% are set together so there is only a small delay between anys dots
% disappearing and their associated rings disappearing
msgID = i_addmessage( psbar, 'Drawing pairwise dots and rings...' );
ptrID = i_setpointer( psbar, 'watch');

view = pview.info;
bdev = i_currentnode( pview );

stages = i_currentstagescard( proot, pview );
viewpw = pview.info.viewpw.ud(stages);

dots  = viewpw.dots;
rings = viewpw.rings;

data = i_currentdata( proot, pview, false );
nf = size( data, 2 );

% get the indices for the rings to plot
if isempty( bdev ) | ~bdev.isa( 'xregbdrydev' ),
    bind = [];
else
    % get the boundary indices
    bind = bdev.getbdrypoints;
end

for i = 2:nf,
    for j = 1:i-1,
        if i ~= j
            % set the coordinates for the plotted points
            set( dots{i-1,j}, 'XData', data(:,j), ...
                'YData', data(:,i) );
            set( rings{i-1,j}, 'XData', data(bind,j), ...
                'YData', data(bind,i) );
        end
    end
end

% finish
i_deletemessage( psbar, msgID);
i_deletepointer( psbar, ptrID );
return

%---------------------------------|--------------------------------------------|
function out = i_bigblackdots( axh )
out = line(...
        'Parent', axh,...
        'LineStyle', 'none', ...
        'Marker', '.', ...
        'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', 20, ...
        'XData', [], ...
        'YData', [], ...
        'ZData', [], ...
        'Visible','off' );
return

%---------------------------------|--------------------------------------------|
function out = i_bigredrings( axh )
out = line(...
        'Parent', axh,...
        'LineStyle', 'none', ...
        'LineWidth', 2, ...
        'Marker', 'o', ...
        'MarkerEdgeColor', 'r', ...
        'MarkerFaceColor', 'none', ...
        'MarkerSize', 10, ...
        'XData', [], ...
        'YData', [], ...
        'ZData', [], ...
        'HitTest', 'off', ...
        'Visible','off' );
return

%---------------------------------|--------------------------------------------|
function i_textpatch( ax, infoStr, CP )
% taken from mbcmodels/validate_rstool

xmode =    get(ax,'xlimmode');
ymode =    get(ax,'ylimmode');
set(ax,'xlimmode','manual','ylimmode','manual','layer','bottom')
%% save old ax units
oldUnits=get(ax,'units');

commonUnit = 'point';

%%create the text to find out its extent and hence if it fits in the figure
ph=patch('FaceColor',[1 1 0.8],...
    'visible','off',...
    'EdgeColor','k',...
    'tag','dataPatch',...
    'FaceAlpha',1,...
    'clipping','off');

th=text(CP(1),CP(2),3.0,infoStr,...
   'units','data',...
   'visible','off',...
   'parent',ax,...
   'FontName','Lucida Console',...
   'clipping','off',...
   'horiz','left',...
   'vert','bottom',...
   'Interpreter','none');        

% everything in same units (commonUnit) to see if it all fits on 
set([ax,th],'units',commonUnit);
Apos=get(ax,'position'); % =ax pos in commonUnit
axW = Apos(3);
axH = Apos(4);

%% set text fontsize in 'point'
set(th,'fontsize', 8);
%% now find how much space the text takes up
ext = get(th,'extent');

if (ext(1)+ext(3))>axW %% goes off axes right
   if (ext(1)-ext(3))<0 %% will go off left if we right-align text
      Tpos = get(th,'position');
      set(th,'position',[0, Tpos(2)]);
   else
      set(th,'horiz','right');
   end
end

if (ext(2)+ext(4))>axH %% goes off axes top
   if (ext(2)-ext(4))<0 %% goes off bottom
      Tpos = get(th,'position');
      set(th,'position',[Tpos(1),0]);
   else
      set(th,'vert','top');
   end
end

%% revert to original units
set(ax,'units',oldUnits);
set(th,'units','data');
ex=get(th,'Extent');
set(ph,...
    'XData', [ex(1), ex(1), ex(1)+ex(3), ex(1)+ex(3)],...
    'YData', [ex(2), ex(2)+ex(4), ex(2)+ex(4), ex(2)],...
    'ZData', repmat( 2.0, [1,4] ) );

oldUpFcn = get(gcbf ,'WindowButtonUpFcn');
set(gcbf, 'WindowButtonUpFcn', ...
    { @i_killtextpatch, ph, th, xmode, ymode, oldUpFcn } );
set([th,ph],'visible','on');

return

%---------------------------------|--------------------------------------------|
function i_killtextpatch(hFig, null, ph, th, xmode, ymode, oldUpFcn)
% Remove text and patch
% taken from mbcmodels/validate_rstool

set(get(ph,'parent'),'xlimmode',xmode,'ylimmode',ymode)
set(gcbf ,'WindowButtonUpFcn',oldUpFcn);
delete(ph);
delete(th);

return

%---------------------------------|--------------------------------------------|
% Enable/disable functions
function o__________________ENABLES
%---------------------------------|--------------------------------------------|
function i_enablemenus( proot, psbar, pview, pmenus )
% also performs the enable for the Toolbar
% changes the view where necessary

sMenus = pmenus.info;
sToolbar = sMenus.Toolbar;
mnuHndls = [...      
        sMenus.File.New;...
        sMenus.File.Settings;...
        sMenus.View.CheckConstraints;...
        sMenus.Edit.Copy;...
        sMenus.Edit.Delete;...
        sMenus.Edit.SetBest;...
        sMenus.Edit.AddBest;...
        sMenus.Edit.RemoveBest;...
        sMenus.View.View2d;...
        sMenus.View.View3d;...
        sMenus.View.ViewPairwise;...
    ];
tbHndls = [...
        sToolbar.NewModel;...
        sToolbar.DeleteModel;...
        sToolbar.ModelSettings;...
        sToolbar.View2d;...
        sToolbar.View3d;...
        sToolbar.ViewPairwise;...
    ];
mnuEn = repmat({'off'}, 11,1);
tbEn = repmat({'off'}, 6,1);


cn = i_currentnode( pview );
if cn.isa( 'xregbdryroot' )
    mnuEn{1} = 'on';
    tbEn{1} = 'on';
else
    mnuEn{2} = 'on';
    mnuEn{3} = 'on';
    mnuEn{4} = 'on';
    tbEn{3} = 'on';
end

if ~( cn == proot )
    mnuEn{5} = 'on';
    mnuEn{6} = 'on';
    mnuEn{7} = 'on';
    mnuEn{8} = 'on';
    tbEn{2} = 'on';
end

factnum = i_currentfactors( proot, pview );
nf = numel( factnum );
if nf == 1,
    % Only the 1d view is available
    if get( pview.info.cards, 'CurrentCard' ) ~= 1, % 1d view
        i_view1d( [], [], proot, psbar, pview, pmenus );
    end
elseif nf == 2,
    % 3d view not allowed, pairwise is pointless
    if ~any( get( pview.info.cards, 'CurrentCard' ) == [1, 2] ), % 1d & 2d views
        i_view2d( [], [], proot, psbar, pview, pmenus );
    end
    mnuEn{9} = 'on';
    tbEn{4} = 'on';
else
    % all views allowed
    mnuEn{9} = 'on';
    mnuEn{11} = 'on';
    mnuEn{10} = 'on';
    tbEn{4} = 'on';
    tbEn{5} = 'on';
    tbEn{6} = 'on';
end
set(mnuHndls, {'enable'}, mnuEn);
set(tbHndls, {'enable'}, tbEn);

return

%---------------------------------|--------------------------------------------|
function i_enabletestselect( proot, psbar, pview, pmenus )

cn = i_currentnode( pview );
en = {'off';'off';'off'};
TS = pview.info.testselect;
if cn.istwostage,
    en{1} = 'on';
    mode = get(TS.radiogroup, 'Value' );
    if mode(2), % local view
        en{2} = 'on';
        en{3} = 'on';
    end
end
set( [TS.radiogroup; handle(TS.button); TS.clickedit], {'enable'}, en );
return

%---------------------------------|--------------------------------------------|
function i_enableintervals( proot, pview )
intervals = get( pview.info.intervals, 'elements' );

nf = nfactors( proot.getfriend) ;
factnum = i_currentfactors( proot, pview );
enable = false( 1, nf );
enable(factnum) = true;
if get( pview.info.cards, 'CurrentCard' ) == 4, % pairwise views
    enable(:) = false;
elseif get( pview.info.cards, 'CurrentCard' ) == 1, % 1d view
    % leave as is
else
    x_val = get( pview.info.factors.popXFactor, 'value' );
    y_val = get( pview.info.factors.popYFactor, 'value' );
    enable(factnum(x_val)) = false;
    enable(factnum(y_val)) = false;
    if get( pview.info.cards, 'CurrentCard' ) == 3, % 3d view
        z_val = get( pview.info.factors.popZFactor, 'value' );
        enable(factnum(z_val)) = false;
    end
end
for i = 1:nf,
    if enable(i),
        set( intervals{i}, 'enable', 'on' );
    else
        set( intervals{i}, 'enable', 'off' );
    end
end
return

%---------------------------------|--------------------------------------------|
function i_setfactors( proot, pview )
factnum = i_currentfactors( proot, pview );
symbols = get( proot.getfriend, 'symbols' );
symbols = symbols(factnum);
nf = length( factnum );

for popup = [ ...
            pview.info.factors.popXFactor, ...
            pview.info.factors.popYFactor, ...
            pview.info.factors.popZFactor ];
    val = get( popup, 'Value' );
    if val > nf,
        set( popup, 'Value', nf );
    end
    set( popup, 'String', symbols );
end
i_factorsel( ...
    pview.info.factors.popXFactor, ...
    pview.info.factors.popYFactor, ...
    pview.info.factors.popZFactor );

return

%---------------------------------|--------------------------------------------|
function i_enableboundarypoints(proot,psbar,pview,pmenus)
% can only highligh boundary points if there is a constraint model
bdev = i_currentnode( pview );
star = bdev.getconstraint;
view = pview.info;

if proot.getnumstages == 1,
    set( [ view.view1d.ud(1).rings{:}, ...
            view.view2d.rings2d, ...
            view.view3d.rings3d, ...
            view.viewpw.ud(1).rings{:}], ...
        'Visible', 'off' );
else, % if proot.getnumstages == 2,
    set( [ view.view1d.ud(1).rings{:}, ...
            view.view1d.ud(2).rings{:}, ...
            view.view1d.ud(3).rings{:}, ...
            view.view2d.rings2d, ...
            view.view3d.rings3d, ...
            view.viewpw.ud(1).rings{:}, ...
            view.viewpw.ud(2).rings{:}, ...
            view.viewpw.ud(3).rings{:}], ...
        'Visible', 'off' );
end
    
if isempty( star ) || bdev.isa( 'xregbdryroot' ),
    set( pmenus.info.Toolbar.BoundaryPoints, 'Enable', 'off' ); 
    set( pmenus.info.View.BoundaryPoints,    'Enable', 'off' ); 
else
    set( pmenus.info.Toolbar.BoundaryPoints, 'Enable', 'on' ); 
    set( pmenus.info.View.BoundaryPoints,    'Enable', 'on' ); 
    % set the rings visible as appropriate
    if strcmpi( get( pmenus.info.Toolbar.BoundaryPoints, 'State' ), 'on' ),
        switch get( view.cards, 'CurrentCard' ),
            case 1,
                card = get( view.view1d.cards, 'CurrentCard' );
                set( [view.view1d.ud(card).rings{:}], 'Visible', 'on' );
            case 2,
                set( view.view2d.rings2d, 'Visible', 'on' );
            case 3,
                set( view.view3d.rings3d, 'Visible', 'on' );
            case 4,
                card = get( view.viewpw.cards, 'CurrentCard' );
                set( [view.viewpw.ud(card).rings{:}], 'Visible', 'on' );
        end
    end
end

return

%---------------------------------|--------------------------------------------|
% Miscellaneous functions
function o____________MISCELLANEOUS
%---------------------------------|--------------------------------------------|
function p = i_currentnode( pview )
treeview = pview.info.treeview;
p = assign( xregpointer, treeview.SelectedItem.Tag );
return

%---------------------------------|--------------------------------------------|
function i_changecurrentnode( proot, psbar, pview, pmenus )
cn = i_currentnode( pview );
if cn ~= pview.info.currentnode,
    pview.info.currentnode = cn;
    i_setfactors( proot, pview );
    i_enabletestselect( proot, psbar, pview, pmenus )
    i_enableboundarypoints( proot, psbar, pview, pmenus );
    i_enableintervals( proot, pview );
    i_enablemenus( proot, psbar, pview, pmenus );
    i_infoupdate( proot, psbar, pview, pmenus );
    i_draw( proot, psbar, pview, pmenus );
end
return

%---------------------------------|--------------------------------------------|
function con = i_currentconstraint( pview )
% Get the constraint from the current node
bdev = i_currentnode( pview ); 
mode = get( pview.info.testselect.radiogroup, 'Value' );
if bdev.istwostage && mode(2),
    test = get( pview.info.testselect.clickedit.control, 'Value' );
    con = bdev.localconstraint( test );
else
    con = bdev.getconstraint;
end
return

%---------------------------------|--------------------------------------------|
function factnum = i_currentfactors( proot, pview )
% Indices of the input factors that are valid at the current node

friend = proot.getfriend;
bdev   = i_currentnode( pview );
data   = bdev.getdata;
nf     = size( data, 2 );

if bdev.istwostage,
    mode = get( pview.info.testselect.radiogroup, 'Value' );
    if mode(1), % global view
        % all factors in the list
        factnum = 1:nfactors( friend );
    else % if mode(2), % local view
        % if two-stage, then the current factors are the first nf
        factnum = 1:nlfactors(friend);
    end
else
    % otherwsie, it's the last nf
    factnum = ((1-nf):0) + nfactors( friend );
end
return

%---------------------------------|--------------------------------------------|
function stages = i_currentstagescard( proot, pview )
% Current number of stages for stage dependent card view
% 1- repsonse
% 2- local
% 3- global

bdev = i_currentnode( pview );
if bdev.istwostage,
    mode = get( pview.info.testselect.radiogroup, 'Value' );
    if mode(1), % response view
        stages = 1;
    else % if mode(2), % local view
        stages = bdev.getstages + 1;
    end
else
    stages = bdev.getstages + 1;
end

return

%---------------------------------|--------------------------------------------|
function symbols = i_currentsymbols( proot, pview )
% Symbols for the current node
friend  = proot.getfriend;
factnum = i_currentfactors( proot, pview );
symbols = get( friend, 'symbols' );
symbols = symbols(factnum);

return

%---------------------------------|--------------------------------------------|
function data = i_currentdata( proot, pview, docode )
% Data for the current node and view and in uncoded units

if nargin<3
    docode= true;
end

friend  = proot.getfriend;
factnum = i_currentfactors( proot, pview );
node    = i_currentnode( pview );

if node.istwostage,
    mode = get( pview.info.testselect.radiogroup, 'Value' );
    if mode(1), % global view
        % need the reponse data
        data = node.getdata( 'response', docode );
    else % if mode(2), % local view
        % two-stage local view ==> then extract test from data
        test = get( pview.info.testselect.clickedit.control, 'Value' );
        data    = node.getdata('local', docode);
        data = data{test};
    end
else
    data    = node.getdata([], docode);
end
return

%---------------------------------|--------------------------------------------|
function i_setinitial(ud)
% ud  all the 'ud' data for the window

root   = ud.root.info;
friend = getfriend( root );
intervals = get( ud.view.info.intervals, 'elements' );
factorsel = ud.view.info.factors;
view      = ud.view.info;
viewmenus = ud.menus.info.View;
toolbar = ud.menus.info.Toolbar;

nf = nfactors( friend );

% Set up the right test numbers for the test selector
if getnumstages( root ) == 2,
    data = getdata( root, 'Local' );
    ntests = size( data, 3 );
    set( view.testselect.clickedit.control, 'List', (1:ntests)', ...
        'Rule', 'list' );
end

% To work out the slice widths, we fake a plot and then look at the y-axis
% tick marks. 
[LB,UB] = range(friend);
mid     = (LB+UB)/2;

atmp = axes( 'parent', ud.Figure , 'visible', 'off');
for i = 1:nf,
    plot( [LB(i), UB(i)] ,'parent', atmp );
    ytk= get( atmp, 'ytick' );
    width = ytk(2) - ytk(1);
    set( intervals{i}, 'Value', mid(i) );
    set( intervals{i}, 'Tolerance', width );
    set( intervals{i}, 'Clickincrement', width/2 );
    set( intervals{i}, 'Min', LB(i) );
    set( intervals{i}, 'Max', UB(i) );
end
delete( atmp );

% deafult resolution is 30
set( factorsel.editResolution, 'value', 30 );

% intial view is 1d plot
set( view.cards, 'CurrentCard', 1 );

set( [viewmenus.View1d; viewmenus.View2d; viewmenus.View3d; viewmenus.ViewPairwise], ...
    {'Checked'}, {'on'; 'off'; 'off'; 'off'} );
set( [toolbar.View1d; toolbar.View2d; toolbar.View3d; toolbar.ViewPairwise], ...
    {'State'}, {'on'; 'off'; 'off'; 'off'});
set( [factorsel.lctrlYFactor; factorsel.lctrlXFactor; factorsel.lctrlZFactor], 'enable', 'off' );



i_setfactors(           ud.root, ud.view );
i_enabletestselect(     ud.root, ud.sbar, ud.view, ud.menus )
i_enableboundarypoints( ud.root, ud.sbar, ud.view, ud.menus );
i_enableintervals(      ud.root, ud.view );
i_enablemenus(          ud.root, ud.sbar, ud.view, ud.menus );
i_infoupdate(           ud.root, ud.sbar, ud.view, ud.menus );
i_draw(                 ud.root, ud.sbar, ud.view, ud.menus );

i_infoupdate( ud.root,ud.sbar,ud.view,ud.menus );

return


%---------------------------------|--------------------------------------------|
function H=i_lookforhandle
H=findobj(allchild(0),'flat','tag',i_hash_fig_tag);
return


%---------------------------------|--------------------------------------------|
%  Statusbar interface
function o_______________STATUS_BAR  
%---------------------------------|--------------------------------------------|
function newid=i_addmessage(psbar,msg)
% add a message to the statusbar queue
ud = psbar.info;
newid = ud.panel.addMessage(msg);
return

function i_deletemessage(psbar,id)
% remove a message from the statusbar queue
if ~isempty(id)
    ud=psbar.info;
    ud.panel.removeMessage(id);
end

function i_clearsbar(psbar)
ud=psbar.info;
ud.panel.clearMessage;
ud.panel.addMessage('Ready');
psbar.info=ud;


%---------------------------------|--------------------------------------------|
% Functions to set mouse pointer
function o____________MOUSE_POINTER
%---------------------------------|--------------------------------------------|
function ID=i_setpointer(psbar,tp)
ud=psbar.info;
ID=ud.pointer.stackSetPointer(ud.Figure,tp);
return

%---------------------------------|--------------------------------------------|
function i_deletepointer(psbar,ID)
ud=psbar.info;
ud.pointer.stackRemovePointer(ud.Figure,ID);
return

%---------------------------------|--------------------------------------------|
function i_clearpointers(psbar)
ud=psbar.info;
ud.pointer.stackClearAndReset(ud.Figure);
return

%---------------------------------|--------------------------------------------|
% C style #define
function o______________HASH_DEFINE  
%---------------------------------|--------------------------------------------|

%---------------------------------|--------------------------------------------|
function s=i_hash_fig_tag
s = 'ConstraintModeling';
return

%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
