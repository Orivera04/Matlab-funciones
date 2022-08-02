function varargout= validate_RMSE(Action,varargin)
% VALIDATE_RMSE rmse plots for MBC model selection tools

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.3 $  $Date: 2004/04/04 03:31:00 $

switch lower(Action)
case 'create'
	  [varargout{1:2}]= i_Create(varargin{:});
case 'view'
	i_View(varargin{:})
case {'modelselect','draw','rmsex'}
	i_draw(gcbf);
case 'testnums'
	i_TestNums(gcbf)
case 'autoscale'
	i_AutoScale
case 'print'
	i_Print(varargin{:});
end


function [Tool, mainLyt]= i_Create(hFig,PRESS)

Tool.Name= 'R&MSE Plots';
Tool.MultiSelect= 1;
Tool.mfile= mfilename;
Tool.Icon = 'sigmahatplot.bmp';
Tool.Renderer='painters';

if nargin < 2,	PRESS= 1; end;
Tool.PRESS= PRESS;

if PRESS, numPlots=3; else, numPlots=2; end;

%%-------------ContextMenu for plots---------------%%
uic= uicontextmenu('parent',hFig);
um= uimenu('parent',uic,...
	'Label','&Test Numbers',...
	'callback',[mfilename,'(''TestNums'')']);
um1= uimenu('parent',uic,...
    'separator','on',...
	'Label','&Print to Figure',...
	'callback',{@i_Copy});

%%----------------------Legend------------------------%%
pH=xreguicontrol('parent',hFig,...
	'visible','off',...
   'style','text',...
   'HorizontalAlign','left',...
   'string','Legend:');
hLegend=xregaxes('parent',hFig,...
	'visible','off',...
   'units','pixels',...
   'xlim',[0 1],'ylim',[0 1],...
   'box','on',...
   'xtick',[],'ytick',[],...
   'DefaultTextFontSize',8,...
   'DefaultTextFontName','Lucida Console');
legendWrapper = axiswrapper(hLegend);

%%-------------------------Axes--------------------------------%%
Colors= get(hLegend,'colororder');
Colors= Colors(2:end,:);

for i=1:numPlots
	AxHand(i)=xregaxes('parent',hFig,...
	'visible','off',...
		'units','pixels',...
		'pos',[1 1 10 10],...
		'ColorOrder',Colors,...
		'nextplot','replacechildren',...
		'xgrid','on','ygrid','on',...
		'ButtonDownFcn','mv_zoom',...
		'uicontextmenu',uic,...
		'box','on');
	axLyt{i}=axiswrapper(AxHand(i));
end

tH=get(AxHand(1),'title');
set(tH,'string','Local RMSE','FontSize',8)
set(get(AxHand(1),'xlabel'),'visible','off');
tH=get(AxHand(2),'title');
set(tH,'string','Two-Stage RMSE','FontSize',8)
set(get(AxHand(2),'xlabel'),'visible','off');
if PRESS
	tH=get(AxHand(3),'title');
	set(tH,'string','PRESS RMSE','FontSize',8)
end

%%-------------plot options popups---------------------%%
h=xreguicontrol('Parent',hFig,...
	'visible','off',...
	'style','text',...
	'string','X-axis variable:',...
	'horizontalalignment','left',...
	'backgroundcolor',get(hFig,'color'));
Tool.RMSEXVar=xreguicontrol('Parent',hFig,...
	'visible','off',...
	'style','popup',...
	'position',[1 1 125 15],...
	'horizontalalignment','left',...
	'callback',[mfilename,'(''rmsex'')'],...
	'backgroundcolor','w');

%%---------------LAYOUTS----------------------%%

legendGrid = xreggridbaglayout(hFig,...
   'packstatus','off',...
   'visible','off',...
   'dimension',[3 2],...
   'rowsizes',[15 22 -1],...
   'colsizes',[125 -1],...
   'gapx',20,...
   'mergeblock',{[2 3],[2 2]},...
   'elements',{h, Tool.RMSEXVar,[],pH,legendWrapper});
infoFrame = xregframetitlelayout(hFig,...
   'visible','off',...
   'center',legendGrid,...
   'innerborder',[10 10 10 10]);
els=cell(1+2*numPlots,3);
els{1} = infoFrame;
els(3:2:end,2) = axLyt(:);
mainLyt = xreggridbaglayout(hFig,...
   'dimension',[1+2*numPlots 3],...
   'rowsizes',[120 30 -1 repmat([50 -1],1,numPlots-1)],...
   'colsizes',[40 -1 20],...
   'border',[10 40 10 10],...
   'mergeblock',{[1 1],[1 3]},...
   'elements',els);

Tool.Legend= hLegend;
Tool.AxHand= AxHand(:);
Tool.TestNum= um;
Tool.helpmenus={'&RMSE Plots Help','xreg_modSel_rmse'};


% --------------------------------------------------------
% SUBFUNCTION i_View
% --------------------------------------------------------
function i_View(hFig,varargin)

i_draw(hFig)


