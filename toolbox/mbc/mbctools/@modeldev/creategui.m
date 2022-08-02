function [lyt, tblyt, View]=creategui(mdev, info)
% MODELDEV/CREATEGUI  Create the modelbrowser view
%
%  [LYT, TBLYT, VIEWDATA]=CreateGui(TP, info)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.6 $  $Date: 2004/04/12 23:34:56 $

switch mdev.ViewIndex
    case 'global'
        [lyt, tblyt, View]=CreateGlobalGui(mdev, info);
    case 'twostage'
        [lyt, tblyt, View]=CreateTSGui(mdev, info);
end


% -----------------------------------------------------
% 	SUBFUNCTION CreateTSGui
% -----------------------------------------------------
function [lyt, tblyt, View]=CreateTSGui(mdev, info)

hFig=info.Figure;
mbH= MBrowser;
p= mbH.CurrentNode;
[X,VMap] = getdata(p.info,'FIT');

View.Name= 'ResponseSweeps';
View.NumSweeps= size(VMap,3);
View.NumRows=2;
View.SperPage = View.NumRows*2;
View.Icon = 1;
View.NumPages = floor((View.NumSweeps-1)/View.SperPage)+1;
View.PageNo=1;


%-----------the subplot axes----------------------%
MarkerStyles= {'o','x','square','diamond','v','^','>','<','pentagram','hexagram'};
Colors = get(0,'defaultAxesColorOrder');
Colors= Colors(2:end,:);

for i=1:View.NumRows*2
    hAx(i)=xregaxes('parent',hFig,...
        'visible','off',...
        'buttondownfcn','mv_zoom',...
        'box','on',...
        'units','pixels',...
        'xgrid','on','ygrid','on',...
        'position',[0 0 1 1],...
        'tag','subplots',...
        'ColorOrder',Colors,...
        'FontSize',8,...
        'LineStyleOrder',MarkerStyles,...
        'nextplot','replacechildren');
    axLyt{i}=axiswrapper(hAx(i));
end
% NOTE: plot routines expect Ax handles in row-wise order hence
hAx= reshape(hAx,View.NumRows,2)';
View.AxHand = hAx(:)';

axesGrid = xreggridlayout(hFig,'correctalg','on',...
    'visible','off',...
    'dimension', [View.NumRows, 2],...
    'elements',axLyt,...
    'gap',50,'border',[50 45 20 20],...
    'packstatus','off');
View.printLayout = axesGrid;


%---------selection grid--------------------%
View.SweepClick = xregGui.clickedit(hFig,...
    'visible','off',...
    'style','leftright',...
    'min',1,...
    'max',View.NumPages,...
    'dragging','off',...
    'horizontalalignment','center',...
    'callback',{@i_SweepChange, 'SweepClick'});
SweepClickTxt = xregGui.labelcontrol('parent', hFig, ...
    'visible', 'off', ...
    'string', 'Page:', ...
    'ControlSize', 60, ...
    'Control', View.SweepClick);

SelectBtn = xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','push',...
    'units','pixels',...
    'string','Select Test...',...
    'tooltipstring','Select Test',...
    'Tag','SelectBtn',...
    'callback',{@i_SweepChange, 'SelectBtn'});

View.CILevel =xregGui.clickedit('parent',hFig,...
    'visible','off',...
    'callback',{@i_CILevel},...
    'dragging','off',...
    'rule','list',...
    'list',[90,95,99,99.9]);
CI = xregGui.labelcontrol('parent', hFig, ...
    'visible', 'off', ...
    'string', 'Confidence interval:', ...
    'ControlSize', 70, ...
    'Control', View.CILevel);

% Page progress monitor
imsrc = mbcfoundation.diskImageStrip;
imsrc.setImageStripFile(fullfile(xregrespath, 'sweep_progress.bmp'),32);
View.PageProgIndicator = xregGui.imagePlayer('parent', hFig, ...
    'visible', 'off', ...
    'imagesource', imsrc, ...
    'min', 1, ...
    'max', View.NumPages, ...
    'value', 1);
