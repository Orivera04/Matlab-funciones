function varargout = mv_doeanalysis(action,varargin)
%MV_DOEANALYSIS Design Evaluation Tool
%
%  GUI switchyard function for creating and handling all calls to the DOE
%  Analysis gui.  Initialise with MV_DOEANALYSIS('create',p_tp) where p_tp
%  is a pointer to a testplan object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.2.5 $  $Date: 2004/04/04 03:27:17 $


switch(lower(action))
    case 'create'
        % Create doe gui window based on given x and model matrices.  Also requires a
        % given figure handle and a position vector for the gui
        h=i_create_gui(varargin{:});
        if nargout
            varargout{1}=h;
        end

    case 'radiosel'
        % handles a click on a radiobutton for matrix viewing
        % Just does the exclusivity setting, then goes into another
        % function for calcing new matrix, then into generic update
        % view function which splashes matrix onto table/graphical viewer
        i_radios(varargin{1});
    case 'display'
        % displays matrix in table/other selected view method
        % expects a matrix, row headings and column headings
        i_display_mat(varargin{1},varargin{2},varargin{3},varargin{4});
    case 'vw.precsn'
        % handles precision chooser window
        i_precision(varargin);
    case 'export'
        % handles export box items
        i_export(varargin{:});
    case 'close'
        % feign a closedown; make gui invisible
        if nargin>1
            % use given figure handle(s)
            figs = varargin{1};
        else
            figs = findall(0,'tag','DOEtool','visible','on');
        end
        set(figs,'visible','off');
    case 'delete'
        % closes gui
        if nargin>1
            % use given figure handle(s)
            figs=varargin{1};
        else
            figs=gcbf;
        end
        for n=1:length(figs)
            ud=get(figs(n),'userdata');
            ud.data.data=i_cleardataptrs(ud.data.data);
        end

        delete(figs);
    case 'resize'
        % Figure resize fcn
        i_resize;
    case 'filter'
        % Handle all calls to modal filter dialog
        i_filter(varargin{:});
    case 'modterms'
        % Function to handle term including/excluding in FX matrix
        i_modterms(varargin{:});
    case 'codex'
        % flicks x matrix between natural and coded units
        i_codex;
    case 'regstat'
        % flicks between regression statistics
        i_regstat;
    case 'detx'
        % flicks between different detx selections
        i_detx;
    case 'rawstat'
        % flicks between raw residual covariance and correlation
        i_rawstat;
    case 'desstat'
        % flicks between design matrix correlation and VIFs
        i_desstat;
    case 'hat'
        % flicks between full hat and leverage values
        i_hat;
    case 'colours'
        % handles all calls within colour selection subgui
        i_colours(varargin{:});
    case 'viewmatinfo'
        % Flicks additional info viewing on/off
        i_viewmatinfo(varargin{:});
    case 'animswitch'
        % switch flag for animations
        figh=gcbf;
        ud=get(figh,'userdata');
        ud.flags.animation=~ud.flags.animation;
        if ud.flags.animation
            st='on';
        else
            st='off';
        end
        set(ud.menus.options.anim,'checked',st);
        i_setanimoptions(ud);
        set(figh,'userdata',ud);
    case 'viewerchange'
        % change to a different view of design matrix
        i_viewerchange(varargin{:})
    case 'srcdata'
        % change source x data from design to experimental and vice versa
        i_srcdata(varargin{:});
    case 'cmap2d'
        % menu callback to alter 2D colourmap
        i_cmap('2d');
    case 'cmap3d'
        % menu callback to alter 3D colourmap
        i_cmap('3d');
    case 'cmap4d'
        % menu callback to alter 4D colourmap
        i_cmap('4d');
    case {'update','updatetp'}
        % update call for posting new data into a DOE tool
        i_updateDOE_tp(varargin{:});
    case 'updatedes'
        % update call for posting new data into a DOE tool
        i_updateDOE_des(varargin{:});
    case 'adddes'
        % update call for appending new designs to the DOE tool
        i_addtoDOE_des(varargin{:});
    case 'gen1d'
        % post general gui for option changes
        i_genopts('1d');
    case 'gen2d'
        % post general gui for option changes
        i_genopts('2d');
    case 'gen3d'
        % post general gui for option changes
        i_genopts('3d');
    case 'gen4d'
        % post general gui for option changes
        i_genopts('4d');
    case 'updatemodel'
        % hook for objects to push new model definition in through
        i_updatemodel(varargin{:});
    case 'modelred'
        % menu callback to reduce the model to largest fittable
        i_modelred;
    case 'saveprefs'
        % write out prefs matfile
        i_saveprefs(gcbf);
    case 'refresh'
        % refresh view - useful if using shared pointers
        i_refresh(varargin{:});
end

return






% ****************************  END SWITCHYARD SECTION  *******************






% ****************************  BEGIN CREATION FUNCTION  ******************







%========================================================================
%========================================================================
% i_create_gui......Put up the gui and initialise everything
%========================================================================
%========================================================================
function out = i_create_gui(p_tp)

% First check that there isn't a DOE tool already up and running
DOEs=mvf('DOEtool');

% need to test if there is a waitbar later - so if not this will be empty
wb=[];

