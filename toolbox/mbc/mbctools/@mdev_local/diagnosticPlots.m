function varargout= diagnosticPlots(md,action,varargin)
% MDEV_LOCAL/DIAGNOSTICPLOTS
% This routine will draw the diagnostic plots
% for any modeldev object.
%
% brdr= diagnosticPlots(m,'create',varargin);
% 
% will create a set of diagnostic plots on a new figure.
% brdr is a layout object that can be packed into other
% layout managers.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.4 $  $Date: 2004/02/09 08:04:27 $



if nargin <2 
   action = 'create';
end

% ----------------------
% Begin the SwitchYard
% ----------------------
switch lower(action)
case 'create'
   [varargout{1:nargout}]= i_create(md,varargin{:});
   % these actions require knowledge of sweep position so must be overloaded
case 'updateview'
   i_updateview(md,varargin{:});
case 'applyoutliers'
   i_applyoutliers(varargin{:});
case 'restoreoutliers'
   i_restoreoutliers(varargin{:});
case 'expand'
   i_expand;
case 'specialplotdraw'
   i_specialplotdraw(varargin{:});
case 'setoutliers'
   i_setOutliers(varargin{:});
case 'getoutliers'
   varargout{1} = i_getOutliers(varargin{:});
case 'testnum'
   i_testnum(varargin{:});
otherwise
   % most actions are done by modeldev/diagnosticsPlots
   if nargout
      [varargout{1:nargout}]= diagnosticPlots(modeldev,action,varargin{:});
   else
      diagnosticPlots(modeldev,action,varargin{:});
   end
end


% ----------------------
% function i_create
% ----------------------
function [f,layout,View]= i_create(md,hFig,View,varargin);

% most actions are done by modeldev/diagnosticsPlots
if nargout
   [f,layout,View]= diagnosticPlots(modeldev,'create',hFig,View,varargin{:});
else
   diagnosticPlots(modeldev,'create',varargin{:});
end

% 
% % get uicontextmenu
ol= View.OutlierLine;

schema.prop(ol,'SNo','mxArray');
schema.prop(ol,'Model','mxArray');
schema.prop(ol,'XFitData','mxArray');
schema.prop(ol,'YFitData','mxArray');
ol.SNo = -1; %%



% ===========================================
% function i_updateview
% ===========================================
function varargout= i_updateview(md,fH,View,m,X,Y)
% This function updates ONLY the data in the graph2d object.
%% called from mv_LocalReg(i_View)

mbH= MBrowser;
if nargin<3
   View= mbH.GetViewData;
end
SNo= View.SweepPos;
% local model
if nargin<=3
   m=LocalModel(md,SNo);
   [X,Y]= getdata(md);
   X= X(:,:,SNo);
   Y= Y(:,:,SNo);
end
OK= md.FitOK;

% outlier line
ol = i_getOutlierLine;
ax= ol.lineParents;
g= ol.g;

% update the outlier line data
ol.p_mdev= address(md);
ol.SNo= SNo;
ol.Model= m;
ol.XFitData= X;
ol.YFitData= Y;

SweepChanged = 1;
if isfield(View,'SweepPos')
   SweepChanged = ol.SNo ~= View.SweepPos;
end

% %% title of scatter plots
tH= get(g.axes,'title');
% set(tH,'string',['Test ',num2str(testnum(X))],...
%     'FontWeight','bold');
% Check the data is ok...
if ~OK(SNo) %% it is NOT okay
   % Clean up the axes.
   set(tH,'string',['Test ',num2str(testnum(X)),' - Model not fitted'],...
      'fontweight','bold');
   data= [double(X) double(Y)];
   %% we will plot the data in RED
   
   [Xc,Yc,fOK,badIndex]=checkdata(m,X,Y);
   %% end of finding data we can plot  
   data= real(data(~badIndex,:));
   
   set(g,...
      'limits',repmat({'auto'},1,size(data,2)),...
      'data',data,...
      'factors',[get(X,'name');get(Y,'name')]);
   set(g.line,'MarkerFaceColor','r','tag','main line')
   
   if ishandle([ol.SpecialPlotAxes]);
      ax= ol.SpecialPlotAxes;
      kids=get(ax,'children');
      delete(kids);
      set(ax,'ylimmode','auto','xlimmode','auto')
      set(get(ax,'xlabel'),...
         'string',['Test ',num2str(testnum(X)),' - Model not fitted'],...
         'fontweight','bold');
   end
   
   if SweepChanged 
      clear(ol);
   end	
   diagnosticPlots(md,'updateoutlier');
   return
