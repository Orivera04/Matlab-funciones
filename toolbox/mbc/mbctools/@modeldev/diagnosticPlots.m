function varargout = diagnosticPlots(m,action,varargin)
%DIAGNOSTICPLOTS Method that manages the diagnostic plots view
%  This routine will draw the diagnostic plots for any modeldev object.
%
%  [fH,layout,View] = DIAGNOSTICPLOTS(m,'create',varargin) will create a
%  set of diagnostic plots on a new figure.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.6 $  $Date: 2004/04/12 23:34:57 $

if nargin <2
    action = 'create';
end

% ----------------------
% Begin the SwitchYard
% ----------------------
switch lower(action)
    case 'create'
        [fH,layout,View]= i_create(m,varargin{:});
        switch nargout
            case 1
                varargout{1}=fH;
            case 2
                varargout{1}=fH;
                varargout{2}=layout;
            case 3
                varargout{1}=fH;
                varargout{2}=layout;
                varargout{3}= View;
        end
    case 'updateview'
        i_updateview(m,varargin{:});
    case 'updateoutlier'
        % This is activated when the popups are changed.
        i_updateoutlier;
    case 'specialplotdraw'
        i_specialplotdraw(varargin{:});
    case 'applyoutliers'
        i_applyoutliers(varargin{:});
    case 'restoreoutliers'
        i_restoreoutliers(varargin{:});
    case 'canceloutliers'
        ol = i_getOutlierLine;
        clear(ol);
    case 'testnum'
        i_testnum(varargin{:});
    case 'copy'
        i_copy;
    case 'viewoptsflag'
        % change the plot options, e.g. show BD etc...
        i_viewoptsflag(varargin{:});
    case 'getcurrentaxes'
        varargout{1} = i_getcurrentaxes(m,varargin{:});
    case 'multiselect'
        i_Multiselect;
    case 'setoutliers'
        i_setOutliers(varargin{:});
    case 'getoutliers'
        varargout{1} = i_getOutliers(varargin{:});
    case 'getoutlierline'
        varargout{1} = i_getOutlierLine;
    case 'plotsweep'
        i_plotsweep(varargin{:});
    case 'outliersselect'
        i_SelectCriteria;
end

% ===========================================
% function i_create
% ===========================================
function [fH, layout, View] = i_create(md, newFig, View, mclass, initcard)

% see if we have created this already.
fH = findobj('name','Diagnostic Plots - Standard Plots');
if ~isempty(fH)
    figure(fH);
    return
end
fH = findobj('name','Diagnostic Plots - Special Plots');
if ~isempty(fH)
    figure(fH);
    return
end
% get the model from the modeldev object.
file = 'diagnosticPlots';

% -----------------------------------------
% Build figure if reqd
% -----------------------------------------
if nargin < 2
    fH = figure('name','Diagnostic Plots',...
        'numbertitle','off',...
        'doublebuffer','on',...
        'visible','off',...
        'menubar','figure');
elseif nargin >1  && ishandle(newFig)
    fH = newFig;
end


% ------------------------------------
% Create the graph2d object
% ------------------------------------
g = mvgraph2d(fH,...
    'grid','on',...
    'box','on',...
    'Callback',[file,...
    '(',mclass,',''updateoutlier'',%OBJECT%,%XVALUE%,%YVALUE%)'],...
    'visible','off');
ax = get(g,'axes');
% set contextmenu to be ux, created by diagmenu
ux = i_uxmenu(fH,mclass,'scatterplots');

set(ax,'uicontext',ux,...
    'nextplot','add',...
    'box','on',...
    'buttondownfcn','mv_zoom');
xlabel = get(ax,'xlabel');
ylabel = get(ax,'ylabel');
set([xlabel,ylabel],'interpreter','none');
% set up empty data and factor settings
g.data = [];
g.factors = '';
% give the main line an appropriate tag etc.
set(g.line,'tag','main line');

%---------------------------------------------------------------------------
% Create an outlier line object to look after the outlier marking
%---------------------------------------------------------------------------
ol = xregGui.outlierline(g.line);
ol.altClickCallback = {@i_plotsweep};
kids= get(ux,'children');
% set uicontextmenu multiselect callback
set(kids(end),'callback',{@i_Multiselect, ol});
% set uimenu multiselect callback
mh= findobj(mvf,'type','uimenu','tag','ToolsMenu');
hf = get(mh,'children');
if ~isempty(hf)
    set(hf(1),'callback',{@i_Multiselect, ol});
