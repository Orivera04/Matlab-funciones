function varargout= validate_prediction(Action,varargin)
% VALIDATE_PREDICTION prediction plots for MBC model selection tools

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.3 $  $Date: 2004/02/09 08:02:17 $

switch lower(Action)
    case 'create'
        [varargout{1:2}]= i_Create(varargin{:});
    case {'modelselect','draw','view'}
        i_View(varargin{:});
    case 'print'
        i_Print(varargin{:});
end


function [Tool, mainLyt]= i_Create(hFig,DataType)

Tool.Name= '&Predicted/Observed';
Tool.MultiSelect= 0;
Tool.mfile= mfilename;
Tool.Icon = 'obspred.bmp';
Tool.Renderer='painters';

if nargin<2
    Tool.DataType= 'FIT';
else
    Tool.DataType= DataType;
end

%-------------ContextMenu for plots---------------%%
uic=i_uxmenu(hFig);
%----------------------Legend------------------------%%
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

%-------------------------Axes--------------------------------
AxHand(1)=xregaxes('parent',hFig,...
    'visible','off',...
    'units','pixels',...
    'nextplot','add',...
    'xgrid','on','ygrid','on',...
    'ButtonDownFcn','mv_zoom',...
    'uicontextmenu',uic,...
    'box','on');
axLyt{1}=axiswrapper(AxHand(1));

tH=get(AxHand(1),'title');
set(tH,'string','Predicted/Observed')

Tool.Legend= hLegend;
Tool.AxHand= AxHand(:);

%---------------LAYOUTS----------------------%
mainLyt = xreggridbaglayout(hFig,...
    'packstatus','off',...
    'dimension',[5 3],...
    'colsizes',[40 -1 20],...
    'rowsizes',[15 0 80 30 -1],...
    'border',[10 40 10 10],...
    'mergeblock',{[1 1],[1 3]},...
    'mergeblock',{[3 3],[1 3]},...
    'elements',{pH, [], legendWrapper, [],[],...
    [],[],[],[],axLyt{1}});

Tool.helpmenus={'&Predicted/Observed Help','xreg_modSel_predObs'};


% --------------------------------------------------------
% SUBFUNCTION i_View
% --------------------------------------------------------
function i_View(hFig,varargin)

[Tool,p,Models,ModelSelect,ModelList]= i_GetTool(hFig);
m=Models{1};
ax=Tool.AxHand(1);

