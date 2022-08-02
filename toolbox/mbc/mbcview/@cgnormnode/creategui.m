function [LYT,TBLYT,ud] = creategui(node,info)
%CREATEGUI

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:33:21 $

h=info.browserH;
menus=h.createmenu(guid(node),2);
set(menus,{'label'},{'&View';'&Normalizer'});
ViewMenuH=menus(1);
ToolsMenuH=menus(2);
cbs = callbacks( node, 'gethandles');

ud.Handles.Figure = info.Figure;
ud.Handles.MessageID = []; % ID of current status bar message

ud.Handles.Menus = i_create_menus(ViewMenuH, ToolsMenuH, cbs);

ud.NormCount = 0; % no normalisers visible yet

% The three important components
T1 = cgtools.breakpointeditor(ud.Handles.Figure);
T2 = cgtools.breakpointeditor(ud.Handles.Figure);
ud.Handles.ComparisonPane = cgtools.normcomp('parent', ud.Handles.Figure, ...
    'visible', 'off');

listeners = [...
    handle.listener(T1,'TableCellsSelected',{cbs.ClearTableSelection,T2}),...
    handle.listener(T1,'ShowHistory',{cbs.PopupViewHistory,1}),...
    handle.listener(T1,'DataChanged',{cbs.DataChanged}),...
    handle.listener(T2,'TableCellsSelected',{cbs.ClearTableSelection,T1}),...
    handle.listener(T2,'ShowHistory',{cbs.PopupViewHistory,2}),...
    handle.listener(T2,'DataChanged',{cbs.DataChanged}) ];

ud.Handles.TablePane = [T1 T2];
ud.Handles.TableListeners = listeners;


[ud.Handles.ToolBarPane , ud.ToolBar.Handles] = i_create_toolbar(ud.Handles.Figure, cbs);
TBLYT = ud.Handles.ToolBarPane; % we need to return this

two_norm=xreggridbaglayout(ud.Handles.Figure,...
    'dimension',[2,1],...
    'gapy',4,...
    'elements',{T1,T2});

ud.Handles.TableSplit = xregcardlayout(ud.Handles.Figure,...
    'numcards',3,...
    'visible','off',...
    'drawonselect','on');

% card layout in which we show two, one or none of the breakpointeditor components.
attach(ud.Handles.TableSplit,xregpanellayout(ud.Handles.Figure,'visible','off'),1);  % blank pane
attach(ud.Handles.TableSplit,T1,2); % single normaliser view
attach(ud.Handles.TableSplit,two_norm,3); % dual normaliser view

% the main layout
ud.Handles.Display = xregsnapsplitlayout(ud.Handles.Figure,...
    'elements',{ud.Handles.TableSplit,ud.Handles.ComparisonPane},...
    'barstyle',1,...
    'split',[0.6 0.4],...
    'orientation','ud',...
    'state','bottom',...
    'split',[0.6 0.4],...
    'style','tobottom',...
    'snapstyle','tozero',...
    'minwidth',[300 150],...
    'visible','off',...
    'callback',{cbs.DisplaySplitChange});

LYT = ud.Handles.Display; % we return this

% set up internal flags that govern how initialisation and optimisation behave.
ud.FunctionFlags.InitialisationFlag = 1; % Will tell us which of the initialisation algorithms to implement.
ud.FunctionFlags.EndPointFlag = 1; % Will tell us whether endpoints are to be fixed or movable.
ud.FunctionFlags.OptimisationAlgFlag = 1; % Will tell us which optimisation algorithm to use (should there ever
% be more than one).
ud.FunctionFlags.OptimisationFlag = 1; % Will tell us whether we are to try to moveboth BP's and 
% Values or just BP's alone.

ud.Store.VarPtrs = []; % create these so that we can safely test them later
ud.Store.ConstPtrs = [];
ud.FeatureData = [];
ud.TablePtr = [];



% -------------------------------------------------------
function d = i_create_menus(VMH, TMH, cbs)
% -------------------------------------------------------
% Function that will set up menus. This might be taking modularisation to extremes but right now
% it gives a way of keeping related code in the same place. Plan is that all uimenus and context 
% menus will be created here. May adjust later if it proves that certain things belong elsewhere.
% Also when this thing is up and running we need to examine whether a seperate Subfunction is really required.


d.Autospace = uimenu(TMH,'label','&Initialize...',...
    'callback',cbs.Initialize);

d.Initialise = uimenu(TMH,'label','&Fill...',...
    'callback',cbs.Fill);

d.Optimise = uimenu(TMH,'label','&Optimize...',...
    'callback',cbs.Optimize);

d.history = uimenu(VMH,'label','&History...',...
    'callback',cbs.ViewHistory);
d.comparison = uimenu(VMH,'label','&Comparison',...
    'checked','off',...
    'callback',cbs.ViewComparison);



% -------------------------------------------------------
function [pane , d] = i_create_toolbar(hand, cbs)
% -------------------------------------------------------
% Make our toolbar

icons{1,1} = cgresload('autospace.bmp','bmp');
icons{2,1} = cgresload('fill.bmp','bmp');
icons{3,1} = cgresload('optimise.bmp','bmp');

[d.ToolBar,btns]= xregtoolbar(hand,{'uipush','uipush','uipush'},...
    {'cdata'},icons,...
    {'ClickedCallBack'},{cbs.Initialize;cbs.Fill;cbs.Optimize},...
    {'ToolTipString'},{'Initialize';'Fill';'Optimize'},...
    {'Transparentcolor'},{[255 255 0];[255 255 0];[255 255 0]});

d.Autospace = btns(1);
d.Initialise = btns(2);
d.Optimise = btns(3);
pane = d.ToolBar;

return

