function varargout= validate_rstool(Action,varargin)
%VALIDATE_RSTOOL Response surface explorer for model validation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.12.4.4 $  $Date: 2004/02/09 08:02:20 $


switch lower(Action)
    case 'create'
        [varargout{1:2}]= i_Create(varargin{:});
    case 'btnmotion'
        i_btnmotion(varargin{:})
    case 'view'
        % compulsory validation Action
        i_View(varargin{:});
    case 'select'
        i_select
    case 'btnup'
        i_btnup
    case 'print'
        i_Print(varargin{:});
    case 'cilevel'
        i_CILevel
end


% ---------------------------------------------
%   subfunction i_Create
% ---------------------------------------------
function [Tool, mainLyt]= i_Create(hFig,m,DataType,p,RememberSettings)

if nargin<5
    RememberSettings = true;
end
if nargin<4
    p= get(MBrowser,'currentnode');
end
if nargin<3
    DataType='FIT';
end

% compulsory tool properties
Tool.Name= '&Cross Section';
Tool.MultiSelect= 1;
Tool.mfile= mfilename;
Tool.Icon = 'rstool.bmp';
Tool.DataType= DataType;
Tool.Renderer='painters';
Tool.RememberSettings= RememberSettings;

nf= nfactors(m);

[L,U]= range(m);
s= get(m,'symbol');
gs(1)= ceil(sqrt(nf));
gs(2)= ceil(nf/gs);


xcs = [];
if Tool.RememberSettings;
    xcs = getCrossSection(p(1).mdevtestplan,m);
end

if size(xcs,1)==nf
    x = xcs(:,1);
    tol = xcs(:,2);
else
    x = (L+U)/2;
    tol = (U-L)/20;
end

j=1;
lh=[];
for i=1:nf
    if ~strcmpi(DataType,'NONE')
        txt{i}= xregclicktolinput(hFig,...
            'visible','off',...
            'name',s{i},...
            'value',x(i),...
            'tolerance',tol(i)/2,...
            'clickincrement',tol(i),...
            'min',L(i),'max',U(i));
    else %% no data
        txt{i}= xregclickinput(hFig,...
            'visible','off',...
            'name',s{i},...
            'value',x(i),...
            'clickincrement',10^(floor(log10(abs(U(i) - L(i))))-1),...
            'min',L(i),'max',U(i));
    end
    udL.factor=i;
    udL.ctrl= txt{i};

    hAx(i)=xregaxes('parent',hFig,...
        'visible','off',...
        'units','pixels',...
        'buttondownfcn','mv_zoom',...
        'box','on',...
        'xgrid','on','ygrid','on',...
        'position',[0 0 1 1]);
    % dragline
    lh(i)= line('parent',hAx(i),...
        'visible','off',...
        'xdata',x([i i]),...
        'ydata',[NaN NaN],...
        'color',[1 0.5 0],...
        'linewidth',3,...
        'buttondownFcn',[mfilename,'(''select'')'],...
        'userdata',udL,...
        'interruptible','off');
    set(get(hAx(i),'xlabel'),...
        'string',s{i},'interpreter','none');
end

L= xreglistctrl(hFig,...
    'visible','off',...
    'position',[1 1 200 200],...
    'controls',txt,...
    'callback',[mfilename,'(''view'',gcbf)'],...
    'cellheight',20   );

hFval=xregaxes('parent',hFig,...
    'visible','off',...
    'units','pixels',...
    'vis','off',...
    'box','on',...
    'xtick',[],'ytick',[],...
    'position',[0 0 1 1]);

fvLyt=axiswrapper(hFval);

u1= xreguicontrol('parent',hFig,...
    'style','check',...
    'value',1,...
    'position',[1 1 80 15],...
    'visible','off',...
    'string','Display confidence level (%):');
u2= xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','edit',...
    'horizontalalignment', 'right', ...
    'position',[1 1 80 15],...
    'callback',[mfilename,'(''CILevel'')'],...
    'backgroundcolor','w',...
    'userdata',95,...
    'string','95');
Tool.CICheck= u1;
Tool.CILevel= u2;
set(u1,'callback',{@i_confCheck,u2});

Tool.Constraints=xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','checkbox',...
    'string','Display boundary constraint',...
    'callback',[mfilename,'(''View'',gcbf)'],...
    'value',1);

if isempty(BoundaryModel(p(1).mdevtestplan,m))
    set(Tool.Constraints,'enable','off','value',0);
end

