function varargout= validate_rf(Action,varargin)
%VALIDATE_RF Log-likelihood plots for MBC model selection tools

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.4 $  $Date: 2004/04/04 03:31:01 $

switch lower(Action)
    case 'create'
        [varargout{1:2}] = i_Create(varargin{:});
    case 'view'
        i_View(varargin{:})
    case {'modelselect','draw'}
        i_draw(gcbf);
    case 'testnums'
        i_TestNums(gcbf)
    case 'autoscale'
        i_AutoScale
    case 'print'
        i_Print(varargin{:});
end

% ---------------------------------------------------------------------------------------
% 													function create
% ---------------------------------------------------------------------------------------
function [Tool, mainLyt] = i_Create(hFig,PRESS)

Tool.Name= '&Likelihood';
Tool.MultiSelect= 1;
Tool.mfile= mfilename;
Tool.Icon = 'likelihood.bmp';
Tool.Renderer='painters';

numPlots=2;

%-------------ContextMenu for plots---------------%
uic= uicontextmenu('parent',hFig);
um= uimenu('parent',uic,...
    'Label','&Test Numbers',...
    'callback',[mfilename,'(''TestNums'')']);
um2= uimenu('parent',uic,...
    'Label','&Auto Scale',...
    'Checked','on',...
    'callback',[mfilename,'(''AutoScale'')']);
um3= uimenu('parent',uic,...
    'separator','on',...
    'Label','&Print to Figure',...
    'callback',{@i_Copy});

%----------------------Legend------------------------%
pH=xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','text',...
    'enable','inactive',...
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

%-------------------------Axes--------------------------------%
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

% TITLES
tH=get(AxHand(1),'title');
set(tH,'string','Negative Log Likelihood Function','FontSize',8)

tH=get(AxHand(2),'title');
set(tH,...
    'string','T^2 = (y_{rf}(i) - yhat_{rf}(i))^T ( \sigma^2\Sigma_i + \Gamma )^{-1} (y_{rf}(i) - yhat_{rf}(i)) ',...
    'FontSize',8)
set(get(AxHand(2),'xlabel'),'string','Observation Number');


%---------------LAYOUTS----------------------%
mainLyt = xreggridbaglayout(hFig,...
    'packstatus','off',...
    'dimension',[7 3],...
    'colsizes',[40 -1 20],...
    'rowsizes',[15 0 80 30 -1 50 -1],...
    'border',[10 40 10 10],...
    'mergeblock',{[1 1],[1 3]},...
    'mergeblock',{[3 3],[1 3]},...
    'elements',{pH, [], legendWrapper, [],[],[],[],...
    [],[],[],[],axLyt{1}, [], axLyt{2}});


Tool.Legend= hLegend;
Tool.AxHand= AxHand(:);
Tool.TestNum= um;
Tool.AutoScale= um2;

% help menus
Tool.helpmenus={'&Likelihood Plot Help','xreg_modSel_likelihood'};


function i_View(hFig,varargin)

i_draw(hFig)

% ---------------------------------------------------------------------------------------
% 													function draw
% ---------------------------------------------------------------------------------------
function i_draw(hFig)

[Tool,p,TSstats,ModelList]=i_GetTool(hFig);

% plot negatice log likelihood
N=sum(isfinite(TSstats.LogL))';
mval= TSstats.Summary(:,end)./N;
plot(TSstats.LogL,'.',...
    'MarkerSize',12,...
    'LineWidth',2,'parent',Tool.AxHand(1),'tag','rft2')
set(Tool.AxHand(1),'nextplot','add');
h=plot(get(Tool.AxHand(1),'xlim'),[mval';mval'],...
    'parent',Tool.AxHand(1));

% plot T-squared
T2index = 4;
mval= TSstats.Summary(:,T2index);
plot(TSstats.RespFeat,'.',...
    'MarkerSize',12,...
    'LineWidth',2,'parent',Tool.AxHand(2),'tag','rft2')
set(Tool.AxHand(2),'nextplot','add');
xlim= get(Tool.AxHand(2),'xlim');
h=plot(xlim,[mval';mval'],...
    'parent',Tool.AxHand(2));


set(Tool.AxHand,'nextplot','replacechildren');

if strcmp(get(Tool.TestNum,'checked'),'on')
    set(Tool.TestNum,'checked','off')
    i_TestNums(hFig,p,TSstats)
end

delete(get(Tool.Legend,'children'));
ht= .98;
Colors= get(Tool.AxHand(1),'ColorOrder');
Markers= get(Tool.AxHand(1),'LineStyleOrder');