end

% ----------------------------------
% Make the Special Plot Axes.
% ----------------------------------
uxSpecial= i_uxmenu(fH,mclass,'specialplots');
ch = get(uxSpecial,'children');
set(ch(end),'callback',{@i_Multiselect, ol});

spax= axes('parent',fH,...
    'tag','Special Plot Axes',...
    'units','pixels',...
    'nextplot','add',...
    'xgrid','on',...
    'ygrid','on',...
    'uicontextmenu',uxSpecial,...
    'buttondownfcn','mv_zoom',...
    'visible', 'off');

ax= axiswrapper(spax);
% need room for axes labels etc
ax=xreggridlayout(fH,...
    'dimension',[1,1],...
    'elements',{ax},...
    'border',[44 34 10 0]);

% make the Special Plot choice list box
lb=xreguicontrol('parent',fH,...
    'style','popupmenu',...
    'string','   ',...
    'Tag','Special Plot List',...
    'visible','off',...
    'callback',[file,'(',mclass,',''specialplotdraw'',gcbf)'],...
    'backgroundcolor',[1 1 1]);

ax= xreggridbaglayout(fH,...
    'dimension',[2 3],...
    'gapy',8,...
    'colsizes',[-1 140 -1],...
    'rowsizes',[20 -1],...
    'mergeblock',{[2 2],[1 3]},...
    'elements',{[],ax,lb});

% ------------------------------------------------------------------------
% Make a splitLayout for both Axes with buttons to change
%                     TOP/BOTTOM ORIENTATION
% -----------------------------------------------------------------------

layout = xregsnapsplitlayout(fH,...
    'visible','off',...
    'orientation','ud',...
    'topinnerborder',[0 0 5 0],...
    'bottominnerborder',[5 0 0 0],...
    'minwidth',[100, 100],...
    'top',g,...
    'bottom',ax);

ud.Brdr= layout;


if nargin<2
    set(ud.Brdr,'container',fH);
    set(fH,'visible','on',...
        'userdata',ud,...
        'resizeFcn',{@i_resize},...
        'packstatus','on');
end

% store all the bits we need
View.OutlierLine= ol;

% new fields in outlierline instead of userdata
schema.prop(ol,'SpecialPlotAxes','mxArray');
schema.prop(ol,'SpecialPlotListBox','mxArray');
schema.prop(ol,'OutlierContextMenu','mxArray');
schema.prop(ol,'OutlierContextMenuSpecial','mxArray');
schema.prop(ol,'plotLayout','mxArray');
schema.prop(ol,'g','mxArray');
schema.prop(ol,'p_mdev','mxArray');
%schema.prop(ol,'old_outliers','mxArray');


ol.g = g;
ol.SpecialPlotAxes= spax;
ol.SpecialPlotListBox= lb;
ol.OutlierContextMenu= ux;
ol.OutlierContextMenuSpecial= uxSpecial;
ol.plotLayout= layout;

return


% ===========================================
% function i_updateview
% ===========================================
function i_updateview(md,fH)
% updates scatter and special plots

% Get the outlier line from the View structure
ol = i_getOutlierLine;
% store modeldev data in userdata
ol.p_mdev= address(md);

labH= [get(ol.g.axes,'title'),get(ol.SpecialPlotAxes,'xlabel')];
% Check the data is ok...
if ~md.Status % if not OK
    % Clean up the scatter-2d axes.
    set(ol.g,'data',[]);
    % delete outlierline from the graph2d object
    % delete all plotted lines but DONT delete the axes label
    delete(intersect(get(ol.g.axes,'children'),ol.outlierLines));
    delete( setdiff(get(ol.SpecialPlotAxes,'children'),labH) );
    % state what is going on
    set(labH,'string','Model not fitted','fontweight','bold');
    clear(ol);
    return
else
    set(labH,'string','','fontweight','normal');
end

% switch off outlier funcs from uicontextmenus if node has children
ax = [ol.g.axes, ol.SpecialPlotAxes];
uic = get(ax,'uicontextmenu');
if md.ModelStage==1
    set(findobj(uic{1},'tag','monitor'),'enable','on');