Tool.CommonY=xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','checkbox',...
    'string','Common y-axis limits',...
    'callback',[mfilename,'(''View'',gcbf)'],...
    'value',1);

if ~strcmpi(Tool.DataType,'NONE')
    Tool.SelData=xreguicontrol('parent',hFig,...
        'visible','off',...
        'style','pushbutton',...
        'string','Select Data Point...',...
        'callback',@i_SelectData);
else
    Tool.SelData=[];
end

% title for listctrl
inputTitle = xregGui.labelcontrol('Parent', hFig,...
    'visible','off',...
    'BaselineOffset', 7, ...
    'BaseLineOffsetZero', 'bottom', ...
    'BaseLineOffsetMode', 'manual', ...
    'string','Input factors:',...
    'LabelAlignment','left', ...
    'ControlSize', 100, ...
    'Control', Tool.SelData);

% add a gridlayout for the axes
g = xreglistctrl(hFig,...
    'visible','off');
% put axes in pairs into xregaxesinput
el={}; ind=1; num = length(hAx);
if num==1
    el{1} = xregaxesinput(hFig,hAx(1),'visible','off');
    set(el{1},'gapx',50);
    set(el{1},'NUMCELLS',1);
else
    for i = 1:2:num-1
        el{ind} = xregaxesinput(hFig,[hAx(i), hAx(i+1)],'visible','off');
        set(el{ind},'gapx',50);
        ind=ind+1;
    end
    if rem(num,2)
        el{ind} = xregaxesinput(hFig,hAx(i+2),'visible','off');
        set(el{ind},'gapx',50);
        set(el{ind},'NUMCELLS',2);
    end
end
% setting new controls also deletes old ones (inside xreglistctrl\set)
set(g,'elements',el);
set(g,'numcells',min(ceil(num/2),2));
set(g,'fixnumcells',min(ceil(num/2),2));

mainLyt=xreggridbaglayout(hFig,...
    'visible','off',...
    'border',[10 10 10 10],...
    'dimension',[11 4],...
    'rowsizes',[25 2 -1 5 20 3 20 3 20 5 200],...
    'colsizes',[160 70 30 -1],...
    'gapx',10,...
    'mergeblock',{[1 1],[1 3]},...
    'mergeblock',{[3 3],[1 3]},...
    'mergeblock',{[11 11],[1 3]},...
    'mergeblock',{[1 11],[4 4]},...
    'elements',{...
    inputTitle, [], L, [], u1, [], Tool.Constraints, [], Tool.CommonY, [], fvLyt, ...
    [], [], [], [], u2, [], [], [], [], [], [], ...
    [], [], [], [], [], [], [], [], [], [], [],...
    g});
Tool.Brdr=mainLyt;
Tool.ListCtrl= L;
Tool.Axes= hAx;
Tool.AxGrid = g;
Tool.selectors= lh;
Tool.funVals= hFval;
Tool.helpmenus={'&Cross Section Help','xreg_modSel_crossSection'};


% ---------------------------------------------
%   subfunction i_View
% ---------------------------------------------
function i_View(hFig,Tool,ModelInfo,ModelList)

if nargin < 3
    [Tool,m,ModelList,pNode]=i_GetTool(hFig);
else
    m= ModelInfo{3};
    pNode= ModelInfo{2};
end


set(hFig,'pointer','watch');
drawnow

% tidy up axes in preparation for drawing
set(Tool.Axes(:),'ylimMode','auto','xlimMode','auto')

delete(findobj(Tool.Axes,'tag','rslines'));
delete(findobj(Tool.Axes,'tag','datalines'));
delete(findobj(Tool.Axes,'tag','boundarydisplay'))

np= get(Tool.Axes,{'nextplot'});
set(Tool.Axes,'nextplot','add');

col= get(Tool.Axes(1),'colororder');
delete(get(Tool.funVals,'child'));

% confidence level
alpha= 1-(1-get(Tool.CILevel,'userdata')/100)/2;
df1=dferror(m{1});
if ~isfinite(df1)
    df1= Inf;
    ni1 = norminv(alpha);
else
    ni1 = tinv(alpha,df1);
end

% remove any transient models
rmModels= false(1,length(m));
for i=1:length(m)
    rmModels(i)= false; % istransient(m{i});
end
m= m(~rmModels);

