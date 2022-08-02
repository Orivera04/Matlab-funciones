function varargout= ValidateSweeps(Action,varargin)
%VALIDATESWEEPS Local tests plots for validation tool

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.10.4.4 $  $Date: 2004/02/09 08:01:50 $

switch lower(Action)
case 'create'
   [varargout{1:2}] = i_Create(varargin{:});
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
case 'copy'
   i_Copy(varargin{:});
end



function [Tool, mainLyt] = i_Create(hFig,NumSweeps,NoPRESS)
% returns mainLyt, unpacked and invisible

Tool.Name= '&Tests';
Tool.mfile= mfilename;
Tool.Icon = 'validatesweeps.bmp';
Tool.NumSweeps= NumSweeps;
Tool.NumRows=2;
Tool.SperPage = Tool.NumRows*2;
Tool.NumPages = floor((NumSweeps-1)/Tool.SperPage)+1;
Tool.MultiSelect=1;
Tool.Renderer='painters';

if nargin<3, NoPRESS=0; end;

%-----------the subplot axes----------------------%
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
% NOTE: plot routines expect Ax handles in row-wise order hence
hAx= reshape(hAx,Tool.NumRows,2)';
Tool.AxHand = hAx(:)';

%---------selection grid--------------------%
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
   'fontsize',get(hFig,'defaultuicontrolfontsize'),...
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
   'fontsize',get(hFig,'defaultuicontrolfontsize'),...
   'rule','list',...
   'list',[90 95 99 99.9]);
Tool.CILevel= CILevel;

%-------------plot options popups---------------------%
Type={'Normal','PRESS'};
predText=xreguicontrol('parent',hFig,...
   'visible','off',...
   'pos',[1 1 100 15],...
   'style','text',...
   'HorizontalAlign','left',...
   'string','Prediction Type:');
predType=xreguicontrol('parent',hFig,...
   'visible','off',...
   'pos',[1 1 100 15],...
   'style','popup',...
   'HorizontalAlign','left',...
   'BackGroundColor','w',...
   'callback',[mfilename,'(''view'',gcbf)'],...
   'value',1,...
   'string',Type);
Tool.PredType= predType;

if NoPRESS
   set(predType,'enable','off');
end

%-----------------Legend--------------------%
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