View.PageProgListeners = [handle.listener(View.SweepClick, findprop(View.SweepClick, 'max'), ...
    'PropertyPostSet', {@i_setmaxpages, View.PageProgIndicator});...
    handle.listener(View.SweepClick, findprop(View.SweepClick, 'value'), ...
    'PropertyPostSet', {@i_setpagevalue, View.PageProgIndicator});...
    handle.listener(View.SweepClick, findprop(View.SweepClick, 'enable'), ...
    'PropertyPostSet', {@i_setenable, View.PageProgIndicator})];


% keep hold of handles for disabling controls (in i_View)
% when there's no best model to see
View.Controls = SelectBtn;

CommentsTxt=xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','text',...
    'enable','inactive',...
    'HorizontalAlign','left',...
    'string','Model comments:',...
    'horizontalalignment','left');
View.Comments= xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','edit',...
    'horizontalAlign','left',...
    'min',0,'max',2,...
    'callback',{@i_Comments},...
    'BackGroundColor','w');

grd=xreggridbaglayout(hFig,...
    'visible','off',...
    'correctalg','on',...
    'dimension',[9 7],...
    'rowsizes',[4 3 8 12 2 3 10 20 -1],...
    'colsizes',[32 0 100 85 30 150 -1],...
    'gapx',5,...
    'mergeblock',{[1 6],[1 1]},...
    'mergeblock',{[3 4],[3 3]},...
    'mergeblock',{[2 5],[4 4]},...
    'mergeblock',{[1 3],[6 7]},...
    'mergeblock',{[4 9],[6 7]},...
    'mergeblock',{[8 8],[3 4]},...
    'elements',{View.PageProgIndicator, [],[],[],[],[],[],[],[], ...
    [],[],[],[],[],[],[],[],[],...
    [],[],SweepClickTxt,[],[],[],[],CI,[],...
    [],SelectBtn,[],[],[],[],[],[],[],...
    [],[],[],[],[],[],[],[],[],...
    CommentsTxt, [],[],View.Comments});

scrollFrame = xregpanellayout(hFig,...
    'visible','off',...
    'state','out', ...
    'center',grd,...
    'innerborder',[5 5 5 5],...
    'visible','off');


%---------------LAYOUTS----------------------%

View.cardLyt = xregcardlayout(hFig,'visible','off','numcards',2);
attach(View.cardLyt,axesGrid,1);

lyt = xreggridbaglayout(hFig,...
    'visible','off',...
    'dimension',[2 1],...
    'rowsizes',[80 , -1],...
    'gapy',10,...
    'elements',{scrollFrame,axesGrid});



% %-----------------Context Menu-------------------%
uic= uicontextmenu('parent',hFig);

labs = {'&Show Removed Data',...
    'Show &Transformed Units',...
    'Show Confidence &Intervals',...
    'Show &Absolute X',...
    'Show Model &Range'};
tags = {'showBD1',...
    'ytrans_units',...
    'confidence interval',...
    'absx',...
    'model range'};

% what should be checked?
PlotOpts= getpref(mbcprefs('mbc'),'LocalPlotOpts');
checked= {'off','off','off','off','off'};
checked(PlotOpts)= {'on'};
checked(~PlotOpts)= {'off'};

uicm= xregmenutool('create',uic,'Label',labs,'checked',checked,'tag',tags);
set(uicm,'callback',{@i_PlotOpts});
set(hAx,'uicontextmenu',uic);
View.Context= uicm;

uimenu('parent',uic,...
    'Label','&Print to Figure',...
    'Separator','on',...
    'callback',{@i_Copy});

% Create the toolbar to display with the mdevproject node
hToolbar = xregGui.uitoolbar('parent', double(info.Figure),...
    'ResourceLocation', xregrespath);

[tblyt, buttons] = xregtoolbar(hToolbar, {'uipush';'uipush'},...
    {'imageFile'}, {'viewCube.bmp';'data.bmp'},...
    {'Tooltipstring'}, {'View Model Definition';'View Modeling Data'},...
    {'clickedcallback'}, {@i_viewmodel;@i_viewTSModellingData},...
    'transparentcolor', [0 255 0]);