Markers= repmat(Markers,ceil(length(ModelList)/length(Markers)),1);
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


% ---------------------------------------------------------------------------------------
% 													function testnums
% ---------------------------------------------------------------------------------------
function i_TestNums(hFig,p,TSstats)

Tool= i_GetTool(hFig);
if strcmp(get(Tool.TestNum,'checked'),'on')
    tH= findobj(Tool.AxHand,'type','text','tag','testnum');
    delete(tH);
    set(Tool.TestNum,'checked','off')
else
    if nargin < 2
        [Tool,p,TSstats]=i_GetTool(gcbf);
    end
    Y= p.getdata('Y');
    tns= testnum(Y);
    lH1= findobj(Tool.AxHand(1),'type','line','tag','rft2');
    xdata1= get(lH1(end),'xdata');
    ydata1= get(lH1(end),'ydata');

    lH2= findobj(Tool.AxHand(2),'type','line','tag','rft2');
    xdata2= get(lH2(end),'xdata');
    ydata2= get(lH2(end),'ydata');
    for i=1:length(xdata1)
        txt(i)=xregtext(xdata1(i),ydata1(i),num2str(tns(i)),...
            'parent',Tool.AxHand(1),...
            'fontsize',8,...
            'horizontalalignment','right',...
            'hittest','off',...
            'tag','testnum',...
            'verticalAlignment','bottom');
        txt(i)=xregtext(xdata2(i),ydata2(i),num2str(tns(i)),...
            'parent',Tool.AxHand(2),...
            'fontsize',8,...
            'horizontalalignment','right',...
            'hittest','off',...
            'tag','testnum',...
            'verticalAlignment','bottom');
    end
    set(Tool.TestNum,'checked','on')
end



% ---------------------------------------------------------------------------------------
% 													function i_AutoScale
% ---------------------------------------------------------------------------------------
function i_AutoScale

[Tool,p]=i_GetTool(gcbf);
if strcmp(get(Tool.AutoScale,'checked'),'on')
    TSstats=i_GetRFstats(p,':',Tool);
    y1min= min(min(TSstats.LogL));
    y1m= max(max(TSstats.LogL));
    set(Tool.AxHand(1),'ylim',[y1min y1m],'YLimMode','manual')
    set(Tool.AutoScale,'checked','off')
    y2m= max(max(TSstats.RespFeat));
    set(Tool.AxHand(2),'ylim',[0 y2m],'YLimMode','manual')
else
    set(Tool.AxHand,'YLimMode','auto')
    set(Tool.AutoScale,'checked','on')
end


% ---------------------------------------------------------------------------------------
% 													function i_GetRFstats
% ---------------------------------------------------------------------------------------
function TSstats=i_GetRFstats(p,ModelNo,Tool)

if isa(p.model,'xregtwostage')
    ts= p.children(ModelNo,TSstatistics);
    ts= cat(2,ts{:});
    ind= cat(2,ModelNo{:});
    for i=1:length(ind);
        j = ind(i);
        ts(i).Summary= ts(i).Summary(j,:);
        ts(i).RespFeat= ts(i).RespFeat(:,j);
        ts(i).LogL= ts(i).LogL(:,j);
    end
    TSstats= ts(1);
    TSstats.Summary= [ts.Summary];
    TSstats.RespFeat= [ts.RespFeat];
    TSstats.LogL= [ts.LogL];
    p= p(ModelNo(1));
else
    t= p.TSstatistics;
    if isa(ModelNo,'cell')
        ind= ModelNo{1};
    else
        ind= ModelNo;
    end
    t.Summary= t.Summary(ind,:);
    t.RespFeat= t.RespFeat(:,ind);
    t.LogL= t.LogL(:,ind);
    TSstats= t;
end

% ---------------------------------------------------------------------------------------
% 													function i_Print
% ---------------------------------------------------------------------------------------
function i_Print(Tool,Name)

lyt1= Tool.AxHand;
lyt2= Tool.Legend;
printlayout1(lyt1,lyt2,Name);

function [Tool,p,TSstats,ModelList]=i_GetTool(hFig)

if nargout==1
    Tool= mv_ValidationTool('get',hFig);
else
    [Tool,ModelInfo,ModelList]= mv_ValidationTool('get',hFig);
    p= ModelInfo{2};
    if nargout>2
        ModelNo= ModelInfo{1};
        TSstats=i_GetRFstats(p,ModelNo,Tool);
    end
end

% ---------------------------------------------------------------------------------------
% 													function i_SetTool
% ---------------------------------------------------------------------------------------
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