%---------------LAYOUTS----------------------%
infoGrid=xreggridbaglayout(hFig,...
   'packstatus','off',...
   'correctalg','on',...
   'dimension',[15 7],...
   'rowsizes',[3 4 8 7 1 2 10 4 15 1 10 4 15 1 -1],...
   'colsizes',[30 60 15 70 30 150 -1],...
   'gapx',5,...
   'mergeblock',{[1 6],[3 4]},...
   'mergeblock',{[2 5],[2 2]},...
   'mergeblock',{[3 4],[1 1]},...
   'mergeblock',{[8 10],[4 4]},...% clickedit
   'mergeblock',{[9 9],[1 3]},...% conf text
   'mergeblock',{[12 14],[4 4]},...% predType
   'mergeblock',{[13 13],[1 3]},...% pred text
   'mergeblock',{[1 3],[6 7]},...%legend text
   'mergeblock',{[4 15],[6 7]},...% legend
   'elements',{...
       [],[],SweepClickTxt,[],[],[],[],[],ConfIntTxt,[],[],[],predText,[],[]...
       [],Tool.SweepClick,[],[],[],[],[],[],[],[],[],[],[],[],[],...
       SelectBtn,[],[],[],[],[],[],[],[],[],[],[],[],[],[],...
       [],[],[],[],[],[],[],CILevel,[],[],[],predType,[],[],[],...
       [],[],[],[],[],[],[],[],[],[],[],[],[],[],[],...
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

%-----------------Context Menu-------------------%
uic= uicontextmenu('parent',hFig);

labs= {'Show Removed &Data',...
      'Show &Transformed Units',...
      'Show &Confidence Intervals',...
      'Show &Absolute X',...
      'Show Model &Range'};
checked= cell(5,1);
PlotOpts= getpref(mbcprefs('mbc'),'LocalPlotOpts');
checked(PlotOpts)= {'on'};
checked(~PlotOpts)= {'off'};

uicm= xregmenutool('create',uic,'Label',labs,'checked',checked);
set(uicm,'callback',[mfilename,'(''PlotOpts'')']);
set(hAx,'uicontextmenu',uic);

uimenu('parent',uic,...
   'Label','&Print to Figure',...
   'Separator','on',...
   'callback',[mfilename,'(''Copy'')']);

Tool.Context= uicm;
Tool.Hand= {ConfIntTxt,CILevel,predText,predType};
Tool.Legend= hLegend;
Tool.printLayout = xreggridlayout(hFig,'correctalg','on',...
   'dimension',[2 2],...
   'gap',50,...
   'border',[50 50 20 20],...
   'elements',axLyt);
Tool.PageNo=1;

Tool.helpmenus={'&Tests Help','xreg_modSel_tests'};

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
function i_draw(hFig,Tool,ModelNos,p,m,MLEMode,ModelList)


% we arrive from Response node model/evaluation with p.info = modeldev
mbh=MBrowser;
if strcmp(p(1).guid,'twostage')
   p = p(1).bestmdev;
end


ax= Tool.AxHand;
% set all axes vis=on since some may have been off in last view
% (will do necessary turn vis off below)
set(ax,'visible','on');


% get the data
X = getdata(p(1).info,'FIT');
XG= X{end};
TS= m{1};
VarSym= get(TS,'symbol');
VarSym= char(VarSym(nlfactors(TS)+1:end));

PageNo=Tool.PageNo;
% Find out the loop size...depends if we are on last page
if PageNo== Tool.NumPages;	% we are on the last page...
   N=size(XG,3) - (Tool.NumPages-1)*Tool.SperPage;
   % do not necessarily want to display all graphs
   AxH=ax(N+1:end);
   set(findobj(AxH),'visible','off');
else
   N=Tool.SperPage;
end

% select the sweeps for this page
SNos= (PageNo-1)*Tool.SperPage+1:(PageNo-1)*Tool.SperPage+N;

XGlobal= XG(:,:,SNos);


PredType= get(Tool.PredType,'value');
AllModelNos= cat(2,ModelNos{:});

MultiModel= length(AllModelNos)>1;

set(hFig,'pointer','watch');

% Clear axes, if something already drawn...
h1=get(ax(1:end),{'children'});
ph= cat(1,h1{:});
delete(ph);

% the colors and markers we want to use are set in every axes.
% get them from the first axes.
Colors= get(ax(1),'ColorOrder');
Markers= get(ax(1),'LineStyleOrder');

PlotOpts= num2cell(strcmp(get(Tool.Context,'checked'),'on'));
if MultiModel 
   % can't do transformations/AbsX for multimodels
   set(Tool.Context(2),'enable','off');
   set(Tool.Context(4),'enable','off');
   
   if PlotOpts{2}
      set(Tool.Context(2),'checked','off');
      PlotOpts{2}= 0;
   end
   if ~PlotOpts{4}
      set(Tool.Context(4),'checked','on')
      PlotOpts{4}= 1;
   end
else
   set(Tool.Context(2),'enable','on');
   set(Tool.Context(4),'enable','on');
end

% get the requested confidence interval IF it is checked
if PlotOpts{3}
   PlotOpts{3} = get(Tool.CILevel,'value');
end


PlotModes= {PredType,MultiModel,MLEMode};

for k=1:N	% N=number of plots for this page;
   % Display Experimental Point (Natural and Code values)
   % data to display Experimental Point (Natural and Coded values)
   natural= XGlobal{k};

   globVarStr= [VarSym, blanks(size(natural,2))',...
         num2str(natural','%10.4g')];
   
   % plot results  (Blue points real data , blue line Local regression fit , Green Line 
   set(hFig,'CurrentAxes',ax(k))
   set(ax(k),...
      'XLimMode','auto','YLimMode','auto',...
      'nextplot','add')
   set(get(ax(k),'zlabel'),'userdata',[]);
   
   AxCols= Colors;
   AxMarks= Markers;

   for i=1:length(p)
       % get the data; already have TP, XG   
       % the local model
       mdevL = p(i).info;
       % X and Y data for this sweep
       [X,Y]= getdata(mdevL,'FIT');
       Xs= X{1}(:,:,SNos(k));
       XG= X{2}(:,:,SNos(k));
       Ys= Y(:,:,SNos(k));
       
       set(ax,'ColorOrder',AxCols,'LineStyleOrder',AxMarks);
       
       [RfStr, SigStr] = sweep_plot(mdevL, {Xs,XG}, Ys,...
           ModelNos{i}, SNos(k), ax(k), PlotOpts, PlotModes);
       
      % create a formatted string array of info
      numBlankLines = size(globVarStr,1)-2;
      if numBlankLines<0
         % globVarStr is only one line! pad this upto 2 lines
         globVarStr = strvcat(globVarStr,' ');
         statStr = strvcat(sprintf('%10s %10s %10s','T^2','-log L','s'),SigStr);
      else % pad statStr upto size of globVarStr
         blnks = repmat(' ',[size(globVarStr,1)-2,1]);
         statStr = strvcat(sprintf('%10s %10s %10s','T^2','-log L','s'),SigStr,blnks);
      end
      dataStr = strvcat(cat(2,globVarStr,statStr),' ', ' ', RfStr);      
      dataPatchFcnHandle = dataPatch(ax(k),dataStr,1);
      
      AxCols= AxCols([2:end 1],:);
      AxMarks= AxMarks([2:end 1]);
      
   end
   set(ax,'ColorOrder',Colors,'LineStyleOrder',Markers);

   set(get(ax(k),'title'),'string',sprintf('Test %1d',testnum(XG)))   
   set(ax(k),'NextPlot','ReplaceChildren');
   set(ax(k),'buttonDownFcn',{@i_AxButtonDown, dataPatchFcnHandle, dataStr, Tool.mainLyt});
end

%---------- LEGEND stuff -------------
delete(get(Tool.Legend,'children'));
ht= .98;
if strcmp(mbh.CurrentNode.guid,'local') || length(AllModelNos)==1
   xregline('xdata',[.02 .08],'ydata',[ht ht]-0.05,...
      'Color',[0 0 0],...
      'LineWidth',1.5,...
      'Parent',Tool.Legend);
   th=xregtext('pos',[.1 ht],'string','Local Fit',...
      'horizon','left','vert','top',...
      'clipping','on',...
      'interpreter','none',...
      'Parent',Tool.Legend);
   Textent= get(th,'extent');
   ht= ht-Textent(4);
end
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

% XLABELS OF AXES
xlh=get(ax,{'xlabel'});
if ~isempty(xlh)
   set([xlh{:}]'   ,'visible','off');
end
xlh=get(ax(max(1,N-1):N),{'xlabel'});
set([xlh{:}]'   ,'visible','on','fontsize',8);

set(hFig,'pointer',get(0,'DefaultFigurePointer'));

%----------------------------------------------------------------------
%  function i_CILevel
%----------------------------------------------------------------------
function i_CILevel(source, null)

h=MBrowser;
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
   [p,OK]=mv_listdlg('ListString',num2str(testnum(p.getdata)'),...
      'InitialValue',1,...
      'PromptString','Select by Test Number',...
      'Name','Select Test',...
      'ListSize',[140 200],...
      'fus',15,'ffs',15,...
      'uh',25,...
      'SelectionMode','single');
   if OK
      Tool.PageNo=floor((p-1)/Tool.SperPage)+1;
      Tool.SweepClick.Value = Tool.PageNo;
   end
end %switch

if OK
   i_SetTool(gcbf,Tool)   
   i_View(gcbf,Tool,ModelInfo,ModelList);
end
% ---------------------------------------------------------------------------------------
% 													function i_PlotOpts
% ---------------------------------------------------------------------------------------
function i_PlotOpts

hFig= gcbf;
% toggle uimenus
cs= get(gcbo,'checked');
if strcmp(cs,'on');
   set(gcbo,'checked','off');
else
   set(gcbo,'checked','on');
end 

[Tool,ModelInfo,ModelList]= i_GetTool(hFig);

% redraw
i_draw(hFig,Tool,ModelInfo{:},ModelList);

PlotOpts= strcmp(get(Tool.Context,'checked'),'on');
setpref(mbcprefs('mbc'),'LocalPlotOpts',PlotOpts)


% ---------------------------------------------------------------------------------------
% 													function i_Print
% ---------------------------------------------------------------------------------------
function i_Print(Tool,Name)

lyt1 = Tool.printLayout;
lyt2= Tool.Legend;
printlayout1(lyt1,lyt2,Name);


% ---------------------------------------------------------------------------------------
% 													function i_Copy
% ---------------------------------------------------------------------------------------
function i_Copy

ax= gca;
Tool= i_GetTool(get(ax,'parent'));
fh= figure;
ax=copyobj(ax,fh);
set(ax,'units','norm','pos',[0.1300    0.1100    0.7750    0.65],'buttondownfcn','');

ax=copyobj(Tool.Legend,fh);
set(ax,'units','norm','pos',[0.1300    0.83    0.7750    0.15]);


% ---------------------------------------------------------------------------------------
% 													function i_GetTool
% ---------------------------------------------------------------------------------------
function [Tool,ModelInfo,ModelList]=i_GetTool(hFig)

if nargout>1
   [Tool,ModelInfo,ModelList]=mv_ValidationTool('get',hFig);
else
   [Tool]=mv_ValidationTool('get',hFig);
end

% ---------------------------------------------------------------------------------------
% 													function i_SetTool
% ---------------------------------------------------------------------------------------
function i_SetTool(hFig,Tool)

mv_ValidationTool('set',hFig,Tool);


% ---------------------------------------------------------------------------------------
% 													function i_AxButtonDown
% ---------------------------------------------------------------------------------------
function i_AxButtonDown(ax, null, dataPatchFcnHandle, str, lyt)

downtype=get(gcbf ,'SelectionType');
switch downtype
case {'extend','open'}
   mv_zoom;
case 'normal'
   % max area for data info
   maxA = get(lyt,'position');
   RS = get(lyt,'rowsizes');
   maxA(4) = maxA(4) - RS(1);
   feval(dataPatchFcnHandle,ax,[],str,maxA);
end