else %% sweep is okay
   %% return graph labels to normal if we had errors written on them
   set(tH,'string','');
   set(get(ol.SpecialPlotAxes,'xlabel'),'fontweight','normal');
   
   set(g.line,'MarkerFaceColor','b','tag','main line')
   
   [data,factors,standardPlotStr,olIndex]= diagnosticStats(md,SNo,X,Y,[],m);
   
   %% === PLOT SCATTER GRAPH2D ===
   set(g,...
      'limits',repmat({'auto'},1,size(data,2)),...
      'data',data,...
      'factors',factors);
   
   %% since things have changed, check special plots are OK
   lb= ol.SpecialPlotListBox;
   lb_val=get(lb,'value');
   if lb_val>length(standardPlotStr)
      set(lb,'value',max(1,length(standardPlotStr)));
   end
   if isempty(standardPlotStr)
      standardPlotStr = '<none>'; %% this picked up in specialplotdraw
   end
   set(lb,'string',standardPlotStr);
   
   % update the potential outliers if sweep number has changed
   ol.outlierIndices= olIndex';
   
   %% === PLOT SPECIAL/OTHER  ===
   % diagnosticPlots(md,'specialplotdraw',fH,ol.SpecialPlotAxes,ol);
   i_specialplotdraw(fH,ol.SpecialPlotAxes,ol);
   
   % draw test numbers


   redraw(ol);
end
i_testnum;


% ===========================================
% Function i_SpecialPlotDraw
% ===========================================
function varargout= i_specialplotdraw(fH,ax,ol)
%% draws the special plot for local model
%% updates the outlier line to display correctly for this new plot

if nargin < 2
    % find outlier line and current axes
    ol = i_getOutlierLine;
end

% diag userdata in ol
ax = ol.SpecialPlotAxes;
delete(get(ax,'children'));

% pointer to current modeldev node
md= ol.p_mdev.info;

L= ol.Model;
Xs= ol.XFitData;
Ys= ol.YFitData;
SNo= ol.SNo;