if isempty(DOEs)
    % since this takes a while - give people a waitbar to look at
    wb = xregGui.waitdlg('title', 'Creating Design Evaluation Figure', 'parent', mvf);

    scrsz=get(0,'Screensize');

    % set size to be 2/3 of screen width, and 3/4 of height.  Center it

    pos(1)=round(scrsz(3)/6);
    pos(2)=round(scrsz(4)/8);
    pos(3)=640;
    pos(4)=560;

    figh=xregfigure('position',[pos(1) pos(2) 50 20],...
        'visible','off',...
        'name','Design Evaluation Tool - [Design]',...
        'Closerequestfcn',[mfilename '(''close'');'],...
        'pointer','watch',...
        'Interruptible','off',...
        'tag','DOEtool',...
        'handlevisibility','callback',...
        'renderer','zbuffer');
    figh.MinimumSize=[640 460];
    figh= double(figh);

    figcol=get(figh,'color');

    % Set up menu structure
    fl=uimenu(figh,'label','&File');
    % this callback ensures cell contents are updated before menu selections are made
    vw=uimenu(figh,'label','&View');
    ud.menus.data.handle=uimenu(figh,'label','&Design');
    opt=uimenu(figh,'label','&Options');

    uimenu(fl,'label','&Close',...
        'accelerator','W',...
        'callback',[mfilename '(''close'');']);

    ud.menus.view.numerical=uimenu(vw,'label','&Table',...
        'callback',[mfilename '(''viewerchange'',''num'');'],...
        'checked','on',...
        'interruptible','off',...
        'accelerator','T');
    ud.menus.view.mvgraph1d=uimenu(vw,'label','1D Graph',...
        'callback',[mfilename '(''viewerchange'',''1dg'');'],...
        'separator','on',...
        'interruptible','off');
    ud.menus.view.mvgraph2d=uimenu(vw,'label','2D Scatter',...
        'callback',[mfilename '(''viewerchange'',''2dg'');'],...
        'separator','on',...
        'interruptible','off');
    ud.menus.view.sparse2d=uimenu(vw,'label','2D Sparse',...
        'callback',[mfilename '(''viewerchange'',''2ds'');'],...
        'interruptible','off');
    ud.menus.view.image2d=uimenu(vw,'label','2D Image',...
        'callback',[mfilename '(''viewerchange'',''2di'');'],...
        'interruptible','off');
    ud.menus.view.scatter3d=uimenu(vw,'label','3D Scatter',...
        'callback',[mfilename '(''viewerchange'',''3dg'');'],...
        'separator','on',...
        'interruptible','off');
    ud.menus.view.mesh3d=uimenu(vw,'label','3D Mesh',...
        'callback',[mfilename '(''viewerchange'',''3dm'');'],...
        'interruptible','off');
    ud.menus.view.surf3d=uimenu(vw,'label','3D Surface',...
        'callback',[mfilename '(''viewerchange'',''3ds'');'],...
        'interruptible','off');
    ud.menus.view.scatter4d=uimenu(vw,'label','4D Scatter',...
        'callback',[mfilename '(''viewerchange'',''4dg'');'],...
        'separator','on',...
        'interruptible','off');
    ud.menus.view.mesh4d=uimenu(vw,'label','4D Mesh',...
        'callback',[mfilename '(''viewerchange'',''4dm'');'],...
        'interruptible','off');
    ud.menus.view.surf4d=uimenu(vw,'label','4D Surface',...
        'callback',[mfilename '(''viewerchange'',''4ds'');'],...
        'interruptible','off');
    ud.menus.view.matrixprops=uimenu(vw,'label','&Matrix Information',...
        'separator','on',...
        'callback',[mfilename '(''viewmatinfo'');'],...
        'accelerator','m',...
        'interruptible','off');

    opt_t=uimenu(opt,'label','&Table');
    uimenu(opt_t,'label','&Precision...',...
        'callback',[mfilename '(''vw.precsn'',''create'');']);
    uimenu(opt_t,'label','&Filters...',...
        'callback',[mfilename '(''filter'',''create'');']);
    uimenu(opt_t,'label','&Colors...',...
        'callback',[mfilename '(''colours'',''create'');']);
    opt_1d=uimenu(opt,'label','&1D Graph');
    uimenu(opt_1d,'label','&General...',...
        'callback',[mfilename '(''gen1d'');']);
    opt_2d=uimenu(opt,'label','&2D Graph');
    uimenu(opt_2d,'label','&General...',...
        'callback',[mfilename '(''gen2d'');']);
    uimenu(opt_2d,'label','Image &Colormap...',...
        'callback',[mfilename '(''cmap2d'');']);
    opt_3d=uimenu(opt,'label','&3D Graph');
    uimenu(opt_3d,'label','&General...',...
        'callback',[mfilename '(''gen3d'');']);
    uimenu(opt_3d,'label','3D Viewer &Colormap...',...
        'callback',[mfilename '(''cmap3d'');']);
    opt_4d=uimenu(opt,'label','&4D Graph');
    uimenu(opt_4d,'label','&General...',...
        'callback',[mfilename '(''gen4d'');']);
    uimenu(opt_4d,'label','4D Viewer &Colormap...',...
        'callback',[mfilename '(''cmap4d'');']);
    uimenu(opt,'label','&Save Current Preferences',...
        'callback',[mfilename '(''saveprefs'');']);
    ud.menus.options.anim=uimenu(opt,'label','Use &Animation',...
        'callback',[mfilename '(''animswitch'');'],...
        'checked','on',...
        'separator','on');

    % add Window menu
    xregwinlist(figh);

    % add help menu
    mv_helpmenu(figh,{'Design Evaluation Tool Help','xreg_designEval'});

    % Set up toolbar
    doeicons = [];
    xregresload('doeicons.mat');

    ud.toolbar.handle=uitoolbar('parent',figh);

    buttons.data.design=uipushtool(ud.toolbar.handle,...
        'cdata',doeicons(:,17:32,:),...
        'tag','design',...
        'clickedcallback',{@i_srcdata,figh,'cycle'},...
        'tooltip','Next Design');

    buttons.view.numerical=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,49:64,:),...
        'tag','table',...
        'clickedcallback',[mfilename '(''viewerchange'',''num'');'],...
        'tooltip','Table',...
        'state','on',...
        'separator','on',...
        'interruptible','off');
    buttons.view.mvgraph1d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,65:80,:),...
        'tag','mvgraph1d',...
        'clickedcallback',[mfilename '(''viewerchange'',''1dg'');'],...
        'tooltip','1D Graph',...
        'interruptible','off');
    buttons.view.mvgraph2d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,81:96,:),...
        'tag','mvgraph2d',...
        'clickedcallback',[mfilename '(''viewerchange'',''2dg'');'],...
        'tooltip','2D Scatter',...
        'interruptible','off');
    buttons.view.sparse2d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,97:112,:),...
        'tag','sparse2d',...
        'clickedcallback',[mfilename '(''viewerchange'',''2ds'');'],...
        'tooltip','2D Sparse',...
        'interruptible','off');
    buttons.view.image2d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,113:128,:),...
        'tag','image2d',...
        'clickedcallback',[mfilename '(''viewerchange'',''2di'');'],...
        'tooltip','2D Image',...
        'interruptible','off');
    buttons.view.scatter3d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,129:144,:),...
        'tag','scatter3d',...
        'clickedcallback',[mfilename '(''viewerchange'',''3dg'');'],...
        'tooltip','3D Scatter',...
        'interruptible','off');
    buttons.view.mesh3d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,145:160,:),...
        'tag','mesh3d',...
        'clickedcallback',[mfilename '(''viewerchange'',''3dm'');'],...
        'tooltip','3D Mesh',...
        'interruptible','off');
    buttons.view.surf3d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,161:176,:),...
        'tag','surf3d',...
        'clickedcallback',[mfilename '(''viewerchange'',''3ds'');'],...
        'tooltip','3D Surface',...
        'interruptible','off');
    buttons.view.scatter4d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,225:240,:),...
        'tag','scatter4d',...
        'clickedcallback',[mfilename '(''viewerchange'',''4dg'');'],...
        'tooltip','4D Scatter',...
        'interruptible','off');
    buttons.view.mesh4d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,241:256,:),...
        'tag','mesh4d',...
        'clickedcallback',[mfilename '(''viewerchange'',''4dm'');'],...
        'tooltip','4D Mesh',...
        'interruptible','off');
    buttons.view.surf4d=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,257:272,:),...
        'tag','surf4d',...
        'clickedcallback',[mfilename '(''viewerchange'',''4ds'');'],...
        'tooltip','4D Surface',...
        'interruptible','off');
    buttons.matinfo=uitoggletool(ud.toolbar.handle,...
        'cdata',doeicons(:,209:224,:),...
        'tag','matinfo',...
        'clickedcallback',[mfilename '(''viewmatinfo'');'],...
        'tooltip', 'Toggle Matrix Information',...
        'separator','on',...
        'interruptible','off');
    buttons.help=mv_helptoolbutton(ud.toolbar.handle,'xreg_designEval','tooltip','Design Evaluation Tool Help');
    ud.toolbar.buttons=buttons;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% Toolbars end, main window begins %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create the viewers and their data
    %----------------------------------------------------------------------
    ud.viewers.card=xregcardlayout(figh,'numcards',6,'packstatus','off');
    % Create a table object for matrix viewing
    ud.viewers.table=xregtable(figh,...
        'position',[0 0 150 100],...
        'zeroindex',[2 2],...
        'rows.spacing',0,...
        'cols.spacing',0,...
        'cells.defaultbackgroundcolor',[1 1 1],...
        'frame.hborder',[5 2],...
        'frame.vborder',[5 2],...
        'frame.boxcolor',[0 0 0],...
        'frame.box','on',...
        'cols.size',50,...
        'rows.size',16,...
        'defaultcelltype','uiemuedit0');
    attach(ud.viewers.card,ud.viewers.table,1);

    ud.viewers.mvgraph1d=[];
    ud.viewers.mvgraph2d=[];
    ud.viewers.mvgraph3d=[];
    ud.viewers.mvgraph4d=[];
    ud.viewers.termselect=[];

    ud.viewers.currentobject=ud.viewers.table;     % copy of current object
    ud.viewers.matrixview=0;                       % Indicator for current view on matrix
    ud.viewers.available(1,:)=[true false(1,11)];        % possible enable statuses
    ud.viewers.available(2,:)=[true true false(1,10)];        % for the viewer buttons
    ud.viewers.available(3,:)=[true false(1,3) true false(1,7)];
    ud.viewers.available(4,:)=[true true false false true false(1,7)];
    ud.viewers.available(5,:)=[true(1,11) false];
    ud.viewers.available(6,:)=[false(1,11) true];
    ud.viewers.opts.framecolor=get(ud.viewers.table,'frame.backgroundcolor');     % Some table options
    ud.viewers.opts.labelcolor=[0 0 0];
    ud.viewers.opts.cellbgcolor=[1 1 1];
    ud.viewers.opts.cellfgcolor=[0 0 0];

    %----------------------------------------------------------------------


    %  Create the Export section
    %----------------------------------------------------------------------
    ud.export.radios=xregGui.rbgroup(figh,'visible','off','nx',1,'ny',2,'value',[1; 0],...
        'string',{'Export to workspace';'Export to mat file...'});
    text1=uicontrol('style','text',...
        'string','Variable name:',...
        'horizontalalignment','left',...
        'parent',figh);
    ud.export.varname=uicontrol('style','edit',...
        'backgroundcolor',[1 1 1],...
        'horizontalalignment','left',...
        'string','Xc',...
        'parent',figh);
    button=uicontrol('style','pushbutton',...
        'position',[0 0 65 25],...
        'string','Export',...
        'callback',[mfilename '(''export'',gcbf);'],...
        'parent',figh,...
        'interruptible','off');

    flwbtm=xregflowlayout(figh,'orientation','RIGHT/TOP',...
        'border',[0 10 0 10],...
        'elements',{button});
    center=xreggridlayout(figh,...
        'dimension',[2 1],...
        'gapy',3,...
        'elements',{text1,ud.export.varname},...
        'rowratios',[.6 .4]);
    brd1=xregborderlayout(figh,'north',ud.export.radios,...
        'south',center,...
        'innerborder',[0 40 0 40]);
    brd2=xregborderlayout(figh,'north',brd1,...
        'south',flwbtm,...
        'innerborder',[0 45 0 85]);
    ud.export.frame=xregframetitlelayout(figh,...
        'title','Export',...
        'center',brd2,...
        'innerborder',[15 10 0 10]);
    %----------------------------------------------------------------------

    % Set up a statusbar
    %----------------------------------------------------------------------

    % update  waitbar
    wb.Waitbar.value = 0.1;

    mv_StatusBar('create',figh,[1 -3 pos(3) 15]);
    mv_StatusBar('progressvis',figh,'off');
    mv_StatusBar('message',figh,'Initialising...',0,'noredraw');
    %----------------------------------------------------------------------

    % Create a dof table and other info bits
    %----------------------------------------------------------------------
    u = zeros(12,1);
    for n=1:12
        u(n)=uicontrol('style','text',...
            'parent',figh,...
            'backgroundcolor',[1 1 1],...
            'visible','off');
    end
    set(u([1 7]),'fontweight','bold');
    set(u(2:6),'horizontalalignment','left');
    set(u,{'string'},{'Source';'Model';'Residual';'        Replication';'        Lack of fit';'Total';...
        'D.O.F.';'0';'0';'0';'0';'0'});
    ud.extrainfo.doftable=xreggridlayout(figh,'correctalg','on','dimension',[6 2],...
        'gapx',1,'gapy',1,'border',[4 4 4 4],'elements',num2cell(u));

    doftitle=uicontrol('style','text',...
        'parent',figh,...
        'visible','off',...
        'string','Degrees of Freedom Table',...
        'Fontweight','bold',...
        'horizontalalignment','center');
    currentinfo=uicontrol('style','text',...
        'parent',figh,...
        'visible','off',...
        'string','Current Matrix Information',...
        'Fontweight','bold',...
        'horizontalalignment','center');
    ud.extrainfo.ranktxt(1)=uicontrol('style','text',...
        'parent',figh,...
        'visible','off',...
        'string','Rank:',...
        'horizontalalignment','right');
    ud.extrainfo.ranktxt(2)=uicontrol('style','text',...
        'parent',figh,...
        'visible','off',...
        'string','0',...
        'horizontalalignment','left');
    ud.extrainfo.condtxt(1)=uicontrol('style','text',...
        'parent',figh,...
        'visible','off',...
        'string','Condition:',...
        'horizontalalignment','right');
    ud.extrainfo.condtxt(2)=uicontrol('style','text',...
        'parent',figh,...
        'visible','off',...
        'string','0',...
        'horizontalalignment','left');
    ud.extrainfo.userpane.text=axestext(figh,...
        'horizontalalignment','left',...
        'verticalalignment','top',...
        'visible','off',...
        'fontsize',get(figh,'defaultuicontrolfontsize'));

    divl=xregGui.dividerline(figh,'visible','off');

    frm=xregframetitlelayout(figh,'innerborder',[0 0 0 0],'center',ud.extrainfo.doftable);
    gr1=xreggridlayout(figh,'correctalg','on','dimension',[3 1],...
        'rowsizes',[20 103 -1],'border',[0 0 5 0],...
        'elements',{doftitle,frm,[]});
    gr2=xreggridlayout(figh,'correctalg','on','dimension',[2 2],...
        'border',[0 10 0 0],'gapx',5,...
        'elements',{ud.extrainfo.ranktxt(1),ud.extrainfo.condtxt(1),...
        ud.extrainfo.ranktxt(2),ud.extrainfo.condtxt(2)});
    gr3=xreggridlayout(figh,'correctalg','on','dimension',[3 1],...
        'rowsizes',[20 40 -1],'border',[5 0 0 0],...
        'elements',{currentinfo,gr2,ud.extrainfo.userpane.text});
    gr3a=xreggridlayout(figh,'correctalg','on','dimension',[1 3],'elements',{gr1,gr3,[]},...
        'border',[0 0 0 10],'colsizes',[190 230 -1]);

    gr4=xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
        'rowsizes',[2 -1],...
        'border',[0 0 0 10],...
        'elements',{divl,gr3a});
    ud.fx.curtains=xregcurtainfxlayout(figh,'visible','off','openoffset',-10,'closeoffset',10,...
        'center',gr4,'stepsize',5);
    ud.extrainfo.layout=xregcardlayout(figh,'numcards',2,'currentcard',2);
    attach(ud.extrainfo.layout,ud.fx.curtains,1);

    ud.viewers.split=xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
        'rowsizes',[-1 0],...
        'elements',{ud.viewers.card,ud.extrainfo.layout},...
        'border',[10 0 5 0]);
    ud.extrainfo.infogrid=gr3a;

    %----------------------------------------------------------------------

    % Create selector list
    %----------------------------------------------------------------------
    rows=12;
    % Create a table object for putting radiobuttons in.
    ud.matrixsel.listbox=texlistbox(figh,...
        'string',{...
        'Design matrix';...
        'Full FX matrix';...
        'Model terms';...
        'Z_2 matrix';...
        'Alias matrix';...
        'Z_{2.1} matrix';...
        'Regression matrix';...
        'Coefficient information';...
        'Standard error';...
        'Hat matrix';...
        '\midX''X\mid';...
        'Raw residual statistics'},...
        'cellheight',25,...
        'callback',[mfilename '(''radiosel'',gcbf);'],...
        'fontsize',10);
    % Correct packstatus after above
    set(ud.viewers.split,'packstatus','off');
    %----------------------------------------------------------------------
    % make controls
    uis=zeros(15,1);
    params=struct('parent',figh,'style','togglebutton','interruptible','off');
    for n=1:length(uis)
        uis(n)=uicontrol(params);
    end

    % Add extra controls that are associated with a specific matrix selection
    crd=xregcardlayout(figh,'numcards',rows+1,...
        'border',[0 10 0 10]);
    codex=uis(1:2);
    set(codex(1),...
        'string','Coded Units',...
        'callback',[mfilename '(''codex'');'],...
        'value',1,...
        'userdata',1,...
        'backgroundcolor',0.5*(1+figcol));
    set(codex(2),...
        'string','Natural Units',...
        'callback',[mfilename '(''codex'');'],...
        'value',0,...
        'userdata',2);

    ud.matrixsel.btns.design=codex;
    gr=xreggridlayout(figh,'correctalg','on','dimension',[3 2],...
        'elements',{codex(1),[],[],codex(2)});
    sfx=xregslidefxlayout(figh,'center',gr,'slidedirection','east');
    attach(crd,sfx,1);
    ud.fx.slidefx(1)={sfx};

    regstat=uis(3:8);
    set(regstat(1),...
        'string','Covariance',...
        'callback',[mfilename '(''regstat'');'],...
        'visible','off',...
        'value',1,...
        'userdata',1,...
        'backgroundcolor',0.5*(1+figcol));
    set(regstat(2),...
        'string','Correlation',...
        'callback',[mfilename '(''regstat'');'],...
        'visible','off',...
        'value',0,...
        'userdata',2);
    set(regstat(3),...
        'string','Partial VIFs',...
        'callback',[mfilename '(''regstat'');'],...
        'visible','off',...
        'value',0,...
        'userdata',3);
    set(regstat(4),...
        'string','Multiple VIFs',...
        'callback',[mfilename '(''regstat'');'],...
        'visible','off',...
        'value',0,...
        'userdata',4);
    set(regstat(5),...
        'string','2 Column Corr.',...
        'callback',[mfilename '(''regstat'');'],...
        'visible','off',...
        'value',0,...
        'userdata',5);
    set(regstat(6),...
        'string','Single Term VIFs',...
        'callback',[mfilename '(''regstat'');'],...
        'visible','off',...
        'value',0,...
        'userdata',6);

    ud.matrixsel.btns.regstat=regstat;
    gr=xreggridlayout(figh,'correctalg','on','dimension',[3 2],...
        'elements',num2cell(regstat([1 3 5 2 4 6])));
    sfx=xregslidefxlayout(figh,'visible','off','center',gr,'slidedirection','east');
    attach(crd,sfx,8);
    ud.fx.slidefx(2)={sfx};


    detx=uis(9:11);
    set(detx(1),...
        'string','|X''X|',...
        'callback',[mfilename '(''detx'');'],...
        'visible','off',...
        'value',1,...
        'userdata',1,...
        'backgroundcolor',0.5*(1+figcol));
    set(detx(2),...
        'string','log(|X''X|)',...
        'callback',[mfilename '(''detx'');'],...
        'visible','off',...
        'value',0,...
        'userdata',2);
    set(detx(3),...
        'string','|X''X|^(1/p)',...
        'callback',[mfilename '(''detx'');'],...
        'visible','off',...
        'value',0,...
        'userdata',3);

    ud.matrixsel.btns.detx=detx;
    gr=xreggridlayout(figh,'correctalg','on','dimension',[3 3],...
        'elements',{detx(1),[],[],detx(2),[],[],detx(3)});
    sfx=xregslidefxlayout(figh,'visible','off','center',gr,'slidedirection','east');
    attach(crd,sfx,11);
    ud.fx.slidefx(5)={sfx};

    rawstat=uis(12:13);
    set(rawstat(1),...
        'string','Covariance',...
        'callback',[mfilename '(''rawstat'');'],...
        'visible','off',...
        'value',1,...
        'userdata',1,...
        'backgroundcolor',0.5*(1+figcol));
    set(rawstat(2),...
        'string','Correlation',...
        'callback',[mfilename '(''rawstat'');'],...
        'visible','off',...
        'value',0,...
        'userdata',2);

    ud.matrixsel.btns.rawstat=rawstat;
    gr=xreggridlayout(figh,'correctalg','on','dimension',[3 2],...
        'elements',{rawstat(1),[],[],rawstat(2)});
    sfx=xregslidefxlayout(figh,'visible','off','center',gr,'slidedirection','east');
    attach(crd,sfx,12);
    ud.fx.slidefx(4)={sfx};

    hat=uis(14:15);
    set(hat(1),...
        'string','Full Hat matrix',...
        'callback',[mfilename '(''hat'');'],...
        'visible','off',...
        'value',0,...
        'userdata',1);
    set(hat(2),...
        'string','Leverage values',...
        'callback',[mfilename '(''hat'');'],...
        'visible','off',...
        'value',1,...
        'userdata',2,...
        'backgroundcolor',0.5*(1+figcol));

    ud.matrixsel.btns.hat=hat;
    gr=xreggridlayout(figh,'correctalg','on','dimension',[3 2],...
        'elements',{hat(1),[],[],hat(2)});
    sfx=xregslidefxlayout(figh,'visible','off','center',gr,'slidedirection','east');
    attach(crd,sfx,10);
    ud.fx.slidefx(3)={sfx};

    ud.matrixsel.btns.current='design';
    ud.matrixsel.card=crd;
    % ---------------------------------------------------------------------
    % update  waitbar
    wb.Waitbar.value = 0.4;

    % assemble right-hand pane
    grd=xreggridlayout(figh,'correctalg','on',...
        'dimension',[3 1],...
        'elements',{ud.matrixsel.listbox,crd,ud.export.frame},...
        'rowsizes',[-1 95 150],'border',[5 0 10 0]);
    spl=xreggridlayout(figh,'correctalg','on',...
        'dimension',[1 2],...
        'colsizes',[-1 200],...
        'border',[0 10 0 10],...
        'elements',{ud.viewers.split,grd});

    div1=xregGui.dividerline(figh);
    div2=xregGui.dividerline(figh);

    biggrd=xreggridlayout(figh,'correctalg','on',...
        'dimension',[4 1],...
        'rowsizes',[2 -1 2 20],...
        'elements',{div1,spl,div2,[]},...
        'container',figh);
    set(biggrd,'visible','on');

    ud.flags=struct('codeview',1,...    % Toggle flag for coded/natural units on Design Matrix
        'viewinfo',0,...                 % Toggle for additional info section
        'animation',1);                  % Toggle for using animations where they exist
    ud.figurelyt=biggrd;                % Main figure layout

    ud.data.data(1).x=[];           % list of pointers to design objects
    ud.data.data(1).mydata=[];      % flags indicating which pointers belong to this GUI and which are shared
    ud.data.currentdata=[];         % pointer into stack of data matrices

    % Set up default viewing prefs for each matrix
    ud.matprefs=i_setupmatprefs;
    ud.matprefs.current='design.coded';
    ud.figurepos=pos(:)';
    set(figh,'position',pos(:)','userdata',ud);
    set(biggrd,'packstatus','on');
    CreatePackGroup(biggrd,'DOEAnalysisGUI');

    DOEs(1)=figh;
    % update  waitbar
    wb.Waitbar.value = 0.6;
end

set(DOEs(1),'visible','on');
out=DOEs(1);
% decide which update to call
if isa(p_tp,'xregdesign') || iscell(p_tp)
    i_updateDOE_des(DOEs(1),p_tp);
elseif isa(p_tp,'xregpointer')
    if p_tp.isa('modeldev');
        i_updateDOE_tp(DOEs(1),p_tp);
    elseif p_tp.isa('xregdesign')
        i_updateDOE_des(DOEs(1),p_tp);
    end
end

if ~isempty(wb)
    % update  waitbar
    wb.Waitbar.value = 1;
    delete(wb);
end


set(DOEs(1),'resizefcn',[mfilename '(''resize'');']);
% Reset pointer to arrow
set(DOEs(1),'pointer','arrow');
mv_StatusBar('message',DOEs(1),i_statusstr(DOEs(1)),0,'noredraw');


% ****************************  END CREATION FUNCTION  ******************************



% **************************  BEGIN MAIN GUI CALLBACKS  *******************************
%
%
%  This section deals with callbacks from the main gui window: the matrix selection table
%   and associated buttons, and the export section.
%
%


%========================================================================
%========================================================================
% i_radios......mutually exclusive radiobuttons and actions
%========================================================================
%========================================================================

function i_radios(figh)

if ~nargin
    figh=gcbf;
end
ud=get(figh,'userdata');

rdtbl=ud.matrixsel.listbox;
val=get(rdtbl,'value');

exportnames={'','FX','m','Z2','A','Z21','FX2','','STDERR','','',''};
% set a new name in export field
if (val)==1
    if ud.flags.codeview
        nm='Xc';
    else
        nm='Xn';
    end
elseif (val)==8
    if get(ud.matrixsel.btns.regstat(1),'value')
        nm='COV';
    elseif get(ud.matrixsel.btns.regstat(2),'value')
        nm='CORR';
    elseif get(ud.matrixsel.btns.regstat(3),'value')
        nm='PVIF';
    elseif get(ud.matrixsel.btns.regstat(4),'value')
        nm='MVIF';
    elseif get(ud.matrixsel.btns.regstat(5),'value')
        nm='COL_CORR';
    elseif  get(ud.matrixsel.btns.regstat(6),'value')
        nm='SVIF';
    end
elseif (val)==10
    if get(ud.matrixsel.btns.hat(1),'value')
        nm='HAT';
    else
        nm='LEVERAGE';
    end
elseif (val)==11
    if get(ud.matrixsel.btns.detx(1),'value')
        nm='DET_XTX';
    elseif get(ud.matrixsel.btns.detx(2),'value')
        nm='LOG_DET_XTX';
    else
        nm='DET_XTX_1P';
    end
elseif(val)==12
    if get(ud.matrixsel.btns.rawstat(1),'value')
        nm='RAW_COV';
    else
        nm='RAW_CORR';
    end
else
    nm=exportnames{val};
end
set(ud.export.varname,'string',nm);

% check data
[ud.data.data,ud.data.currentdata,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if alert
    return
end
% perform viewing operation
i_updatetbl(figh,'');

return




%========================================================================
%========================================================================
% i_export - handle calls to export section of window
%========================================================================
%========================================================================

function i_export(figh)

ud=get(figh,'userdata');
val=get(ud.export.radios,'value');
varname=get(ud.export.varname,'string');
if ~isvarname(varname);
    errordlg([varname ' is not a valid MATLAB variable name.'],'Export Error','modal');
    return
end

% check data
[ud.data.data,ud.data.currentdata,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if alert
    return
end

if strcmp(class(ud.viewers.currentobject),'term_selector')
    data=ud.data.data(ud.data.currentdata).x.model;
else
    % need to get data from current object
    data=get(ud.viewers.currentobject,'value');
end

switch find(val)
    case 1
        % To workspace
        assignin('base',varname,data);
        % Let user know something has happened
        disp(['Matrix ''' varname ''' successfully exported']);

    case 2
        % To file
        [file,path]=uiputfile('out.mat','Select file');
        if ~file
            return
        end
        eval([varname '=data;']);
        try
            save([path file],varname);
        catch
            h = errordlg(['File not saved: ' lasterr],'Save Error', 'modal');
            waitfor(h)
        end
end
return




%========================================================================
%========================================================================
% i_resize - redraws gui due to a user resize operation
%========================================================================
%========================================================================

function i_resize

% Note that resizing breaks when the user makes the window too small to contain
% the main table properly.  This could be fixed by making a smallest allowable size

figh=gcbf;
if strcmp(get(figh,'tag'),'NORESIZE')
    set(figh,'tag','i_resize');
    return
end

ud=get(figh,'userdata');
pos=get(figh,'position');
if all(pos(3:4)==ud.figurepos(3:4))
    %  no way.
    return
end

% Note the next section provides a means of stopping too small a gui
% This will need to be changed if I provide a means of altering
% column sizes!
resize=0;
if pos(3)<640
    pos(3)=640;
    resize=1;
end
if pos(4)<460
    pos(4)=460;
    resize=1;
end
if resize
    % first check this isn't outside visible screen area
    scrsize=get(0,'screensize');
    pos(1)=pos(1)-(pos(1)+pos(3)-scrsize(3)>0)*(pos(1)+pos(3)-scrsize(3));
    pos(2)=pos(2)-(pos(2)+pos(4)-scrsize(4)>-70)*(pos(2)+pos(4)-scrsize(4)+70);
    set(figh,'position',pos);
end


i_setanimoptions(ud,'off');

% repack main layout
repack(ud.figurelyt);

% move statusbar and line above it
mv_StatusBar('move',figh,[1 -3 pos(3) 15]);

% Make things visible again
i_setanimoptions(ud);
ud.figurepos=pos;
set(figh,'userdata',ud);
return



%========================================================================
%========================================================================
% i_codex - handles clicks on buttons for natural/coded units
%========================================================================
%========================================================================

function i_codex
%This is a callback function attached to the natural/coded togglebuttons
obj=gcbo;
figh=gcbf;
figcol=get(figh,'color');
set(figh,'pointer','watch');
num=get(obj,'userdata');
cstat=get(obj,'value');
if ~cstat
    % must have been already on
    set(obj,'value',1);
    set(figh,'pointer','arrow');
    return
end

ud=get(figh,'userdata');
mv_StatusBar('message',figh,'Calculating...');

if num==1
    func='';
    other=ud.matrixsel.btns.design(2);
    ud.flags.codeview=1;
    nm='Xc';
else
    func='invcode';
    other=ud.matrixsel.btns.design(1);
    ud.flags.codeview=0;
    nm='Xn';
end
ud.matprefs.current=i_matprefsname(1,num);

% Change Export default name
set(ud.export.varname,'string',nm);

set(other,'value',0,'backgroundcolor',figcol);
set(obj,'backgroundcolor',0.5*(1+figcol));
set(figh,'userdata',ud);

% check data
[ud.data.data,ud.data.currentdata,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if ~alert
    % Now need to convert current viewer matrix to coded/natural.
    obj=ud.viewers.currentobject;

    if ~isempty(ud.data.data(ud.data.currentdata).x.factorsettings)
        if ~isempty(func)
            x=feval(func,ud.data.data(ud.data.currentdata).x.model,...
                ud.data.data(ud.data.currentdata).x.factorsettings);
        else
            x=ud.data.data(ud.data.currentdata).x.factorsettings;
        end
        mv_StatusBar('message',figh,'Updating display...');
        set(obj,'value',x);
    else
        x=[];
    end

    i_updateinfo(figh,x,i_getfield(ud.matprefs,[ud.matprefs.current '.infostring']));
    set(figh,'pointer','arrow');
    mv_StatusBar('message',figh,i_statusstr(figh));
else
    set(figh,'pointer','arrow');
end

return



%========================================================================
%========================================================================
% i_regstat - handles clicks on togglebuttons for regression statistics matrices
%========================================================================
%========================================================================

function i_regstat
obj=gcbo;
figh=gcbf;
figcol=get(figh,'color');
num=get(obj,'userdata');
val=get(obj,'value');
if ~val
    % Not allowed to deselect!
    set(obj,'value',1);
    return
end
set(figh,'pointer','watch');
ud=get(figh,'userdata');
tbl=ud.viewers.table;

ind=setxor([1 2 3 4 5 6],num);

% get the button number we've come from
vals=get(ud.matrixsel.btns.regstat(ind),'value');
fromval=ind(find(cat(1,vals{:})));

% sort out buttons
set(obj,'backgroundcolor',0.5*(1+figcol));
set(ud.matrixsel.btns.regstat(ind),'value',0,'backgroundcolor',figcol);

ud.matprefs.current=i_matprefsname(8,num);

mv_StatusBar('message',figh,'Calculating...');

[ud.data.data,ud.data.currentdata,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if ~alert
    [x,rh,ch]=i_calcmatrix(ud.data.data(ud.data.currentdata).x.model,...
        ud.data.data(ud.data.currentdata).x.factorsettings,8,num);
    [rowsz, colsz, celltp, killdiag, extra]=i_matdispopts(0,8,num);
end

mv_StatusBar('message',figh,'Updating display...');
upd=1;
switch num
    case 1
        if (fromval==2) && ud.viewers.matrixview==0
            upd=0;
        end
        str='COV';
    case 2
        if (fromval==1) && ud.viewers.matrixview==0
            upd=0;
        end
        str='CORR';
    case 3
        if (fromval==6) && ud.viewers.matrixview==0
            upd=0;
        end
        str='PVIF';
    case 4
        str='MVIF';
    case 5
        str='COL_CORR';
    case 6
        if (fromval==3) && ud.viewers.matrixview==0
            upd=0;
        end
        str='SVIF';
end

set(ud.export.varname,'string',str);
if ~alert
    if upd==0
        tbl(:,:).value=x;
        % install colormap and filter preferences
        prefs=i_getfield(ud.matprefs,ud.matprefs.current);
        set(tbl,'colormap',prefs.colormap,...
            'colorintervals',prefs.colorintervals,...
            'usecolors',prefs.usecolormap,...
            'filters.type',prefs.filtertype,...
            'filters.value',prefs.filtervalue,...
            'filters.tolerance',prefs.filtertol,...
            'defaultcellformat',prefs.formatstr);
    else
        set(figh,'userdata',ud);
        i_display_mat(figh,x,rh,ch,[],[],[],killdiag,[]);
    end
    i_updateinfo(figh,x,i_getfield(ud.matprefs,[ud.matprefs.current '.infostring']));
end
set(figh,'pointer','arrow','userdata',ud);
mv_StatusBar('message',figh,i_statusstr(figh));
return




%========================================================================
%========================================================================
% i_detx - switch between 3 detx buttons
%========================================================================
%========================================================================

function i_detx

obj=gcbo;
figh=gcbf;
figcol=get(figh,'color');
num=get(obj,'userdata');
val=get(obj,'value');
if ~val
    % Not allowed to deselect!
    set(obj,'value',1);
    return
end

ud=get(figh,'userdata');
tbl=ud.viewers.table;

ind=setxor([1 2 3],num);

% sort out buttons
set(obj,'backgroundcolor',0.5*(1+figcol));
set(ud.matrixsel.btns.detx(ind),'value',0,'backgroundcolor',figcol);

ud.matprefs.current=i_matprefsname(11,num);

mv_StatusBar('message',figh,'Calculating...');

[ud.data.data,ud.data.currentdata,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if ~alert
    x = i_calcmatrix(ud.data.data(ud.data.currentdata).x.model,...
        ud.data.data(ud.data.currentdata).x.factorsettings,11,num);
end
mv_StatusBar('message',figh,'Updating display...');

% update export string
switch num
    case 1
        str='DET_XTX';
    case 2
        str='LOG_DET_XTX';
    case 3
        str='DET_XTX_1P';
end
set(ud.export.varname,'string',str);
if ~alert
    % update viewing object
    switch ud.viewers.matrixview
        case 0
            tbl(:,:)=x;
        case 1
            set(ud.viewers.mvgraph1d,'data',x,'factors',[]);
        case {2,3,4}
            set(ud.viewers.mvgraph2d,'data',x,'factors',[]);
        case {5,6,7}
            set(ud.viewers.mvgraph3d,'data',x,'factors',[]);
        case {8,9,10}
            set(ud.viewers.mvgraph4d,'data',x,'factors',[]);
    end

    i_updateinfo(figh,x,i_getfield(ud.matprefs,[ud.matprefs.current '.infostring']));
end
set(figh,'pointer','arrow');
mv_StatusBar('message',figh,i_statusstr(figh));
return



%========================================================================
%========================================================================
% i_rawstat - switch between raw residual statistics
%========================================================================
%========================================================================

function i_rawstat

obj=gcbo;
figh=gcbf;
figcol=get(figh,'color');
num=get(obj,'userdata');
val=get(obj,'value');
if ~val
    % Not allowed to deselect!
    set(obj,'value',1);
    return
end

ud=get(figh,'userdata');
tbl=ud.viewers.table;

ind=setxor([1 2],num);

% sort out buttons
set(obj,'backgroundcolor',0.5*(1+figcol));
set(ud.matrixsel.btns.rawstat(ind),'value',0,'backgroundcolor',figcol);

ud.matprefs.current=i_matprefsname(12,num);

mv_StatusBar('message',figh,'Calculating...');

[ud.data.data,ud.data.currentdata,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if ~alert
    x=i_calcmatrix(ud.data.data(ud.data.currentdata).x.model,...
        ud.data.data(ud.data.currentdata).x.factorsettings,12,num);
end
mv_StatusBar('message',figh,'Updating display...');

switch num
    case 1
        str='RAW_COV';
    case 2
        str='RAW_CORR';
end
set(ud.export.varname,'string',str);

if ~alert
    switch ud.viewers.matrixview
        case 0
            prefs=i_getfield(ud.matprefs,ud.matprefs.current);
            set(tbl,'colormap',prefs.colormap,...
                'colorintervals',prefs.colorintervals,...
                'usecolors',prefs.usecolormap,...
                'filters.type',prefs.filtertype,...
                'filters.value',prefs.filtervalue,...
                'filters.tolerance',prefs.filtertol,...
                'defaultcellformat',prefs.formatstr,...
                'cells.value',x);
        case 1
            set(ud.viewers.mvgraph1d,'data',x,'factors',mbcordinalstring(size(x,2)));
        case {2,3,4}
            set(ud.viewers.mvgraph2d,'data',x,'factors',{mbcordinalstring(size(x,2)),mbcordinalstring(size(x,2))});
        case {5,6,7}
            set(ud.viewers.mvgraph3d,'data',x,'factors',mbcordinalstring(size(x,2)));
        case {8,9,10}
            set(ud.viewers.mvgraph4d,'data',x,'factors',mbcordinalstring(size(x,2)));
    end

    i_updateinfo(figh,x,i_getfield(ud.matprefs,[ud.matprefs.current '.infostring']));
end
set(figh,'pointer','arrow','userdata',ud);
mv_StatusBar('message',figh,i_statusstr(figh));
return



%========================================================================
%========================================================================
% i_hat - switch between hat matrix and leverage
%========================================================================
%========================================================================

function i_hat

obj=gcbo;
figh=gcbf;
figcol=get(figh,'color');
num=get(obj,'userdata');
val=get(obj,'value');
if ~val
    % Not allowed to deselect!
    set(obj,'value',1);
    return
end
set(figh,'pointer','watch');
ud=get(figh,'userdata');
tbl=ud.viewers.table;

ind=setxor([1 2],num);

% sort out buttons
set(obj,'backgroundcolor',0.5*(1+figcol));
set(ud.matrixsel.btns.hat(ind),'value',0,'backgroundcolor',figcol);

ud.matprefs.current=i_matprefsname(10,num);

mv_StatusBar('message',figh,'Calculating...');

[ud.data.data,ud.data.currentdata,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if ~alert
    [x,rh,ch]=i_calcmatrix(ud.data.data(ud.data.currentdata).x.model,...
        ud.data.data(ud.data.currentdata).x.factorsettings,10,num);
    [rowsz, colsz, celltp, killdiag, extra]=i_matdispopts(0,10,num);
end
mv_StatusBar('message',figh,'Updating display...');
switch num
    case 1
        str='HAT';
    case 2
        str='LEVERAGE';
end
set(ud.export.varname,'string',str);
if ~alert
    switch ud.viewers.matrixview
        case 0
            i_display_mat(figh,x,rh,ch,[],[],[],[],[]);

            if killdiag==1
                % Take out top half of matrix for hat
                msk=(triu(ones(size(x,1)),1)~=0);
                tbl(msk).visible='off';
            end

            prefs=i_getfield(ud.matprefs,ud.matprefs.current);
            set(tbl,'colormap',prefs.colormap,...
                'colorintervals',prefs.colorintervals,...
                'usecolors',prefs.usecolormap,...
                'filters.type',prefs.filtertype,...
                'filters.value',prefs.filtervalue,...
                'filters.tolerance',prefs.filtertol,...
                'defaultcellformat',prefs.formatstr);
        case 1
            set(ud.viewers.mvgraph1d,'data',x,'factors',ch);
        case {2,3,4}
            set(ud.viewers.mvgraph2d,'data',x,'factors',{ch,rh});
        case {5,6,7}
            set(ud.viewers.mvgraph3d,'data',x,'factors',ch);
        case {8,9,10}
            set(ud.viewers.mvgraph4d,'data',x,'factors',ch);
    end

    i_updateinfo(figh,x,i_getfield(ud.matprefs,[ud.matprefs.current '.infostring']));
end
set(figh,'pointer','arrow','userdata',ud);
mv_StatusBar('message',figh,i_statusstr(figh));
return







% **********************  END MAIN GUI CALLBACKS *********************************










% **********************  BEGIN MENU CALLBACKS  **********************************
%
%
%  This section inculudes all the callbacks triggered from the menubar and the
%   toolbar (most of these actually link into menu callbacks)
%
%



%========================================================================
%========================================================================
% i_srcdata - changes data source from design to experimental
%========================================================================
%========================================================================

function i_srcdata(src,evt,figh,opt)
ud=get(figh,'userdata');
obj=src;
objud=get(obj,'userdata');
if nargin>3
    switch lower(opt)
        case 'cycle'
            % toolbar button now cycles through list of available data
            max=length(ud.data.data);
            objud=ud.data.currentdata+1;
            if objud>max
                objud=1;
            end
    end
end

% check to see the selected one isn't already valid
if objud==ud.data.currentdata
    return
else
    % check data asked for is valid - should the option be there if it isn't?
    [ud.data.data,objud,alert]=i_checkdata(ud.data.data,objud,figh);
    if alert
        % no good data
        return
    end
    if strcmp(ud.data.data(objud).x.optimisetype,'experimental data') ...
            && isempty(ud.data.data(objud).x.factorsettings)
        % no data
        errordlg(['The experimental data has not yet been matched to the design.',...
            '  You must perform this step before viewing the experimental data.'],...
            'Function not available','modal');
        % go back to previous setting
    else
        % update checked view on menu
        st=cell(length(ud.data.data),1);
        st(:)={'off'};
        st(objud)={'on'};
        set(ud.menus.data.opts(:),{'checked'},st);
        % reset stored data in model
        ud.data.currentdata=objud;
        % update figure title
        set(figh,'name',['Design Evaluation Tool - [' ud.data.data(ud.data.currentdata).x.name ']']);
        set(figh,'userdata',ud);

        % do a rank check on new regression matrix
        ok=ud.data.data(ud.data.currentdata).x.rankcheck;
        if ~ok
            en='off';
        else
            en='on';
        end
        i_setmatrixoptions(ud.matrixsel.listbox,en);
        % if current selection is not allowed, revert to design matrix?
        selval=get(ud.matrixsel.listbox,'value');
        if (selval>=8 ||  selval==6) && ~ok
            set(ud.matrixsel.listbox,'value',1);
            if ud.flags.codeview
                nm='Xc';
            else
                nm='Xn';
            end
            set(ud.export.varname,'string',nm);
            i_updateinfo(figh);
        end

        % perform viewing operation
        i_updatetbl(figh,'nobtns');
        i_updatedoftbl(figh);


    end
end

return





%========================================================================
%========================================================================
% i_viewerchange - change viewtype for matrix
%========================================================================
%========================================================================

function i_viewerchange(sel)
figh=gcbf;

ud=get(figh,'userdata');
switch lower(sel)
    case 'num'
        selval=0;
        newfield='numerical';
        newmnufield='numerical';
    case '1dg'
        selval=1;
        newfield='mvgraph1d';
        newmnufield='mvgraph1d';
    case '2dg'
        selval=2;
        newfield='mvgraph2d';
        newmnufield='mvgraph2d';
        tp='graph';
    case '2ds'
        selval=3;
        newfield='mvgraph2d';
        newmnufield='sparse2d';
        tp='sparse';
    case '2di'
        selval=4;
        newfield='mvgraph2d';
        newmnufield='image2d';
        tp='image';
    case '3dg'
        selval=5;
        newfield='mvgraph3d';
        newmnufield='scatter3d';
        tp='scatter';
    case '3dm'
        selval=6;
        newfield='mvgraph3d';
        newmnufield='mesh3d';
        tp='mesh';
    case '3ds'
        selval=7;
        newfield='mvgraph3d';
        newmnufield='surf3d';
        tp='surface';
    case '4dg'
        selval=8;
        newfield='mvgraph4d';
        newmnufield='scatter4d';
        tp='scatter';
    case '4dm'
        selval=9;
        newfield='mvgraph4d';
        newmnufield='mesh4d';
        tp='mesh';
    case '4ds'
        selval=10;
        newfield='mvgraph4d';
        newmnufield='surf4d';
        tp='surface';
end

if ud.viewers.matrixview==selval
    % Just ensure button is still depressed
    newh=i_getfield(ud.toolbar.buttons.view,newmnufield);
    set(newh,'state','on');
    return
end

switch ud.viewers.matrixview
    case 0
        oldfield='numerical';
        oldmnufield='numerical';
    case 1
        oldfield='mvgraph1d';
        oldmnufield='mvgraph1d';
    case 2
        oldfield='mvgraph2d';
        oldmnufield='mvgraph2d';
    case 3
        oldfield='mvgraph2d';
        oldmnufield='sparse2d';
    case 4
        oldfield='mvgraph2d';
        oldmnufield='image2d';
    case 5
        oldfield='mvgraph3d';
        oldmnufield='scatter3d';
    case 6
        oldfield='mvgraph3d';
        oldmnufield='mesh3d';
    case 7
        oldfield='mvgraph3d';
        oldmnufield='surf3d';
    case 8
        oldfield='mvgraph4d';
        oldmnufield='scatter4d';
    case 9
        oldfield='mvgraph4d';
        oldmnufield='mesh4d';
    case 10
        oldfield='mvgraph4d';
        oldmnufield='surf4d';
end

if strcmp(newfield,'mvgraph2d') || ...
        strcmp(newfield,'mvgraph3d') || ...
        strcmp(newfield,'mvgraph4d')
    obj=i_getfield(ud.viewers,newfield);
    set(obj,'type',tp);
    oldh=i_getfield(ud.menus.view,oldmnufield);
    newh=i_getfield(ud.menus.view,newmnufield);
    set([oldh;newh],{'checked'},{'off';'on'});
    oldh=i_getfield(ud.toolbar.buttons.view,oldmnufield);
    newh=i_getfield(ud.toolbar.buttons.view,newmnufield);
    set([oldh;newh],{'state'},{'off';'on'});
    ud=get(figh,'userdata');
    ud.viewers.matrixview=selval;
    set(figh,'userdata',ud);
end

if ~strcmp(oldfield,newfield)
    % update checked view
    oldh=i_getfield(ud.menus.view,oldmnufield);
    newh=i_getfield(ud.menus.view,newmnufield);
    set([oldh;newh],{'checked'},{'off';'on'});
    oldh=i_getfield(ud.toolbar.buttons.view,oldmnufield);
    newh=i_getfield(ud.toolbar.buttons.view,newmnufield);
    set([oldh;newh],{'state'},{'off';'on'});
    ud=get(figh,'userdata');
    ud.viewers.matrixview=selval;

    ud=i_switchtoviewer(ud,selval,figh);
    set(figh,'userdata',ud);

    % check data
    [ud.data.data,ud.data.currentdata,alert]=...
        i_checkdata(ud.data.data,ud.data.currentdata,figh);
    if alert
        return
    end
    % perform viewing operation
    i_updatetbl(figh,'nobtns');
end

return




%========================================================================
%========================================================================
% i_viewmatinfo - change gui layout to show additional information
%========================================================================
%========================================================================

function i_viewmatinfo
figh=gcbf;
tg=get(figh,'tag');
set(figh,'tag','NORESIZE');
ud=get(figh,'userdata');
% update state of userdata immediately so other interrupting callbacks redraw
% correctly
ud.flags.viewinfo=~ud.flags.viewinfo;
set(figh,'userdata',ud);

%update information in info section
obj=ud.viewers.currentobject;
x=get(obj,'value');
i_updateinfo(figh,x,i_getfield(ud.matprefs,[ud.matprefs.current '.infostring']))

% decide if we're going to turn stuff on or off
if ~ud.flags.viewinfo
    % Need to turn stuff off
    set(ud.extrainfo.layout,'currentcard',2);
    set(ud.viewers.split,'rowsizes',[-1 0]);

    set(ud.menus.view.matrixprops,'checked','off');
    set(ud.toolbar.buttons.matinfo,'state','off');
else
    % Need to turn stuff on
    set(ud.viewers.split,'rowsizes',[-1 160]);
    set(ud.extrainfo.layout,'currentcard',1);

    set(ud.menus.view.matrixprops,'checked','on');
    set(ud.toolbar.buttons.matinfo,'state','on');
end

if ~strcmp(get(figh,'tag'),'NORESIZE')
    % something happened that tried to interrupt
    cmd=get(figh,'tag');
    feval(cmd);
end

set(figh,'tag',tg);

return




%========================================================================
%========================================================================
% i_modelred - reduce current model definition
%========================================================================
%========================================================================

function i_modelred(input)
figh=gcbf;
ud=get(figh,'userdata');
% check data validity
[ud.data.data,ind,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if alert
    return
end

% reduce model
mv_StatusBar('message',figh,'Reducing model definition...');
mdl=reducetofull(ud.data.data(ud.data.currentdata).x.model,...
    ud.data.data(ud.data.currentdata).x.factorsettings);
[mdl,ok]=InitStore2(mdl,ud.data.data(ud.data.currentdata).x.factorsettings);
ud.data.data(ud.data.currentdata).x.info=ud.data.data(ud.data.currentdata).x.model(mdl);

i_updatetbl(figh,'nobtns');
i_updatedoftbl(figh);
if ~ok
    en='off';
else
    en='on';
end
i_setmatrixoptions(ud.matrixsel.listbox,en);

mv_StatusBar('message',figh,'Ready');
return




%========================================================================
%========================================================================
% i_precision - handle calls to precision chooser window
%========================================================================
%========================================================================

function i_precision(input)
figh=gcbf;
ud=get(figh,'userdata');
tbl=ud.viewers.table;
fmt=tbl_formatgui(tbl);

if ischar(fmt)
    prefs=i_getfield(ud.matprefs,ud.matprefs.current);
    prefs.formatstr=fmt;
    ud.matprefs=i_setfield(ud.matprefs,ud.matprefs.current,prefs);
end
set(figh,'userdata',ud);

return




%========================================================================
%========================================================================
% i_filter - handles calls to do with the Filter GUI
%========================================================================
%========================================================================

function i_filter(action)
figh=gcbf;
ud=get(figh,'userdata');
tbl=ud.viewers.table;
% use table method for filter gui
filt=tbl_filtergui(tbl);

if isstruct(filt)
    % Now update current matrix prefs from new table settings
    prefs=i_getfield(ud.matprefs,ud.matprefs.current);
    prefs.filtertype=filt.type;
    prefs.filtervalue=filt.value;
    prefs.filtertol=filt.tolerance;
    ud.matprefs=i_setfield(ud.matprefs,ud.matprefs.current,prefs);
end
mv_StatusBar('message',figh,i_statusstr(figh));
set(figh,'userdata',ud);
return




%========================================================================
%========================================================================
% i_colours - handles all calls to the colour changing gui
%========================================================================
%========================================================================

function i_colours(action,varargin)

switch lower(action)
    case 'create'
        % get userdata
        figh=gcbf;
        ud=get(figh,'userdata');
        tbl=ud.viewers.table;
        % create figure window for altering precision

        scrsz=get(0,'screensize');
        cfig=figure('visible','off',...
            'position',[scrsz(3)/2-150 scrsz(4)/2-120 280 260],...
            'toolbar','none',...
            'menubar','none',...
            'numbertitle','off',...
            'name','Table Colors',...
            'units','pixels',...
            'resize','off',...
            'doublebuffer','on',...
            'color',get(0,'defaultuicontrolbackgroundcolor'));

        txt(1)=uicontrol('style','text',...
            'position',[0 0 100 15],...
            'string','Table background:',...
            'horizontalalignment','right',...
            'parent',cfig);
        txt(2)=uicontrol('style','text',...
            'position',[0 0 100 15],...
            'string','Label text:',...
            'horizontalalignment','right',...
            'parent',cfig);
        txt(3)=uicontrol('style','text',...
            'position',[0 0 100 15],...
            'string','Cell background:',...
            'horizontalalignment','right',...
            'parent',cfig);
        txt(4)=uicontrol('style','text',...
            'position',[0 0 100 15],...
            'string','Cell text:',...
            'horizontalalignment','right',...
            'parent',cfig);

        col(1)=uicontrol('style','edit',...
            'position',[0 0 75 20],...
            'string',['[' num2str(ud.viewers.opts.framecolor(1)) ' ',...
            num2str(ud.viewers.opts.framecolor(2)) ' ',...
            num2str(ud.viewers.opts.framecolor(3)) ']'],...
            'horizontalalignment','left',...
            'callback',[mfilename '(''colours'',''chcol'');'],...
            'backgroundcolor',[1 1 1],...
            'parent',cfig,...
            'tag','framecol');
        col(2)=uicontrol('style','edit',...
            'position',[0 0 75 20],...
            'string',['[' num2str(ud.viewers.opts.labelcolor(1)) ' ',...
            num2str(ud.viewers.opts.labelcolor(2)) ' ',...
            num2str(ud.viewers.opts.labelcolor(3)) ']'],...
            'horizontalalignment','left',...
            'callback',[mfilename '(''colours'',''chcol'');'],...
            'backgroundcolor',[1 1 1],...
            'parent',cfig,...
            'tag','labelcol');
        col(3)=uicontrol('style','edit',...
            'position',[0 0 75 20],...
            'string',['[' num2str(ud.viewers.opts.cellbgcolor(1)) ' ',...
            num2str(ud.viewers.opts.cellbgcolor(2)) ' ',...
            num2str(ud.viewers.opts.cellbgcolor(3)) ']'],...
            'horizontalalignment','left',...
            'callback',[mfilename '(''colours'',''chcol'');'],...
            'backgroundcolor',[1 1 1],...
            'parent',cfig,...
            'tag','cellbgcol');
        col(4)=uicontrol('style','edit',...
            'position',[0 0 75 20],...
            'string',['[' num2str(ud.viewers.opts.cellfgcolor(1)) ' ',...
            num2str(ud.viewers.opts.cellfgcolor(2)) ' ',...
            num2str(ud.viewers.opts.cellfgcolor(3)) ']'],...
            'horizontalalignment','left',...
            'callback',[mfilename '(''colours'',''chcol'');'],...
            'backgroundcolor',[1 1 1],...
            'parent',cfig,...
            'tag','cellfgcol');

        sw(1)=uicontrol('style','toggle',...
            'value',0,...
            'position',[0 0 30 20],...
            'backgroundcolor',ud.viewers.opts.framecolor,...
            'callback',[mfilename '(''colours'',''interactivechcol'');'],...
            'parent',cfig,...
            'tag','framecol');
        sw(2)=uicontrol('style','toggle',...
            'value',0,...
            'position',[0 0 30 20],...
            'backgroundcolor',ud.viewers.opts.labelcolor,...
            'callback',[mfilename '(''colours'',''interactivechcol'');'],...
            'parent',cfig,...
            'tag','labelcol');
        sw(3)=uicontrol('style','toggle',...
            'value',0,...
            'position',[0 0 30 20],...
            'backgroundcolor',ud.viewers.opts.cellbgcolor,...
            'callback',[mfilename '(''colours'',''interactivechcol'');'],...
            'parent',cfig,...
            'tag','cellbgcol');
        sw(4)=uicontrol('style','toggle',...
            'value',0,...
            'position',[0 0 30 20],...
            'backgroundcolor',ud.viewers.opts.cellfgcolor,...
            'callback',[mfilename '(''colours'',''interactivechcol'');'],...
            'parent',cfig,...
            'tag','cellfgcol');

        % Use a colormap option
        cm=uicontrol('style','checkbox',...
            'parent',cfig,...
            'string','Use a colormap for rendering matrix values',...
            'callback',[mfilename '(''colours'',''usecm'');']);
        cm(2)=uicontrol('style','pushbutton',...
            'parent',cfig,...
            'position',[0 0 105 25],...
            'string','Define Colormap...',...
            'callback',[mfilename '(''colours'',''cmapdef'',''create'');']);

        % build layouts
        flw1=xregflowlayout(cfig,'orientation','right/center','gap',5,...
            'border',[0 0 -5 0],'elements',{sw(1) col(1) txt(1)},'packstatus','off');
        flw2=xregflowlayout(cfig,'orientation','right/center','gap',5,...
            'border',[0 0 -5 0],'elements',{sw(2) col(2) txt(2)});
        flw3=xregflowlayout(cfig,'orientation','right/center','gap',5,...
            'border',[0 0 -5 0],'elements',{sw(3) col(3) txt(3)});
        flw4=xregflowlayout(cfig,'orientation','right/center','gap',5,...
            'border',[0 0 -5 0],'elements',{sw(4) col(4) txt(4)});
        flw5=xregflowlayout(cfig,'orientation','right/center',...
            'elements',{cm(2)});
        grd=xreggridlayout(cfig,'correctalg','on','dimension',[6 1],...
            'elements',{flw1 flw2 flw3 flw4 cm(1) flw5},...
            'rowratios',[2 2 2 2 2 2.5],'gap',10);
        frm=xregframetitlelayout(cfig,'center',grd,'title','colors','innerborder',[15 10 10 10]);

        % Check to see if a colourmap is defined for the table
        if strcmp(tbl.usecolors,'on')
            set(cm,'value',1)
            set([col(4);sw(4);txt(4)],'enable','off');
        else
            set(cm(2),'enable','off');
        end

        % OK and Cancel buttons
        cancbtn=uicontrol('style','pushbutton',...
            'position',[0 0 65 25],...
            'string','Cancel',...
            'callback','closereq',...
            'parent',cfig);
        okbtn=uicontrol('style','pushbutton',...
            'position',[0 0 65 25],...
            'string','OK',...
            'callback',[mfilename '(''colours'',''colours'');'],...
            'parent',cfig);

        flw=xregflowlayout(cfig,'orientation','right/center','gap',7,'border',[0 0 -7 0],...
            'elements',{cancbtn okbtn});
        lyt=xregborderlayout(cfig,'center',frm,'south',flw,'innerborder',[10 45 10 10],...
            'container',cfig,'packstatus','on');

        colud.table=tbl;
        colud.coledit=col;
        colud.colsw=sw;
        colud.parent=figh;
        colud.colmap=cm;
        colud.coltxt=txt;
        colud.map=tbl.colormap;
        colud.ints=tbl.colorintervals;
        set(cfig,'userdata',colud,'visible','on');


    case 'chcol'
        obj=gcbo;
        figh=gcbf;
        ud=get(figh,'userdata');
        objtag=get(obj,'tag');
        switch lower(objtag)
            case 'framecol'
                ind=1;
            case 'labelcol'
                ind=2;
            case 'cellbgcol'
                ind=3;
            case 'cellfgcol'
                ind=4;
        end
        str=get(obj,'string');

        num=str2num(str);

        if length(num)~=3
            color=get(ud.colsw(ind),'backgroundcolor');
            set(obj,'string',['[' num2str(color(1)) ' ',...
                num2str(color(2)) ' ' num2str(color(3)) ']']);
            return
        else
            set(ud.colsw(ind),'backgroundcolor',num);
        end

    case 'interactivechcol'
        % Called when a toggle button is clicked
        obj=gcbo;
        figh=gcbf;
        ud=get(figh,'userdata');
        objtag=get(obj,'tag');
        switch lower(objtag)
            case 'framecol'
                ind=1;
            case 'labelcol'
                ind=2;
            case 'cellbgcol'
                ind=3;
            case 'cellfgcol'
                ind=4;
        end

        colnow=get(obj,'backgroundcolor');
        newcol=uisetcolor(colnow);
        set(obj,'backgroundcolor',newcol,'value',0);
        set(ud.coledit(ind),'string',['[' num2str(newcol(1)) ' ',...
            num2str(newcol(2)) ' ' num2str(newcol(3)) ']']);

    case 'colours'
        % Update colours after OK is clicked

        figh=gcbf;
        ud=get(figh,'userdata');
        cols=get(ud.coledit,'string');
        for n=1:length(cols)
            cols{n}=str2num(cols{n});
        end
        tbl=ud.table;

        guiud=get(ud.parent,'userdata');
        % Update colours in userdata
        guiud.viewers.opts.framecolor=cols{1};
        guiud.viewers.opts.labelcolor=cols{2};
        guiud.viewers.opts.cellbgcolor=cols{3};
        guiud.viewers.opts.cellfgcolor=cols{4};

        % Update DOE matrix colour prefs
        prefs=i_getfield(guiud.matprefs,guiud.matprefs.current);

        set(ud.parent,'userdata',guiud);
        set(tbl,'frame.color',cols{1},...
            'cells.defaultbackgroundcolor',cols{3},...
            'cells.defaultforegroundcolor',cols{4});
        % Different matrices have a different number of heading cells
        switch lower(guiud.matprefs.current)
            case {'regressionstat.multiplevifs','detxtx','stderror'}
                % row headings only
                set(tbl,'cells.rowselection',[1 tbl.rows.number],...
                    'cells.colselection',[1 1],...
                    'cells.foregroundcolor',cols{2});
            otherwise
                % need row and column headings
                set(tbl,'cells.rowselection',[1 1],...
                    'cells.colselection',[2 tbl.cols.number],...
                    'cells.foregroundcolor',cols{2},...
                    'cells.rowselection',[2 tbl.rows.number],...
                    'cells.colselection',[1 1],...
                    'cells.foregroundcolor',cols{2});
        end

        if get(ud.colmap(1),'value')
            % Apply the colormap
            tbl.colormap=ud.map;
            tbl.colorintervals=ud.ints;
            tbl.usecolors='on';
            prefs.colormap=ud.map;
            prefs.colorintervals=ud.ints;
            prefs.usecolormap='on';
        else
            tbl.usecolors='off';
            prefs.usecolormap='off';
        end
        close(figh);
        guiud.matprefs=i_setfield(guiud.matprefs,guiud.matprefs.current,prefs);
        set(ud.parent,'userdata',guiud);
        mv_StatusBar('message',ud.parent,i_statusstr(ud.parent));
    case 'usecm'
        % flick enable status on cell text colour swatch
        obj=gcbo;
        figh=gcbf;
        ud=get(figh,'userdata');
        val=get(obj,'value');

        if val
            % disable colour swatch
            set([ud.coledit(4);ud.colsw(4);ud.coltxt(4)],'enable','off');
            % enable colourmap setting features
            set(ud.colmap(2),'enable','on');
        else
            % enable colour swatch
            set([ud.coledit(4);ud.colsw(4);ud.coltxt(4)],'enable','on');
            % disable colourmap setting features
            set(ud.colmap(2),'enable','off');
        end

    case 'cmapdef'
        % First decide default input map and intervals

        figh=gcbf;
        ud=get(figh,'userdata');
        map=ud.map;
        ints=ud.ints;

        if isempty(map)
            map=[0 0 0];
        end

        [newmap,newints]=uisetcolormap(map,ints);

        if length(newmap)==1 && newmap==0
            newmap=map;
            newints=ints;
        end

        % Put colormap info straight into table.
        ud.map=newmap;
        ud.ints=newints;

        set(figh,'userdata',ud);

end

return





%========================================================================
%========================================================================
% i_genopts - posts general options dialogue for 1d,2d,3d,4d objects
%========================================================================
%========================================================================

function i_genopts(obj)
figh=gcbf;
ud=get(figh,'userdata');

switch lower(obj)
    case '1d'
        obj=ud.viewers.mvgraph1d;
        if isempty(obj)
            % create and attach
            ud.viewers.mvgraph1d=mvgraph1d(figh,...
                'visible','off');
            attach(ud.viewers.card,ud.viewers.mvgraph1d,2);
            obj=ud.viewers.mvgraph1d;
            set(figh,'userdata',ud);
        end
    case '2d'
        obj=ud.viewers.mvgraph2d;
        if isempty(obj)
            ud.viewers.mvgraph2d=mvgraph2d(figh,...
                'visible','off',...
                'factorselection','exclusive');
            attach(ud.viewers.card,ud.viewers.mvgraph2d,3);
            obj=ud.viewers.mvgraph2d;
            set(figh,'userdata',ud);
        end
    case '3d'
        obj=ud.viewers.mvgraph3d;
        if isempty(obj)
            ud.viewers.mvgraph3d=mvgraph3d(figh,...
                'visible','off',...
                'factorselection','exclusive');
            attach(ud.viewers.card,ud.viewers.mvgraph3d,4);
            obj=ud.viewers.mvgraph3d;
            set(figh,'userdata',ud);
        end
    case '4d'
        obj=ud.viewers.mvgraph4d;
        if isempty(obj)
            ud.viewers.mvgraph4d=mvgraph4d(figh,...
                'visible','off',...
                'factorselection','exclusive');
            attach(ud.viewers.card,ud.viewers.mvgraph4d,5);
            obj=ud.viewers.mvgraph4d;
            set(figh,'userdata',ud);
        end
end

prefsgui(obj);

return





%========================================================================
%========================================================================
% i_cmap - changes image colourmap for 2d,3d,4d objects
%========================================================================
%========================================================================

function i_cmap(obj)
figh=gcbf;
ud=get(figh,'userdata');

switch lower(obj)
    case '2d'
        obj=ud.viewers.mvgraph2d;
        if isempty(obj)
            ud.viewers.mvgraph2d=mvgraph2d(figh,...
                'visible','off',...
                'factorselection','exclusive');
            attach(ud.viewers.card,ud.viewers.mvgraph2d,3);
            obj=ud.viewers.mvgraph2d;
            set(figh,'userdata',ud);
        end
    case '3d'
        obj=ud.viewers.mvgraph3d;
        if isempty(obj)
            ud.viewers.mvgraph3d=mvgraph3d(figh,...
                'visible','off',...
                'factorselection','exclusive');
            attach(ud.viewers.card,ud.viewers.mvgraph3d,4);
            obj=ud.viewers.mvgraph3d;
            set(figh,'userdata',ud);
        end
    case '4d'
        obj=ud.viewers.mvgraph4d;
        if isempty(obj)
            ud.viewers.mvgraph4d=mvgraph4d(figh,...
                'visible','off',...
                'factorselection','exclusive');
            attach(ud.viewers.card,ud.viewers.mvgraph4d,5);
            obj=ud.viewers.mvgraph4d;
            set(figh,'userdata',ud);
        end
end
cmapnow=obj.colormap;

newcmap=uisetcolormap(cmapnow,NaN);

if length(newcmap)>1
    obj.colormap=newcmap;
end

return




% **********************  END MENU CALLBACKS  ********************************








% **********************  BEGIN VIEWING OBJECT CALLBCAKS  *********************
%
%
%
%  This section includes callbacks that have been attached to the viewing objects.
%   This is mainly ones attached to cells in a table object.
%
%
%


%========================================================================
%========================================================================
% i_modterms - handles include/exclude callbacks from FX matrix gui
%========================================================================
%========================================================================

function i_modterms
% get callback object: this will have a column number attached to it
figh=gcbf;
set(figh,'pointer','watch');
cud=get(gcbo,'userdata');
ud=get(cud.parent,'userdata');
tbl=get(ud.objecthandle,'userdata');
clear ud
ud=get(figh,'userdata');
col=cud.col;
val=get(gcbo,'value');
% Do gui updating
switch val
    case 0
        tgcol=[0 0.85 0];
        ttcol=ud.viewers.opts.labelcolor;
        colen='on';
        stat=3;
    case 1
        tgcol=[0.85 0 0];
        ttcol=0.5*ud.viewers.opts.labelcolor;
        colen='off';
        stat=2;
end

set(tbl,'cells.rowselection',[1 1],...
    'cells.colselection',[col col],...
    'cells.foregroundcolor',ttcol,...
    'cells.rowselection',[2 2],...
    'cells.colselection',[col col],...
    'cells.backgroundcolor',tgcol,...
    'cells.rowselection',[tbl.rows.fixed+1 tbl.rows.number],...
    'cells.colselection',[col col],...
    'cells.enable',colen);
drawnow('expose');

% Need to update the model in the userdata with new terms info....??
% Do this using setstatus to set ith term status to 2 or 3
guiud=get(figh,'userdata');
[guiud.data.data,guiud.data.currentdata,alert]=i_checkdata(guiud.data.data,guiud.data.currentdata,figh);
if ~alert
    mdl=ud.data.data(ud.data.currentdata).x.model;
    Tind= termorder(mdl);
    mdl=setstatus(mdl,Tind(col-1),stat);
    mdl=SetTerm(mdl,Tind(col-1),(stat>2));
    [mdl,ok]=InitStore2(mdl,guiud.data.data(guiud.data.currentdata).x.factorsettings);
    guiud.data.data(guiud.data.currentdata).x.info=guiud.data.data(guiud.data.currentdata).x.model(mdl);

    % update doftable display
    i_updatedoftbl(figh);

    % do a rank check on new regression matrix
    if ~ok
        en='off';
    else
        en='on';
    end
    i_setmatrixoptions(ud.matrixsel.listbox,en);
end
set(figh,'pointer','arrow');
return






%========================================================================
%========================================================================
% i_updatemodel - update model from term selector object
%========================================================================
%========================================================================

function i_updatemodel(m)
figh=gcbf;
ud=get(figh,'userdata');
[ud.data.data,ud.data.currentdata,alert]=i_checkdata(ud.data.data,ud.data.currentdata,figh);
if alert
    return
end

[m,ok]=InitStore2(m,ud.data.data(ud.data.currentdata).x.factorsettings);
ud.data.data(ud.data.currentdata).x.info=ud.data.data(ud.data.currentdata).x.model(m);

i_updatedoftbl(figh);
% do a rank check on new regression matrix
if ~ok
    en='off';
else
    en='on';
end
i_setmatrixoptions(ud.matrixsel.listbox,en);

return






% ***********************  END VIEWING OBJECT CALLBCAKS  *********************








% ************************  BEGIN INTERNAL UTILITY FUNCTIONS  ********************
%
%
%
%  This section contains functions that are used internally, and are probably called
%   from multiple places.
%
%





%========================================================================
%========================================================================
% i_statusstr - create an appropriate status bar string
%========================================================================
%========================================================================


function str=i_statusstr(figh)

ud=get(figh,'userdata');
tbl=ud.viewers.table;
str=[];

% First a colourmap string
if ud.viewers.matrixview==0
    if strcmp(tbl.usecolors,'on')
        str=[str 'Colormap active'];
    else
        str=[str 'No colormap enabled'];
    end
end
% Now a filter description
if ud.viewers.matrixview==0
    % Describe filter
    val=tbl.filters.value;
    tol=tbl.filters.tolerance;
    switch tbl.filters.type
        case 'eq'
            str=[str '.  Filtering out values == ' num2str(val) ' ' char(177) ' ' num2str(tol)];
        case 'ne'
            str=[str '.  Filtering out values ~= ' num2str(val) ' ' char(177) ' ' num2str(tol)];
        case 'lt'
            str=[str '.  Filtering out values < ' num2str(val)];
        case 'le'
            str=[str '.  Filtering out values <= ' num2str(val)];
        case 'gt'
            str=[str '.  Filtering out values > ' num2str(val)];
        case 'ge'
            str=[str '.  Filtering out values >= ' num2str(val)];
        case 'none'
            str=[str '.  No filter enabled'];
    end
end

if isempty(str)
    str='Ready';
end

str=[str '.'];

return




%========================================================================
%========================================================================
% i_updatedoftbl - update dof table when design matrix is changed
%========================================================================
%========================================================================

function i_updatedoftbl(figh)
ud=get(figh,'userdata');
doftbl=ud.extrainfo.doftable;
el=get(doftbl,'elements');
el=cat(1,el{:});
el=reshape(el,6,2);

mdl=ud.data.data(ud.data.currentdata).x.model;
% Look for data replication
reps=replicants(mdl,ud.data.data(ud.data.currentdata).x.factorsettings);
% count up replication dof number
repnum=sum(cellfun('length',reps)-1);

val(5,1)=ud.data.data(ud.data.currentdata).x.npoints;
val(3,1)=repnum;

ptsremain=val(5)-val(3);
if sum(Terms(mdl)) <= ptsremain
    val(1)=sum(Terms(mdl));
    ok=1;
else
    val(1)=ptsremain;
    ok=0;
end

val(2)=val(5)-val(1);
val(4)=val(2)-val(3);

str=cellstr(num2str(val));

if ~ok
    set(el([2 end],2),'foregroundcolor',[1 0 0]);
else
    set(el([2 end],2),'foregroundcolor',[0 0 0]);
end

set(el(2:end,2),{'string'},str);
return




%========================================================================
%========================================================================
% i_updatetbl - looks at radiobutton selection and calcs and updates table
%========================================================================
%========================================================================

function i_updatetbl(fig,opts)

set(fig,'pointer','watch');
ud=get(fig,'userdata');
rds=ud.matrixsel.listbox;
curr_val=get(rds,'value');

% slide buttons out of gui
if ~strcmp(ud.matrixsel.btns.current,'none') && ~strcmp(opts,'nobtns')
    set(ud.matrixsel.card,'currentcard',13);
end

mv_StatusBar('message',fig,'Calculating...',0,'noredraw');

[btngrp,btn_val]=i_btngrp(fig,curr_val);

ud.matrixsel.btns.current=btngrp;
ud.matprefs.current=i_matprefsname(curr_val,btn_val);

[x,rh,ch]=i_calcmatrix(ud.data.data(ud.data.currentdata).x.model,...
    ud.data.data(ud.data.currentdata).x.factorsettings,curr_val,btn_val);

[rowsz, colsz, celltp, killdiag, extra]=i_matdispopts(0,curr_val,btn_val);

% set ud to update matprefs.current
set(fig,'userdata',ud);

mv_StatusBar('message',fig,'Updating display...',0,'noredraw');

% update allowable viewing objects
% This means that disallowed ones that are selected need to be changed (go to table)
% Note that there is a 12th viewer object that is never user selectable: the term_selector
views=ud.viewers.available(i_getfield(ud.matprefs,[ud.matprefs.current '.viewers']),:);
bthndls=struct2cell(ud.toolbar.buttons.view);
mnhndls=struct2cell(ud.menus.view);
mnhndls=mnhndls(1:end-1);
if ~views(ud.viewers.matrixview+1)
    % switch viewer to first available one
    ind=find(views);
    ud.viewers.matrixview=ind(1)-1;
    ud=i_switchtoviewer(ud,ud.viewers.matrixview,fig);
    set(fig,'userdata',ud);
    st=cell(size(views))';
    st(:)={'off'};
    st(ind(1))={'on'};
    set([bthndls{:}],{'state'},st(1:end-1));
    set([mnhndls{:}],{'checked'},st(1:end-1));
end
en=cell(size(views))';
en(:)={'off'};
en(views)={'on'};
set([bthndls{:},mnhndls{:}],{'enable'},[en(1:end-1);en(1:end-1)]);

% Use another function for actually updating table
i_display_mat(fig,x,rh,ch,rowsz,colsz,celltp,killdiag,extra);

% Update rank and condition numbers
i_updateinfo(fig,x,i_getfield(ud.matprefs,[ud.matprefs.current '.infostring']));

% Slide in buttons
if ~strcmp(ud.matrixsel.btns.current,'none') && ~strcmp(opts,'nobtns')
    set(ud.matrixsel.card,'currentcard',curr_val);
end

mv_StatusBar('message',fig,i_statusstr(fig),0,'noredraw');
set(fig,'pointer','arrow');
return




%========================================================================
%========================================================================
% i_display_mat......Display given matrix
%========================================================================
%========================================================================

function i_display_mat(figh,matx,rh,ch,rs,cs,tp,diagstatus,extra)
% If rh or ch are empty , it doesn't use any headings.  Currently only supports
% a single heading row/column if required, no more.

if isempty(rh)
    nfixc=0;
else
    nfixc=1;
end
if isempty(ch)
    nfixr=0;
else
    nfixr=1;
end

if isempty(rs)
    rs=20;
end
if isempty(cs)
    cs=50;
end
if isempty(tp)
    tp='uiemuedit0';
end


% Add an extra fixed row for exclusion toggle buttons
if strcmp(extra,'toggles')
    nfixr=nfixr+1;
end

ud=get(figh,'userdata');
obj=ud.viewers.currentobject;
set(ud.viewers.card,'visible','off');

% don't want a redraw is this is an initialisation call
global DOE_INIT_FLAG
if isempty(DOE_INIT_FLAG) || ~DOE_INIT_FLAG
    drawnow('expose');
end
clear('global','DOE_INIT_FLAG');

if strcmp(class(obj),'xregtable')

    obj.redrawmode='basic';
    obj.clear;

    if size(matx,1)+nfixr<1 || size(matx,2)+nfixc<1 || isempty(matx)
        % No data to display
        obj.visible='on';
        obj.redraw;
        obj.redrawmode='normal';
        return
    end

    % get filter and colormap settings
    prefs=i_getfield(ud.matprefs,ud.matprefs.current);

    zeroind=[nfixr+1 nfixc+1];
    if ischar(matx)
        % special case: want to display a string
        set(obj,'zeroindex',[1 1],...
            'rows.size',rs,...
            'cols.size',250,...
            'defaultcelltype','uitext',...
            'defaultcellformat',prefs.formatstr,...
            'rows.number',1,...
            'cols.number',1,...
            'rows.fixed',1,...
            'cells.backgroundcolor',ud.viewers.opts.framecolor,...
            'cells.foregroundcolor',ud.viewers.opts.labelcolor);
    elseif nfixr && nfixc
        % amalgamate separate calls to reduce time in table redraw fcn
        set(obj,'rows.size',rs,...
            'cols.size',cs,...
            'defaultcelltype',tp,...
            'defaultcellformat',prefs.formatstr,...
            'rows.number',size(matx,1)+nfixr,...
            'cols.number',size(matx,2)+nfixc,...
            'rows.fixed',nfixr,...
            'cols.fixed',nfixc,...
            'zeroindex',zeroind,...
            'cells.rowselection',[zeroind(1) size(matx,1)+nfixr],...
            'cells.colselection',[1 1],...
            'cells.type','text',...
            'cells.string',rh,...
            'cells.foregroundcolor',ud.viewers.opts.labelcolor,...
            'cells.rowselection',[1 1],...
            'cells.colselection',[zeroind(2) size(matx,2)+nfixc],...
            'cells.type','text',...
            'cells.string',ch,...
            'cells.foregroundcolor',ud.viewers.opts.labelcolor,...
            'cells.rowselection',[1 nfixr],...
            'cells.colselection',[1 nfixc],...
            'cells.visible','off',...
            'colormap',prefs.colormap,...
            'colorintervals',prefs.colorintervals,...
            'usecolors',prefs.usecolormap,...
            'filters.type',prefs.filtertype,...
            'filters.value',prefs.filtervalue,...
            'filters.tolerance',prefs.filtertol);
    elseif nfixc
        set(obj,'rows.size',rs,...
            'cols.size',cs,...
            'defaultcelltype',tp,...
            'defaultcellformat',prefs.formatstr,...
            'rows.number',size(matx,1)+nfixr,...
            'cols.number',size(matx,2)+nfixc,...
            'rows.fixed',nfixr,...
            'cols.fixed',nfixc,...
            'zeroindex',zeroind,...
            'cells.rowselection',[zeroind(1) size(matx,1)+nfixr],...
            'cells.colselection',[1 1],...
            'cells.type','text',...
            'cells.string',rh,...
            'cells.foregroundcolor',ud.viewers.opts.labelcolor,...
            'colormap',prefs.colormap,...
            'colorintervals',prefs.colorintervals,...
            'usecolors',prefs.usecolormap,...
            'filters.type',prefs.filtertype,...
            'filters.value',prefs.filtervalue,...
            'filters.tolerance',prefs.filtertol);
    elseif nfixr
        set(obj,'rows.size',rs,...
            'cols.size',cs,...
            'defaultcelltype',tp,...
            'defaultcellformat',prefs.formatstr,...
            'rows.number',size(matx,1)+nfixr,...
            'cols.number',size(matx,2)+nfixc,...
            'rows.fixed',nfixr,...
            'cols.fixed',nfixc,...
            'zeroindex',zeroind,...
            'cells.rowselection',[1 1],...
            'cells.colselection',[zeroind(2) size(matx,2)+nfixc],...
            'cells.type','text',...
            'cells.string',ch,...
            'cells.foregroundcolor',ud.viewers.opts.labelcolor,...
            'colormap',prefs.colormap,...
            'colorintervals',prefs.colorintervals,...
            'usecolors',prefs.usecolormap,...
            'filters.type',prefs.filtertype,...
            'filters.value',prefs.filtervalue,...
            'filters.tolerance',prefs.filtertol);
    end

    % Throw matrix in
    obj(:,:)=matx;

    if diagstatus>0
        % make half of matrix invisible
        msk=(triu(ones(size(matx,1)),diagstatus)~=0);
        obj(msk).visible='off';
    elseif diagstatus<0
        % make half of matrix invisible
        msk=(tril(ones(size(matx,1)),diagstatus)~=0);
        obj(msk).visible='off';
    end

    % If necessary, add toggle ui's with callbacks that set exclusions, etc
    if strcmp(extra,'toggles')
        % Need to correctly set initial values (0 or 1) and colours
        % red means excluded, green is included
        out=~terms2(ud.data.data(ud.data.currentdata).x.model);

        set(obj,'cells.rowselection',[2 2],...
            'cells.colselection',[zeroind(2) obj.cols.number],...
            'cells.type','uitogglebutton',...
            'cells.backgroundcolor',[0 0.85 0],...
            'cells.callback',[mfilename '(''modterms'');']);

        obj(2-nfixr,out).value=1;
        obj(2-nfixr,out).backgroundcolor=[0.85 0 0];

        % Will probably want to disable entire column when excluded
        obj(:,out).enable='off';
        obj(1-nfixr,out).foregroundcolor=0.5*ud.viewers.opts.labelcolor;
    end

    obj.redrawmode='normal';
    obj.redraw;
elseif strcmp(class(obj),'term_selector')
    model(obj,matx);
elseif isa(obj,'mvgraph2d')
    if ~isnumeric(matx)
        matx=[];
    end
    h=ch;
    if isempty(h)
        h={{},rh};
    else
        h={h,rh};
    end
    set(obj,'data',matx,'factors',h);
else
    if ~isnumeric(matx)
        matx=[];
    end
    set(obj,'data',matx,'factors',ch);
end
set(ud.viewers.card,'visible','on');
return




%========================================================================
%========================================================================
% i_calcmatrix......return matrix and rh,ch for given matrix
%========================================================================
%========================================================================

function [xout,rh,ch]=i_calcmatrix(m,x,main,sub)

% main is the radio selection number, sub is the sub button selection, if any
if isempty(x)
    % oh dear.  don't try any calcs
    if main==3
        xout=m;
    else
        xout=[];
    end
    rh=[];
    ch=[];
    return
end
if ischar(x)
    % return char
    if main==3
        xout=m;
    else
        xout=x;
    end
    rh=[];
    ch=[];
end

switch main
    case 1
        % Design matrix
        switch sub
            case 1
                xout=x;
            case 2
                xout=invcode(m,x);
        end
        rh = mbcordinalstring(size(xout,1));
        ch = get(m,'symbol');
    case 2
        % FX matrix
        xout=fx(m);
        rh = mbcordinalstring(size(xout,1));
        ch = labels(m);
    case 3
        xout=m;
        rh=[];
        ch=[];
    case 4
        % Z2 matrix
        xout=z2matrix(m);
        if isempty(xout)
            xout='All terms are currently included in the model';
            rh=[];
            ch=[];
        else
            rh = mbcordinalstring(size(xout,1));
            ch = labels(m);
            ch = ch(~terms2(m));
        end
    case 5;
        % Alias matrix
        xout=alias(m);
        if isempty(xout)
            xout='All terms are currently included in the model';
            rh=[];
            ch=[];
        else
            l=labels(m);
            rh=l(terms2(m));
            ch=l(~terms2(m));
        end
    case 6
        % Z2.1 matrix
        xout=z21matrix(m);
        if isempty(xout)
            xout='All terms are currently included in the model';
            rh=[];
            ch=[];
        else
            rh = mbcordinalstring(size(xout,1));
            ch = labels(m);
            ch = ch(~terms2(m));
        end
    case 7
        % FX2 - Regression matrix
        xout=regression(m);
        rh = mbcordinalstring(size(xout,1));
        ch = labels(m);
        ch = ch(terms2(m));
    case 8
        % Regression statistics  matrices
        switch sub
            case 1
                % Covariance
                xout=cov(m);
                ch=labels(m);
                ch=ch(terms2(m));
                rh=ch;
            case 2
                % Correlation
                xout=cov(m);
                [s, xout]=xregcov2corr(xout);
                ch=labels(m);
                ch=ch(terms2(m));
                rh=ch;
            case 3
                % Partial VIFs
                xout=vif(m);
                xout=xout(1:end-1,:);
                xout=xout(:,2:end);
                xout=xout';
                ch=labels(m);
                ch=ch(terms2(m));
                rh=ch;
                % strip off constant label if necessary
                if (length(rh)-size(xout,1))==2
                    rh=rh(2:end);
                    ch=ch(2:end);
                end
                rh=rh(2:end);
                ch=ch(1:end-1);
            case 4
                % Multiple VIFs
                % Need to use collinear function from linearmod
                xout=cov(m);
                [s, xout]=xregcov2corr(xout);
                xout = diag(inv(xout));
                rh=labels(m);
                rh=rh(terms2(m));
                ch=[];
            case 5
                % 2 column correlations
                xout=twocolumncorr(m);
                rh=labels(m);
                rh=rh(terms2(m));
                % strip off constant label if necessary
                if (length(rh)-size(xout,1))==1
                    rh=rh(2:end);
                end
                ch=rh;
            case 6
                % Single Term VIFs
                xout=twocolumncorr(m);
                xind=~eye(size(xout));
                xout(xind)=1./(1-(xout(xind).^2));
                xout(~xind)=inf;
                xout=xout(1:end-1,:);
                xout=xout(:,2:end);
                xout=xout';
                ch=labels(m);
                ch=ch(terms2(m));
                rh=ch;
                rh=rh(2:end);
                ch=ch(1:end-1);
                % strip off constant label if necessary
                if (length(rh)-size(xout,1))==1
                    rh=rh(2:end);
                    ch=ch(2:end);
                end
        end
    case 10
        % Hat Matrix
        xout=hat(m);
        switch sub
            case 1
                rh = mbcordinalstring(size(xout,1));
                ch = mbcordinalstring(size(xout,2));
            case 2
                xout=diag(xout);
                ud.matprefs.current='hat.leverage';
                ch=[];
                rh = mbcordinalstring(size(xout,1));
        end
    case 9
        % Standard Error
        xout=stderr(m);
        xout=xout(:);
        rh=labels(m);
        rh=rh(terms2(m));
        ch=[];
    case 11
        % |X'X|
        xout=det_xtx(m);
        switch sub
            case 2
                xout=log(xout);
            case 3
                p=length(find(terms2(m)));
                xout=xout.^(1/p);
        end
        xout=real(xout);
        rh='\midX''X\mid:';
        ch=[];
    case 12
        % raw residual statistics
        xout=hat(m);
        xout=(eye(size(xout))-xout);
        switch sub
            case 2
                d=(diag(xout)).^0.5;
                d=d*d';
                xout=xout./d;
        end
        rh = mbcordinalstring(size(xout,1));
        ch = mbcordinalstring(size(xout,2));
    otherwise
        xout=[];
        rh=[];
        ch=[];
end
return




%========================================================================
%========================================================================
% i_matdispopts......return display options for a given matrix
%========================================================================
%========================================================================

function [rowsz, colsz, celltp, killdiag, extra]=i_matdispopts(mode,main,sub)

% defaults
rowsz=20;
colsz=50;
celltp='uiemuedit0';
killdiag=0;
extra=[];

switch main
    case 1
        if mode
            celltp='uiedit';
            rowsz=20;
        else
        end
    case 2
        % FX matrix
        extra='toggles';
    case 3
        % term selector
    case 4
        % Z2 matrix
    case 5
        % Alias matrix
    case 6
        % Z2.1 matrix
    case 7
        % FX2 - Regression matrix
    case 8
        % Regression statistics  matrices
        switch sub
            case 1
                % Covariance
                killdiag=1;
            case 2
                % Correlation
                killdiag=1;
            case 3
                % Partial VIFs
                killdiag=1;
            case 4
                % Multiple VIFs
                % Need to use collinear function from linearmod
            case 5

                killdiag=1;
            case 6

                killdiag=1;
        end
    case 10
        % Hat Matrix
        switch sub
            case 1
                % Full Hat
                killdiag=1;
            case 2
                % Leverage
        end
    case 9
        % Standard Error
    case 11
        % |X'X|
        % Will need to check toolbar button state to decide which form is needed
        colsz=80;
    case 12
        % raw residual statistics
        killdiag=1;
end
return




%========================================================================
%========================================================================
% i_btngrp......return the button group name for a given radio selection
%========================================================================
%========================================================================

function [name,current]=i_btngrp(figh,sel)

names={'design';'none';'none';'none';'none';'none';'none';...
    'regstat';'none';'hat';'detx';'rawstat';};
name=names{sel};

if ~strcmp(name,'none')
    ud=get(figh,'userdata');
    btns=i_getfield(ud.matrixsel.btns,name);
    vals=get(btns(:),'value');
    vals=cat(1,vals{:});
    current=find(vals);
else
    current=[];
end
return




%========================================================================
%========================================================================
% i_matprefsname......return the name for the matprefs section
%========================================================================
%========================================================================

function name=i_matprefsname(grp,btn)

names={'design';'fx';'termselect';'z2';'alias';'z21';'regression';...
    'regressionstat';'stderror';'hat';'detxtx';'rawresstat'};
name=names{grp};
switch grp
    case 1
        names={'.coded' '.natural'};
        name=[name names{btn}];
    case 8
        names={'.cov' '.corr' '.partialvifs' '.multiplevifs' '.colcorr' '.singlevifs'};
        name=[name names{btn}];
    case 10
        names={'.hat' '.leverage'};
        name=[name names{btn}];
    case 12
        names={'.cov' '.corr'};
        name=[name names{btn}];
end
return





%========================================================================
%========================================================================
% i_updateDOE_tp......update the DOE tool with new testplan data.
%========================================================================
%========================================================================

function i_updateDOE_tp(figh,p)

% this function may be called to update a DE tool window with
% data from the testplan pointer p_tp.  figh is the handle to the DOE figure

ud=get(figh,'userdata');


ud.data.data=i_cleardataptrs(ud.data.data);

% need to replace design and experimental data, update model, and put data
%  into current viewer.
p_tp= address(p.mdevtestplan);
mdl=p.model;
des=p_tp.Design;

ddes=model(des,InitStore2(mdl,factorsettings(des)));

ud.data.data(1).x= xregpointer(ddes);
ud.data.data(1).mydata=1;
ud.data.currentdata=1;
if p_tp~=p
    %switch to experimental mode
    [Xg,y]=getdata(p.info);
    % select 'good' data
    Dok= isfinite(double(y));
    Xg= Xg(Dok,:);

    expdes=reinit(des,code(mdl,double(Xg)));
    expmdl=InitStore2(mdl,factorsettings(expdes));
    expdes=model(expdes,expmdl);
    expdes=name(expdes,'Experimental Data');
    expdes=optimisetype(expdes,'experimental data');
    ud.data.data(2).x= xregpointer(expdes);
    ud.data.data(2).mydata=1;
    ud.data.currentdata=2;
else
    if p_tp.IsMatched
        % bring in experimental, don't switch
        Xg=p_tp.getdata('X');
        expdes=reinit(des,code(mdl,double(Xg)));
        expmdl=InitStore2(mdl,factorsettings(expdes));
        expdes=model(expdes,expmdl);
        expdes=name(expdes,'Experimental Data');
        expdes=optimisetype(expdes,'experimental data');
        ud.data.data(2).x= xregpointer(expdes);
        ud.data.data(2).mydata=1;
    else
        expdes=clear(des);
        expmdl=InitStore2(mdl,factorsettings(expdes));
        expdes=model(expdes,expmdl);
        expdes=name(expdes,'Experimental Data');
        expdes=optimisetype(expdes,'experimental data');
        ud.data.data(2).x= xregpointer(expdes);
        ud.data.data(2).mydata=1;
    end
end
set(figh,'name',['Design Evaluation Tool - [' ud.data.data(ud.data.currentdata).x.name ']']);

set(figh,'userdata',ud);

% do a rank check on new regression matrix
ok=ud.data.data(ud.data.currentdata).x.rankcheck;
if ~ok
    en='off';
else
    en='on';
end
i_setmatrixoptions(ud.matrixsel.listbox,en);

% if current selection is not allowed, revert to design matrix?
selval=get(ud.matrixsel.listbox,'value');
if (selval>=8 || selval==6) && ~ok
    set(ud.matrixsel.listbox,'value',1);
    if ud.flags.codeview
        nm='Xc';
    else
        nm='Xn';
    end
    set(ud.export.varname,'string',nm);
    i_updateinfo(figh);
end

% update Edit..Data Sources
i_newsources(figh);
i_updatedoftbl(figh);
global DOE_INIT_FLAG
DOE_INIT_FLAG=1;
i_updatetbl(figh,'nobtns');
clear('global','DOE_INIT_FLAG');
return





%========================================================================
%========================================================================
% i_updateDOE_des......update the DOE tool with new designs.
%========================================================================
%========================================================================

function i_updateDOE_des(figh,d)
% this function may be called to update a DE tool window with
% data from the designs d.  figh is the handle to the DOE figure
%
%  d may be :  a design
%           :  a pointer to a design
%           :  a cell array of designs and pointers to designs

ud=get(figh,'userdata');
ud.data.data=i_cleardataptrs(ud.data.data);

% need to replace design and experimental data, update model, and put data
%  into current viewer.

% convert everything to a cell
if isa(d,'xregdesign')
    d={d};
elseif isa(d,'xregpointer') && isa(d.info,'xregdesign')
    d={d};
elseif ~iscell(d)
    return
end


% loop over inputs and set them all to pointers
for n=1:length(d)
    dnow=d{n};
    if isa(dnow,'xregdesign')
        % initialise model store
        dnow=model(dnow,InitStore2(model(dnow),factorsettings(dnow)));
        % create pointer
        ud.data.data(n).x= xregpointer(dnow);
        ud.data.data(n).mydata=1;
    elseif isa(dnow,'xregpointer')
        des=dnow.info;
        if isa(des,'xregdesign')
            % initialise model store
            des=model(des,InitStore2(model(des),factorsettings(des)));
            dnow.info=des;
            ud.data.data(n).x=dnow;
            ud.data.data(n).mydata=0;
        end
    end
end
ud.data.currentdata=1;
set(figh,'name',['Design Evaluation Tool - [' ud.data.data(ud.data.currentdata).x.name ']']);

set(figh,'userdata',ud);

% do a rank check on new regression matrix
ok=ud.data.data(1).x.rankcheck;
if ~ok
    en='off';
else
    en='on';
end
i_setmatrixoptions(ud.matrixsel.listbox,en);

% if current selection is not allowed, revert to design matrix?
selval=get(ud.matrixsel.listbox,'value');
if (selval>=8 || selval==6) && ~ok
    set(ud.matrixsel.listbox,'value',1);
    if ud.flags.codeview
        nm='Xc';
    else
        nm='Xn';
    end
    set(ud.export.varname,'string',nm);
    i_updateinfo(figh);
end

% redraw gui
i_newsources(figh);
i_updatedoftbl(figh);
global DOE_INIT_FLAG
DOE_INIT_FLAG=1;
i_updatetbl(figh,'nobtns');
clear('global','DOE_INIT_FLAG');
return





%========================================================================
%========================================================================
% i_addtoDOE_des......add designs to the tool.
%========================================================================
%========================================================================

function i_addtoDOE_des(figh,d)
% this function may be called to update a DE tool window with
% data from the designs d.  figh is the handle to the DOE figure
%
%  d may be :  a design
%           :  a pointer to a design
%           :  a cell array of designs and pointers to designs
%
%  designs are added to the current list of available evaluation
%  designs

% convert everything to a cell
if isa(d,'xregdesign')
    d={d};
elseif isa(d,'xregpointer') && isa(d.info,'xregdesign')
    d={d};
elseif ~iscell(d)
    return
end

ud=get(figh,'userdata');
numnow=length(ud.data.data);

% loop over inputs and set them all to pointers
for n=1:length(d)
    dnow=d{n};
    if isa(dnow,'xregdesign')
        % initialise model store
        dnow=model(dnow,InitStore2(model(dnow),factorsettings(dnow)));
        % create pointer
        ud.data.data(numnow+n).x= xregpointer(dnow);
        ud.data.data(numnow+n).mydata=1;
    elseif isa(dnow,'xregpointer')
        des=dnow.info;
        if isa(des,'xregdesign')
            % initialise model store
            des=model(des,InitStore2(model(des),factorsettings(des)));
            dnow.info=des;
            ud.data.data(numnow+n).x=dnow;
            ud.data.data(numnow+n).mydata=0;
        end
    end
end

set(figh,'userdata',ud);

% redraw gui
i_newsources(figh);

% switch to new design
ud=get(figh,'userdata');
newmenu=ud.menus.data.opts(end);
i_srcdata(newmenu,[],figh);
return







%========================================================================
%========================================================================
% i_updateinfo......update the info pane.
%========================================================================
%========================================================================

function i_updateinfo(figh,x,str)
% need to do rank and condition only if matrix is ok-looking
ud=get(figh,'userdata');
%only do this if info visible, otherwise we're spending time on infostring

if ud.flags.viewinfo
    if nargin<2
        x=[];
    end
    if ~isnumeric(x)
        x=[];
    end
    if all(~(isinf(x) | isnan(x)))
        rnk=num2str(rank(x));
        cnd=num2str(cond(x));
    else
        rnk='NaN';
        cnd='NaN';
    end
    set([ud.extrainfo.ranktxt(2);ud.extrainfo.condtxt(2)],{'string'},{rnk;cnd});
    if ~isnan(str)
        %update text object with correctly wrapped data
        i_infostring(ud.extrainfo.userpane.text,str,ud);
    end
end
return




%========================================================================
%========================================================================
% i_infostring......update the info text object.
%========================================================================
%========================================================================

function i_infostring(obj,str,ud)
% need to split string into words then sequentially add them with carriage returns
% to simulate a wrapping object.
pos=get(ud.extrainfo.infogrid,'colsizes');
maxex=pos(2);
pos=get(obj,'position');
set(obj,'visible','off');
if pos(3)~=230
    pos(3)=230;
    set(obj,'position',pos);
end

str_dbl=double(str);
CRs=[0 find(str_dbl==10) length(str)+1];
% split into chunks
str_cell=cell(length(CRs)-1,1);
for n=1:length(str_cell)
    str_cell(n)={str(CRs(n)+1:CRs(n+1)-1)};
end

% go over chunks and check their length
n=1;
while n<=length(str_cell)
    str=str_cell{n};
    set(obj,'string',str);
    ex=get(obj,'extent');
    if ex(3)>maxex
        spcs=find(double(str)==32);
        frac=length(str).*maxex./ex(3);
        if isempty(spcs)
            brk=floor(frac);
        else
            brk=find(spcs<frac);
            brk=spcs(brk(end));
        end
        str_cell=[str_cell(1:n-1); {str(1:brk)}; {str(brk+1:end)}; str_cell(n+1:end)];
    end
    n=n+1;
end
set(obj,'string',str_cell,'visible','on');
return




%========================================================================
%========================================================================
% i_newsources......update the source menu in data
%========================================================================
%========================================================================

function i_newsources(figh)

ud=get(figh,'userdata');
dt=ud.menus.data.handle;

% First delete current data menu
if isfield(ud.menus.data,'opts')
    delete(ud.menus.data.opts(:));
    ud.menus.data.opts=[];
end
numsrc=length(ud.data.data);
for n=1:numsrc
    ud.menus.data.opts(n)=uimenu(dt,'label',ud.data.data(n).x.name,...
        'callback',{@i_srcdata,figh},...
        'userdata',n);
end

if isempty(ud.data.currentdata)
    % check first option
    set(ud.menus.data.opts(1),'checked','on');
elseif ud.data.currentdata>numsrc
    set(ud.menus.data.opts(end),'checked','on');
else
    set(ud.menus.data.opts(ud.data.currentdata),'checked','on');
end

set(figh,'userdata',ud);
return





%========================================================================
%========================================================================
% i_saveprefs......save ud.matprefs in mat file
%========================================================================
%========================================================================

function i_saveprefs(figh)

if length(figh)>1
    %there are still DOE windows open so don't save current prefs.
    return
else
    ud=get(figh,'userdata');
    p=mbcprefs('mbc');
    s=i_remove_static_prefs_fields(ud.matprefs);
    setpref(p,'DesignEval',s);
    saveprefs(p);
end
return




%========================================================================
%========================================================================
% i_cleardataptrs......free pointer memory and delete pointer references
%========================================================================
%========================================================================


function data=i_cleardataptrs(data)

for n=1:length(data)
    % free pointers if they belong to this gui
    if data(n).mydata
        freeptr(data(n).x);
    end
end
data=struct('x',[]);

return




%========================================================================
%========================================================================
% i_refresh......reinitialise model stores and redisplay
%========================================================================
%========================================================================

function i_refresh(figh)

if nargin<1
    figh=findall(0,'type','figure','tag','DOEtool');
    if ~isempty(figh)
        figh=figh(1);
    else
        return
    end
end

ud=get(figh,'userdata');

[ud.data.data,ind,alert]=i_checkdata(ud.data.data,1:length(ud.data.data),figh,'nowarn');
if alert
    % gui is shut down.  Data is all bad
    return
end

% redo model stores
for n=1:length(ud.data.data);
    ud.data.data(n).x.info=...
        ud.data.data(n).x.model(InitStore2(ud.data.data(n).x.model,ud.data.data(n).x.factorsettings));
end

% do a rank check on new regression matrix
ok=ud.data.data(ud.data.currentdata).x.rankcheck;
if ~ok
    en='off';
else
    en='on';
end
i_setmatrixoptions(ud.matrixsel.listbox,en);

% if current selection is not allowed, revert to design matrix?
selval=rdtbl(1:end,1).value;
if (find(selval)>=8 || find(selval)==6) && ~ok
    selval=zeros(size(selval));
    selval(1)=1;
    rdtbl(1:end,1).value=selval;
    rdtbl(2:end,2).foregroundcolor=[0 0 0];
    rdtbl(1,2).foregroundcolor=[0 0 1];
    if ud.flags.codeview
        nm='Xc';
    else
        nm='Xn';
    end
    set(ud.export.varname,'string',nm);
    i_updateinfo(figh);
end

set(figh,'userdata',ud);
% redraw gui
i_newsources(figh);
i_updatedoftbl(figh);
i_updatetbl(figh,'nobtns');

return




%========================================================================
%========================================================================
% i_checkdata......check data pointers and clean up bad ones
%========================================================================
%========================================================================

function [datastruct, index, alert]=i_checkdata(datastruct, index, figh, opt)
if nargin<4
    opt=1;
elseif strcmp(opt,'nowarn')
    opt=0;
end
if nargin<3
    figh=findall(0,'type','figure','tag','DOEtool');
    if ~isempty(figh)
        figh=figh(1);
    else
        % no doe tools???
        return
    end
end
if nargin<2
    index=1:length(datastruct);
end

alert=0;
reselect=0;
if length(index)==1
    % additional mode: tell user the data asked for wasn't valid and the GUI is resetting
    reselect=1;
end

ind2=[];
for n=index
    if ~isvalid(datastruct(n).x)
        % keep data
        ind2(end+1)=n;
    end
end
if ~isempty(ind2)
    datastruct(ind2)=[];
end
index=setxor(index,ind2);
index(index>length(datastruct))=[];

if length(datastruct)==0
    % Panic.  Alert user that there is no data, then close
    alert=1;
    h=warndlg(['There is no valid data available for display.  The Design Evaluation GUI',...
        ' will now be closed'],'Warning','modal');
    waitfor(h);
    mv_doeanalysis('close');
    % don't want to do next bit!
    return
end

if reselect && isempty(index)
    alert=1;
    if opt
        h=warndlg(['This data cannot be found and may have been deleted elsewhere.',...
            '  The Design Evaluation GUI will revert to the first valid dataset.'],'Warning','modal');
        waitfor(h);
    end
    ud=get(figh,'userdata');
    ud.data.currentdata=1;
    ud.data.data=datastruct;
    set(figh,'userdata',ud);
    % refresh - this checks all data validity
    i_refresh(figh);
end

return





%========================================================================
%========================================================================
% i_getfield......replacement for external getfield
%========================================================================
%========================================================================

function [out]=i_getfield(base,ext)
% parse ext for .'s
dots=findstr(ext,'.');
% set up subsrefs structs
if isempty(dots)
    s=struct('type','.','subs',ext);
else
    dots=[1 dots+1 length(ext)+2];
    sbs = cell(1, length(dots)-1);
    for n=1:(length(dots)-1)
        sbs{n} = ext(dots(n):(dots(n+1)-2));
    end
    s = struct('type',repmat({'.'},1,length(dots)-1),'subs',sbs);
end
out = subsref(base,s);
return




%========================================================================
%========================================================================
% i_setfield......replacement for external setfield
%========================================================================
%========================================================================

function [out]=i_setfield(base,ext,val)
% parse ext for .'s
dots = findstr(ext,'.');
% set up subsrefs structs
if isempty(dots)
    s = struct('type','.','subs',ext);
else
    dots = [1 dots+1 length(ext)+2];
    sbs = cell(1, length(dots)-1);
    for n = 1:(length(dots)-1)
        sbs{n} = ext(dots(n):(dots(n+1)-2));
    end
    s = struct('type',repmat({'.'},1,length(dots)-1),'subs',sbs);
end
out = subsasgn(base,s,val);
return


%========================================================================
%========================================================================
% i_setmatopts......turn matrix options on or off
%========================================================================
%========================================================================

function i_setmatrixoptions(list,en)

if strcmpi(en,'on')
    set(list,'enable','on');
else
    ens=repmat({'on'},1,12);
    ens([6 6 8:end])={'off'};
    set(list,'enable',ens);
end
return


%========================================================================
%========================================================================
% i_setanimoptions......turn animated options on/off
%========================================================================
%========================================================================

function i_setanimoptions(ud,st)
if nargin<2
    st={'off','on'};
    st=st{ud.flags.animation+1};
end
% set sliding effects off
for n=1:length(ud.fx.slidefx)
    set(ud.fx.slidefx{n},'slidefx',st);
end
set(ud.fx.curtains,'curtainfx',st);
return


%========================================================================
%========================================================================
% i_switchtoviewer......orchestrate switching of viewer objects
%========================================================================
%========================================================================

function ud=i_switchtoviewer(ud,selval,figh)
switch selval
    case 0
        newobj=ud.viewers.table;
        cardnum=1;
    case 1
        newobj=ud.viewers.mvgraph1d;
        if isempty(newobj)
            % create and attach
            ud.viewers.mvgraph1d=mvgraph1d(figh,...
                'visible','off');
            attach(ud.viewers.card,ud.viewers.mvgraph1d,2);
            newobj=ud.viewers.mvgraph1d;
        end
        cardnum=2;
    case {2,3,4}
        newobj=ud.viewers.mvgraph2d;
        if isempty(newobj)
            % create and attach
            tps={'graph','sparse','image'};
            tp=tps{selval-1};
            ud.viewers.mvgraph2d=mvgraph2d(figh,...
                'visible','off',...
                'factorselection','exclusive',...
                'type',tp);
            attach(ud.viewers.card,ud.viewers.mvgraph2d,3);
            newobj=ud.viewers.mvgraph2d;
        end
        cardnum=3;
    case {5,6,7}
        newobj=ud.viewers.mvgraph3d;
        if isempty(newobj)
            % create and attach
            tps={'scatter','mesh','surface'};
            tp=tps{selval-4};
            ud.viewers.mvgraph3d=mvgraph3d(figh,...
                'visible','off',...
                'factorselection','exclusive',...
                'type',tp);
            attach(ud.viewers.card,ud.viewers.mvgraph3d,4);
            newobj=ud.viewers.mvgraph3d;
        end
        cardnum=4;
    case {8,9,10}
        newobj=ud.viewers.mvgraph4d;
        if isempty(newobj)
            % create and attach
            tps={'scatter','mesh','surface'};
            tp=tps{selval-7};
            ud.viewers.mvgraph4d=mvgraph4d(figh,...
                'visible','off',...
                'factorselection','exclusive',...
                'type',tp);
            attach(ud.viewers.card,ud.viewers.mvgraph4d,5);
            newobj=ud.viewers.mvgraph4d;
        end
        cardnum=5;
    case 11
        newobj=ud.viewers.termselect;
        if isempty(newobj)
            % create and attach
            ud.viewers.termselect=term_selector(figh,...
                'visible','off');
            updatecommand(ud.viewers.termselect,'mv_doeanalysis',{'updatemodel','%MODEL'});
            attach(ud.viewers.card,ud.viewers.termselect,6);
            newobj=ud.viewers.termselect;
        end
        cardnum=6;
end
ud.viewers.currentobject=newobj;
set(ud.viewers.card,'currentcard',cardnum);
return



function s=i_setupmatprefs
% load user-settable settings
ap=mbcprefs('mbc');
s=getpref(ap,'DesignEval');

% add static data that user can't change
s.design.coded.infostring='\itXc\rm : design/actual factor test points matrix for the experiment, in coded units.';
s.design.natural.infostring='\itXn\rm : design/actual factor test points matrix for the experiment, in natural units.';
s.fx.infostring='Full model matrix, shows all possible terms in the model.  Terms may be included and excluded from the model from here.';
s.termselect.infostring='Select terms for inclusion into or exclusion from the model.';
s.z2.infostring='\itZ_2\rm : Matrix of terms that have been removed from the model.';
s.alias.infostring=['\itA\rm : The alias matrix is defined by the expression:' char(10) char(10) ...
    '                \bfA\rm = (\bfX\rm\prime\bfX\rm)^{-1}\bfX\rm\prime\bfZ_2\rm'];
s.z21.infostring=['\itZ_{2.1}\rm : matrix defined by the expression:' char(10) char(10) ...
    '                \bfZ_{2.1}\rm = \bfZ_2\rm-\bfXA\rm'];
s.regression.infostring=['\itX\rm : regression matrix.  Consists of all terms included in the model.' ...
    '  \itn\rm\times\itp\rm matrix where \itn\rm is the number of test points in the design and \itp\rm is the number of terms in the model.'];
s.regressionstat.cov.infostring=['\itCov(b)\rm : variance-covariance matrix for the regression coefficient vector \bfb\rm.' char(10)  char(10) ...
    '                \itCov\rm(\bfb\rm) = (\bfX\rm\prime\bfX\rm)^{-1}'];
s.regressionstat.corr.infostring=['\itCorr(b)\rm : correlation matrix for the regression coefficient vector \bfb\rm.' char(10)  char(10) ...
    '  \itCorr\rm(\bfb\rm)_{ij} = \_\_\_\_\_\itCov\rm(\bfb\rm)_{ij}\_\_\_\_\_\_' char(10) ...
    '                    \surd(\itCov\rm(\bfb\rm)_{ii})\surd(\itCov\rm(\bfb\rm)_{jj})'];
s.regressionstat.partialvifs.infostring=['Measure of the non-orthogonality of the design.  The Partial VIFs are defined as:' char(10)  char(10) ...
    '            \itVIF\rm_{ij} = 1/(1-\itCorr\rm(\bfb\rm)_{ij}^2)' char(10) ...
    '                                      for p\geqi>j>1'];
s.regressionstat.multiplevifs.infostring=['Measure of the non-orthogonality of the design.  The Multiple VIFs are defined as:' char(10)  char(10) ...
    '                \itVIF\rm_{i} = \{\itCorr\rm(\bfb\rm)^{-1}\}_{ii}'];
s.regressionstat.colcorr.infostring='\itCorr(X)\rm : correlation for two columns of \bfX\rm.';
s.regressionstat.singlevifs.infostring=['Measure of the non-orthogonality of the design.  The Single Term VIFs are defined as:' char(10)  char(10) ...
    '            \itVIF\rm_{ij} = 1/(1-\itCorr\rm(\bfX\rm)_{ij}^2)' char(10) ...
    '                                      for p\geqi>j>1'];
s.hat.hat.infostring=['\itH\rm : the Hat matrix.' char(10)  char(10) ...
    '                \bfH\rm = \bfQQ\rm\prime' char(10)  char(10) ...
    'where \bfQ\rm results from a QR decomposition of \bfX\rm.'];
s.hat.leverage.infostring='The leverage values are the terms on the leading diagonal of \bfH\rm.';
s.stderror.infostring='\it\sigma_j\rm : standard error of the j^{th} coefficient relative to the RMSE.';
s.detxtx.infostring=['\itD\rm : determinant of \bfX\rm\prime\bfX\rm.  This may be displayed in three forms:' char(10) ...
    '\bullet  \mid\bfX\rm\prime\bfX\rm\mid' char(10) ...
    '\bullet  ln\mid\bfX\rm\prime\bfX\rm\mid' char(10) ...
    '\bullet  \mid\bfX\rm\prime\bfX\rm\mid^{1/p}'];
s.rawresstat.cov.infostring=['\itCov(e)\rm : variance-covariance matrix for the residuals.' char(10)  char(10) ...
    '              \itCov\rm(\bfe\rm) = (\bfI\rm - \bfH\rm)'];
s.rawresstat.corr.infostring=['\itCorr(e)\rm : correlation matrix for the residuals.' char(10)  char(10) ...
    '  \itCorr\rm(\bfe\rm)_{ij} = \_\_\_\_\_\itCov\rm(\bfe\rm)_{ij}\_\_\_\_\_\_' char(10) ...
    '                    \surd(\itCov\rm(\bfe\rm)_{ii})\surd(\itCov\rm(\bfe\rm)_{jj})'];

s.design.coded.viewers=5;
s.design.natural.viewers=5;
s.fx.viewers=3;
s.termselect.viewers=6;
s.z2.viewers=4;
s.alias.viewers=4;
s.z21.viewers=4;
s.regression.viewers=4;
s.regressionstat.cov.viewers=3;
s.regressionstat.corr.viewers=3;
s.regressionstat.partialvifs.viewers=3;
s.regressionstat.multiplevifs.viewers=3;
s.regressionstat.colcorr.viewers=3;
s.regressionstat.singlevifs.viewers=3;
s.hat.hat.viewers=3;
s.hat.leverage.viewers=4;
s.stderror.viewers=4;
s.detxtx.viewers=1;
s.rawresstat.cov.viewers=3;
s.rawresstat.corr.viewers=3;
return


function s=i_remove_static_prefs_fields(s)

fnms=fieldnames(s);
for n=1:length(fnms)
    if strcmp(fnms{n},'viewers') || strcmp(fnms{n},'infostring')
        s=mv_rmfield(s,fnms{n});
    else
        D=i_getfield(s,fnms{n});
        if isstruct(D)
            s=i_setfield(s,fnms{n},i_remove_static_prefs_fields(D));
        end
    end
end
