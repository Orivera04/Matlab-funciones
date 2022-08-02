function varargout= IndptSweeps(Action,varargin)
% INDPTSWEEPS test plots for MBC model evaluation tool

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.9.4.2 $  $Date: 2004/02/09 08:01:49 $

switch lower(Action)
case 'create'
   [varargout{1:2}]= i_Create(varargin{:});
case {'modelselect','draw'}
   i_draw(gcbf);
case 'select'
   i_Select;
case 'step'
   i_step(varargin{:});
case 'view'
   i_View(varargin{:});
case 'plotopts'
   i_PlotOpts;
case 'print'
   i_Print(varargin{:});
end



function [Tool, mainLyt]= i_Create(hFig,NumSweeps,NoPRESS);

Tool.Name= '&Tests';
Tool.mfile= mfilename;
Tool.Icon = 'validatesweeps.bmp';
Tool.NumSweeps= NumSweeps;
Tool.NumRows=2;
Tool.SperPage = Tool.NumRows*2;
Tool.NumPages = floor((NumSweeps-1)/Tool.SperPage)+1;
Tool.MultiSelect=1;
Tool.Renderer = 'painters';

if nargin<4 NoPRESS=0; end;


%%-----------the subplot axes----------------------%%
MarkerStyles= {'o','x','square','diamond','v','^','>','<','pentagram','hexagram'};
Colors = get(0,'defaultAxesColorOrder');
Colors= Colors(2:end,:);

for i=1:Tool.NumRows*2 
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
%% NOTE: plot routines expect Ax handles in row-wise order hence
Tool.AxHand = [hAx(1), hAx(3), hAx(2), hAx(4)] ;

%%---------selection grid--------------------%%
SweepClickTxt = xreguicontrol('parent',hFig,...
   'visible','off',...
   'style','Text',...
   'units','pixels',...
   'string','Page:');

Tool.SweepClick = xregGui.clickedit(hFig,...
   'visible','off',...
   'style','leftright',...
   'min',1,...
   'max',Tool.NumPages,...
   'dragging','off',...
   'horizontalalignment','center',...
   'callback',{@i_SweepChange, 'SweepClick'});

SelectBtn = xreguicontrol('parent',hFig,...
   'visible','off',...
   'style','push',...
   'units','pixels',...
   'string','Select Test...',...
   'tooltipstring','Select Test Number',...
   'Tag','SelectBtn',...
   'callback',{@i_SweepChange, 'SelectBtn'});

ConfIntTxt=xreguicontrol('parent',hFig,...
   'visible','off',...
   'style','text',...
   'enable','inactive',...
   'HorizontalAlign','left',...
   'string','Confidence Interval:');
CILevel =xregGui.clickedit('parent',hFig,...
   'visible','off',...
   'callback',{@i_CILevel},...
   'dragging','off',...
   'rule','list',...
   'list',[90 95 99 99.9]);
Tool.CILevel= CILevel;

%%-----------------Legend--------------------%%
legendText=xreguicontrol('parent',hFig,...
   'visible','off',...
   'pos',[1 1 10 10],...
   'style','text',...
   'HorizontalAlign','left',...
   'string','Legend:');
hLegend=xregaxes('parent',hFig,...
   'visible','off',...
   'units','pixels',...
   'pos',[1 1 10 10],...
   'xlim',[0 1],'ylim',[0 1],...
   'box','on',...
   'xtick',[],'ytick',[],...
   'DefaultTextFontSize',8,...
   'DefaultTextFontName','Lucida Console');
legendWrapper = axiswrapper(hLegend);

%%---------------LAYOUTS----------------------%%
infoGrid=xreggridbaglayout(hFig,...
   'packstatus','off',...
   'dimension',[11 7],...
   'rowsizes',[3 4 8 7 1 2 10 4 15 1 -1],...
   'colsizes',[30 60 15 70 30 150 -1],...
   'gapx',5,...
   'mergeblock',{[1 6],[3 4]},...
   'mergeblock',{[2 5],[2 2]},...
   'mergeblock',{[3 4],[1 1]},...
   'mergeblock',{[8 10],[4 4]},...%% clickedit
   'mergeblock',{[9 9],[1 3]},...%% conf text
   'mergeblock',{[1 3],[6 7]},...%%legend text
   'mergeblock',{[4 11],[6 7]},...%% legend
   'elements',{...
       [],[],SweepClickTxt,[],[],[],[],[],ConfIntTxt,[],[],...
       [],Tool.SweepClick,[],[],[],[],[],[],[],[],[],...
       SelectBtn,[],[],[],[],[],[],[],[],[],[],...
       [],[],[],[],[],[],[],CILevel,[],[],[],...
       [],[],[],[],[],[],[],[],[],[],[],...
       legendText,[],[],legendWrapper});

infoFrame = xregframetitlelayout(hFig,'visible','off',...
   'center',infoGrid);