else
    set(findobj(uic{1},'tag','monitor'),'enable','off');
end

% get new stats
[data,factors,standardPlotStr,olIndex] = diagnosticStats(md);


% === PLOT SCATTER GRAPH2D ===
set(ol.g,'limits',repmat({'auto'},1,size(data,2)),...
    'data',data,...
    'factors',factors);
set(ol.g.line,'MarkerFaceColor',diagPlotColor(md));

% since things have changed, check special plots are OK
lb= ol.SpecialPlotListBox;
lb_val=get(lb,'value');
if lb_val>length(standardPlotStr)
    set(lb,'value',max(1,length(standardPlotStr)));
end
if isempty(standardPlotStr)
    standardPlotStr = '<none>'; % this picked up in specialplotdraw
end
set(lb,'string',standardPlotStr);
% === PLOT SPECIAL/OTHER  ===
% BUG FIX: if previous view had olIndex = [20, 21] and new view has length(data)= 18
% the specialplotdraw will crash. Hence clear(ol). We set olIndex from diagnosticStats anyway.
clear(ol);
diagnosticPlots(md,'specialplotdraw',fH,ol.SpecialPlotAxes,ol,0);

% with new lines plotted, set outlierIndices from the diagnosticStats call
ol.outlierIndices= olIndex(:)';

% redraw outlierline and check testnumbers
i_updateoutlier(ol);


% ===========================================
% Function i_SpecialPlotDraw
% ===========================================
function  i_specialplotdraw(fH,ax,ol,drawTestNum)
% draws the special plot with outliers/test nums marked

if nargin < 2
    % find outlier line and current axes
    ol = i_getOutlierLine;
    ax = ol.SpecialPlotAxes;
end
if nargin<4
    drawTestNum= true;
end

% Get the function to plot
lb= ol.SpecialPlotListBox;
value= get(lb,'value');
str= get(lb,'string');

if any(ismember(str, '<none>'))
    % switch away from special plots as there are none!
    % not just one statement - waiting for snapsplitlayout fixes!
    set(ol.plotLayout,'state','center');
    set(ol.plotLayout,'state','bottom');
    set(ol.plotLayout,'splitenable','off');
    return
else
    set(ol.plotLayout,'splitenable','on');
end

plotname= str{value};

%-----switch off some options in uicontextmenu-------
uic= get(ax,'uicontextmenu');
kids= get(uic,'children');
set(kids(end),'callback',{@i_Multiselect, ol});

% pointer to current modeldev node
pmd= ol.p_mdev;
m= pmd.model;
[X,Y]= getdata(pmd.info);

% kill everything on the axes
ax = ol.SpecialPlotAxes;
allCh= get(ax,'children');
remove(ol,allCh);
delete(allCh(ishandle(allCh)));

% update the plots
set(ax,'xgrid','on',...
    'xlimmode','auto',...
    'ylimmode','auto',...
    'XTickLabelMode','auto',...
    'XTickMode','auto',...
    'YTickLabelMode','auto',...
    'YTickMode','auto',...
    'box','on');

if pmd.status
    % === call the special plot routine ===
    pmd.specialPlots(plotname,ax,X,Y);
    % specialPots creates the line vis on, so switch it off if axes are vis off
    set(get(ax,'children'),'visible',get(ax,'visible'));
    % ==== add to the outlier line ====
    ml = findobj(ax,'tag','main line');
    add(ol,ml);
    % Check the testnumber thingy...
    if drawTestNum
        uxT= findobj([ol.g.axes,ol.SpecialPlotAxes],'tag','TestNumText');
        if ~isempty(uxT)
            delete(uxT);
            i_testnum([],[],'draw');
        end
    end
end

% sort out special plot uicontextmenus
switch lower(plotname)
    case 'normal plot'
        t= get(kids,'tag');
        u= kids(ismember(t,{'confidence interval','showBD1','ytrans_units'}));
        set(u,'enable','off');
    otherwise
        % Get the options from the context menu
        ubd= findobj(kids,'tag','showBD1');
        uci= findobj(kids,'tag','confidence interval');
        utr= findobj(kids,'tag','ytrans_units');
        ulg= findobj(kids,'tag','legend');
        set([ubd,uci,ulg],'enable','on');
        % switch off Y Trans Units menu if there is no Y-transform
        if isempty(get(m,'ytrans'))
            set(utr, 'enable','off');
        else
            set(utr, 'enable','on');
        end

        % disable confidence intervals if no pevcheck
        if pevcheck(m)
            set(uci,'enable','on');
        else
            set(uci,'enable','off','check','off');
        end
