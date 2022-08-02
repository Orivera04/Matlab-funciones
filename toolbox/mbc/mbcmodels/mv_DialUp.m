function varargout= mv_DialUp(Action,varargin)
%MV_DIALUP Surface plot/table generator for viewing global models
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.2.5 $  $Date: 2004/04/04 03:30:43 $


switch lower(Action)
    case 'create'
        [varargout{1:2}]= i_Create(varargin{:});
    case 'close'
        % Make invisible for now, so default values can be retrieved
        % Figure is deleted when base model is changed or on Exit Main GR
        set(gcbf,'visible','off');
    case 'table'
        % Produce UITable of Values
        i_DrawTable(gcbf);
    case 'checkvals'
        % check values entered in edit boxes
        i_CheckVals(varargin{:})
    case 'export'
        % Export Matrix to Workspace
        i_Export;
    case 'replay'
        % Replay Movie
        i_Replay;
    case 'exclusive'
        i_Exclusive(varargin{:});
        i_DisplayType(varargin{1})
    case {'display','modelselect','view','plot'}
        % display called from datum checkbox
        i_Display(varargin{:})
    case {'displaytype'}
        i_DisplayType(varargin{:})
    case 'numsteps'
        i_NumSteps(varargin{:});
    case 'pethreshold'
        i_PEthreshold(varargin{:});
    case 'print'
        i_Print(varargin{:});
end

%-------------------------------------------------------------------
% SUBFUNCTION i_Create
%-------------------------------------------------------------------
function [Tool, mainPane] = i_Create(hFig,m,p,RememberSettings)
% creates a layout = mainPane with lots of bits inside
% returns mainPane unpacked and invisible

if nargin<3
    p= get(MBrowser,'currentnode');
end
if nargin<4
    RememberSettings = true;
end

Tool.Name= 'Response &Surface';
Tool.mfile= mfilename;
Tool.MultiSelect=0;
Tool.Icon = 'dialup.bmp';
Tool.model = m;
yi= yinfo(m);
Tool.RespName= yi.Name;
Tool.Renderer='zbuffer';
Tool.RememberSettings= RememberSettings;

labels= get(m,'symbol');
Types = InputFactorTypes(m);
isTwoStage= isa(m,'xregtwostage');
nf= nfactors(m);

% title for listctrl
listCtrlTitle = xreguicontrol(hFig,...
    'style','text',...
    'visible','off',...
    'string','Input factors:',...
    'horizontalalign','left');
% make a xreglistctrl object
hnd.listCtrl = xreglistctrl(hFig,...
    'visible','off',...
    'cellborder',2,...
    'border',4,...
    'cellheight',18,...
    'userdata',[]);

% -------------------------------------
%      Factor Selectors
% -------------------------------------
hnd.factor(1)=xreguicontrol('style','popupmenu',...
    'parent',hFig,...
    'string',' ',...
    'backgroundcolor','w',...
    'visible','off',...
    'value',1,...
    'tag','1');
hnd.text(1)=xreguicontrol('style','text',...
    'parent',hFig,...
    'string','X-axis factor:',...
    'visible','off',...
    'userdata',{});
hnd.factor(2)=xreguicontrol('style','popupmenu',...
    'parent',hFig,...
    'string',' ',...
    'value',min(2,nf),...
    'backgroundcolor','w',...
    'visible','off',...
    'userdata',0,...
    'tag','2');
hnd.text(2)=xreguicontrol('style','text',...
    'parent',hFig,...
    'string','Y-axis factor:',...
    'visible','off',...
    'userdata',{});
hnd.factor(3)=xreguicontrol('style','popupmenu',...
    'parent',hFig,...
    'string',' ',...
    'value',min(3,nf),...
    'backgroundcolor','w',...
    'visible','off',...
    'tag','3');
hnd.text(3)=xreguicontrol('style','text',...
    'parent',hFig,...
    'string','Time factor:',...
    'visible','off',...
    'userdata',{});
% Deal with type 2 input factors
% userdata of factors holds ListCtrl indices
if prod(Types)>1
    % some type 2 input factors
    % fix Xvar as "time", restrict other factors
    ind = find(Types==1);
    set(hnd.factor(1),'value',1,'enable','inactive',...
        'string',labels(1),'userdata',1);
    set(hnd.factor(2),'string',labels(ind(2:end)),...
        'userdata',ind(2:end),'value',1);
    set(hnd.factor(3),'string',labels(ind(2:end)),...
        'userdata',ind(2:end),'value',min(2,max(1,length(ind)-1)));
else
    set(hnd.factor,'string',labels,...
        'userdata',1:length(labels));
end
set(hnd.factor(1),'callback',[mfilename,'(''exclusive'',gcbf,1)']);
if nf>=2
    set(hnd.factor(2),'callback',[mfilename,'(''exclusive'',gcbf,2)']);
end
if nf>=3
    set(hnd.factor(3),'callback',[mfilename,'(''exclusive'',gcbf,3)']);
end

% Check Box to user absolute value of local variable
if isTwoStage && get(m,'DatumType')
    hnd.AbsX=xreguicontrol('parent',hFig,...
        'visible','off',...
        'style','checkbox',...
        'string',['Display using (',labels{1},' - datum)'],...
        'callback',[mfilename,'(''DisplayType'',gcbf)'],...
        'value',0);
    PEenable='on';
else
    PEenable='on';
    hnd.AbsX=[];
end

hnd.Constraints=xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','checkbox',...
    'string','Display boundary constraint',...
    'callback',[mfilename,'(''DisplayType'',gcbf)'],...
    'value',1);

if isempty(BoundaryModel(p.mdevtestplan,m))
    set(hnd.Constraints,'enable','off','value',0);
end

% -------------------------------------
%      Plot type controls + buttons
% -------------------------------------
% SEE WHICH PLOTS WILL BE POSSIBLE
n= nf - sum(Types>1);
%note: size includes text controls = none-value controls
if n<2
    DisplayTypes= {'Table','2-D Plot'};
    InitVal=2;
elseif n<3
    DisplayTypes= {'Table','2-D Plot','Multiline Plot','Contour Plot','Surface Plot'};
    InitVal=5;