els = cell((Tool.NumRows*2 + 1),5);
els{1} = infoFrame;
els(3:2:end,2) = axLyt(1:Tool.NumRows);
els(3:2:end,4) = axLyt(Tool.NumRows+1:end);
mainLyt=xreggridbaglayout(hFig,'dimension',[(Tool.NumRows*2 + 1) 5],...
   'rowsizes',[120 25 -1 repmat([50 -1],1,Tool.NumRows-1)],...
   'colsizes',[40 -1 50 -1 10],...
   'mergeblock',{[1 1],[1 5]},...
   'border',[10 50 10 5],...
   'elements',els);
Tool.mainLyt=mainLyt;

%%-----------------Context Menu-------------------%%
uic= uicontextmenu('parent',hFig);

labs= {'Show &Outliers',...
      '&Transformed Units',...
      '&Confidence Intervals',...
      '&Absolute X',...
      'Model &Range'};
checked= {'on','off','on','on','on'};

uicm= xregmenutool('create',uic,'Label',labs,'checked',checked);
set(uicm,'callback',[mfilename,'(''PlotOpts'')']);
set(hAx,'uicontextmenu',uic);

Tool.Context= uicm;
Tool.Hand= {ConfIntTxt,CILevel};
Tool.Legend= hLegend;
Tool.PageNo=1;

% help options
Tool.helpmenus={'&Tests Help','xreg_modEval_tests'};


% -----------------------------------------------------
% 	SUBFUNCTION i_View
% -----------------------------------------------------
function i_View(hFig,varargin)

if nargin == 1
   [Tool,ModelInfo,ModelList]= i_GetTool(hFig);
else
   [Tool,ModelInfo,ModelList]= deal(varargin{:});
end
i_draw(hFig,Tool,ModelInfo{:},ModelList);



% -----------------------------------------------------
% 	SUBFUNCTION i_draw
% -----------------------------------------------------
function i_draw(hFig,Tool,ModelNos,p,m,null,ModelList)

X = getdata(p.info,'FIT');
%% get the data
[ValX,ValY]= valdata(p.info);
Xloc= ValX{1};
Xg = ValX{2};

G= model(p.mdevtestplan);
VarSym= char(get(G,'symbol'));

ax= Tool.AxHand;
% set all axes vis=on since some may have been off in last view
% (will do necessary turn vis off below)
set(ax,'visible','on');

PageNo=Tool.PageNo;
% Find out the loop size...depends if we are on last page
if PageNo== Tool.NumPages;	% we are on the last page...
   N=size(ValX{1},3) - (Tool.NumPages-1)*Tool.SperPage;
   % do not necessarily want to display all graphs
   AxH=ax(N+1:end);
   set(findobj(AxH),'visible','off');
else
   N=Tool.SperPage;
end
% select the sweeps for this page
SNos= (PageNo-1)*Tool.SperPage+1:(PageNo-1)*Tool.SperPage+N;


AllModelNos= cat(2,ModelNos{:});
TS= m(AllModelNos);
nl= nlfactors(TS{1});

MultiModel= length(AllModelNos)>1;

ptr= get(hFig,'pointer');
set(hFig,'pointer','watch');


% Clear axes, if already drawn...
h1=get(ax(1:end),{'children'});
ph=[ cat(1,h1{:})];
delete(ph);

Colors= get(ax(1),'ColorOrder');
Markers= get(ax(1),'LineStyleOrder');

PlotOpts= num2cell(strcmp(get(Tool.Context,'checked'),'on'));
%% if conf int checked - get user specified value
if PlotOpts{3}
   PlotOpts{3} = get(Tool.CILevel,'value');
end

