function varargout= mv_ValidationTool(Action,varargin)
%MV_VALIDATIONTOOL Base model selection GUI tool for Model-Based Calibration Toolbox
%
%  This function must be extended before use
%  see Validate_OneStage,
%     Validate_Local,
%     Validate_TwoStage,
%     Valdiate_FreeKnot
%     Validate_mle
%     Validate_Indpt
%  for examples of usage.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.13.2.4 $  $Date: 2004/04/04 03:30:46 $


if isa(Action,'char')
    switch lower(Action)
        case 'create'
            % create GUI
            varargout{1}= i_Create(varargin{:});
        case 'view'
            % changes validation view (e.g. from sweep plots to Dial-Up)
            i_ChangeView(varargin{:});
        case 'resize'

        case 'add'
            % add views to validation tool
            i_AddViews(varargin{:});
        case 'statstable'
            % creates stats table
            i_StatsTable(varargin{:});
        case 'set'
            % set view userdata
            i_SetView(varargin{:});
        case 'get'
            % get view user data
            [varargout{1:nargout}]= i_GetView(varargin{:});
        case 'close'
            % close figure
            i_Close;
        case 'print'
            i_Print
        case 'selectbest'
            % select best model
            i_SelectBest(varargin{:});
        case 'selectall'
            i_SelectAll(gcbf);
        case 'attachlayout'
            % attach a layout to a card
            i_attachLayout(varargin{:})
        case 'setmessage'
            i_setsbarstring(varargin{:});
        case 'setwaitbar'
            i_setwaitbar(varargin{:});
        case 'setcreatemessage'
            i_setcreatemessage(varargin{1});
    end
elseif mbciscom(Action)
    % activex callback for listbox (Click and KeyUp events)
    Action.inactive=-1;
    persistent RUNNING

    stop=0;
    if varargin{1}==5
        % don't run if just a shift or ctrl key is pressed
        [event,keycode,ext]= deal(varargin{1:end-2});
        stop= (keycode==16 | keycode==17);
    end
    if isempty(RUNNING) && ~stop
        RUNNING=1;
        try
            i_ListView(Action,varargin{1:end-2});
        end
        RUNNING=[];
    end
    Action.inactive=0;
end


%----------------------------------------------------
% SUBFUNCTION I_CREATE
%----------------------------------------------------
function hFig= i_Create(Vfile,p,Models,ParFig,NumPages)
% now creates a figure with a gridLayout inside ([3 1] = main pane, butons, status bar)
% main pane is a split layout for Cards (top) and ListView (btm)

% check for other open validation tools and close them
validationguis=findobj(allchild(0),'flat','tag','ValidationTool');
if ~isempty(validationguis)
    figure(validationguis(1));
    resp= questdlg('Another validation tool is already open. Do you want to close this figure?',...
        'Validation','OK','Cancel','Cancel');
    if strcmp(resp,'Cancel')
        hFig=[];
        return
    else
        delete(validationguis(1));
    end
end


% put title on window
name= ['Model Selection for ',p.fullname];

hMain= xregfigure('units','pixels',...
    'IntegerHandle','off',...
    'HandleVisibility','callback',...
    'NumberTitle','off',...
    'name',name,...
    'menubar','none',...
    'color',get(0,'defaultUIControlBackgroundColor'),...
    'DefaultAxesFontSize',8,...
    'PaperPositionMode','Auto',...
    'PaperOrientation','landscape',...
    'CloseRequestFcn','',...
    'Tag','ValidationTool',...
    'DefaultUIControlInterruptible','off',...
    'DefaultUIMenuInterruptible','off',...
    'DefaultuitoggletoolInterruptible','off',...
    'visible','off',...
    'renderermode','manual',...
    'renderer','painters',...
    'doublebuffer','on');

hMain.MinimiseResources='off';
hMain.minimumSize = [800 650];
hFig = double(hMain);
xregpersistfigpos(hMain,'defaultpos',[257 49 1024 904]);
xregmoveonscreen(hMain);
fPos=get(hMain,'position');



% menus for the figure
hM=xregmenutool('create',hFig,...
    'Label',{'&File'},'position',1);
hMs=xregmenutool('create',hM,...
    'Label',{'&Print','&Close'},...
    'CallBack',{[mfilename,'(''print'')'],'close(gcbf);'},...
    'Accelerator',{'P','W'});
hV=xregmenutool('create',hFig,...
    'Label',{'&View'},'position',2);