end

% Set up a legend
i_createLegend(ax,m);


%------------------------------------------------------------------------
% subfunction i_createLegend
%------------------------------------------------------------------------
function i_createLegend(AxHand,m)
% create legend
% the contextmenu of the special plots
contm = get(AxHand,'uicontextmenu');
uim = findobj(contm,'type','uimenu','tag','legend');

tags = {'main line','BDPts','localfit','free knot line','rbf center mark'};

Types = InputFactorTypes(m);
if length(find(Types==1)) > 1
    % global model has >1 input factors
    allLabels = {'Data','Removed data','Predicted = Observed','Knot position','RBF center'};
else 
    % global model has only 1 input and we show the model fit
    allLabels = {'Data','Removed data','Model fit','Knot position','RBF center'};
end

% Throw out empty lines
lineh = []; legLabels = {};
for i = 1:length(tags)
    h = findobj(AxHand,'type','line','tag',tags{i});
    if ~isempty(h) && ishandle(h) && length(get(h,'xdata'))>0
        lineh = [lineh, h];
        legLabels = [legLabels, allLabels(i)];
    end
end

leg = mbcgraph.legend(lineh, legLabels, ...
    'Location', 'NorthWest', ...
    'MoveMode', 'boundtoaxes', ...
    'LockVisibleToParent', true, ...
    'Active', strcmp(get(uim,'checked'), 'on'));

% Listeners are checking for context menu changing the legend state and for
% the lines being deleted (Legend needs to be removed at this point to
% ensure no legend is shown for blank plots)
uim = handle(uim(1));
lh = handle(lineh(1));
set(AxHand, 'userdata', ...
    [handle.listener(uim, uim.findprop('Checked'), 'PropertyPostSet',{@i_legendSetActive, leg, uim}); ...
    handle.listener(lh, 'ObjectBeingDestroyed', {@i_legendDelete, leg}) ...
    ]);

%------------------------------------------------------------------------
% subfunction i_legendSetActive
%------------------------------------------------------------------------
function i_legendSetActive(src, event, leg, uim)
% Called when the "Show Legend" menu is checked
if ishandle(leg)
    if strcmp(get(uim, 'Checked'), 'on')
        leg.Active = true;
        leg.Visible = 'on';
    else
        leg.Active = false;
    end
end

%------------------------------------------------------------------------
% subfunction i_legendDelete
%------------------------------------------------------------------------
function i_legendDelete(src, event, leg)
if ishandle(leg) && ~isBeingDestroyed(leg)
    delete(leg);
end


% ===========================================
% Function i_legendCheck
% ===========================================
function i_legendCheck(src,eventData)

state=get(src,'checked');
switch state
    case 'on'
        set(src,'checked','off');
    case 'off'
        set(src,'checked','on');
end

% ===========================================
% function i_updateoutlier
% ===========================================
function i_updateoutlier(ol)
% redraws outlier line (and test numbers) on graph2d
% when the factors are changed
if ~nargin
    ol = i_getOutlierLine;
end
redraw(ol);
% TEST NUMBERS
uxT= findobj(ol.OutlierContextMenu,'tag','Test Num');
txtH=findobj([ol.g.axes,ol.SpecialPlotAxes],'type','text','Tag','TestNumText');
delete(txtH);
% if test num checked, draw them on
if ~isempty(uxT) && strcmp(get(uxT(1),'check'),'on')
    diagnosticPlots(info(ol.p_mdev),'testnum',[],[],'draw');
end

% ===========================================
%  function i_applyoutliers
% ===========================================
function i_applyoutliers(fH)
% check not too many outliers for the model fitting
% apply outliers to the modeldev

% get the potential outlier index
ol = i_getOutlierLine;
p_mdev = ol.p_mdev;
pot_outlier= ol.outlierIndices;

oldStatus= p_mdev.status;