for k=1:N			% N=1,2 or 3;
   
   Xs= Xloc(:,:,SNos(k));
   Ys= ValY(:,:,SNos(k));
   Xgs = Xg(:,:,SNos(k));
   % Display Experimental Point (Natural and Code values)
   % data to display Experimental Point (Natural and Coded values)
   natural= double(Xgs);
   coded= code(G,natural);
   globVarStr= [VarSym, blanks(size(coded,2))',...
         num2str(natural','%10.4g'), blanks(size(coded,2))',...
         num2str(coded','%5.2f')];
   
   dispstr= sprintf('%10s','s');
   
   % plot results  (Blue points real data , blue line Local regression fit , Green Line 
   set(hFig,'CurrentAxes',ax(k))
   set(ax(k),...
      'XLimMode','auto','YLimMode','auto',...
      'nextplot','add',...
      'ButtonDownFcn','mv_zoom')
   set(get(ax(k),'zlabel'),'userdata',[]);
   
   AxCols= Colors;
   AxMarks= Markers;
   
   for i=1:length(TS)
      % validation plot
      sNumStr = sweep_plot(TS{i},{Xs,Xgs},Ys,ax(k),PlotOpts);
      
      %%create info str for tooltip patch
      blnks = repmat(' ',[size(globVarStr,1)-2,1]);
      infoStr= strvcat(sprintf('%10s','s'),sNumStr,blnks);
      infoStr = strcat(globVarStr, infoStr);
      
      dataPatchFcnHandle = dataPatch(ax(k),infoStr,1);
      
      AxCols= AxCols([2:end 1],:);
      AxMarks= AxMarks([2:end 1]);
      
   end
   set(ax,'ColorOrder',Colors,'LineStyleOrder',Markers);
   
   set(get(ax(k),'title'),'string',sprintf('Test %1d',testnum(Xgs)))   
   set(ax(k),'NextPlot','ReplaceChildren',...
      'buttonDownFcn',{@i_AxButtonDown, dataPatchFcnHandle, infoStr});
end

%----------- LEGEND STUFF ----------------
delete(get(Tool.Legend,'children'));
ht= .98;
Markers= repmat(Markers,ceil(length(AllModelNos)/length(Markers)),1);
Colors= repmat(Colors,ceil(length(AllModelNos)/length(Colors)),1);

for i=1:length(AllModelNos);
   xregline('xdata',[.02 .08],'ydata',[ht ht]-0.05,...
      'Marker',Markers{i},...
      'LineWidth',1.5,...
      'Color',Colors(i,:),...
      'Parent',Tool.Legend);
   th=xregtext('pos',[.1 ht],'string',ModelList{i},...
      'horizon','left','vert','top',...
      'clipping','on',...
      'interpreter','none',...
      'Parent',Tool.Legend);
   Textent= get(th,'extent');
   ht= ht-Textent(4);
end

%% XLABELS OF AXES
xlh=get(ax,{'xlabel'});
if ~isempty(xlh)
   set([xlh{:}]'   ,'visible','off');
end
xlh=get(ax(max(1,N-1):N),{'xlabel'});
set([xlh{:}]'   ,'visible','on','fontsize',8);

set(hFig,'pointer',ptr);

%----------------------------------------------------------------------
%  function i_CILevel
%----------------------------------------------------------------------
function i_CILevel(source, null)

h=MBrowser;
View=h.GetViewData;
PR=xregGui.PointerRepository;
ID=PR.stackSetPointer(h.Figure,'watch');
i_View(gcbf);
PR.stackRemovePointer(h.Figure,ID);

% ---------------------------------------------------------------------------------------
%  function i_SweepChange
% ---------------------------------------------------------------------------------------
function i_SweepChange(source, null, str)

[Tool,ModelInfo,ModelList]= i_GetTool(gcbf);

switch str
case 'SweepClick'
   OK=1;
   Tool.PageNo=Tool.SweepClick.Value;
   
case 'SelectBtn'
   p= ModelInfo{2};
   VMap= p.valdata;
   [p,OK]=mv_listdlg('ListString',num2str(testnum(VMap{1})'),...
      'InitialValue',1,...
      'PromptString','Select test by Log Number',...
      'Name','Select Test',...
      'ListSize',[140 200],...
      'fus',15,'ffs',15,...
      'uh',25,...
      'SelectionMode','single');
   
   if OK
      Tool.PageNo=floor((p-1)/Tool.SperPage)+1;
      Tool.SweepClick.Value = Tool.PageNo;
   end
end %%switch

if OK
   i_SetTool(gcbf,Tool)   
   i_View(gcbf,Tool,ModelInfo,ModelList);
end

% ---------------------------------------------------------------------------------------
% 													function i_PlotOpts
% ---------------------------------------------------------------------------------------
function i_PlotOpts

% toggle uimenus
cs= get(gcbo,'checked');
if strcmp(cs,'on');
   set(gcbo,'checked','off');
else
   set(gcbo,'checked','on');
end 
% redraw
i_View(gcbf);


% ---------------------------------------------------------------------------------------
% 													function i_Print
% ---------------------------------------------------------------------------------------
function i_Print(Tool,Name);

aH = reshape(Tool.AxHand,2,length(Tool.AxHand)/2)';
lyt1= findobj(aH,'flat','visible','on');
lyt2= Tool.Legend;
printlayout1(lyt1,lyt2,Name);

% ---------------------------------------------------------------------------------------
% 													function i_GetTool
% ---------------------------------------------------------------------------------------
function [Tool,ModelInfo,ModelList]=i_GetTool(hFig);

if nargout>1
   [Tool,ModelInfo,ModelList]=mv_ValidationTool('get',hFig);
else
   [Tool]=mv_ValidationTool('get',hFig);
end

% ---------------------------------------------------------------------------------------
% 													function i_SetTool
% ---------------------------------------------------------------------------------------
function i_SetTool(hFig,Tool);

ud= get(hFig,'userdata');


mv_ValidationTool('set',hFig,Tool);

% ---------------------------------------------------------------------------------------
% 													function i_AxButtonDown
% ---------------------------------------------------------------------------------------
function i_AxButtonDown(ax, null, dataPatchFcnHandle, str)

downtype=get(gcbf ,'SelectionType');
switch downtype
case {'extend','open'}
   mv_zoom;
case 'normal'
   feval(dataPatchFcnHandle,ax,[],str);
end