View.toolbarBtns = buttons;


% View Menu
mns=mbH.CreateMenu(guid(mdev),2);
set(mns,{'label'},{'&Model';'&View'});
View.menus.model=mns(1);
View.menus.view=mns(2);

% Model Menu
Labels={'&Evaluate...'
    'Se&lect...'};
CallBacks= {@i_Evaluate
    @i_SelectModel};

hf= zeros(size(Labels));
for i=1:length(Labels)
    hf(i)= uimenu(mns(1),...
        'label',Labels{i},...
        'Callback',CallBacks{i});
end
set(hf(1),'accelerator','E');
set(hf(2),'separator','on');
View.menus.Evaluate=hf(1);
View.menus.Select=hf(2);

% View Menu
Labels={'&Model Definition',...
    'Modeling &Data',...
    '&Next Page','&Previous Page','&Select Test...'};
CallBacks= {@i_viewmodel,...
    @i_viewTSModellingData, ...
    {@i_SweepChange, 'ViewMenuNext'},...
    {@i_SweepChange, 'ViewMenuBack'},...
    {@i_SweepChange, 'SelectBtn'}};
Tags = {'View', 'Data', 'Next','Back','Select'};

hf= zeros(size(Labels));
for i=1:length(Labels)
    hf(i)= uimenu(mns(2),...
        'tag',Tags{i},...
        'label',Labels{i},...
        'Callback',CallBacks{i});
end
set(hf(1),'Accelerator','V');
set(hf(3),'Accelerator','F');
set(hf(4),'Accelerator','B');
set(hf(3),'separator','on');

return

% -----------------------------------------------------
% 	SUBFUNCTION CreateGlobalGui
% -----------------------------------------------------
function [lyt, tblyt, View]=CreateGlobalGui(mdev, info)

% since this takes a while - give people a waitbar to look at
wb = xregGui.waitdlg('title', 'Creating Global Model View', 'parent', mvf);

hFig=double(info.Figure);

View.mfile= 'mv_GlobalReg';
m= mdev.Model;

% diagnostic plots
[f,dPlots,View]= diagnosticPlots(mdev,'create',hFig,View,'modeldev');
set(dPlots,'visible','off');

% update waitbar
wb.Waitbar.value = 0.33;

% make the view-specific toolbar
hToolbar = xregGui.uitoolbar('parent', hFig,...
    'ResourceLocation', xregrespath);

[tblyt, buttons] = xregtoolbar(hToolbar, {'uipush';'uipush';'uipush';'uipush'},...
    {'imageFile'}, {'viewCube.bmp';'boxcox.bmp';'buildModels.bmp';'data.bmp'},...
    {'Tooltipstring'}, {'View Model Definition';'Box-Cox Transform';'Build Models';'View Modeling Data'},...
    {'clickedcallback'}, {'mv_GlobalReg(''SubFigure'',''DisplayModel'')';
    'mv_GlobalReg(''SubFigure'',''Transform'')';
    @i_BuildModels; @i_viewGlobalModellingData},...
    'transparentcolor', [0 255 0]);
View.toolbarBtns = buttons(:);

% update waitbar
wb.Waitbar.value = 0.40;

%=====  Set up the main layout panels  ======
wholeSweepLyt= xregborderlayout(hFig,...
    'visible','off',...
    'center',dPlots);

plotGridLyt = xregsnapsplitlayout(hFig,...
    'visible','off',...
    'orientation','lr',...
    'split',[0.75, 0.25],...
    'leftinnerborder',[0 5 0 0],...
    'rightinnerborder',[0 0 0 5],...
    'border',[5 5 5 5],...
    'style','toright',...
    'minwidth',[400, 220],...
    'left',wholeSweepLyt);

% update waitbar
wb.Waitbar.value = 0.49;