set(hFig,'DefaultUIControlBackGroundColor',get(hFig,'color'))

% register this figure for the "window" menu on MBRowser
xregwinlist(hFig);

% Create a default help menu
mv_helpmenu(hFig);

% Create empty toolbar
ud.hToolbar=xregGui.uitoolbar(hFig,'visible','off','ResourceLocation', xregrespath);

% buttons for bottom of figure
Strings= {'Assign Best', 'Select All'};
CallBacks= {'''SelectBest''', '''SelectAll'''};
for i=1:length(Strings)
    ud.Btns(i)= uicontrol('parent',hFig,...
        'style','push',...
        'callback',[mfilename,'(',CallBacks{i},')'],...
        'string',Strings{i});
end
if length(Models)==1, set(ud.Btns(1:2),'enable','off'); end;

% log scaling text
ud.scaleText =  uicontrol('parent',hFig,...
    'HorizontalAlign','right',...
    'style','text',...
    'enable','inactive');


%----------------Create the ListView---------------%
% listview title (uicontrol text)
listViewText = uicontrol('parent',hFig',...
    'Style','text',...
    'enable','inactive',...
    'fontsize',14,...
    'foregroundcolor',[.4 .2 .8],...
    'horizontalalign','left',...
    'String',[' Model List for ', p.fullname]);


% ActiveX listview
callbacks= {'DblClick','xregselbest'
    'click',mfilename
    'KeyUp',mfilename
    'columnclick','xreglvsorter'
    'mousemove','MotionManager'};
h= xregGui.listview([1 1 300 200],hFig,callbacks);
% put in a container for layouts to work (wrapper inherits from actxcontrol)
h = actxcontainer(h);
IL= imlistMBrowser(mctree);
h.InsertSmallIcons(IL);
set(h,'view',3,...
    'hideselection',0,...
    'GridLines',1,...
    'FullRowSelect',0,...
    'LabelEdit',1,...
    'BorderStyle',0,...
    'Appearance',0,...
    'Parent',hFig);
ud.ListView= h;

% statusbar
ud.statusBar=uicontrol('parent',hFig,...
    'style','text',...
    'enable','inactive',...
    'horizontalalignment','left');
% waitbar
ud.waitbar=xregGui.waitbar('parent',hFig);

% find out how tall the status bar needs to be to contain current font size.
fontHeight = get(listViewText,'extent');
% note that room for text is statusHeight - 2
textHeight = fontHeight(4)+2;

% try to get splitlayout showing all models
splitPos=fPos(4)-200;
desiredSize= 25*min(length(Models),5);
desiredSplit=[splitPos-desiredSize, desiredSize];

%text item to tell user that views are being created
CreationText = uicontrol('parent',hFig,...
    'style','text',...
    'enable','inactive',...
    'string','Generating available views...',...
    'horizontalalignment','left',...
    'visible','off');


% ----------------------- setup the layouts  -----------------------------%

listViewTextPanel = xregpanellayout(hFig,...
    'center',listViewText,...
    'state','out',...
    'packstatus','off');
grd = xreggridlayout(hFig,...
    'dimension',[2 1],...
    'elements',{listViewTextPanel, h},...
    'correctalg','on',...
    'rowsizes',[textHeight, -1]);
listviewLyt = xregpanellayout(hFig,'center',grd,'innerborder',[0 0 0 0]);


%--------------Card layout----------------------%
ud.TabObj=xregcardlayout(hFig,...
    'numcards',NumPages);
ud.createcard=xregcardlayout(hFig,'numcards',2);
CreationLyt = xreglayerlayout(hFig,'elements',{CreationText},'border',[10 10 10 10]);
attach(ud.createcard,CreationLyt,1);
attach(ud.createcard,ud.TabObj,2);
top_panel=xregpanellayout(hFig,'center',ud.createcard,'innerborder',[0 0 0 0]);

% split layout for card layout and listview
splitLyt = xregsplitlayout(hFig,...
    'orientation','ud',...
    'top',top_panel,...
    'bottom',listviewLyt,...
    'minwidth',[460 85],...
    'split',desiredSplit,...
    'dividerstyle','flat',...
    'dividerwidth',4);