Xnat= invcode(m,repmat(linspace(-1,1,100)',1, nfactors(m)));


ch=get(ax,'children');
delete(ch(ishandle(ch)));

% get context menus for plot options
ux=get(ax,'uicontextmenu');
uitn = findobj(ux,'tag','Test Num');
uibd = findobj(ux,'tag','showBD1');
uiy = findobj(ux,'tag','ytrans_units');
uici = findobj(ux,'tag','confidence interval');
% check if ytrans available
if isempty(get(Models{1},'ytrans'))
    set(uiy,'enable','off','checked','off');
else
    set(uiy,'enable','on');
end
% check that confidence intervals can be drawn
% use pevcheck as is done inside plot
if pevcheck(Models{1})
    set(uici,'enable','on');
else
    set(uici,'enable','off','checked','off');
end

plotoptions = [strcmp(get(uibd,'checked'),'on'),...
    strcmp(get(uitn,'checked'),'on'),...
    strcmp(get(uici,'checked'),'on')];

if strcmp(Tool.DataType,'FIT')
    % do the plotting
    [X,Y,DataOk]= FitData(p(1).info);
else
    [X,Y]= getdata(p(1).info,Tool.DataType);
    DataOk= ~isbad(Y);
end
lh= plot(Models{1},X,Y,DataOk,plotoptions,ax);
set(lh,'tag','main line');
% check whether or not TestNumbers are needed
i_TestNums(uitn,[],hFig,X(DataOk,:),Y(DataOk));
% set up the legend
delete(get(Tool.Legend,'children'));

tags = {'main line','BDPts','localfit','free knot line',...
    'Rbf center mark'};
allLabels = {'Data','Removed data','Model fit','Knot position','RBF center'};
% throw out empty lines
lineh=[];legLabels={};
for i=1:length(tags)
    h= findobj(ax,'type','line','tag',tags{i});
    if ~isempty(h) && ishandle(h) && ~isempty(get(h,'xdata')) % no xdata
        lineh=[lineh(:)',h]; legLabels={legLabels{:},allLabels{i}};
    end
end

ht= .98;
for i=1:length(lineh);
    if ~strcmp(get(lineh(i),'LineStyle'),'-')
        xd= 0.05;
        yd=ht-0.05;
    else
        xd=[0.03, 0.07]; yd=[ht-0.05,ht-0.05];
    end

    xregline('xdata',xd,'ydata',yd,...
        'marker',get(lineh(i),'marker'),...
        'markerfacecolor',get(lineh(i),'markerfacecolor'),...
        'markersize',get(lineh(i),'markersize'),...
        'LineStyle',get(lineh(i),'LineStyle'),...
        'LineWidth',get(lineh(i),'LineWidth'),...
        'Color',get(lineh(i),'Color'),...
        'Parent',Tool.Legend);
    th=xregtext('pos',[.1 ht],'string',legLabels{i},...
        'horizon','left','vert','top',...
        'clipping','on',...
        'interpreter','none',...
        'Parent',Tool.Legend);
    Textent= get(th,'extent');
    ht= ht-Textent(4);
end

% --------------------------------------------------------
% SUBFUNCTION i_TestNums
% --------------------------------------------------------
function i_TestNums(src,event,hFig,X,Y)

[Tool,p,Models,bd]=i_GetTool(hFig);
if strcmp(get(src,'checked'),'off')
    tH= findobj(Tool.AxHand,'type','text','tag','testnum');
    delete(tH);
else
    lH1= findobj(Tool.AxHand(1),'type','line','tag','main line');
    xdata1= get(lH1(end),'xdata');
    ydata1= get(lH1(end),'ydata');

    if size(X,3)==size(X,1)
        tns= testnum(X);
    else
        tns= 1:size(X,1);
    end
    
    for i=1:length(xdata1)
        xregtext(xdata1(i),ydata1(i),num2str(tns(i)),...
            'parent',Tool.AxHand(1),...
            'fontsize',8,...
            'horizontalalignment','right',...
            'hittest','off',...
            'tag','testnum',...
            'clipping','on',...
            'verticalAlignment','bottom');
    end
end


% ===========================================
% Function i_viewoptsflag
% ===========================================
function i_viewoptsflag(src,event)
% callback when uicontextmenus clicked for Conf Intervals, Show Outliers etc
h=gcbo;

ch= get(h,'check');
% change the check status
if strcmp(ch,'on')
    set(h,'check','off');
else
    set(h,'check','on');
end
i_View(gcbf)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_Print printing subfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Print(Tool,Name)

lyt1= Tool.AxHand;
lyt2= [];
printlayout1(lyt1,lyt2,Name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_GetTool subfunction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Tool,p,Models,ModNo,ModelList]=i_GetTool(hFig)

if nargout==1
    Tool=mv_ValidationTool('get',hFig);
else
    [Tool,ModelInfo,ModelList]=mv_ValidationTool('get',hFig);
    ModNo= ModelInfo{1};
    p= ModelInfo{2};
    Models= ModelInfo{3};
end

% ===========================================
% Function i_copy
% ===========================================
function i_copy(ax, null)
% get the axes
ax= gca;
f= figure;
newax=copyobj(ax,f);
pos=get(f,'defaultaxesposition');
set(newax,'units','normalized',...
    'position',pos,...
    'color',[1 1 1]);
kids= get(newax,'children');
set(kids,'hittest','off','handlevisibility','off');

% ===========================================
% Function i_uxmenu
% ===========================================
function ux=i_uxmenu(fH)
% MODELDEV/DIAGMENU - Makes contextmenu for the diagnostic plots

% Build the parent context menu
ux=uicontextmenu('parent',fH,...
    'tag','prediction context menu');

% set up labels for menus
Labels= {...
    'Sho&w Removed Data',...
    'Show &Transformed Units',...
    'Show Confidence &Intervals',...
    '&Print to Figure',...
    '&Test Number',...
    };

Check= {...
    'on',...
    'off',...
    'on',...
    'off',...
    'off',...
    };

% set up callbacks for menus
Cbks= {...
    {@i_viewoptsflag},...
    {@i_viewoptsflag},...
    {@i_viewoptsflag},...
    {@i_copy},...
    {@i_viewoptsflag},...
    };

% set up Tags for menus
Tags= {...
    'showBD1',...
    'ytrans_units',...
    'confidence interval',...
    'Copy Plot',...
    'Test Num',...
    };

% build the context menu
u= xregmenutool('create',...
    ux,...
    'label',Labels,...
    'callback', Cbks,...
    'Tag',Tags,...
    'check',Check);
set([u(4),u(5)],'separator','on');

