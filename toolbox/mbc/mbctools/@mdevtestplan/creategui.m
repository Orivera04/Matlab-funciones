function [lyt, tblyt, View]=CreateGui(TP, info)
% CREATEGUI  Create the gui for testplan
%
%  [LYT, TBLYT, VIEWDATA]=CreateGui(TP, info)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.4.5 $  $Date: 2004/04/04 03:31:33 $

hFig=info.Figure;


h= xreguicontrol('parent',hFig,...
   'visible','off',...
	'style','text',...
	'position',[1 1 120 15],...
	'HorizontalAlignment','left',...
	'FontWeight','bold',...
	'String','Number of stages: ');
View.StageClick = xregGui.clickedit(hFig,...
   'visible','off',...
   'min',1,...
	'max',2,...
	'rule','integer',...
   'dragging','off',...
	'style','leftright',...
	'rule','integer',...
	'callback',@i_SetStages);

hStages= xregflowlayout(hFig,...
	'elements',{h,View.StageClick},...
	'orientation','left/center',...
   'packgroup','TESTPLAN_GUI',...
   'packstatus','off');


%s= xregGui.scrollaxes('parent',hFig,...
s= xregaxes('parent',hFig,...
	'visible','off',...
	'xlim',[0 300],...
	'ylim',[0 300],...
	'xtick',[],...
	'ytick',[],...
	'DefaultRectangleInterruptible','off',...
	'DefaultLineInterruptible','off',...
	'DefaultTextInterruptible','off',...
	'DefaultImageInterruptible','off',...
	'box','on',...
	'units','pixels',...
	'position',[10 10 310 310]);

View.HSM= s;

h= xreguicontrol('parent',hFig,...
   'visible','off',...
	'style','text',...
	'position',[1 1 120 20],...
	'HorizontalAlignment','left',...
	'FontWeight','bold',...
	'String','Data set:');
View.DataInfo= xreguicontrol('parent',hFig,...
   'visible','off',...
	'style','text',...
	'position',[1 1 200 80],...
	'HorizontalAlignment','left',...
	'String','Data Set');
h2= xreguicontrol('parent',hFig,...
   'visible','off',...
	'style','text',...
	'position',[1 1 120 20],...
	'HorizontalAlignment','left',...
	'FontWeight','bold',...
	'String','Notes:');
View.Notes= xreguicontrol('parent',hFig,...
   'visible','off',...
	'style','edit',...
	'min',0,'max',2,...
	'backgroundcolor','w',...
	'position',[1 1 220 300],...
	'HorizontalAlignment','left',...
	'String','');

hData= xreggridlayout(hFig,...
	'correctalg','on',...
	'dimension',[5 3],...
	'elements',{[],[],[],[],[],...
		h,View.DataInfo,[],h2,View.Notes,...
		[],[],[],[],[]},...
	'colsizes',[10 -1 20],...
	'Rowsizes',[20 120 10 20 -1],...
   'packgroup','TESTPLAN_GUI');


Brdr= xregborderlayout(hFig,...
	'north',hStages,...
   'center',axiswrapper(s),...
	'east',hData,...
   'innerborder',[20 20 250 45],...
   'packgroup','TESTPLAN_GUI');

View.layout= Brdr;
View.viewindex=info.ViewIndex;
lyt=Brdr;

tblyt=[];


%%% Menus %%%
mbH=MBrowser;
mns=mbH.CreateMenu(guid(TP),2);
set(mns,{'label'},{'&TestPlan';'&View'});
View.menus.tools=mns(1);

Labels= {'Set Up &Inputs...'
    'Set Up &Model...'
    'Design &Experiment'
    '&Boundary Constraints' 
    '&Summary Statistics...'
    '&New Data...'
    'Select &Data...'
    'Make &Template...'
    'E&xport Multimodels'};
CallBacks= {@i_Inputs
	@i_Model
	@i_Design
    @i_BoundaryConstraints
    @i_SummaryStats
	@i_LoadData
	@i_Match
	@i_MakeTemplate
    @i_ExportMulti};
hf= zeros(size(Labels));
for i=1:length(hf);
	hf(i)= uimenu(mns(1), 'Label',Labels{i}, 'Callback', CallBacks{i});
end
set(hf(2),'Accelerator','M');
set(hf(6),'separator','on');
set(hf(8),'separator','on');
View.menus.testplan= hf;
View.menus.toolschild= hf(3:end);


View.menus.view=mns(2);
View.menus.viewchild(1)=uimenu(mns(2), 'Label','&Design Data...', 'Callback', @i_ViewDesign);
View.menus.viewchild(2)=uimenu(mns(2), 'Label','&Model...', 'Callback', @i_ViewModel);

[tblyt, buttons] = xregtoolbar(hFig,{'uipush';'uipush';'uipush'},...
	{'clickedcallback'}, {@i_Design;@i_Match; @i_MakeTemplate},...
	{'tooltip'},{'Design Experiment';'Select Data';'Make Template'});

set(tblyt,'ResourceLocation',xregrespath);
set(buttons,{'ImageFile'}, {'doe.bmp';'data.bmp';'tptemplate.bmp'},...
	{'transparentcolor'}, {[0 255 0]; [0 255 0]; [0 255 0]})

View.toolbarBtns = buttons;

View.menus.ContextMenu=mbH.makeContextMenuBase;
uimenu(View.menus.ContextMenu,'separator','on','Label','Make &Template...','callback',@i_MakeTemplate);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_SetStages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_SetStages(h,evt);


mbH= MBrowser;
T= mbH.CurrentNode.info;
ViewData= mbH.GetViewData;
NStage= h.Value;
hDOE = findobj(allchild(0),'flat','tag','DOEeditor','visible','on');
hAutoMatch = findobj(allchild(0),'flat','tag','dataEditor','visible','on');
if ~isempty(hDOE) 
	uiwait(xregerror('Error','The number of stages cannot be changed while the design editor is open.'));
   h.Value= length(T.DesignDev);
	return
end
if ~isempty(hAutoMatch) 
	uiwait(xregerror('Error','The number of stages cannot be changed while the data selection tool is open.'));
   h.Value= length(T.DesignDev);
	return
end




if NStage ~= length(T.DesignDev);
    % clear any response models
    T.Responses= [];
	switch NStage
	case 1
		T.DesignDev= T.DesignDev(end);
	case 2
		% add level for stage 1
		d= designdev;
		L= localsurface(xregcubic(2));
		set(L,'Symbols',{'L1'});
		d.BaseModel=L;
		m= getModel(T.DesignDev);
		% check global models
		mcud= ModelClasses(m,4);
        nf= nfactors(m);
        T.DesignDev= [d validatemodels(T.DesignDev,1,mcud.classfuncs,xregcubic(2*ones(1,nf)))];
	end
	pointer(T);
	
    ViewData= view(T,mbH,ViewData);
    mbH.SetViewData(ViewData);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_Match
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OK=i_Match(obj, nul)

mbH=MBrowser;
p=mbH.CurrentNode;
View=mbH.GetViewData(p.guid);

hDOE = findobj(allchild(0),'flat','tag','DOEeditor','visible','on');
hAutoMatch = findobj(allchild(0),'flat','tag','dataEditor','visible','on');



OK=0;
if isempty(hDOE)
    T= p.info;
    set(mbH.Figure,'pointer','watch');
    if ~T.Matched & isempty(hAutoMatch);
        [T,OK] = datawizard(T);
        if OK
            mbH.ViewNode;
            mbH.listview;
        end
    else
        OK=1;
        % add actual design to tssf before calling matching
        h = sendObjectToDataEditor(T, T.DataLink);
    end
    set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));