tblyt= xregpanellayout(hFig,'innerborder',[0 0 0 0],'center',ud.hToolbar);
sbarlyt= xregpanellayout(hFig,'center',ud.statusBar,'innerborder',[2 0 0 2]);
mainLyt=xreggridbaglayout(hFig,'dimension',[9, 6],...
    'rowsizes',[35, 2, -1, 10, 5, 15, 5, 10, 20],...
    'colsizes',[10 90 10 90 -1 150],...
    'mergeblock',{[1 1],[1 6]},...
    'mergeblock',{[3 3],[1 6]},...
    'mergeblock',{[5 7],[2 2]},...
    'mergeblock',{[5 7],[4 4]},...
    'mergeblock',{[6 6],[5 6]},...
    'mergeblock',{[9 9],[1 5]},...
    'elements',{tblyt, [],[],[],[],[];...
    [],[],[],[],[],[];...
    splitLyt, [],[],[],[],[];...
    [],[],[],[],[],[];...
    [],ud.Btns(1),[],ud.Btns(2),[],[];...
    [],[],[],[],ud.scaleText,[];...
    [],[],[],[],[],[];...
    [],[],[],[],[],[];...
    sbarlyt,[],[],[],[],ud.waitbar});

hMain.LayoutManager = mainLyt;
set(mainLyt,'packstatus','on');
% common userdata
ud.ParFig= ParFig;
ud.p= p;
ud.Models= Models;
ud.ViewMenu= hV;
ud.mfile= Vfile;
ud.CurrentView= 1;
ud.View = [];

% have a pointer to an "OK" flag for changing views
% link it to figure so when figure closes, pointer is freed
ud.changeViewFlag = xregGui.RunTimePointer(1);
LinkToObject(ud.changeViewFlag,ParFig);

% set userdata for this (the validation) figure
set(hFig,'UserData',ud);
return

%----------------------------------------------------
% SUBFUNCTION I_ADDVIEW
%----------------------------------------------------
function i_AddViews(hFig,View)

ud= get(hFig,'UserData');

start = length(ud.View);
if isempty(ud.View) && ~iscell(View),
    % hope it's a relevant structure and off we go
    ud.View{1} = View;
elseif isempty(ud.View) && iscell(View),
    ud.View = View;
elseif ~iscell(View)
    ud.View= {ud.View{:},View};
else
    ud.View= {ud.View{:},View{:}};
end

ud.hToolbar.setRedraw(false);
for i = start+1:length(ud.View)
    % Add menu item
    MenuLabel = ud.View{i}.Name;
    MenuCallBk = [mfilename,'(''view'',gcbf,',int2str(i),')'];
    uimenu('Parent',ud.ViewMenu,...
        'Label',MenuLabel,...
        'CallBack',MenuCallBk);

    % Add toolbar icon
    ttpString = strrep(ud.View{i}.Name,'&','');
    xregGui.uitoggletool(ud.hToolbar, ...
        'ImageFile', ud.View{i}.Icon, ...
        'TooltipString', ttpString, ...
        'ClickedCallback', MenuCallBk, ...
        'TransparentColor', [0 255 0]);
end
% Set first toolbar button to be depressed
Btns = get(ud.hToolbar,'children');
set(Btns(1),'state','on');
ud.hToolbar.setRedraw(true);
ud.hToolbar.drawToolBar;

set(get(handle(hFig),'LayoutManager'),'packstatus','on');
set(hFig,'UserData',ud,'visible','on');
set(ud.hToolbar,'visible','on');
set(ud.TabObj,'visible','on');


%----------------------------------------------------
% SUBFUNCTION I_CHANGEVIEW
%----------------------------------------------------
function i_ChangeView(hFig,Index)

ud= get(hFig,'userdata');

% if flag = 0 we are currently in the process of changing views
if ~ud.changeViewFlag.info
    % bail out
    return