%====== Summary stats table ======
Stbl=xregtable(hFig,...
    'visible','off',...
    'defaultcelltype','uitext',...
    'defaultcellformat','%.4g',...
    'rows.number',2,...
    'cols.number',2,...
    'rows.size',15,...
    'cols.size',88,...
    'cols.fixed',1,...
    'zeroindex',[1 2],...
    'rows.spacing',2,...
    'cols.spacing',2,...
    'frame.hborder',[2 2],...
    'frame.vborder',[2 2],...
    'frame.box','on',...
    'frame.visible','off',...
    'vslider.width',13,...
    'position',[-200 -200 100 100],...
    'redrawmode','basic');

% update waitbar
wb.Waitbar.value = 0.72;

View.SummaryStats=Stbl;

Fstats= xregframetitlelayout(hFig,...
    'title','Summary table',...
    'Center',Stbl,...
    'innerborder',[8 0 0 5],...
    'visible','off');
set(Stbl,'redrawmode','normal');


%======NORTH: buttons panel and Box Cox text (if relevant) ======
% the current model string
View.ModelString=axestext(hFig,'visible','off','clipping','on');

View.BoxCoxText = xreguicontrol(hFig,...
    'style','text',...
    'visible','off',...
    'horizontalalignment','right',...
    'backgroundcolor',get(mvf,'color'));

BoxCoxGrid = xreggridlayout(hFig,...
    'dimension',[3,2],...
    'visible','off',...
    'elements',{[],View.ModelString,[],[],View.BoxCoxText,[]},...
    'gapx',10,...
    'colsizes',[-1,80],...
    'rowsizes',[-1, 20, -1],...
    'correctalg','on');

View.infoGrid=xregpanellayout(hFig,...
    'visible','off',...
    'border',[0 5 0 0],...
    'innerborder',[5 5 10 5],...
    'center',BoxCoxGrid);

set(wholeSweepLyt,'north',View.infoGrid,...
    'innerborder',[0 0 0 42]);

%====== model dependent section - a cardlayout ======
View.Diagnosticsinfo.cards=xregcardlayout(hFig,...
    'visible','off',...
    'numcards',1);
View.Diagnosticsinfo.structs{1}= gui_diagstats(m,'create',hFig);
View.Diagnosticsinfo.ids{1}= gui_diagstats(m,'id');
View.Diagnostics= View.Diagnosticsinfo.structs{1};
attach(View.Diagnosticsinfo.cards,View.Diagnostics.layout,1);

% update waitbar
wb.Waitbar.value = 0.9;

%====== The edit box for Model Comments ======
View.Comments= xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','edit',...
    'horizontalAlign','left',...
    'min',0,'max',2,...
    'callback','mv_GlobalReg(''comments'')',...
    'BackGroundColor','w');
F{2}= xregframetitlelayout(hFig,...
    'title','Model comments',...
    'Center',View.Comments,...
    'innerborder',[10 5 5 5],...
    'visible','off',...
    'packstatus','off');

%====== The list of outliers ======
ho=xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','listbox',...
    'backgroundcolor','w',...
    'tooltipstring','double-click to see test data',...
    'string','');
txt=xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','text',...
    'HorizontalAlignment','left',...
    'string','* Data not restorable');
tolyt= xreggridlayout(hFig,...
    'dimension',[2,1],...
    'rowsizes',[-1 15],...
    'correctalg','on',...
    'visible','off',...
    'elements',{ho,txt});

F{1}= xregframetitlelayout(hFig,...
    'title','Removed data',...
    'Center',tolyt,...
    'border',[0 0 0 0],...
    'innerborder',[10 5 5 5],...
    'visible','off');
View.OutlierList=ho;

% put these together
editGrid = xreggridlayout(hFig,...
    'dimension',[2,1],...
    'visible','off',...
    'correctalg','on',...
    'rowsizes',[-1,60],...
    'elements',F);

%===== RIGHT of split: stats + notes + outliers ======
Fd= xreggridlayout(hFig,...
    'dimension',[3,1],...
    'rowsizes',[210,110, -1],...
    'correctalg','on',...
    'visible','off',...
    'gapy',5,...
    'elements',{Fstats,View.Diagnosticsinfo.cards, editGrid});