% --------------------------------------------------------
% SUBFUNCTION i_draw
% --------------------------------------------------------
function i_draw(hFig)

[Tool,p,ModNo,ModelList]=i_GetTool(hFig);

if isempty(get(Tool.RMSEXVar,'string'))
	mg= p.children(1,'model');
	xg= get(mg{1},'symbol');
	xvars= [{'Observation Number'} xg(:)' p.children('name')]; 
	set(Tool.RMSEXVar,'string',xvars,'value',1);
end
XVar= get(Tool.RMSEXVar,'value');

% do the plotting
h=p.rmse_plot('local',XVar,Tool.AxHand(1));


set(h(1),'tag','main line');
% check if testnums required
if strcmp(get(Tool.TestNum,'check'),'on')
	p.ShowTestNum(Tool.AxHand(1),0);
end
% turn on zoom
set(Tool.AxHand(1),'buttondownfcn','mv_zoom');

% do the plotting
h=p.rmse_plot('pred',XVar,Tool.AxHand(2),ModNo);
% turn off xlabel on the axis above
set(get(Tool.AxHand(1),'xlabel'),'visible','off');

set(h(1),'tag','main line');
% check if testnums required
if strcmp(get(Tool.TestNum,'check'),'on')
    p.ShowTestNum(Tool.AxHand(2),0);
end
% turn on zoom
set(Tool.AxHand(2),'buttondownfcn','mv_zoom');

if Tool.PRESS
    % do the plotting
	h=p.rmse_plot('PRESS',XVar,Tool.AxHand(3),ModNo);
    % turn off xlabel on the axis above
    set(get(Tool.AxHand(2),'xlabel'),'visible','off');
    
    set(h(1),'tag','main line');
	% check if testnums required
	if strcmp(get(Tool.TestNum,'check'),'on')
		p.ShowTestNum(Tool.AxHand(3),0);
	end
	% turn on zoom
	set(Tool.AxHand(3),'buttondownfcn','mv_zoom');
end

set(Tool.AxHand,'nextplot','replacechildren');


delete(get(Tool.Legend,'children'));
ht= .98;
Colors= get(Tool.AxHand(1),'ColorOrder');
Colors= repmat(Colors,ceil(length(ModelList)/length(Colors)),1);

i=1;
Textent(4)=0;
while ht-Textent(4)>0 && i<=length(ModelList)
	xregline('xdata',.05,'ydata',ht-0.05,...
		'Marker','.',...
		'LineStyle','none',...
		'LineWidth',1.5,...
		'Color',Colors(i,:),...
		'Parent',Tool.Legend);
	th=xregtext('clipping','on',...
		'pos',[.1 ht],'string',ModelList{i},...
		'horizon','left','vert','top',...
		'interpreter','none',...
		'Parent',Tool.Legend);
	Textent= get(th,'extent');
	ht= ht-Textent(4);
	i=i+1;
end


% --------------------------------------------------------
% SUBFUNCTION i_TestNums
% --------------------------------------------------------
function i_TestNums(hFig,p,TSstats)

Tool= i_GetTool(hFig);
if strcmp(get(Tool.TestNum,'checked'),'on')
	tH= findobj(Tool.AxHand,'type','text','tag','TestNumText');
	delete(tH);
	set(Tool.TestNum,'checked','off')
else
	if nargin < 2
		[Tool,p,TSstats]=i_GetTool(gcbf);
	end
	
	p.ShowTestNum(Tool.AxHand(1),0);
	p.ShowTestNum(Tool.AxHand(2),0);
	
	if Tool.PRESS
		p.ShowTestNum(Tool.AxHand(3),0);
	end   
	set(Tool.TestNum,'checked','on')
end



% --------------------------------------------------------
% SUBFUNCTION i_Print
% --------------------------------------------------------
function i_Print(Tool,Name)

lyt1= Tool.AxHand;
lyt2= Tool.Legend;
printlayout1(lyt1,lyt2,Name);

% --------------------------------------------------------
% SUBFUNCTION i_GetTool
% --------------------------------------------------------
function [Tool,p,ModelNo,ModelList]=i_GetTool(hFig)

if nargout==1
	Tool= mv_ValidationTool('get',hFig);
else
	[Tool,ModelInfo,ModelList]= mv_ValidationTool('get',hFig);
	p= ModelInfo{2};
	ModelNo= ModelInfo{1}{1};   
end

% --------------------------------------------------------
% SUBFUNCTION i_SetTool
% --------------------------------------------------------
function i_SetTool(hFig,Tool)

mv_ValidationTool('set',hFig,Tool);


% ---------------------------------------------------------------------------------------
% 													function i_Copy
% ---------------------------------------------------------------------------------------
function i_Copy(src,null)

ax= gca;
Tool= i_GetTool(get(ax,'parent'));
fh= figure;
ax=copyobj(ax,fh);
set(ax,'units','norm','pos',[0.1300    0.1100    0.7750    0.65],'buttondownfcn','');

ax=copyobj(Tool.Legend,fh);
set(ax,'units','norm','pos',[0.1300    0.83    0.7750    0.15]);