% Apply the outliers
[mdev,OK]= addoutliers(p_mdev.info,pot_outlier);
% clear the outlierline
clear(ol);

% Convert OK to 0/1 before comparing with status
OK(OK<0) = 0;
OK(OK>0) = 1;
if OK==oldStatus
    % only a view required if status is the same
    ViewNode(MBrowser);
else
    % Forced hide/show/view if status changes
    ResetView(MBrowser);
end

% ===========================================
%  function i_restoreoutliers(fH)
% ===========================================
function i_restoreoutliers(fH)
% get the outlier line
ol = i_getOutlierLine;
p_mdev = ol.p_mdev;
oldStatus= p_mdev.status;
% fire up dialogue for outlier restoration
restoreoutlierdlg('create',p_mdev.info);
% restoreoutlierdlg changes olIndices and redraws outlierline
if ~isempty(ol.outlierIndices)
    p_mdev.restoreoutliers('single',ol.outlierIndices);

    % clear outlierline - currently holds indices of points being restored.
    % don't want these circled AND can cause errors if e.g. last point restored when
    % other points removed...xdata not long enough
    clear(ol);

    if p_mdev.status == oldStatus
        % only a view required if status is the same
        ViewNode(MBrowser);
    else
        % Forced hide/show/view if status changes
        ResetView(MBrowser);
    end
end


% ===========================================
% function i_testnum
% ===========================================
function i_testnum(src,event,action)
mbh = MBrowser;
v=mbh.GetViewData;

scAx = v.OutlierLine.g.axes;
spAx = v.OutlierLine.SpecialPlotAxes;
p = v.OutlierLine.p_mdev;

mH(1)=findobj(get(scAx,'uicontextmenu'),'Tag','Test Num');
mH(2)=findobj(get(spAx,'uicontextmenu'),'Tag','Test Num');
menu = findobj(v.menus.view,'tag','testnum');
% View menu

% Check to see if the text is already on
txtH=findobj([scAx,spAx],'type','text',...
    'Tag','TestNumText');

if nargin<3 && ~isempty(txtH)
    action = 'clear';
elseif nargin<3
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

% ===========================================
% Function i_copy
% ===========================================
function i_copy(ax, null)

mbh = MBrowser;
p = mbh.CurrentNode;
type = p.NodeType;
ol = i_getOutlierLine;

% get the axes
ax= gca;
axTag = get(gca,'tag');

f= figure;
set(f,'name',p.fullname,'numbertitle','off');
newax=copyobj(ax,f);
pos=get(f,'defaultaxesposition');
set(newax,'Units','normalized',...
    'Position',pos,...
    'uicontextmenu', [],...
    'ButtonDownFcn', '',...
    'Color',[1 1 1]);

titleStr = '';
if strcmpi(axTag,'Special Plot Axes');
    spName = get(ol.SpecialPlotListBox,'string');
    spName = spName{get(ol.SpecialPlotListBox,'value')};
    titleStr = spName;
end
if strcmpi(type,'local model')
    if isempty(titleStr)
        titleStr = ['Test ',num2str(testnum(ol.XFitData))];
    else
        titleStr = [titleStr,':  test ',num2str(testnum(ol.XFitData))];
    end
end
set(get(newax,'title'),'string',titleStr,'fontweight','bold');

kids= get(newax,'children');
set(kids,'hittest','off','handlevisibility','off');



% ===========================================
% Function i_resize
% ===========================================
function i_resize(src,event)
ud=get(gcbf,'userdata');
repack(ud.Brdr)

% ===========================================
% Function i_viewoptsflag
% ===========================================
function i_viewoptsflag(h)
% callback when uicontextmenus clicked for Conf Intervals, Show Outliers etc
ch= get(h,'check');
% change the check status
if strcmp(ch,'on')
    set(h,'check','off');
else
    set(h,'check','on');
end

% see if we need to redraw the special plot
ol = i_getOutlierLine;
state = get(ol.plotLayout,'state');
spInd= get(ol.SpecialPlotListBox,'value');

if ~strcmp(state,'bottom') && spInd==1
    % only update these if on first special plot (usually pred/obs)
    ax= ol.SpecialPlotAxes;
    diagnosticPlots(ol.p_mdev.info,'specialplotdraw',gcbf,ax,ol);
end