set(plotGridLyt,'right',Fd);
lyt= plotGridLyt;

% update waitbar
wb.Waitbar.value = 1;

% ======== END OF LAYOUT SETUP ===================

mbH=MBrowser;
mns=mbH.CreateMenu(guid(mdev),3);
set(mns,{'label'},{'&Model';'&View';'&Outliers'});

% Model Menu
Labels={'&Set Up...',...
    '&Reset',...
    'Summar&y Statistics',...
    '&Evaluate...',...
    'Box-Cox &Transform',...
    '&Utilities',...
    '&Make Template',...
    '&Build Models...',...
    'Se&lect...',...
    '&Assign Best'};

tags= {'setup','reset','stats','eval','Ytranstool','utilities','template','build','select','best'}';


CallBacks= {@i_Setup
    'mv_GlobalReg(''reset'')'
    @i_SummaryStats
    @i_Evaluate
    'mv_GlobalReg(''SubFigure'',''Transform'')'
    ''
    @i_MakeTemplate
    @i_BuildModels
    @i_SelectModel
    @i_AssignBest};

hf= zeros(size(Labels));
for i=1:length(Labels)
    hf(i)= uimenu(mns(1),...
        'label',Labels{i},...
        'tag',tags{i},...
        'Callback',CallBacks{i});
end
set(hf(1),'accelerator','M');
set(hf(4),'accelerator','E');
set(hf([5 7]),'separator','on');
View.menus.model= hf;


% View Menu
View.menus.view=mns(2);
Labels={'&Model Definition', 'Modeling &Data', 'Test &Numbers'};
Accel={'V','',''};
Tags = {'modelview', 'data', 'testnum'};
Callback={'mv_GlobalReg(''SubFigure'',''DisplayModel'')', @i_viewGlobalModellingData, @i_testnum};
for i=1:length(Labels)
    uimenu(View.menus.view,...
        'label',Labels{i},...
        'Callback',Callback{i},...
        'tag',Tags{i},...
        'Accelerator',Accel{i});
end

% Outliers default menu options
View.menus.tools=mns(3);
Labels={'Select &Multiple Outliers',...
    '&Clear Outliers',...
    '&Remove Outliers',...
    'Restore Removed &Data...',...
    'Co&py Outliers From...',...
    '&Selection Criteria'};
Callback={'diagnosticPlots(modeldev,''multiselect'')',...
    'diagnosticPlots(modeldev,''CancelOutliers'',mvf)',...
    'diagnosticPlots(modeldev,''ApplyOutliers'',mvf)',...
    'diagnosticPlots(modeldev,''RestoreOutliers'',mvf)',...
    'CopyOutliers(modeldev);',...
    'diagnosticPlots(modeldev,''OutliersSelect'',mvf)'};
Accel={'','','A','Z','',''};
hf= zeros(size(Labels));
for i=1:length(Labels)
    hf(i)= uimenu(View.menus.tools,...
        'tag','oulier',...
        'label',Labels{i},...
        'Callback',Callback{i},...
        'Accelerator',Accel{i});
end
View.menus.outliers= hf;

delete(wb);
return


%----------------------------------------------------------------------
%  function i_viewmodel
%----------------------------------------------------------------------
function i_viewmodel(src,event)

mbh=MBrowser;
p=mbh.CurrentNode;

if p.hasBest
    mvH= view(p.model);
end

%----------------------------------------------------------------------
%  function i_viewTSModellingData
%----------------------------------------------------------------------
function i_viewTSModellingData(src,event)

h = MBrowser;
p = h.CurrentNode;
% Get the data to send to the editor
[X, Y] = getdata(info(p), 'FIT');
% remove outliers
DataOK= true(size(Y,1),1);
DataOK(p.outliers)= false;