if md.FitOK(ol.SNo)
    % Get the function to plot
    lb= ol.SpecialPlotListBox;
    value= get(lb,'value');
    str= get(lb,'string');
    if any(ismember(str, '<none>'))
        % switch away from special plots as there are none!
        diagnosticPlots(md,'changePlot',fH,3);
        return
    end
    plotname= str{value};

    %%-----switch off some options in uicontextmenu-------
    uic= get(ax,'uicontextmenu');
    kids= get(uic,'children');
    set(kids(end),'callback',{@i_Multiselect, ol});

    ubd= findobj(kids,'tag','showBD1');
    uci= findobj(kids,'tag','confidence interval');
    utr= findobj(kids,'tag','ytrans_units');
    ulg= findobj(kids,'tag','legend');
    uout = findobj(kids,'tag','outlier');
    u = [ubd, uci, utr];

    % update the plots
    set(ax,'xgrid','on',...
        'xlimmode','auto',...
        'ylimmode','auto',...
        'XTickLabelMode','auto',...
        'XTickMode','auto',...
        'YTickLabelMode','auto',...
        'YTickMode','auto',...
        'box','on');

    mv_rotate3d(ax,'off');

    switch lower(plotname)
        case 'local response'
            set(ax,'View',[0 90])
            h= i_localplot(md,ax,ol);

            %% is there a Y trans?
            if isempty(get(L,'ytrans'))
                set(utr, 'enable','off');
            else
                set(utr, 'enable','on');
            end
            set([uci,ubd,ulg,uout'],'enable','on');
        case 'normal plot'
            set(ax,'View',[0 90])
            data= diagnosticStats(L,Xs,Ys);
            if ~isempty(data)
                studres= data(:,4);
                p=mv_normplot(studres,ax);
                set(p,'parent',ax,'hittest','off');
                set(p(1),'tag','main line',...
                    'hittest','on',...
                    'buttondownfcn','diagnosticPlots(modeldev,''click'',gcbo)');
                xH=get(ax,'xlabel');
                set(xH,'string','Probability');
                yH=get(ax,'ylabel');
                set(yH,'string','Data');
            end
            set([ulg,uout'],'enable','on');
            set([u],'enable','off');
        otherwise
            specialPlots(L,plotname,ax,Xs,Ys);
            set([u,ulg,uout'],'enable','off');
    end
    set(get(ax,'children'),'visible',get(ax,'visible'));
    % update the outlier line relative to this plot
    ml = findobj(ax,'tag','main line');
    add(ol, ml);

    % Set up a legend
    i_createLegend(ax,BestModel(md));

else
    set(get(ax,'xlabel'),'string', ...
        sprintf('Test %d - Model not fitted',testnum(Xs)));
end

%===========================================
%  function i_applyoutliers
% ===========================================
function i_applyoutliers(fH)

% get the potential outlier index
ol = i_getOutlierLine;

index = ol.outlierIndices;
clear(ol);
mv_LocalReg('applyoutliers', index);

% ===========================================
%  function i_restoreoutliers(fH)
% ===========================================
function i_restoreoutliers(fH)

% get the potential outlier index
ol = i_getOutlierLine;
clear(ol);
mv_LocalReg('restoreoutliers');
% ===========================================
% function i_expand
% ===========================================
function i_expand

set(gcbo,'enable','off');
% get the outlier line
ol = i_getOutlierLine;
% get the graph 2d object
g= ol.g;
% get the axes
ax= g.axes;
pos= get(ax,'position');
xpos= get(g.xpopup,'position');
dp= pos(2)-xpos(2);
pos= [pos(1)-10 xpos(2)+15 pos(3)+10 pos(4)+dp-10];
% Set popups and text invisible
set([g.xpopup, g.xtext, g.ypopup, g.ytext],'visible','off');

% set the size of the axes
set(ax,'position',pos);

% ===========================================
% Function i_getOutlierLine
% ===========================================
function ol = i_getOutlierLine

mb=MBrowser;
View= mb.GetViewData;
if isfield(View,'OutlierLine')
   ol = View.OutlierLine;
else
   ol = View.Global.OutlierLine;
end
% ===========================================
% Function i_Multiselect
% ===========================================
function i_Multiselect(caller, null, oL)
multiselect(oL);



% ===========================================
% Function i_localplot
% ===========================================
function h= i_localplot(mdev,AxHand,ol);
% MDEV_LOCAL/LOCALPLOT plots twostage sweep predictions


% this should be part of mdev_local/diagnosticStats
uic= get(AxHand,'uicontextmenu');
kids= get(uic,'children');
% Get the options from the context menu
ubd= findobj(kids,'tag','showBD1');
BDflag= strcmp(get(ubd,'check'),'on');
uci= findobj(kids,'tag','confidence interval');
cif= strcmp(get(uci,'check'),'on');
utr= findobj(kids,'tag','ytrans_units');
trans= strcmp(get(utr,'check'),'on');


PlotOpts= [BDflag,trans,cif,0,0];


L= ol.Model;
SNo= ol.SNo;

% twostage model
TS= BestModel(mdev);

PlotOpts(4)=1;
h=[];
View= GetViewData(MBrowser);
if ~isempty(TS) & ~View.Update
   % Local X and Y for this page
   
   [X,Y] = getdata(mdev,'FIT');
   % Global Dependents
   Xs= X{1}(:,:,SNo);    % Local Input Data
   XG= X{2}{SNo};        % Global Input Data
   Ys= Y{SNo};
   
   Cord= get(AxHand,'ColorOrder');
   if mle_best(mdev) %% plot the purple MLE line
      set(AxHand,'ColorOrder',[0.5 0 0.5]);
   else
      set(AxHand,'ColorOrder',[0 0.5 0]);
   end
   %% plot the twostage line(s)
   hLines= plot(TS,{Xs,XG},Ys,PlotOpts,AxHand);
   set(hLines,'HitTest','off')
   
   set(AxHand,'ColorOrder',Cord);
end

State= get(AxHand,'nextplot');
set(AxHand,'nextplot','add')

if mdev.FitOK(SNo)
   [XL,YL,DataOK]= FitData(mdev,SNo);
   %% plot the local fit and the data points
   h= plot(L,XL,YL,DataOK,PlotOpts,AxHand);
end

set(AxHand,'nextplot',State)

if ~isempty(h);
   kids= findobj(AxHand,'type','line');
   set(h,'tag','main line',...
      'buttondownfcn','diagnosticPlots(modeldev,''click'',gcbo)');
   set(kids(kids~=h),'hittest','off');
end	


%------------------------------------------------------------------------
% subfunction i_createLegend
%------------------------------------------------------------------------
function i_createLegend(AxHand,TS)
%% create legend
%% the contextmenu of the special plots
contm= get(AxHand,'uicontextmenu');
uim = findobj(contm,'type','uimenu','tag','legend');

tags = {'main line','BDPts','localfit','localdatum',...
    'localfcnvals','twostagepoints','twostagefit',...
    'twostagedatum','twostagefcnval'};

if isempty(TS) || ~ismle(TS) %% empty if no twostage model reconstructed yet
    allLabels = {'Data','Removed data','Local fit','Datum',...
        'Value for RF','Two-stage at data','Two-stage fit','Two-stage datum',...
        'Two-stage value at RF'};
else
    allLabels = {'Data','Removed data','Local fit','Datum',...
        'Value for RF','MLE at data','MLE fit','MLE datum',...
        'MLE value at RF'};
end

%% throw out empty lines
lineh=[];legLabels={};
for i=1:length(tags)
    h= findobj(AxHand,'type','line','tag',tags{i});
    if ~isempty(h) && ishandle(h) && length(get(h,'xdata')) %% no xdata
        lineh = [lineh;h];
        legLabels = [legLabels,repmat(allLabels(i),1,length(h))];
    end
end
if isempty(lineh)
    return
end
leg = mbcgraph.legend(lineh,legLabels, ...
    'Location', 'NorthWest', ...
    'MoveMode', 'boundtoaxes', ...
    'LockVisibleToParent', true, ...
    'Active', strcmp(get(uim,'checked'), 'on'));

% Listeners are checking for context menu changing the legend state and for
% the lines being deleted (Legend needs to be removed at this point to
% ensure no legend is shown for blank plots)
lh = handle(lineh(1));
ah = handle(AxHand);
uim = handle(uim(1));
ah.userdata = [ ...
    handle.listener(uim, uim.findprop('Checked'),'PropertyPostSet',{@i_legendSetActive, leg, uim}); ...
    handle.listener(lh, 'ObjectBeingDestroyed', {@i_legendDelete, leg}) ...
    ];

%------------------------------------------------------------------------
% subfunction i_legendSetActive
%------------------------------------------------------------------------
function i_legendSetActive(src, event,leg, uim)
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
% function i_testnum
% ===========================================
function ol=i_testnum(fh,ax,action)
mbh = MBrowser;
v=mbh.GetViewData;

ol= v.OutlierLine;
scAx = ol.g.axes;
spAx = ol.SpecialPlotAxes;
p = ol.p_mdev;
mdev= info(p);


SNo= ol.SNo;
L= ol.Model;
X= ol.XFitData;
Y= ol.YFitData;


mH(1)=findobj(get(scAx,'uicontextmenu'),'Tag','Test Num');
mH(2)=findobj(get(spAx,'uicontextmenu'),'Tag','Test Num');
menu = findobj(v.menus.view,'tag','testnum');
%% View menu

% Check to see if the text is already on
txtH=findobj([scAx,spAx],'type','text',...
   'Tag','TestNumText');


if nargin==0 
    % determine state from menu check box
    if strcmp(get(menu,'check'),'on')
        action = 'draw';
    else
        action = 'clear';
    end
elseif nargin<3
    % toggle show test number state
    if ~isempty(txtH);
        action = 'clear';
    else
        action = 'draw';
    end
end

delete(txtH);
switch action
case 'draw'
   if mdev.FitOK(SNo)
       tn= 1:size(Y,1);
       
       Yall= getdata(mdev,'Y');
       [bd,bdind]= intersect(sindex(Yall,SNo),outliers(mdev));
       tnbd = tn(bdind);
       tn(bdind)= [];
       i_drawtestnum(mdev,scAx,tn,tnbd);
       i_drawtestnum(mdev,spAx,tn,tnbd);
   end	
   set(mH,'check','on')
   set(menu,'check','on')
case 'clear'
    set(mH,'check','off');
    set(menu,'check','off')
end

function i_drawtestnum(mdev,ax, tn,tnbd);;

lh=findobj(ax,'tag','main line');
tnvis= get(ax,'visible');
lh=lh(1);
xdata=get(lh,'xdata');
ydata=get(lh,'ydata');

txt= zeros(length(tn),1);
tstr= mbcnum2str(tn,20,'%20.12g');
for i=1:length(xdata)
      
   txt(i)=text(xdata(i),ydata(i),tstr(i,:),...
      'parent',ax(1),...
      'fontsize',8,...
      'color',[0 0 0],...
      'horizontalalignment','right',...
      'hittest','off',...
      'verticalAlignment','bottom',...
      'Tag','TestNumText',...
      'visible',tnvis,...
      'clipping','off');
end

% check if we have to show testnumbers for bad data
lh =findobj(ax,'tag','BDPts');
if ~isempty(lh)
    bdx= get(lh,'xdata');
    bdy= get(lh,'ydata');
    bdok= isfinite(bdy);
    tstr= mbcnum2str(tnbd,20,'%20.12g');

    for i=1:length(tnbd)
        text(bdx(i),bdy(i),tstr(i,:),...
            'parent',ax(1),...
            'fontsize',8,...
            'color',[0 0 1],...   % blue text
            'horizontalalignment','right',...
            'hittest','off',...
            'verticalAlignment','bottom',...
            'visible',tnvis,...
            'Tag','TestNumText',...
            'clipping','off');
    end		
end