else
    DisplayTypes= {'Table','2-D Plot','Multiline Plot','Contour Plot','Surface Plot','Movie'};
    InitVal=5;
end

hnd.dispType = xreguicontrol('parent',hFig,...
    'style','listbox',...
    'visible','off',...
    'string',DisplayTypes,...
    'BackgroundColor','w',....
    'value',InitVal,...
    'callback',[mfilename,'(''DisplayType'',gcbf)']);

% -------------------------------------
%   Controls specific to each plot type
% -------------------------------------
% Check Box for surface PE colouring
hnd.PEcol=xreguicontrol('parent',hFig,...
    'visible','off',...
    'style','checkbox',...
    'string','Prediction Error shading',...
    'callback',[mfilename,'(''Display'',gcbf)'],...
    'enable',PEenable,...
    'value',0);
hnd.PEthresh=xregGui.labelcontrol('parent',hFig,...
    'ControlSize',70,...
    'string','Prediction Error threshold:',...
    'visible','off',...
    'Control',xregGui.uicontrol('parent',hFig,...
    'visible','off',...
    'style','edit',...
    'backgroundcolor','w',...
    'callback',[mfilename, '(''PEthreshold'',gcbf)']));

String  = {'Contours...','Export','Replay'};
CallBack= {'','''Export''','''Replay'''};
for i=1:length(String);
    hnd.Btns(i)= xreguicontrol('parent',hFig,...
        'visible','off',...
        'style','push',...
        'string',String{i},...
        'callback',[mfilename,'(',CallBack{i},')']);