% Make the data all the same size
ss = [X{1} expand(X{2},tsizes(X{1})) Y];
% Need to generate the predicted Y value if we have abest model
if p.hasBest
    % Get the best model
    m = p.model;
    % Create a sweepset with the correct size
    predictedY = set(Y, 'name', {['predicted_' varname(m)]} );
    % Evaluate the model
    predictedY(:, 1) = m(X);
    % Concatenate into the sweepset
    ss = [ss predictedY];
end
ss= ss(DataOK,:);
% Open data edit facility
f = xregdataedit('create', 'CloseClickedFcn', []);
% Register as a subfigure
h.RegisterSubFigure(f);
% Send the modelling data to the data editor
f.DataMessageService.setDataObject(ss);
f.DataMessageService.isReadOnly = true;

%----------------------------------------------------------------------
%  function i_viewGlobalModellingData
%----------------------------------------------------------------------
function i_viewGlobalModellingData(src,event)

h = MBrowser;
p = h.CurrentNode;
% Get the data to send to the editor
[X, Y, DataOK] = FitData(info(p));
X= X(DataOK,:);
Y= Y(DataOK);

% Need to generate the predicted Y value
m = p.model;
% Create a sweepset with the correct size
predictedY = set(Y, 'name', {['predicted_' varname(m)]} );
% Evaluate the model
predictedY(:, 1) = m(X);
% Make the data all the same size
ss = [X Y predictedY];
% Open data edit facility
f = xregdataedit('create', 'CloseClickedFcn', []);
% Register as a subfigure
h.RegisterSubFigure(f);
% Send the modelling data to the data editor
f.DataMessageService.setDataObject(ss);
f.DataMessageService.isReadOnly = true;

%%%%%%%%%%%%%%%%%%%%%%
% Two-stage callbacks
%%%%%%%%%%%%%%%%%%%%%%%


%----------------------------------------------------------------------
%  function i_Comments
%----------------------------------------------------------------------
function i_Comments(source, null)

mbH= MBrowser;
p= mbH.CurrentNode;

m= p.model;
m= comments(m,get(source,'string'));
p.model(m);

%----------------------------------------------------------------------
%  function i_CILevel
%----------------------------------------------------------------------
function i_CILevel(source, null)
h=MBrowser;
View=h.GetViewData;
PlotOpts= num2cell(strcmp(get(View.Context,'checked'),'on'));
if PlotOpts{3} % get the requested confidence interval IF it is checked
    PR=xregGui.PointerRepository;
    ID=PR.stackSetPointer(h.Figure,'watch');
    h.ViewNode;
    PR.stackRemovePointer(h.Figure,ID);
end


% ---------------------------------------------------------------------------------------
%  function i_SweepChange
% ---------------------------------------------------------------------------------------
function i_SweepChange(source, null, str)

mbH= MBrowser;
PR=xregGui.PointerRepository;
ID=PR.stackSetPointer(mbH.Figure,'watch');
p= mbH.CurrentNode;
View= mbH.GetViewData;