else
    % set flag to show we are busy
    ud.changeViewFlag.info = 0;

    View= ud.View{Index};

    % the second figure menu has a check by the current view
    hV=xregmenutool('find',hFig,2);
    % change checked view menus
    set(get(hV,'children'),'check','off');
    xregmenutool('set',hV,Index,'check','on');


    % listview multiselect status
    set(ud.ListView,'multiselect',View.MultiSelect);

    % the 'select all' and 'assign best' buttons
    if length(ud.Btns)>1
        if ~View.MultiSelect || length(ud.Models)==1
            set(ud.Btns(2),'enable','off')
            set(ud.ListView,'SelectedItem',ud.ListView.SelectedItem);
        else
            set(ud.Btns(2),'enable','on');
        end
    end

    ud.CurrentView= Index;
    ud.View{Index}=View;

    % change tab
    set(hFig,'renderer',View.Renderer);
    set(ud.TabObj,'currentcard',Index);
    set(hFig,'UserData',ud);

    set(ud.statusBar,'string','');

    % get model
    [ModelInfo,ModelList]= i_ModelSelect(hFig,ud,View);
    % and run view on it
    feval(View.mfile,'view',hFig,View,ModelInfo,ModelList);

    % switch help menu to new one using info in View structure

    % add the validation help entries
    % where are we coming from??
    switch lower(ud.mfile)
        case 'validate_indpt'
            helpMenuStr = '&Model Evaluation Tool Help';
            helpTag = 'xreg_modelEvaluation';
        otherwise
            helpMenuStr = '&Model Selection Tool Help';
            helpTag = 'xreg_modelSelection';
    end

    if isfield(View,'helpmenus')
        mv_helpmenu(hFig,[{helpMenuStr,helpTag}; View.helpmenus]);
    else
        mv_helpmenu(hFig,{helpMenuStr,helpTag});
    end

    % set state of toolbar toggle buttons
    % need to set current 'on' if view changed from menus
    Btns = get(ud.hToolbar,'children');
    for i=[1:Index-1,Index+1:length(Btns)]
        set(Btns(i),'state','off');
    end
    set(Btns(Index),'state','on');

    % set flag to show we have finished
    ud.changeViewFlag.info = 1;

end
%----------------------------------------------------
% SUBFUNCTION  I_ATTACHLAYOUT
%----------------------------------------------------
function i_attachLayout(hFig,Lyt, cardNum)
% different display creation funcs return an invisible, unpacked layout.
% attach it to a card and set unpack it

ud= get(hFig,'userdata');
Tab=ud.TabObj;

attach(Tab, Lyt, cardNum);

return

%----------------------------------------------------
% SUBFUNCTION I_GETVIEW
%----------------------------------------------------
function [View,ModelInfo,ModelList]= i_GetView(hFig)

ud= get(hFig,'userdata');
View= ud.View{ud.CurrentView};
if nargout>1
    [ModelInfo,ModelList]= i_ModelSelect(hFig,ud,View);
end

%----------------------------------------------------
% SUBFUNCTION I_SETVIEW
%----------------------------------------------------
function i_SetView(hFig,NewView)

ud= get(hFig,'userdata');
ud.View{ud.CurrentView}= NewView;
set(hFig,'UserData',ud);



%----------------------------------------------------
% SUBFUNCTION I_LISTVIEW
%----------------------------------------------------
function i_ListView(varargin)

% get figure handle
hFig= findobj(allchild(0),'flat','Tag','ValidationTool');
hFig= hFig(1);
ud=get(hFig,'UserData');
View= ud.View{ud.CurrentView};

% get modelinfo
[ModelInfo,ModelList]= i_ModelSelect(hFig,ud,View);
% and update view
feval(View.mfile,'view',hFig,View,ModelInfo,ModelList);

%----------------------------------------------------
% SUBFUNCTION I_SELECTBEST
%----------------------------------------------------
function i_SelectBest(varargin)

% get fig handle
hFig= findobj(allchild(0),'flat','Tag','ValidationTool');
hFig= hFig(1);
ud=get(hFig,'UserData');
h= ud.ListView;

% choose best
ud.BestModel= i_ChooseBest(hFig,h,ud.p);
set(hFig,'userdata',ud);

%----------------------------------------------------
% SUBFUNCTION I_SELECTALL
%----------------------------------------------------
function i_SelectAll(hFig)

ud=get(hFig,'UserData');
View= ud.View{ud.CurrentView};

h= ud.ListView.ListItems;
for i=1:double(h.Count)
    h.Item(i).Selected = 1;
end

[ModelInfo,ModelList]= i_ModelSelect(hFig,ud,View);
feval(View.mfile,'view',hFig,View,ModelInfo,ModelList);

%----------------------------------------------------
% SUBFUNCTION I_MODELSELECT
%----------------------------------------------------
function [ModelInfo,ModelList]= i_ModelSelect(varargin)

if nargin==0
    hFig= findobj(allchild(0),'flat','Tag','ValidationTool');
    hFig= hFig(1);
    ud= get(hFig,'userdata');
    View= ud.View{ud.CurrentView};