% ===========================================
% Function i_getcurrentaxes
% ===========================================
function h = i_getcurrentaxes(md,fH)

% Get the outlier line from the View structure
ol = i_getOutlierLine;
h = ol.lineParents;


% ===========================================
% Function i_getOutlierLine
% ===========================================
function ol = i_getOutlierLine

View= GetViewData(MBrowser);
if isfield(View,'OutlierLine')
    ol = View.OutlierLine;
else
    ol = View.Global.OutlierLine;
end

% ===========================================
% Function i_Multiselect
% ===========================================
function i_Multiselect(caller, null, oL)
if ~nargin
    oL = i_getOutlierLine;
end
multiselect(oL);


% ===========================================
% Function i_uxmenu
% ===========================================
function ux=i_uxmenu(fH,mclass,plotType)
% MODELDEV/DIAGMENU - Makes contextmenu for the diagnostic plots

% Build the parent context menu
ux=uicontextmenu('parent',fH,...
    'tag','outlier context menu');

% set up labels for menus
Labels= {...
    'Select &Multiple Outliers',...
    '&Clear Outliers',...
    '&Remove Outliers',...
    'Restore Removed &Data...',...
    '&Show Removed Data',...
    'Show &Transformed Units',...
    'Show Confidence &Intervals',...
    'Show &Legend',...
    '&Print to Figure',...
    'Test &Numbers',...
    };

if strcmp(mclass,'mdev_local')
    Labels{end}= 'Record &Numbers';
end

Check= {...
    'off',...
    'off',...
    'off',...
    'off',...
    'on',...
    'off',...
    'on',...
    'on',...
    'off',...
    'off',...
    };

Accel= {...
    '',...
    '',...
    'A',...
    'Z',...
    '',...
    '',...
    '',...
    '',...
    '',...
    '',...
    };
% set up callbacks for menus
Cbks= {...
    '',...
    ['diagnosticPlots(',mclass,',''canceloutliers'',gcbf)'],...
    ['diagnosticPlots(',mclass,',''applyoutliers'',gcbf)'],...
    ['diagnosticPlots(',mclass,',''restoreoutliers'',gcbf)'],...
    ['diagnosticPlots(',mclass,',''viewoptsflag'',gcbo)'],...
    ['diagnosticPlots(',mclass,',''viewoptsflag'',gcbo)'],...
    ['diagnosticPlots(',mclass,',''viewoptsflag'',gcbo)'],...
    {@i_legendCheck},...
    {@i_copy},...
    ['diagnosticPlots(',mclass,',''testnum'',gcbf,gca)']...
    };

% set up Tags for menus
Tags= {...
    'outlier',...
    'outlier',...
    'outlier',...
    'outlier',...
    'showBD1',...
    'ytrans_units',...
    'confidence interval',...
    'legend',...
    'Copy Plot',...
    'Test Num',...
    };

% build the context menu
switch plotType
    case 'scatterplots'
        ind = [1:4 length(Labels)-1:length(Labels)];
        u= xregmenutool('create',...
            ux,...
            'label',Labels(ind),...
            'callback', Cbks(ind),...
            'Tag',Tags(ind),...
            'Accelerator',Accel(ind),...
            'check',Check(ind));
        set([u(5),u(end)],'separator','on');
    case 'specialplots'
        u= xregmenutool('create',...
            ux,...
            'label',Labels,...
            'callback', Cbks,...
            'Accelerator',Accel,...
            'Tag',Tags,...
            'check',Check);
        set([u(5),u(9:10)],'separator','on');
end
if strcmp(mclass,'modeldev')
    if strcmp(plotType,'scatterplots')
        % monitor plot variables
        u(end+1)= uimenu('parent',ux,...
            'Label','Plot &Variables',...
            'tag','monitor',...
            'callback',@i_MonitorDlg);
    end
end


% ===========================================
% function i_PlotSweep
% ===========================================
function i_plotsweep(mL,null)
% right click on a point to see the sweep it comes from.
p= get(MBrowser,'CurrentNode');
if ~p.isRespFeat
    return
end

ol = i_getOutlierLine;
p= ol.p_mdev;
% Get the data;