end
% Contour properties
udv.V=[];
udv.labels=1;
udv.fill=0;
set(hnd.Btns(1),'userdata',udv,...
    'callback',['mv_ContourValues(''create'',gcbf,''',mfilename,''')']);

hnd.framePS=xregGui.labelcontrol('parent',hFig,...
    'visible','off',...
    'ControlSize',50,...
    'string','Frames/second:',...
    'Control',xregGui.clickedit(hFig,...
    'visible','off',...
    'min',1,...
    'max',20,...
    'value',2,...
    'dragging','off',...
    'clickincrement',1));

%  Create the Export section
hnd.exportRadios=xregGui.rbgroup(hFig,'nx',1,'ny',2,'value',[1; 0],...
    'string',{'Export to workspace';'Export to mat file...'},...
    'visible','off');
export.text1=xreguicontrol('style','text',...
    'string','Save input as:',...
    'visible','off',...
    'horizontalalignment','left',...
    'parent',hFig);
hnd.exportName1=xreguicontrol('style','edit',...
    'backgroundcolor',[1 1 1],...
    'visible','off',...
    'horizontalalignment','left',...
    'string','X',...
    'parent',hFig);
export.text2=xreguicontrol('style','text',...
    'string','Save result as:',...
    'visible','off',...
    'horizontalalignment','left',...
    'parent',hFig);
hnd.exportName2=xreguicontrol('style','edit',...
    'backgroundcolor',[1 1 1],...
    'visible','off',...
    'horizontalalignment','left',...
    'string','Y',...
    'parent',hFig);

% -------------------------------------
%     TABLE for viewing data
% -------------------------------------
Tool.TablePos= [1 1 100 100];

% only create table on first viewing
hnd.DispTable=[];
hnd.ColorBar= [];
hnd.ColorBarWrapper=[];
% -------------------------------------
%     AXES for viewing data
% -------------------------------------
hnd.Axes=xregaxes('parent',hFig,...
    'units','pixels',...
    'visible','off');
hnd.axisWrapper = axiswrapper(hnd.Axes);

ux= uicontextmenu('parent',hFig);
set(hnd.Axes,'uicontextmenu',ux);
xregdialupmenu('init',hnd.Axes);

% ============ set up layouts ====================
PEcard = xreggridlayout(hFig,...
    'correctalg','on',...
    'packstatus','off',...
    'dimension',[3 1],...
    'rowsizes',[-1 20 20],...
    'gapy',2,...
    'elements',{[],hnd.PEcol,hnd.PEthresh});
CONTcard = xreggridlayout(hFig,...
    'correctalg','on',...
    'dimension',[2 2],...
    'rowsizes',[-1 25],...
    'colsizes',[-1 65],...
    'elements',{[],[],[],hnd.Btns(1)});
MOVIEcard = xreggridbaglayout(hFig,...
    'dimension',[4 2],...
    'colsizes',[-1 65],...
    'rowsizes',[-1 2 20 3],...
    'gapx',10,...
    'mergeblock',{[2 4],[2 2]},...
    'elements',{[],[],hnd.framePS,[],[],hnd.Btns(3),[],[]});
% card layout for PEcol, contour, replay
hnd.controlsCard = xregcardlayout(hFig,...
    'visible','off',...
    'numcards',5,...
    'currentcard',InitVal);
attach(hnd.controlsCard, PEcard, 3);
attach(hnd.controlsCard, CONTcard, 4);
attach(hnd.controlsCard, MOVIEcard, 5);

% listbox and cardLayout
hnd.insideChoice = xreggridlayout(hFig,...
    'correctalg','on',...
    'dimension',[2 1],...
    'rowsizes',[-1 47],...
    'elements',{hnd.dispType,hnd.controlsCard});
% frame round all of this
hnd.choiceFrame=xregframetitlelayout(hFig,...
    'innerborder',[10 10 10 10],...
    'visible','off',...
    'title','Display type',...
    'center',hnd.insideChoice);
% frame for export controls
exptop = xreggridbaglayout(hFig,...
    'dimension',[4 2],...
    'rowsizes',[35 -1 15 20],...
    'gapx',10,...
    'mergeblock',{[1 1],[1 2]},...
    'elements',{hnd.exportRadios,[],export.text1,hnd.exportName1,...
    [],[],export.text2,hnd.exportName2});
exp = xreggridbaglayout(hFig,...
    'dimension',[2 2],...
    'rowsizes',[-1 25],...
    'colsizes',[-1 65],...
    'gapy',10,...
    'mergeblock',{[1 1],[1 2]},...
    'elements',{exptop,[],[],hnd.Btns(2)});
hnd.exportFrame = xregframetitlelayout(hFig,...
    'visible','off',...
    'title','Export model values',...
    'center',exp,...
    'innerborder',[15 10 10 10]);

% the pane for graphs/tables
hnd.AxesLayout = xreggridlayout(hFig,...
    'visible','off',...
    'dimension',[1,2],...
    'correctalg','on',...
    'elements',{hnd.axisWrapper,[]},...
    'colsizes',[-1 -1],...
    'colratios',[1 0],...
    'border',[50 40 40 20]);
hnd.displayPane = xreglayerlayout(hFig,...
    'visible','off','elements',{[],hnd.AxesLayout});
rhspane= xreggridbaglayout(hFig,...
    'dimension',[5 5],...
    'rowsizes',[-1 15 15 2 22],...
    'colsizes',[-1 90 90 90 -1],...
    'gapx',20,...
    'mergeblock',{[1 1],[1 5]},...
    'elements',{hnd.displayPane,[],[],[],[],...
    [],[],hnd.text(1),[],hnd.factor(1),...
    [],[],hnd.text(2),[],hnd.factor(2),...
    [],[],hnd.text(3),[],hnd.factor(3)});

mainPane = xreggridbaglayout(hFig,...
    'visible','off',...
    'dimension',[8,2],...
    'gapy',2,...
    'gapx',20,...
    'rowsizes',[15, -1 20 20 5 -1 7 140],...
    'colratios',[.3 .7],...
    'mergeblock',{[1 8],[2 2]},...
    'border',[10 10 10 10],...
    'elements',{listCtrlTitle,hnd.listCtrl,...
    hnd.AbsX,hnd.Constraints,[],hnd.choiceFrame,[],hnd.exportFrame,rhspane});

Tool.Hand=hnd;
Tool.Movie=[];
Tool.helpmenus={'&Response Surface Help','xreg_modSel_surface'};
% sort out initial ranges
i_DisplayType(hFig,1,Tool,m,p)


%-------------------------------------------------------------------
% SUBFUNCTION i_GetValues (not *check* vals!!)
%-------------------------------------------------------------------
function [x,XVar,YVar,TVar]=i_GetValues(Tool,Check)
% call with 2 args and Check=0 returns new factor values
% WITHOUT checking single valuedness
% x = input data
% XVar = number of factor (from listctrl) for x-coords

% the handles
h=Tool.Hand;

x= get(h.listCtrl,'Values');

[XVar,YVar,TVar] = i_GetFactors(Tool);
factors = [XVar,YVar,TVar];


% Check that non X,Y,T variables must be scalar
m = Tool.model;
Types = InputFactorTypes(m);
if nargin < 2 || Check
    Str= get(h.listCtrl,'name');
    for i= 1:length(x)
        x{i}=x{i}(:);
        if ~any(i==factors) && length(x{i})>1 && Types(i)==1
            errordlg(['A single value is required for ',Str{i}],...
                'Plot Error','modal');
            XVar=[]; % signals error
            return
        end
    end
end

%-------------------------------------------------------------------
% SUBFUNCTION i_GetFactors (not *check* vals!!)
%-------------------------------------------------------------------
function [XVar,YVar,TVar] = i_GetFactors(Tool)
% for current factor selections, returns the relevant
% input control indices from the ListCtrl.

h=Tool.Hand;

XVals = get(h.factor(1),'userdata');
YVals = get(h.factor(2),'userdata');
TVals = get(h.factor(3),'userdata');

XVar = XVals(get(h.factor(1),'Value'));
YVar=[]; TVar=[];

Types = InputFactorTypes(Tool.model);
nf = nfactors(Tool.model) - sum(Types>1);
if nf>1
    YVar = YVals(get(h.factor(2),'Value'));
    if XVar==YVar
        YVar= find(~ismember( 1:nf, XVar) );
        YVar= YVar(1);
        set(h.factor(2),'Value',YVar)
    end

end
if nf>2
    TVar = TVals(get(h.factor(3),'Value'));

    if TVar==YVar || TVar==XVar
        TVar= find(~ismember( 1:nf, [XVar YVar]) );
        TVar= TVar(1);
        set(h.factor(3),'Value',TVar)
    end

end


return
%-------------------------------------------------------------------
% SUBFUNCTION i_ListCtrlCallback
%-------------------------------------------------------------------
function i_ListCtrlCallback(Tool,num)
% Input Objects can be eg. Type2 for dynamic models where time and input need same num of elements

% if Type 1 input factor changed - all Type 2 inputs should still be fine
% if Type 2 input factor changed - need to check all have same num of elements
h = Tool.Hand;
Types = InputFactorTypes(Tool.model);
ind = find(Types>1);
oldx = get(h.listCtrl,'Userdata');

if prod(Types)>1 && intersect(num, [1; ind(:)]) % callback is from Type 2 input factor

    x= get(h.listCtrl,'Values');
    xT2 = {x{1},x{ind}}; % the type 2 inputs
    if num==1 % new time vector
        for i = 2:length(xT2)
            if length(x{i})>1
                x{i} = spline(oldx{1},x{i},x{1});
            end
        end

    else
        % take new time to be
        x{1} = linspace(0, oldx{1}(end),length(x{num}));
        for i = setdiff(2:length(xT2),num)
            x{i} = spline(oldx{1},oldx{i},x{1});
        end

    end
    set(h.listCtrl,'Values',x,'userdata',x);
end
return
%-------------------------------------------------------------------
% SUBFUNCTION i_CheckVals
%-------------------------------------------------------------------
function i_CheckVals(src, evt, hFig )

Tool= i_GetTool( hFig );
num = evt.ListIndex;
h = Tool.Hand;

% Check for too many plot points
x = i_GetValues(Tool);

Types = InputFactorTypes(Tool.model);
numPoints = prod(cellfun('length',x(Types==1)));
DispType= get(h.dispType,'value');
switch DispType
    case '1' % table
        if numPoints > 10000
            errordlg('Too many plot points requested for a table. Please input a smaller number.',...
                'Plot error','modal');
            return
        end
    otherwise
        if numPoints > 1000000
            errordlg('Too many plot points requested. Please input a smaller number.',...
                'Plot error','modal');
            return
        end
end

controls = get(h.listCtrl,'controls');
% get new expression
Types = InputFactorTypes(Tool.model);
x = get(controls{num},'value');

if ischar(x) ...
        || isempty(x) ...
        || ~isa(x,'double') ...
        || ndims(x) > 2 ...
        || ~any(size(x)==1) ...
        || ~isreal(x)
    errordlg('Some inputs not numeric. Input controls should catch this.',...
        'Plot Error','modal');
    return
else
    % if some type 2 input factors
    if prod(Types)>1 && num==1 && x(1)<0
        errordlg('Time vector must be non-negative. Please enter a minimum value >=0.',...
            'Plot Error','modal');
        return
    end
    i_ListCtrlCallback(Tool,num);
    i_Display(hFig);
end

%-------------------------------------------------------------------
% SUBFUNCTION i_Exclusive
%-------------------------------------------------------------------
function i_Exclusive(hFig,factorNum)
% exclusive factor choice from popupmenu selectors
Tool= i_GetTool(hFig);
h = Tool.Hand;
Types = InputFactorTypes(Tool.model);

% inputs are listCtrl indices
% facs are indices for factor popups
[xvar yvar tvar] = i_GetFactors(Tool);
inputs = [xvar yvar tvar];
facs = [get(h.factor(1),'Value'),get(h.factor(2),'Value'),get(h.factor(3),'Value')];
if prod(Types)>1
    inputs(1) = 0;
    facs(1) = 0;
end

% what if < 3 inputs??
numControls = size(h.listCtrl) - sum(Types>1); % = length of factor popup string
if numControls < length(inputs) || numControls < length(facs)
    % eg. don't care about factor control 3 if only 2 inputs available
    inputs = inputs(1:numControls);
    facs = facs(1:numControls);
end


if nargin ==2 && length(unique(inputs))~=length(inputs)
    % h.factor(factorNum) is the one just changed
    % keep this the same and change another factor
    change = setdiff(find(inputs==inputs(factorNum)),factorNum);
    numEls = length(get(h.factor(change(1)),'string'));
    freeEls = setdiff(1:numEls,facs);
    if ~isempty(freeEls)
        set(h.factor(change),'value',freeEls(1));
    else
        warning('mv_dialup(i_Exclusive)...how can we have got here??');
    end
elseif length(unique(inputs))~=length(inputs)
    % If visible on has brought into play a control...must be YVar or TVar
    if facs(2)==facs(1)
        numEls = length(get(h.factor(2),'string'));
        freeEls = setdiff(1:numEls,facs);
        if ~isempty(freeEls)
            set(h.factor(2),'value',freeEls(1));
        else
            warning('mv_dialup(i_Exclusive)...how can we have got here??');
        end
    elseif length(unique(facs))~=length(facs) % change TVar
        numEls = length(get(h.factor(3),'string'));
        freeEls = setdiff(1:numEls,facs);
        if ~isempty(freeEls)
            set(h.factor(3),'value',freeEls(1));
        else
            warning('mv_dialup(i_Exclusive)...how can we have got here??');
        end
    end
end


%-------------------------------------------------------------------
% SUBFUNCTION i_DisplayType
%-------------------------------------------------------------------
function i_DisplayType(hFig,Start,Tool,m,p)

if nargin < 4
    [Tool,m,p]=i_GetTool(hFig);
end
h = Tool.Hand;
if nargin<2
    Start=0;
end

if ~istransient(m)

    Types = InputFactorTypes(m);

    if Start && all(Types==1)
        if Tool.RememberSettings
            % get default settings from testplan
            [x,DispType,factors] = getRespSurf(p.mdevtestplan,m);
            if length(x)~=nfactors(m)
                DefaultPlotSetup(p.mdevtestplan);
                [x,DispType,factors] = getRespSurf(p.mdevtestplan,m);
            end
        else
            % do a 2-d plot on first variable
            Bnds= getcode(m);
            mid= sum(Bnds,2)/2;
            x= {{Bnds(1,1), Bnds(1,2),21}  num2cell(mid(2:end)')};
            DispType= 2;
            factors= 1;
        end
        for i= 1:length(x);
            if iscell(x{i})
                % expand {min,max,numpts}
                x{i}= linspace(x{i}{:});
            end
        end
        for i= 1:length(factors)
            set(h.factor(i),'value',factors(i));
        end
        set(h.dispType,'value',DispType);
    elseif Start && prod(Types)>1
        x = cell(nfactors(m),1);
        XVar= 1; YVar=[]; TVar = [];
        DispType= 2;
        factors= 1;
        set(h.dispType,'value',DispType);
    else
        [x,XVar,YVar,TVar]=i_GetValues(Tool,0);
        DispType= get(h.dispType,'value');
    end

    % if we change Display Type, we want to plot the default number of points
    % for this new view eg. only 5 movie frames.
    resetFlag=0;
    set([h.factor(1),h.text(1)],'visible','on');
    switch DispType
        case 1
            % table
            TVar=[];
            if (size(h.listCtrl) - sum(Types>1))<2
                YVar=[];
            end
        case 2
            % 2-D plot
            YVar=[];
            TVar=[];
            resetFlag=1;
        case {3,4,5}
            % multi-line, contour, surface
            TVar=[];
    end

    if ~Start
        numActive = length([XVar,YVar,TVar]);
        [xvar yvar tvar] = i_GetFactors(Tool);
        factors = [xvar yvar tvar];
        factors = factors(1:numActive);
    end

    % work out default values
    [L,U]= range(m);
    if ~isempty(Tool.Hand.AbsX)
        AbsX= get(Tool.Hand.AbsX,'Value');
        if AbsX
            % local variable is relative to datum (range is centered around 0)
            m1= (L(1)+U(1))/2;
            L(1)= -m1;
            U(1)= m1;
        end
    end

    % =============================================================
    %                MAKING NEW CONTROLS
    % =============================================================
    % check for type 2 inputs
    Types = InputFactorTypes(m);
    labels= get(m,'symbol');

    NewVal ={};
    NewControls = {};
    % Set non-plotted variables to the (arithmetic) mean
    for inputNum = 1:nfactors(m)
        % inputs needing to be a vector eg. DYNAMIC MODEL
        if Types(inputNum)>1
            if length(x{inputNum})>=1 % input vector okay
                NewVal= {NewVal{:}, x{inputNum}};
                NewControls = {NewControls{:},xregvectorinput(hFig,labels{inputNum},x{inputNum})};
            else % create input vector with 21 points
                NewVal= {NewVal{:}, linspace(L(inputNum),U(inputNum),21)};
                NewControls = {NewControls{:},xregvectorinput(hFig,labels{inputNum},[0, repmat(U(inputNum),[1,20])] )};
            end

            % if inputNum NOT any of the plot factors
        elseif ~any(inputNum==factors) && ~(inputNum==1 && prod(Types)>1)
            if length(x{inputNum})~=1 % should be a constant
                NewVal= {NewVal{:},(L(inputNum)+U(inputNum))/2};
                % 5 steps through range
                stepVal= (U(inputNum)-L(inputNum))/5;
                tmp = xregclickinput(hFig,...
                    'name',labels{inputNum},...
                    'min',L(inputNum),'max',U(inputNum),...
                    'clickincrement',stepVal);
                set(tmp,'value',(L(inputNum)+U(inputNum))/2);
                NewControls = {NewControls{:},tmp};
            else % already is a constant hence okay
                NewVal= {NewVal{:},x{inputNum}};
                % 5 steps through range
                stepVal= (U(inputNum)-L(inputNum))/5;
                tmp = xregclickinput(hFig,...
                    'name',labels{inputNum},...
                    'min',L(inputNum),'max',U(inputNum),...
                    'clickincrement',stepVal);
                set(tmp,'value',x{inputNum});
                NewControls = {NewControls{:},tmp};
            end

            % if inputNum is a plot factor
        elseif isempty(x{inputNum}) ||  (length(x{inputNum})==1 && DispType~=1) || resetFlag
            % second clause since DispType=2=table can have size of 1
            if ~isempty(TVar) && inputNum==TVar
                N= 5; %num movie frames
            elseif DispType==3 && inputNum==YVar
                N=5;
            else
                N=21; %num plot points
            end
            NewVal= {NewVal{:}, linspace(L(inputNum),U(inputNum),N)};
            if DispType== 1 %table
                NewControls = {NewControls{:},xregvectorinput(hFig,labels{inputNum},linspace(L(inputNum),U(inputNum),N) )};
            else
                NewControls = {NewControls{:},...
                    xregrangeinput(hFig,'name',labels{inputNum},...
                    'value',linspace(L(inputNum),U(inputNum),N) )};
            end

            %(table) everything is okay! input is a vector as it should be for this factor
        else
            NewVal= {NewVal{:},x{inputNum}};
            if DispType== 1%table
                NewControls = {NewControls{:},...
                    xregvectorinput(hFig,labels{inputNum},x{inputNum} )};
            else
                NewControls = {NewControls{:},...
                    xregrangeinput(hFig,'name',labels{inputNum},...
                    'value',x{inputNum})};
            end
        end
    end
    set(h.listCtrl,'controls',NewControls);
    set(h.listCtrl, 'callback', {@i_CheckVals, hFig} );
    x = get(h.listCtrl,'values');
    set(h.listCtrl,'userdata',x);
else
    set([h.factor(2:end),h.text(2:end)],'visible','off');
end

if nargin == 1 || (nargin>1 && ~Start)
    % now display the plot
    i_Display(hFig);
end

return

%-------------------------------------------------------------------
% SUBFUNCTION i_Display
%-------------------------------------------------------------------
function i_Display(hFig,Tool,ModelInfo,otherinfo)

if nargin == 1
    [Tool,m,p]=i_GetTool(hFig);
else
    m= ModelInfo{3}{1};
    p= ModelInfo{2};
    % get new response name
    yi = yinfo(m);
    Tool.RespName = yi.Name;
    if ~isempty(Tool.Hand.AbsX)
        AbsX= get(Tool.Hand.AbsX,'Value');
        if isa(m,'xregtwostage') && get(m,'datumtype') && AbsX
            set(m,'datum',0);
        end
    end
end
h = Tool.Hand;
set(h.text(2),'string','Y-axis factor:');

if istransient(m)
    set(h.controlsCard,'currentcard',1);
    delete(get(h.Axes,'children'));
    set([h.factor(2:end),h.text(2:end)],'visible','off');

    text(0.5,0.5,'No response surface for transient models',...
        'HorizontalAlignment','center',...
        'parent',h.Axes,'units','normalized');
    return
end

DispType= get(h.dispType,'value');
switch DispType
    case 1
        % table
        set([h.factor(3),h.text(3)],'visible','off');
        set(h.controlsCard,'currentcard',2);
        if size(h.listCtrl)<2
            set([h.factor(2),h.text(2)],'visible','off');
        else
            set([h.factor(2),h.text(2)],'visible','on');
        end
        i_DrawTable(hFig,Tool,m,p);
    case 2
        % 2-D plot
        if ishandle(h.ColorBar),
            delete(h.ColorBarWrapper);
            set(h.AxesLayout,'colsizes',[-1 -1],'elements',{h.axisWrapper,[]},'gapx',0);
            repack(h.AxesLayout);
        end;
        set([h.factor(2:3),h.text(2:3)],'visible','off');
        set(h.controlsCard,'currentcard',1);
        i_Plot2D(hFig,Tool,m,p);
    case 3
        % multiline plot
        set(h.text(2),'string','Multiline factor:');
        set([h.factor(2),h.text(2)],'visible','on');
        set([h.factor(3),h.text(3)],'visible','off');
        set(h.controlsCard,'currentcard',1);
        i_Plot3D(hFig,DispType,Tool,m,p);
    case 4
        % contour plot
        set([h.factor(2),h.text(2)],'visible','on');
        set([h.factor(3),h.text(3)],'visible','off');
        set(h.controlsCard,'currentcard',4);
        i_Plot3D(hFig,DispType,Tool,m,p);
    case 5
        % surface
        set([h.factor(2),h.text(2)],'visible','on');
        set([h.factor(3),h.text(3)],'visible','off');
        set(h.controlsCard,'currentcard',3);
        i_Plot3D(hFig,DispType,Tool,m,p);
    case 6
        % movie
        set([h.factor(2:3),h.text(2:3)],'visible','on');
        % turn on replay vis
        set(h.controlsCard,'currentcard',5);
        i_Plot3D(hFig,DispType,Tool,m,p);
end
% reset display type list in case user has been playing while the plot is generated
set(h.dispType,'value',DispType);

return

%-------------------------------------------------------------------
% SUBFUNCTION i_SetTool
%-------------------------------------------------------------------
% store userdata in validation tool and
function i_SetTool(hFig,Tool)


mv_ValidationTool('set',hFig,Tool)

return


%-------------------------------------------------------------------
% SUBFUNCTION i_GetTool
%-------------------------------------------------------------------
% get tool userdata and model from validation tool
function [Tool,m,p]=i_GetTool(hFig)

if nargout==1
    Tool= mv_ValidationTool('get',hFig);
else
    % get validation tool data
    [Tool,ModelInfo]= mv_ValidationTool('get',hFig);
    m= ModelInfo{3}{1};
    % Use relative Local Value
    if ~isempty(Tool.Hand.AbsX)
        AbsX= get(Tool.Hand.AbsX,'Value');
        if isa(m,'xregtwostage') && get(m,'datumtype') && AbsX
            % can't do PE Shading here
            set(Tool.Hand.PEcol,'value',0,'enable','off');
            set(m,'datum',0);
        else
            set(Tool.Hand.PEcol,'enable','on');
        end
    end
    % pointer
    p= ModelInfo{2};
end

return

%-------------------------------------------------------------------
% SUBFUNCTION i_Plot3D
%-------------------------------------------------------------------
function i_Plot3D(hFig,DispType,Tool,m,p)
% get handles
h = Tool.Hand;

mv_ValidationTool('setmessage','Generating data for plot ... ');

set(hFig,'pointer','watch');

% get Dial-Up Values
[x,XVar,YVar,TVar]= i_GetValues(Tool);
Types = InputFactorTypes(m);
% XVar=[] is returned from i_GetValues as a check if values are not OK
if isempty(XVar)
    return
end

if all(Types==1) && Tool.RememberSettings
    % store settings
    xstore= x;
    for i= find(cellfun('prodofsize',x)>1)
        % turn into {min,max,numpts cell array
        xstore{i}= {x{i}(1) x{i}(end) length(x{i})};
    end
    if sum(cellfun('prodofsize',x)>1)==3
        VarList= [XVar,YVar,TVar];
    else
        VarList= [XVar,YVar];
    end
    setRespSurf(p.mdevtestplan,m,xstore,DispType,VarList);
end


% Hide any old Tables
if ~isempty(h.DispTable) && strcmp(get(h.DispTable,'visible'),'on')
    set(h.DispTable,'visible','off');
end

set(h.Axes,'visible','on');
set(hFig,'CurrentAxes',h.Axes);

OldFig= get(0,'currentfigure');
set(0,'currentfigure',hFig);
hvis= get(hFig,'handlevis');
set(hFig,'handlevis','on')

delete(get(h.Axes,'children'));

if ishandle(h.ColorBar)
    delete(h.ColorBarWrapper);
end
h.ColorBar= [];

mv_rotate3d(h.Axes,'off');
xtrans= YVar>XVar;
PEcol=0;

cmodel= [];
if get(h.Constraints,'value')
    % show data boundary on surface
    cmodel= BoundaryModel(p.mdevtestplan,m);
end

cmap= get(hFig,'colormap');
if isempty(cmodel) && isequal(cmap(end,:),mbcbdrycolor)
    cmap= cmap(1:end-1,:);
    set(hFig,'colormap',cmap);
end

cmap= xregdialupmenu('colormap',h.Axes);

switch DispType %some sort of surface plot
    case 3 %multi-line
        lines = multiline(m,x,h.Axes,xtrans,cmodel,cmap);
        % 	[hs, h.ColorBar]= surface(m,x,h.Axes,PEcol,xtrans);
        set(h.AxesLayout,'colsizes',[-1 -1],...
            'elements',{h.axisWrapper,[]},'gapx',0);
        drawnow;

    case 4 %contour plot
        udv= get(h.Btns(1),'userdata');
        [c,patchH,h.ColorBar]= contour(m,x,h.Axes,udv.V,[udv.labels,udv.fill,xtrans],cmodel);
        if ishandle(h.ColorBar)
            set(h.ColorBar,'deletefcn','','units','pixels');
            % colorbar into layouts
            h.ColorBarWrapper = axiswrapper(h.ColorBar);
            set(h.AxesLayout,'colsizes',[-1 20],...
                'elements',{h.axisWrapper,h.ColorBarWrapper},'gapx',30);
            drawnow;
        else
            set(h.AxesLayout,'colsizes',[-1 -1],...
                'elements',{h.axisWrapper,[]},'gapx',0);
            drawnow;
        end

    case 5 %surface
        % pass 1 into surface = PE shading for surface
        cv = get(h.Axes,'view');
        if cv(1) == 0
            set(h.Axes, 'view',[-37.5 30]);
        end
        PEcol=get(h.PEcol,'value');
        if PEcol
            set(h.PEthresh,'enable','on');
        else
            set(h.PEthresh,'enable','off');
        end

        [hs, h.ColorBar]= surface(m,x,h.Axes,[PEcol,xtrans],cmodel);

        % store original PE limits in thresh ud
        if ishandle(h.ColorBar)
            yl= get(h.ColorBar,'ylim');
            set(h.ColorBar,'deletefcn','','units','pixels');
            set(h.PEthresh.Control,'userdata',yl,'string',num2str(yl(2)));
            % colorbar into layouts
            h.ColorBarWrapper = axiswrapper(h.ColorBar);
            set(h.AxesLayout,'colsizes',[-1 20],...
                'elements',{h.axisWrapper,h.ColorBarWrapper},'gapx',40);
            drawnow;
        else
            set(h.PEthresh.Control,'string','');
            set(h.AxesLayout,'colsizes',[-1 -1],...
                'elements',{h.axisWrapper,[]},'gapx',0);
            drawnow;
        end
        % if type 2 inputs, draw them on y=0 plane
        if prod(Types)>1
            ind = find(Types>1);
            for i=1:length(ind)
                yp= x{ind(i)};
                if length(yp) ~= length(x{XVar});
                    yp=repmat(yp(1),size(x{XVar}));
                end
                line(repmat(min(get(h.Axes,'Xlim')),size(x{XVar})),x{XVar},yp,'LineWidth',2);
            end
        end

        xregdialupmenu('updateplot',h.Axes);

    case 6 %movie
        % Area for Movie GetFrame
        cv = get(h.Axes,'view');
        if cv(1) == 0
            set(h.Axes, 'view',[-37.5 30]);
        end
        AxesPos= get(h.Axes,'pos');
        AxesPos(1)= AxesPos(1)-AxesPos(3)*.1;
        AxesPos(2)= AxesPos(2)-AxesPos(4)*.2;
        AxesPos(3)= AxesPos(3)*1.4;
        AxesPos(4)= AxesPos(4)*1.4;
        Tool.Movie= movie(m,x,TVar,h.Axes,AxesPos,xtrans,cmodel);

end

xregdialupmenu('updateplot',h.Axes)
mv_ValidationTool('setmessage','Ready');

set(hFig,'pointer','arrow');
Tool.Hand.ColorBar = h.ColorBar;
Tool.Hand.ColorBarWrapper = h.ColorBarWrapper;
% Save userdata
i_SetTool(hFig,Tool)
if PEcol
    i_PEthreshold(hFig)
end

set(hFig,'handlevis',hvis)
set(0,'currentfigure',OldFig);
return


%-------------------------------------------------------------------
% SUBFUNCTION i_Plot2D
%-------------------------------------------------------------------
function i_Plot2D(hFig,Tool,m,p)
% get handles
h = Tool.Hand;

% get Dial-Up Values
[x,XVar]= i_GetValues(Tool);
% XVar=[] is returned if values are not OK
if isempty(XVar)
    return
end

if Tool.RememberSettings
    % store settings
    setRespSurf(p.mdevtestplan,m,x,2,XVar);
end

% Delete any old Tables
if ~isempty(h.DispTable) && strcmp(get(h.DispTable,'visible'),'on')
    set(h.DispTable,'visible','off');
end

% Generate Table
set(hFig,'pointer','watch');
Y2 = GenTable(m,x);


cmodel= [];
if get(h.Constraints,'value')
    % show data boundary on surface
    cmodel= BoundaryModel(p.mdevtestplan,m);
end


if ~isempty(cmodel)
    cvals= cgrideval(cmodel,x,m)>=0;
    Y2(cvals)=NaN;
end
set(hFig,'CurrentAxes',h.Axes);
mv_rotate3d(h.Axes,'off');
delete(get(h.Axes,'children'));
% Area for Movie GetFrame
AxesPos= get(h.Axes,'pos');
AxesPos(4)= AxesPos(4)*1.2;

% draw plot
plot(x{XVar},Y2(:),'parent',h.Axes,'LineWidth',2,'Color',[0 0.5 0]);
set(h.AxesLayout,'colsizes',[-1 -1],...
    'elements',{h.axisWrapper,[]},'gapx',0);
set(h.Axes,'xgrid','on','ygrid','on','box','on','UserData',Y2);

Xlab= InputLabels(m);
Xlab = Xlab{XVar};
Ylab= ResponseLabel(m);
% label axes
if ischar(Xlab) && ischar(Ylab)
    set(get(h.Axes,'xlabel'),...
        'string',Xlab,'interpreter','none');
    set(get(h.Axes,'ylabel'),...
        'string',Ylab,'interpreter','none');
end

% also plot lines for Type 2 input factors
Types = InputFactorTypes(m);
if prod(Types)>1
    ind = find(Types>1);
    for i=1:length(ind)
        line(x{XVar},x{ind(i)},'parent',h.Axes,...
            'LineStyle','-.');
    end
end

set(h.Axes,'visible','on');
set(hFig,'pointer','arrow');
% Save userdata
i_SetTool(hFig,Tool)

%-------------------------------------------------------------------
% SUBFUNCTION i_DrawTable
%-------------------------------------------------------------------
function i_DrawTable(hFig,Tool,m,p)

[x,XVar,YVar]= i_GetValues(Tool);
if isempty(XVar)
    return
end

if Tool.RememberSettings
    % store settings
    setRespSurf(p.mdevtestplan,m,x,1,[XVar,YVar]);
end

mv_ValidationTool('setmessage','Generating data for table...');

set(hFig,'pointer','watch');
if isempty(Tool.Hand.DispTable)
    Tool.Hand.DispTable=mbctable.simple(com.mathworks.toolbox.mbc.gui.table.ModelViewTable, ...
        'parent', hFig, ...
        'visible', 'off');
    set(Tool.Hand.displayPane,'visible','off',...
        'elements',{Tool.Hand.DispTable,Tool.Hand.AxesLayout});
end

cmodel= [];
if get(Tool.Hand.Constraints,'value')
    % show data boundary on surface
    cmodel= BoundaryModel(p.mdevtestplan,m);
end

Y= GenTable(m,x);
if size(Tool.Hand.listCtrl)>1
    [Xord,reord]= sort([XVar YVar]);
    %
    % Need to reshape Y so it is a 2D matrix for table
    Y= reshape(Y,length(x{Xord(1)}),length(x{Xord(2)}));
    if any(diff(reord)<0)
        % Transpose if Yind<Xind
        Y=Y';
    end
else
    Y=Y(:);
end

if ~isempty(cmodel)
    cvals= cgrideval(cmodel,x,m)>=0;
    if size(Tool.Hand.listCtrl)>1
        cvals= reshape(cvals,length(x{Xord(1)}),length(x{Xord(2)}));
        if any(diff(reord)<0)
            % Transpose if Yind<Xind
            cvals=cvals';
        end
    else
        cvals= cvals(:);
    end
else
    cvals= [];
end

if ishandle(Tool.Hand.Axes)
    set(Tool.Hand.axisWrapper,'visible','off');
end
if ishandle(Tool.Hand.ColorBar)
    set(Tool.Hand.ColorBarWrapper,'visible','off');
end

% IS THIS AN ERROR IN SETTOOL??
if iscell(Tool.RespName)
    Tool.RespName = Tool.RespName{:};
end

% transponse the table
if nfactors(m)>1
    Y= Y';
    tmp= XVar;
    XVar=YVar;
    YVar=tmp;
    if ~isempty(cvals)
        cvals = cvals';
    end
end

% store the data as userdata for the axes.  this
% saves us from trying to store two copies.
set(Tool.Hand.Axes,'userdata',Y);

tbl= Tool.Hand.DispTable;
if size(Tool.Hand.listCtrl)==1
    Xlab= get(m, 'symbols');
    Xlab = Xlab{XVar};
    tbl.table.initTable(Y,cvals,x{XVar}(:), Xlab);
else
    tbl.table.initTable(Y,cvals,x{XVar}(:),x{YVar}(:));
end

% No Movie for Tables
Tool.Movie = [];

i_SetTool(hFig,Tool)
mv_ValidationTool('setmessage','Ready');
set(hFig,'pointer','arrow');
set(Tool.Hand.DispTable,'visible','on');

return

%-------------------------------------------------------------------
% SUBFUNCTION i_Export
%-------------------------------------------------------------------
function i_Export

Tool= i_GetTool(gcbf);
h = Tool.Hand;

x = i_GetValues(Tool,0);

DispType= get(Tool.Hand.dispType,'value');
switch DispType
    case {1,6} % movie or table
        Y = get(h.Axes,'userdata');

    otherwise
        sh= findobj(h.Axes,'type','surface');
        if isempty(sh)
            % This is a 2D plot
            Y=get(h.Axes,'UserData');
        else
            % Table is in surface plot
            Y= get(sh,'ZData');
        end
end

exportName1 = validmlname(get(h.exportName1,'string'));
exportName2 = validmlname(get(h.exportName2,'string'));

radio = get(h.exportRadios,'value');
if radio(end)
    [savename, savepath]= uiputfile('','Select file to save variables');
    if savename
        eval([exportName1 '=x;']);
        eval([exportName2 '=Y;']);
        save([savepath, savename],exportName1,exportName2);
    end
else
    assignin('base',exportName1,x);
    assignin('base',exportName2,Y);
    message= msgbox(str2mat(['The table written to base workspace as ',...
        exportName2,'.',...
        'The Dial-Up values are written to base workspace as a cell array '...
        exportName1,'.']),'Export','modal');
    figure(message)
end

return

%-------------------------------------------------------------------
% SUBFUNCTION i_Replay
%-------------------------------------------------------------------
function i_Replay

Tool= i_GetTool(gcbf);

fps = get(Tool.Hand.framePS.Control,'value');

AxesPos= get(Tool.Hand.Axes,'pos');
AxesPos(1)= AxesPos(1)-AxesPos(3)*.1;
AxesPos(2)= AxesPos(2)-AxesPos(4)*.2;
AxesPos(3)= AxesPos(3)*1.4;
AxesPos(4)= AxesPos(4)*1.2;

% replay the movie if it exists
if ~isempty(Tool.Movie);
    % movie 2 fps or max of 10 sec
    movie(gcbf,Tool.Movie,1,max(fps,fix(size(Tool.Movie,2)/10)),AxesPos);
end

return

%-------------------------------------------------------------------
% SUBFUNCTION i_PEthreshold
%-------------------------------------------------------------------
function  i_PEthreshold(hFig)

Tool= i_GetTool(hFig);
h = Tool.Hand;
yl= get(h.ColorBar,'ylim');
newlim= str2num(get(h.PEthresh.Control,'string'));

if isempty(newlim)
    % userdata holds original PEV limits, get the upper limit.
    newlim=get(h.PEthresh.Control,'userdata'); newlim=newlim(2);
elseif newlim<yl(1) % must be nonempty
    newlim=get(h.PEthresh.Control,'userdata'); newlim=newlim(2);
    msgbox('PE threshold must be greater than the lower limit of prediction error.',...
        'PE Threshold error','modal');
end
% always write reformatted number back in
newlimstr = sprintf('%0.4g',newlim);
set(h.PEthresh.Control,'string',newlimstr);


set(h.Axes,'clim',[yl(1) newlim]);
axes(h.Axes);

set(h.ColorBar,'ylim',[yl(1) newlim],'YTickLabelMode','auto','YTickMode','auto');
set(get(h.ColorBar,'children'),'ydata',[yl(1) newlim]);

Tool.Hand=h;
i_SetTool(hFig,Tool);


%-------------------------------------------------------------------
% SUBFUNCTION i_Print
%-------------------------------------------------------------------
function i_Print(Tool,TitleStr)

h = Tool.Hand;

DispType= get(h.dispType,'value');

switch DispType
    case {1, 6}
        % currently not printing Table nor movie
        h = errordlg('The Movie display and the Table display cannot be printed.', ...
            'MBC Toolbox', 'modal');
        waitfor(h);
        return
    otherwise
        inputs = InputLabels(Tool.model);

        x= i_GetValues(Tool);
        for i=1:length(x)
            if numel(x{i})==1
                inputs{i}= sprintf('%20s = %.5g',inputs{i},x{i});
            else
                inputs{i}= sprintf('%20s = [%.5g,%.5g] ',inputs{i},x{i}([1 end]) );
            end
        end

        inputs = {'Input Factors','',inputs{:}};

        fh = figure('visible','off');
        lay = xreglayerlayout(fh,'border',[80 20 20 50]);
        font=get(0,'fixedWidth');
        tH = axestext(fh,'units','pixels',...
            'fontweight','demi',...
            'fontName',font,...
            'interpreter','none',...
            'string',inputs);
        set(lay,'elements',{tH},'position',get(tH,'extent'));

        if DispType == 2
            printlayout1(h.DispTable,lay,TitleStr);
        else
            printlayout1(h.Axes,lay,TitleStr);
        end
        close(fh);
end