else
    [hFig,ud,View]= deal(varargin{:});
end

if View.MultiSelect
    % multi select is supported
    h= ud.ListView.ListItems;
    ModNo=[];
    j=1;
    ModelList = {};
    for i=1:double(h.Count)
        Item= h.Item(i);
        if Item.Selected
            mkey= get(Item,'key');
            ModNo= [ModNo sscanf(mkey, 'M%d')];
            ModelList{j} = get(Item,'text');
            j=j+1;
        end
    end
    if length(ModNo)>5
        for i= 6:length(ModNo);
            mkey= sprintf('M%1d',ModNo(i));
            h.Item(mkey).Selected = 0;
        end

        ModNo=ModNo(1:5);
        uiwait(warndlg('Too many models selected. Only the first 5 are displayed',...
            'Model Selection','modal'));
    end
else
    % single selection
    Item= ud.ListView.SelectedItem;
    mkey= get(Item,'key');
    ModNo= sscanf(mkey, 'M%d');
    ModelList{1} = get(Item,'text');
end

if isempty(ModNo);
    % multiselection may mean that no items are selected
    % so select the first one
    Item= h.Item(1);
    set(Item,'selected',1);
    ModNo= 1;
    ModelList{1} = get(Item,'text');
end
% assign Best - disable if more than one model is selected
if length(ModNo)>1 || length(ud.Models)==1
    set(ud.Btns(1),'enable','off')
else
    set(ud.Btns(1),'enable','on')
end
% call the child function (e.g. Validate_twostage) to get the modelinfo
ModelInfo= feval(ud.mfile,'select',ud.Models,ModNo,ud.p);


%----------------------------------------------------
% SUBFUNCTION I_CHOOSEBEST
%----------------------------------------------------
function BestMod= i_ChooseBest(hFig,h,p)

if nargin==0
    hFig= findobj(allchild(0),'flat','Tag','ValidationTool');
    hFig= hFig(1);
end
ud= get(hFig,'userdata');
h= ud.ListView;

BestItem= h.SelectedItem;
BestMod= BestItem.key;

ListItems= h.ListItems;
for i=1:double(ListItems.Count)
    Item= ListItems.Item(i);
    Ckey= get(Item,'key');
    ModNo= sscanf(Ckey, 'M%d');
    im= icon(ud.Models{ModNo});
    if strcmp(BestMod,Ckey)
        set(Item,'smallicon',im(3));
    else
        set(Item,'smallicon',im(1));
    end