else
    xregerror('Error','Data cannot be selected while the design editor is open');
end
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_MakeTemplates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_MakeTemplate(obj,nul);

mbH=MBrowser;
p=mbH.CurrentNode;
p.TemplateDialog;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ModelBoundary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_BoundaryConstraints(obj,nul);

mbH = MBrowser;
p = mbH.CurrentNode;
set( mbH.Figure, 'pointer', 'watch' );
drawnow

T = p.info;

% setup friend model
m = HSModel( T.DesignDev );
nf = nfactors( m );
friend = copymodel( m, xregmodel( 'nfactors', nf ) );
c = getcode( friend );
friend = setcode( friend, c, '' ); % set target range to [-1, 1]

if T.ConstraintData == 0,
    % need to make new bdry tree
    
    [X,friend,broot]= MakeBdryData(T);
    
    T.ConstraintData = address( broot );
else
    broot = T.ConstraintData.info;
end
figh = xregbdrymodeleditor( broot );
p.info = T;

mbH.RegisterSubFigure( figh );
set( mbH.Figure, 'pointer', get(0,'DefaultFigurePointer') );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_Design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Design(obj,nul)

mbH=MBrowser;
p=mbH.CurrentNode;
View=mbH.GetViewData(p.guid);

hAutoMatch = findobj(allchild(0),'flat','tag','dataEditor','visible','on');
if ~isempty(hAutoMatch)
	xregerror('Error','The design editor cannot be used while the data selection figure is open');
	return
end


T= p.info;
Stage= find(strcmp(get(View.hHSM.hBorder,'selected'),'on'));
if isempty(Stage)
   Stage= find(strcmp(get(View.hHSM.pBorder,'selected'),'on'));
   if Stage> length(T.DesignDev)
      Stage= length(T.DesignDev);
   end
end
	