switch lower(str)
    case 'sweepclick'
        OK=1;
        View.PageNo=View.SweepClick.Value;

    case 'selectbtn'

        [ptr,OK]=mv_listdlg('ListString',num2str(testnum(p.getdata)'),...
            'InitialValue',1,...
            'PromptString','Select by Test Number',...
            'Name','Select Test',...
            'ListSize',[140 200],...
            'fus',15,'ffs',15,...
            'uh',25,...
            'SelectionMode','single');

        if OK, View.PageNo=floor((ptr-1)/View.SperPage)+1; end;
        View.SweepClick.Value = View.PageNo;

    case 'viewmenunext'
        OK=1;
        View.SweepClick.Value = View.SweepClick.Value+1;
        View.PageNo = View.SweepClick.Value;

    case 'viewmenuback'
        OK=1;
        View.SweepClick.Value = View.SweepClick.Value - 1;
        View.PageNo = View.SweepClick.Value;

end %switch

if OK
    % enable/disable view menus dealt with in modeldev/view

    mbH.SetViewData(View);
    mbH.ViewNode;
end

PR.stackRemovePointer(mbH.Figure,ID);

% ---------------------------------------------------------------------------------------
% 													function i_PlotOpts
% ---------------------------------------------------------------------------------------
function i_PlotOpts(source, null)

% toggle uimenus
cs= get(gcbo,'checked');
if strcmp(cs,'on');
    set(gcbo,'checked','off');
else
    set(gcbo,'checked','on');
end

% redraw
h= MBrowser;
PR=xregGui.PointerRepository;
ID=PR.stackSetPointer(h.Figure,'watch');
View= h.GetViewData;

PlotOpts= strcmp(get(View.Context,'checked'),'on');
setpref(mbcprefs('mbc'),'LocalPlotOpts',PlotOpts)

h.ViewNode;
PR.stackRemovePointer(h.Figure,ID);

% ---------------------------------------------------------------------------------------
% 													function i_Copy
% ---------------------------------------------------------------------------------------
function i_Copy(source, null)

ax= gca;
p= get(MBrowser,'CurrentNode');

fh= figure;
ax=copyobj(ax,fh);
set(ax,'units','norm','pos',[0.1300    0.1100    0.7750    0.65]);
ax2 = axes('parent',fh,'visible','off');
set(ax2,'units','norm','pos',[0.1300    0.9    0.7750    0.09]);
best =p.bestmdev;
text('parent',ax2,'string', ['Twostage model: ', fullname(p.info), '/', best.name]);
copyobj(ax2, fh);



% --------------------------------------------------------------
% 					Global callbacks
% ---------------------------------------------------------------

function i_Setup(h,evt)

SetupModel(MBrowser);

function i_Evaluate(h,evt)

Evaluate(MBrowser);

function i_MakeTemplate(h,evt)

p= get(MBrowser,'currentnode');
p.MakeTemplate;

function i_BuildModels(h,evt)

p= get(MBrowser,'currentnode');
p.buildmodels;


function i_SelectModel(h,evt)

Validate(MBrowser);


function i_testnum(menu,event)
mbh = MBrowser;
v=mbh.GetViewData;

scAx = v.OutlierLine.g.axes;
spAx = v.OutlierLine.SpecialPlotAxes;
p = v.OutlierLine.p_mdev;

mH(1)=findobj(get(scAx,'uicontextmenu'),'Tag','Test Num');
mH(2)=findobj(get(spAx,'uicontextmenu'),'Tag','Test Num');

% View menu

% Check to see if the text is already on
txtH=findobj([scAx,spAx],'type','text',...
    'Tag','TestNumText');
if ~isempty(txtH)
    action = 'clear';
else
    action = 'draw';
end

switch action
    case 'draw'
        if p.status
            p.ShowTestNum(scAx,1);
            p.ShowTestNum(spAx,1);
            set(mH,'check','on')
            set(menu,'check','on')
        end
    case 'clear'
        delete(txtH);
        set(mH,'check','off');
        set(menu,'check','off')
end


function i_AssignBest(h,evt)

mbh = MBrowser;
mdev= info(mbh.CurrentNode);
if mdev.Status
    p= Parent(mdev);
    p.BestModel(address(mdev));
end

function i_setpagevalue(src, evt, hProg)
hProg.value = evt.NewValue;


function i_setmaxpages(src, evt, hProg)
hProg.max = evt.NewValue;

function i_setenable(src, evt, hProg)
srcobj = evt.AffectedObject;
if strcmp(evt.NewValue, 'on')
    hProg.max = srcobj.max;
    hProg.value = srcobj.value;
else
    hProg.value = 0;
end


function i_SummaryStats(src,Evt)

mbh = MBrowser;
mdev= info(mbh.CurrentNode);
if mdev.Status
    [m,OK]= gui_SummaryStats(mdev.Model);
    if OK
        mbh.SelectNode(xregpointer,1);
        % update the model statistics
        [X,Y]= getdata(mdev);
        [X,Y]= checkdata(m,X,Y);
        s= FitSummary(m,X,Y);
        mdev.Model= m;
        mdev= statistics(mdev,s);
        % view the updated node
        mbh.SelectNode(address(mdev),1);
    end
end