end
if length(ud.Models)>1
    set(ud.statusBar,'string',['The best model is ''',BestItem.text,'''']);
end

%----------------------------------------------------
% SUBFUNCTION I_STATSTABLE
%----------------------------------------------------
function i_StatsTable(hFig,ModelList,ColHead,s,SortKey)

ud= get(hFig,'userdata');
h= ud.ListView;
pos= get(hFig,'position');

set(ud.statusBar,'string','Calculating Validation Statistics');
% get width available for listview
listWidth=pos(3);

% adjust width for points/pixel ratio


OldUnits= get(0,'units');
spix= get(0,'ScreenSize');
set(0,'units','points');
spos= get(0,'ScreenSize');
set(0,'units',OldUnits);
wid= listWidth*spos(3)/spix(3);

% calculate width for model label

mc=char(ModelList);
hT= uicontrol('Parent', hFig, 'units','points','style','text','string',mc(1,:));
tsize= get(hT,'extent');
msize= max(min(tsize(3)+30,wid*.3),144);
delete(hT)

% Column Headers for stats

hCols= h.ColumnHeaders;
hItem= hCols.Add;
% Model label first
set(hItem,'text','Model');
set(hItem,'width',msize);
m2= double(get(hItem,'width'));


sok= ~all(~isfinite(s));
if ~all(sok)
    s= s(:,sok);
    ColHead= ColHead(sok);
    if ~sok(SortKey)
        SortKey= find(sok, 1, 'last');
    else
        SortKey= SortKey-sum(~sok(1:SortKey-1));
    end
end

% index of best into cell array of TS models
bm= ud.p.bestmdev;
BMind=0;
if ~isa(bm,'double') && bm~=0
    % i.e. isa pointer
    bname= bm.name;
else
    bname='';
    BMind= bm;
end

hListItems= h.ListItems;

if ~isempty(s)
    wid= wid*m2/msize;
    Width=   max(60,fix((wid-m2)/size(s,2)-10));

    % Other stats
    for i= 1:length(ColHead)
        hItem= hCols.Add;
        set(hItem,'text',ColHead{i});
        set(hItem,'width',Width);
        set(hItem,'alignment','lvwColumnRight');
        set(hItem,'tag','num');
    end

    % add stats to listview
    % make into formatted string
    for i=1:size(s,1)
        hItem=hListItems.Add;
        set(hItem,'text',ModelList{i});
        set(hItem,'ToolTipText',ModelList{i});
        if strcmp(ModelList{i},bname);
            BMind= i;
        end
        set(hItem,'SmallIcon',1);
        set(hItem,'key',sprintf('M%1d',i));
        % stats
        for j=1:length(ColHead)
            if isfinite(s(i,j))
                set(hItem,'SubItems',j,num2str(s(i,j)) );
            end
        end
        EnsureVisible(hItem);
    end

    [ss,ind] = sortrows(s,SortKey);

    h.sorted=0;
    h.sortkey=SortKey;
    if length(ind)>1
        h.ReorderList = ind;
    end


else
    ind= 1:length(ModelList);
    for i=ind
        hItem=hListItems.Add;
        set(hItem,'text',ModelList{i});
        if strcmp(ModelList{i},bname);
            BMind= i;
        end
        set(hItem,'SmallIcon',1);
        set(hItem,'key',sprintf('M%1d',i));
    end
end

if BMind==0
    % by default choose first element in list
    set(h,'SelectedItem',hListItems.Item(1));
elseif hListItems.Count>=BMind
    % previously selected best model
    n= hListItems.Item(find(ind==BMind));
    set(h,'SelectedItem',n);
end

% set up best model
ud.BestModel= i_ChooseBest(hFig,h,ud.p);
set(ud.statusBar,'string','');
set(hFig,'userdata',ud);


%----------------------------------------------------
% SUBFUNCTION I_PRINT
%----------------------------------------------------
function i_Print

[View,ModelIInfo,ModelList]= i_GetView(gcbf);
p = get(MBrowser,'CurrentNode');
TitleStr = strvcat(['Model Selection for: ' p.fullname],char(ModelList));

feval(View.mfile,'print',View,TitleStr)

%----------------------------------------------------
% SUBFUNCTION I_CLOSE
%----------------------------------------------------
function i_Close

hFig= mvf('ValidationTool');

figure(hFig(1))
ud= get(hFig(1),'UserData');
p= ud.p;
ch= p.children;
Resp='No';
if ~isempty(ch);
    drawnow
    hListItems= get(ud.ListView,'ListItems');
    hBest= hListItems.Item(ud.BestModel);
    BestName= get(hBest,'text');

    Resp= questdlg(str2mat('Do you want to select the model: ',...
        ['    ''',BestName,''''],...
        'as the best model?'),...
        'Model Selection','Yes','No','Cancel','Yes');
    switch lower(Resp)
        case 'yes'
            BMIndex= sscanf(ud.BestModel, 'M%d');
            % call particular close function (e.g. Validate_TwoStage)
            feval(ud.mfile,'close',hFig(1),p,BMIndex);
        case 'no'
            % restore modeldev status if we have change it for
            p.undovalidate;
    end

    mbH= MBrowser;
    if mbH.CurrentNode==p && p== mbH.treeview('current')
        % update current model browser view if you are still on the same node
        mbH.ViewNode;
        % update listview (to show best model as blue icon)
        mbH.listview;

        mbH.doDrawText;
    end
end
if ~strcmp(Resp,'Cancel')
    p.history('clear');
    if ishandle(hFig)
        delete(hFig)
    end
    figure(ud.ParFig);
else
    figure(hFig)
end


function i_setsbarstring(newstring)
hFig= mvf('ValidationTool');
ud= get(hFig(1),'UserData');
set(ud.statusBar,'string',newstring);

function i_setwaitbar(varargin)
hFig= mvf('ValidationTool');
ud= get(hFig(1),'UserData');
set(ud.waitbar,varargin{:});


function i_setcreatemessage(state)
hFig= mvf('ValidationTool');
ud= get(hFig(1),'UserData');
if state
    set(ud.createcard,'currentcard',1);
    set(hFig,'CloseRequestFcn','');
else
    set(ud.createcard,'currentcard',2);
    set(hFig,'CloseRequestFcn',[mfilename,'(''close'')']);
end