if ~isempty(m)


    xd= get(Tool.ListCtrl,'values');
    els = get(Tool.ListCtrl,'elements');
    tol= zeros(1,length(els));


    if ~strcmpi(Tool.DataType,'NONE');
        for i = 1:length(els),
            tol(i) = get(els{i},'tolerance');
        end;
        % plot data
        [X,Y]= getdata(pNode(1).info,Tool.DataType);

        %% if twostage X = {Xl(numRecs x nl x numTests), Xg(numTests x nf-nl x numTests)}
        %% if onestage X = {Xg(numTests x nf x numTests)}

        mi= m{1};
        nf= nfactors(mi);
        if size(X{end},2)<nf
            %% not enough vars in global data
            %% need to expand global data and put alongside local
            Xg= expand(X{end},tsizes(Y));
            X = [X{1},Xg];
        else
            X = X{end};
        end

        X(isbad(Y),:)= NaN;
        Xdata= double(X);
        %% Create logical array shwing data in/out of tolerances
        D= zeros(size(Xdata));
        for j=1:nf %% for each of the model inputs
            %% find tolerances from gui - or create defaults if this is first time in
            if isempty(tol(j)) || isnan(tol(j))
                tol(j) = max( diff(sort(Xdata(:,j))) );
                set(els{j},'tolerance',num2str(tol(j)));
            end
            D(:,j) = abs( Xdata(:,j)-xd{j}(1) ) < tol(j);
        end
        for i=1:nf
            ah= Tool.Axes(i);
            %% which data are within tols for ALL other factors?
            Dindex= find(all(D(:,i~=(1:nf)),2));
            Xc = X(Dindex,i);
            Xdata= double(Xc);
            Ydata= double(Y(Dindex,1,:));
            % only use finite data
            DataOK= isfinite(Ydata);
            Xdata= Xdata(DataOK,:);
            Ydata= Ydata(DataOK,:);
            Dindex= Dindex(DataOK);

            % plot data and set callback
            datalines = plot(Xdata,Ydata,'.k','parent',ah,'MarkerSize',20,'tag','datalines');
            set(datalines,'buttondownfcn',{@i_dataInfo,i,X(Dindex,:,:), Dindex });
        end
    end

    % Plot a heading for the whole legend
    ht=0.98;
    th = xregtext(.02,ht,...
        'Selected model values:',...
        'parent',Tool.funVals,...
        'verticalalignment','top',...
        'fontsize',8,...
        'clipping','on',...
        'horizontalalignment','left');
    htTxt = get(th,'extent');
    ht = ht - htTxt(4)*1.4;

    for i=1:length(m)
        % current value and pev
        [p,yhat]=pev(m{i},[xd{:}]);

        %% see if we are plotting Confidence Intervals
        if get(Tool.CICheck,'value');
            df= dferror(m{i});
            if df~=df1
                if  ~isfinite(df)
                    ni = norminv(alpha);
                else
                    ni = tinv(alpha,df);
                end
            else
                ni=ni1;
            end
            dispStr = sprintf('''%s''\n   yhat = %.4g \\pm %.4g',detex(ModelList{i}),yhat,ni*sqrt(p));

        else
            ni = NaN;
            dispStr = sprintf('''%s''\n   yhat = %.4g',detex(ModelList{i}),yhat);
        end

        % main plots
        rsplot(m{i},xd,Tool.Axes,Tool.selectors,ni,col(i,:));

        % write confidence intervals in legend
        th=xregtext(.05,ht,...
            dispStr,...
            'parent',Tool.funVals,...
            'verticalalignment','top',...
            'color',col(i,:),...
            'fontsize',8,...
            'clipping','on',...
            'horizontalalignment','left');
        htTxt= get(th,'extent');
        ht= ht- htTxt(4)*1.2;
    end

    %% ensure invisible axes (of the grid) are not set visible=on
    redraw(Tool.AxGrid,'cell');

    % save selected values and tolerances
    if  Tool.RememberSettings
        if strcmpi(Tool.DataType,'NONE');
            xcs= getCrossSection(pNode(1).mdevtestplan,m{1});
            xcs(:,1)= [xd{:}]';
            setCrossSection(pNode(1).mdevtestplan,m{1},xcs);
        else
            xcs= [[xd{:}]' tol(:)*2];
            setCrossSection(pNode(1).mdevtestplan,m{1},xcs);
        end
    end

    allLines= findobj(Tool.Axes(:),'type','line');
    if get(Tool.CommonY,'value')
        % common Y axis
        ydata= get(allLines(:),{'ydata'});
        ylimMin = min( cat(2,ydata{:}) );
        ylimMax = max( cat(2,ydata{:}) );
        CommonY= [ylimMin ylimMax];
        set(Tool.Axes(:),'ylim', CommonY);
        set(Tool.selectors,'ydata',CommonY);
    else
        for i=1:length(Tool.Axes)
            % individual limits
            ydata= get(findobj(Tool.Axes(i),'type','line'),'ydata');
            ylimMin = min( cat(2,ydata{:}) );
            ylimMax = max( cat(2,ydata{:}) );
            ylim= [ylimMin ylimMax];
            set(Tool.Axes(i),'ylim', ylim);
        end
    end

    if get(Tool.Constraints,'value')
        % draw boundaries
        cmodel= BoundaryModel(pNode(1).mdevtestplan,m{1});
        if getsize(cmodel)== nfactors(m{1})
            hrect= rsplot(cmodel,m{1},xd,Tool.Axes);
        end
    end
else
    for i=1:length(Tool.Axes);
        text(0.5,0.5,'No cross-section for transient models',...
            'HorizontalAlignment','center',...
            'parent',Tool.Axes(i),'units','normalized');
    end
end % if ~isempty(m)

set(Tool.Axes(:),{'nextplot'},np);
set(hFig,'pointer',get(0,'DefaultFigurePointer'))


% ---------------------------------------------
%   subfunction i_select
% ---------------------------------------------
function i_select
hFig=gcbf;
[Tool,m,ModelList]=i_GetTool(hFig);

% construct data package that contains only what is needed for dragging operation
ptr=xregGui.RunTimePointer;
ud.Figure=hFig;
ud.lineH = gcbo;
ud.axesH=get(ud.lineH,'parent');
ud.axesXlim=get(ud.axesH,'xlim');
objud=get(ud.lineH,'userdata');
ud.ctrl = objud.ctrl;
ud.ind = objud.factor;
ud.textH = get(Tool.funVals,'child');
ud.textH = ud.textH(end-1:-1:1);
xd= get(Tool.ListCtrl,'values');
ud.startPoint=[xd{:}];
ud.alpha= 1-(1-get(Tool.CILevel,'userdata')/100)/2;
% calculate ni vector
ni=zeros(size(m));
df1=dferror(m{1});
if ~isfinite(df1)
    df1= Inf;
    ni(1) = norminv(ud.alpha);
else
    ni(1) = tinv(ud.alpha,df1);
end
for k = 2:length(m)
    df=dferror(m{k});
    if df~=df1
        if ~isfinite(df)
            ni(k) = norminv(ud.alpha);
        else
            ni(k) = tinv(ud.alpha,df);
        end
    else
        ni(k) = ni(1);
    end
end
ud.ni=ni;
ud.doCI = get(Tool.CICheck,'value');
if ud.doCI
    ud.txtformat = '''%s''\n   yhat = %.4g \\pm %.4g';
else
    ud.txtformat = '''%s''\n   yhat = %.4g';
end
for k=1:length(ModelList)
    ModelList{k} = detex(ModelList{k});
end
ud.ModelList=ModelList;
ud.Models = m;
ud.WBUF = get(hFig,'WindowButtonUpFcn');

ptr.info=ud;
set(hFig,'pointer','left',...
    'WindowButtonMotionFcn',{@i_btnmotion,ptr},...
    'WindowButtonUpFcn',{@i_btnup,ptr});


% ---------------------------------------------
%   subfunction i_btnup
% ---------------------------------------------
function i_btnup(src,evt,ptr)
tmpud=ptr.info;

set(gcbf,'pointer',get(0,'DefaultFigurePointer'),...
    'WindowButtonMotionFcn','',...
    'WindowButtonUpFcn',tmpud.WBUF)
i_View(tmpud.Figure);
delete(ptr);


% ---------------------------------------------
%   subfunction i_btnmotion
% ---------------------------------------------
function i_btnmotion(src,evt,ptr)
tmpud=ptr.info;

x= get(tmpud.axesH,'currentpoint');
x(1)= min(max(x(1),tmpud.axesXlim(1)),tmpud.axesXlim(2));
% move line
set(tmpud.lineH,'xdata',[x(1) x(1)]);
% change list value
set(tmpud.ctrl,'value',x(1));

m = tmpud.Models;
ni = tmpud.ni;
xd = tmpud.startPoint;
xd(tmpud.ind) = x(1);

% update function/CI display
for i=1:length(m)
    [p,yhat]=pev(m{i},xd);
    if tmpud.doCI
        % confidence interval
        set(tmpud.textH(i),'string',sprintf(tmpud.txtformat,tmpud.ModelList{i},yhat,ni(i)*sqrt(p)));
    else
        % function value only
        set(tmpud.textH(i),'string',sprintf(tmpud.txtformat,tmpud.ModelList{i},yhat));
    end
end
drawnow('expose')

% ---------------------------------------------
%   subfunction i_confCheck
% ---------------------------------------------
function i_confCheck(src,event,editBox)

val = get(src,'value');

if val
    set(editBox,'enable','on','backgroundcolor','w');
else
    set(editBox,'enable','off','backgroundcolor',get(gcbf,'color'));
end

i_View(gcbf);

% ---------------------------------------------
%   subfunction i_CILevel
% ---------------------------------------------
function i_CILevel

if xregCheckIsNum('range',[70 99.9])
    i_View(gcbf);
end


% ---------------------------------------------
%   subfunction i_GetTool
% ---------------------------------------------
function [Tool,Models,ModelList,p]=i_GetTool(hFig)

if nargout==1
    Tool=mv_ValidationTool('get',hFig);
else
    [Tool,ModelInfo,ModelList]=mv_ValidationTool('get',hFig);
    p= ModelInfo{2};
    Models= ModelInfo{3};
end

% ---------------------------------------------
%   subfunction i_dataInfo
% ---------------------------------------------
function i_dataInfo(src,event,j,X, allTests)

% j (of 1:nf) is the input factor for this graph
% X is a sweep set for the data in this line

cp = get(gca,'currentpoint');
cp = cp(1,1:2);
Xdata = double(X);
X= X(isfinite(Xdata(:,j)),:);
Xdata= Xdata(isfinite(Xdata(:,j)),:);
% Y data of line
lineY = get(src,'ydata')';

ah = get(src,'parent');
[nullx,indx]=min(abs(Xdata(:,j)-cp(1)));
[nully,indy]=min(abs(lineY-cp(2)));
% find all data points within tols of currentPoint
accuracy = 100;
tolX = diff(get(ah,'xlim'))/accuracy;
tolY = diff(get(ah,'ylim'))/accuracy;
ind = find(all( [abs(Xdata(:,j)-cp(1))<tolX, abs(lineY-cp(2))<tolY] ,2));

% sometimes the patch appears with no data!!!
if isempty(ind)
    %% at worst, show the two points that were very near to cp
    ind = unique([indx,indy]);
end

hFig= get(ah,'parent');
[Tool,m]=i_GetTool(hFig);
if strcmp(get(hFig,'SelectionType'),'open') && ~isempty(ind)
    % select clicked point and redraw
    Xd= double(X(ind(1),:));
    set(Tool.ListCtrl,'values',num2cell(Xd));
    i_View(hFig);
else
    inputs = factorNames(m{1});
    names = strvcat(inputs);
    names = strvcat('TEST',names);
    %% need to get all coods into strings and concatenate in blocks
    %% saves playing around with tabbing the text to get alignment
    if isa(X,'sweepset')
        % use test numbers from sweepset
        if size(X,1)==size(X,3)
            allTests = testnum(X(ind));
        else
            allTests= zeros(1,length(ind));
            for i=1:length(ind)
                allTests(i) = testnum(X(ind(i),:));
            end
        end
    else
        allTests= allTests(ind);
    end
    outStr='';
    dataStr = '';

    for j=1:length(ind) %% counts through all points "hit"
        dataStr=sprintf(' %.4g',allTests(j));
        for i = 1:length(inputs) %% counts through all coords
            thisStr = sprintf(' %.4g',Xdata(ind(j),i));
            dataStr = strvcat(dataStr,thisStr);
        end
        outStr = [outStr,dataStr];
    end
    % display patch
    i_dataPatch(ah,[names,outStr],cp);
end

return

%----------------------------------------------------------------------
%  SUBFUNCTION i_dataPatch
%----------------------------------------------------------------------
function i_dataPatch(ax,infoStr,CP)

xmode =    get(ax,'xlimmode');
ymode =    get(ax,'ylimmode');
set(ax,'xlimmode','manual','ylimmode','manual','layer','bottom')
% save old ax units
oldUnits=get(ax,'units');

commonUnit = 'point';

%create the text to find out its extent and hence if it fits in the figure
ph=patch('FaceColor',[1 1 0.8],...
    'visible','off',...
    'EdgeColor','k',...
    'tag','dataPatch',...
    'FaceAlpha',1,...
    'clipping','off');

th=text(CP(1),CP(2),3.0,infoStr,...
    'units','data',...
    'visible','off',...
    'parent',ax,...
    'FontName','Lucida Console',...
    'clipping','off',...
    'horiz','left',...
    'vert','bottom',...
    'Interpreter','none');

% --- everything in same units (commonUnit) to see if it all fits on ----
set([ax,th],'units',commonUnit);
Apos=get(ax,'position'); % =ax pos in commonUnit
axW = Apos(3);
axH = Apos(4);

% sort out text size (a bit!)
maxFontSize = 8; %in 'point'
fsize= min(axH/size(infoStr,1),maxFontSize);
fsize= min(fsize,1.7*axW/size(infoStr,2));
% set text fontsize in 'point'
set(th,'fontsize',fsize);
% now find how much space the text takes up
ext = get(th,'extent');

if (ext(1)+ext(3))>axW % goes off axes right
    if (ext(1)-ext(3))<0 % will go off left if we right-align text
        Tpos = get(th,'position');
        set(th,'position',[0, Tpos(2)]);
    else
        set(th,'horiz','right');
    end
end

if (ext(2)+ext(4))>axH % goes off axes top
    if (ext(2)-ext(4))<0 % goes off bottom
        Tpos = get(th,'position');
        set(th,'position',[Tpos(1),0]);
    else
        set(th,'vert','top');
    end
end

% revert to original units
set(ax,'units',oldUnits);
set(th,'units','data');
ex=get(th,'Extent');
set(ph,'XData',[ex(1),ex(1),ex(1)+ex(3), ex(1)+ex(3)],...
    'YData',[ex(2),ex(2)+ex(4) ex(2)+ex(4),ex(2)],...
    'ZData',repmat(2.0,[1,4]));

oldUpFcn = get(gcbf ,'WindowButtonUpFcn');
set(gcbf ,'WindowButtonUpFcn',{@i_killPatch, ph, th, xmode, ymode, oldUpFcn});
set([th,ph],'visible','on');

%----------------------------------------------------------------------
%  SUBFUNCTION i_killPatch
%----------------------------------------------------------------------
function i_killPatch(hFig, null, ph, th, xmode, ymode, oldUpFcn)

% Remove text and patch
set(get(ph,'parent'),'xlimmode',xmode,'ylimmode',ymode)
set(gcbf ,'WindowButtonUpFcn',oldUpFcn);
delete(ph);
delete(th);


% ---------------------------------------------
%   subfunction i_Print
% ---------------------------------------------
function i_Print(Tool,Name)

lyt1= Tool.AxGrid;
lyt2= Tool.funVals;
printlayout1(lyt1,lyt2,Name);


function i_SelectData(src,evt)

[Tool,Models,ModelList,pNode]=i_GetTool(gcbf);
m= Models{1};

if ~strcmp(Tool.DataType,'NONE');
    [X,Y]= getdata(pNode(1).info,Tool.DataType);
    nf= nfactors(m);
    if size(X{end},2)<nf
        %% not enough vars in global data
        %% need to expand global data and put alongside local
        Xg= expand(X{end},tsizes(Y));
        X = [X{1},Xg];
    else
        X = X{end};
    end

    if isnumeric(X)
        Xd   = X;
        tnum = 1:size(X,1);
    else
        Xd= mean(X);
        tnum= testnum(X);
    end
    Ns= length(tnum);
    currentVal= get(Tool.ListCtrl,'values');
    els = get(Tool.ListCtrl,'elements');
    tol= zeros(1,nf);
    for i = 1:length(els),
        tol(i) = get(els{i},'tolerance');
    end;

    currentVal= [currentVal{:}];
    ind= find( all( abs( currentVal(ones(Ns,1),:) - Xd) < tol(ones(Ns,1),:) , 2) );
    if isempty(ind)
        ind= 1;
    else
        if length(ind)>1
            % closest point
            [dum,minIndex]= min( abs( currentVal(ones(length(ind),1),:) - Xd(ind,:) ) );
            ind= ind(minIndex(1));
        end
    end

    [ind,OK]= mv_listdlg('ListString', cellstr(mbcnum2str(tnum(:))),...
        'Name','Data Selection',...
        'InitialValue',ind,...
        'SelectionMode','single');

    if OK
        Xd= Xd(ind,:);
        set(Tool.ListCtrl,'values',num2cell(Xd));
        i_View(gcbf);
    end
end