fcall= get(View.hHSM.Menu(2),'callback');
feval(fcall,[],[],Stage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ViewDesign
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ViewDesign(obj,nul)

mbH=MBrowser;
p=mbH.CurrentNode;
View=mbH.GetViewData(p.guid);

hDOE = findobj(allchild(0),'flat','tag','DOEeditor','visible','on');
if ~isempty(hDOE)
	xregerror('Error','The design viewer cannot be used while the design editor is open');
	return
end

T= p.info;
Stage= find(strcmp(get(View.hHSM.hBorder,'selected'),'on'));
if isempty(Stage)
   Stage= find(strcmp(get(View.hHSM.pBorder,'selected'),'on'));
   if Stage> length(T.DesignDev)
      Stage= length(T.DesignDev);
   end
end

fcall= get(View.hHSM.Menu(3),'callback');
feval(fcall,[],[],Stage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ViewModel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ViewModel(obj,nul)

mbH=MBrowser;
p=mbH.CurrentNode;
View=mbH.GetViewData(p.guid);
T= p.info;


NStages= length(T.DesignDev);
Stage= find(strcmp(get(View.hHSM.hBorder,'selected'),'on'));
if NStages==1 & isempty(Stage)
   Stage= find(strcmp(get(View.hHSM.pBorder,'selected'),'on'));
   if  Stage>NStages
      Stage= NStages;
   end
end
if ~isempty(Stage) 
   fcall= get(View.hHSM.Menu(4),'callback');
   feval(fcall,[],[],Stage);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_Input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Inputs(h,evt)

mbH=MBrowser;
p=mbH.CurrentNode;
View=mbH.GetViewData(p.guid);

T= p.info;
NStages= length(T.DesignDev);
Stage= find(strcmp(get(View.hHSM.pBorder,'selected'),'on'));
if NStages==1 
   if isempty(Stage) 
      Stage= find(strcmp(get(View.hHSM.hBorder,'selected'),'on'));
   elseif  Stage>NStages
      Stage= NStages;
   end
end
if ~isempty(Stage) 
   fcall= get(View.hHSM.hInput(Stage),'buttondownfcn');
   feval(fcall{:});
end

%-----------------------------
function [hDOE,hAutoMatch]= i_FindDOE;

hDOE       = findobj(allchild(0),'flat','tag','DOEeditor','visible','on');
hAutoMatch = findobj(allchild(0),'flat','tag','dataEditor','visible','on');

%-----------------------------
function i_SummaryStats(h, evt)

mbH = MBrowser;
p = mbH.CurrentNode;
T = p.info;
D = T.DesignDev;
View= mbH.GetViewData;

NStages= length(D);
if nargin<3
	Stage= get(gco,'userdata');
end

[hDOE,hAutoMatch]= i_FindDOE;
if ~isempty(hDOE) | ~isempty(hAutoMatch)
	xregerror('Error','The model statistics cannot be defined while the design editor or the data selection figure is open');
	return
end

d = D(Stage);
m = getModel(d);

set(View.hHSM.hStage(Stage),'facecolor',View.hHSM.Colors.Selected);
% setup gui
[m,OK]= gui_SummaryStats(m);
set(View.hHSM.hStage(Stage),'facecolor',View.hHSM.Colors.Model);

set(View.hHSM.hModel(Stage),'string',name(m))

if OK
	d = setmodel(d,m);
    D(Stage) = d;
    p.designdev(D);
end

%-----------------------------
function i_PutDesignDev(ds,Stage);

% store in base workspace for now

p= get(MBrowser,'CurrentNode');
d= p.designdev;

d= DesignDev2Cell(d);
d{Stage}=ds;
d= Cell2DesignDev(d);

p.designdev(d);


%-----------------------------
function i_Model(h,evt);

SetupModel(MBrowser);


%-----------------------------
function i_LoadData(h,evt);

h = MBrowser;
p = h.CurrentNode;
View = h.GetViewData;

hDOE = findobj(allchild(0),'flat','tag','DOEeditor','visible','on');
hAutoMatch = findobj(allchild(0),'flat','tag','dataEditor','visible','on');

if isempty(hDOE) && isempty(hAutoMatch)

    MP = info(p.project);
    T = p.info;
    if T.Matched
        resp= questdlg('Loading new data for the test plan will change all the test plan response models. Do you want to continue?',...
            'Data Loading','Yes','No','No');
        if strcmp(resp,'No')
            return
        end
    end
    
    
    set(h.figure, 'pointer', 'watch')
    drawnow
    D= T.DesignDev;
    Dold= D;
    [des,index]= ActualDesign(D);
    if strcmp(name(des),'Actual Design')
        % delete actual design
        T.DesignDev= DeleteDesign(D,index);
        xregpointer(T);
    end
    
    [T,OK] = datawizard(T);
    if OK
        % force a complete redraw
        h.ViewNode;
        h.listview;
    else
        % restore designdev
        T.DesignDev= Dold;
        xregpointer(T);
    end
    
    
    set(h.figure,'pointer','arrow')
end



function i_ExportMulti(src,evt);
mbh= MBrowser;
p = get(mbh,'CurrentNode');
dname= xregGetDefaultDir('Models');
[fname,pathname]=uiputfile(fullfile(dname,'*.mat'),'Export to Multi-Model Trade off');
drawnow
if isstr(fname)
   mv_busy('Saving all local models...');
   [pth, f,e]= fileparts(fullfile(pathname,fname));
   if isempty(e)
       e= '.mat';
   end
   
   p.AllLocalModels(fullfile(pth,[f,e]));
   mv_busy('delete')
end