switch get(mL,'type')
    case 'line'
        [x,y,dataOK]= FitData(p.info);

        ax= get(mL,'parent');

        % find the point in the line that we have clicked on.
        pos=get(ax,'currentpoint');
        pos=pos(1,1:2);
        xdata=get(mL,'xdata');
        ydata=get(mL,'ydata');
        metric=((xdata-pos(1))./diff(get(ax,'xlim'))).^2 + ...
            ((ydata-pos(2))./diff(get(ax,'ylim'))).^2;
        [md,mLind]=min(metric);
        if isempty(mLind)
            return
        end

        %  pt=[xdata(mLind),ydata(mLind)];
        testnums=testnum(x);
        testnums=testnums(dataOK);
        TN=testnums(mLind);
        % observed y data
        yobs= double(y(dataOK));
        yobs= yobs(mLind);
        % predicted y
        x=double(x);
        xp= x(dataOK,:);
        xp= xp(mLind,:);

    case 'uicontrol'
        x= getdata(p.info,'X',0);
        y= double(getdata(p.info,'Y',0));

        str = get(mL,'string');
        ind = get(mL,'value');
        if isempty(str) || ind==0
            return
        end
        str= strrep(str{ind},'*','');
        TN = str2num(str);
        testnums=testnum(x);
        mLind = find(testnums==TN);

        % observed y data
        yobs= y(mLind);
        % predicted y
        x=double(x);
        xp= x(mLind,:);
end


m= p.model;
yhat= EvalModel(m,xp);

plocal= p.Parent;
while plocal~=0 && ~isa(plocal.model,'localmod')
    % find local modeldev node
    plocal= plocal.Parent;
end

if plocal==0
    return
end

presp= plocal.Parent;

XData= plocal.getdata('X');
YData= plocal.getdata('Y');

SNo=testnum(XData)==TN;
XG= p.getdata('X');

Xg = double(XG(:,:,SNo));
Xgc= code(m,Xg);
fh= figure('Numbertitle','off',...
    'Name',p.fullname,...
    'Tag','DisplayPlots');
ax= xregaxes('parent',fh);

plot(XData(:,1,SNo),YData(:,:,SNo),'o','bd','parent',ax);

set(get(ax,'title'),...
    'string',['Test ',sprintf('%3d',TN)],...
    'FontWeight','Bold')
set(get(ax,'ylabel'),...
    'interpreter','none',...
    'string',presp.name);


% Display Experimental Point (Natural and Code values)
dispstr= [char(get(m,'symbol')) blanks(size(XG,2))' num2str(Xg','%10.4g')...
    blanks(size(XG,2))' num2str(Xgc','%5.2f')];
str1=num2str(yobs,'%7.3f');
str2=num2str(yhat,'%5.3f');
strn=char(str1,str2);
s1=['Observed  : ';'Predicted : '];
dispstr=char([s1,strn],'',dispstr);
th=text('parent',ax,...
    'units','norm','pos',[0.95,0.02],...
    'string',dispstr,....
    'FontName','Courier New',...
    'FontSize',9,...
    'Interpreter','none',...
    'horizon','right','vert','bottom');
tpos= get(th,'extent');

Note= plocal.SweepNotes(SNo);
lineLength = 30;
if ~isempty(Note)
    if size(Note,1)==1 && length(Note)>lineLength  % note is one long line
        Note = [Note, blanks(lineLength-rem(length(Note),lineLength))];
        Note = reshape(Note,lineLength,length(Note)/lineLength);
        Note=Note';
    end
    text('parent',ax,...
        'units','norm','pos',[0.95,0.04+tpos(4)],...
        'string',Note,....
        'FontName','Courier New',...
        'FontSize',9,...
        'Interpreter','none',...
        'horizon','right','vert','bottom');
end



function i_MonitorDlg(h,evt)

mbH= MBrowser;
p=get(mbH,'currentnode');
mdev= info(p);
if mdev.ModelStage==1
    data = getdata(p.info,'ALLDATA');
    ok = monitordlg('create',address(p.mdevtestplan),data);
    if ok
        i_updateview(p.info,mbH.Figure)
    end
end


function i_SelectCriteria

mbH= MBrowser;
p=get(mbH,'currentnode');
mdev= info(p);

[mdev,OK]= OutlierDialog(mdev);
if OK
    diagnosticPlots(mdev,'updateview',mbH.Figure);
end
