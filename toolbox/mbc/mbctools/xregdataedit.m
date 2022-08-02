function varargout = xregdataedit(action, varargin)
%XREGDATAEDIT Create/Alter the data editor framework
%
%  H = XREGDATAEDIT  creates a data editor window
%  H = XREGDATAEDIT('create','gui','action','value',...)  creates a
%  window and sets properties
%  XREGDATAEDIT(H,'action','value')  sets properties on a current window

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.8.3 $    $Date: 2004/04/04 03:32:49 $ 

% Default constructor to create the window
if ~nargin
    action = 'create';
end

switch lower(action)
    case 'create'
        varargout{1} = i_createGui(varargin{:});
    case 'gethandle'
        varargout{1} = i_getThisHandle;
end

% -------------------------------------------------------------------------
% Internal functions to create the GUI for the data editor
% -------------------------------------------------------------------------
function f = i_createGui(varargin)
% Check for existing GUI handle
f = i_getThisHandle;
if ~isempty(f)
    i_wakeup(f, varargin{:});
    return;
end

modelBrowser = MBrowser;

% Otherwise we need to create the GUI ... Note don't set close request
% function here in case user presses close during the creation process
f = xregdatagui.figure(varargin{:},...
    'tag', 'dataEditor',...
    'visible', 'off',...
    'renderer', 'zbuffer',...
    'name', 'Data Editor',...
    'keypressfcn', 'figure(gcbf)',...
    'closerequestfcn', '',...
    'pointer', 'watch',...
    'Browser', modelBrowser,...
    'MinimumSize', [400 200]);

xregpersistfigpos(f);
xregmoveonscreen(f);

% Create the statusbar and add the first message that will be seen
f.StatusBar = xregGui.statusbar('parent', f);
msgID = f.StatusBar.addMessage('Creating information views ...');

% Create the menuview objct to generate and maintain the menus and toolbar
menu = xregdatagui.menuview('parent', f, ...
    'DataMessageService', f.DataMessageService);
% Add our custom view menu to the handle provided by the menuview object
f.addViewMenu(menu.ViewMenuHandle);
% Create the toolbar for the moment - TO DO get this from the menuview
f.UIToolbar = menu.createToolbar;
% Put the toolbar (created above) in a panel
toolbarPanel = xregpanellayout(f, ...
    'packstatus', 'off', ...
    'center', f.UIToolbar, ...
    'innerborder', [0 0 0 0], ...
    'state', 'in');

% Link the visible components together
mainLayout = xreggridbaglayout(f,...
    'dimension', [3 1],...
    'elements', {toolbarPanel [], f.StatusBar},...
    'rowsizes', [31 -1 20],...
    'gapy', 2);

% Set the figure visible to show the statusbar and put it in the mainLayout
% so that the user can watch the creation of the figure
f.LayoutManager = mainLayout;
set(mainLayout, 'packstatus', 'on');
f.visible = 'on';
f.StatusBar.waitbar.value = 0.25;
drawnow('expose');

% Disable the figureaxes actions until creation is finished
fa = xregGui.figureaxes;
fa.disableAxesMovement(f);

% Create the specific data and testnumber views that will always be added
% to the data editor
dataInfoView   = xregdatagui.datainfoview('parent', f, ...
    'visible', 'off', ...
    'DataMessageService', f.DataMessageService);

f.StatusBar.waitbar.value = 0.4;

testnumberView = xregdatagui.testnumberview('parent', f, ...
    'visible', 'off', ...
    'DataMessageService', f.DataMessageService);
% Force the testnumber view to be in charge of RequestSelectedTests
testnumberView.pSendSelectedTestsChanged;

% Create the layouts for the specific data views to sit in
infoSnapPanel = xregsnapsplitlayout(f,...
    'packstatus', 'off', ...
    'visible', 'off',...
    'barstyle',1,...
	'orientation', 'ud',...
	'style','totop',...
  	'split', [0 1],...
    'minwidth', [110 100],...
    'top', dataInfoView,...
    'bottom', []);
f.ViewOwner = {infoSnapPanel 2};
testSnapPanel = xregsnapsplitlayout(f,...
    'packstatus', 'off',...
    'visible', 'off',...
    'barstyle',1,...
	'orientation', 'lr',...
	'style','toleft',...
	'split', [0 1],...
    'minwidth', [60 100],...
    'left', testnumberView,...
    'right', infoSnapPanel);

% How far through are we?
f.StatusBar.changeMessage(msgID, 'Regenerating saved views...');
f.StatusBar.Waitbar.value = 0.6;

% Get the layout preferences
p = getpref(mbcprefs('mbc'), 'DataEditor');
if isempty(p.LayoutData)
    % Use a default layout
    p.LayoutData = {'xregdatagui.sweepsetplotview'};
end
% Install the saved layout data in the middle of the infoSnapPanel
OK = f.replaceDisplayLayout(p.LayoutData, f.ViewOwner, 'off');
if ~OK
    % Use a default layout
    f.replaceDisplayLayout({'xregdatagui.sweepsetplotview'});
end
f.StatusBar.changeMessage(msgID, 'Redrawing...');
f.StatusBar.Waitbar.value = 0.9;

set(mainLayout, ...
    'elements', {toolbarPanel testSnapPanel, f.StatusBar}, ...
    'packstatus', 'on');
set(testSnapPanel, 'visible', 'on');

fa.enableAxesMovement(f);

% How far through are we?
f.StatusBar.changeMessage(msgID, 'Completing...');
f.StatusBar.Waitbar.value = 1;

% Make GUI visible
set(f,'deletefcn', @i_deleteFigure,...
    'closerequestfcn', @i_sleep,...
    'pointer','arrow');

% Listen to changes in the size of the data info view to ensure it is alway
% 110 pixels high, except when it's snapped shut
l = handle.listener(f, 'ResizeEvent', ...
    {@i_setInfoHeight dataInfoView infoSnapPanel});
set(mainLayout, 'userdata', l);

% Tell the user everything is ready
f.StatusBar.Waitbar.value = 0;
f.StatusBar.changeMessage(msgID, 'Ready');



%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setInfoHeight(src, event, dataInfoView, snapPanel)
% Push all the height change into the bottom split, keeping the minimum
% size of the top part 110 pixels. Note that the floor will ensure that
% these (110 and currentWidths(2) + deltaH) will not sum to more than
% the new possible height of the figure.
snapPos = get(snapPanel, 'position');
currentWidths = get(snapPanel, 'minwidth');
newWidths = [110 snapPos(4)-110];
if ~isequal(newWidths, currentWidths)
    set(snapPanel, 'minwidth', [110 snapPos(4)-110], 'split', [0 1]);
end


%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_sleep(src, event)
f = handle(src);
if ~isempty(f.CloseClickedFcn)
    % Execute the CloseClickedFcn
    eventData.LeaveVisible = false;
    xregcallback(f.CloseClickedFcn, f, eventData);
else
    f.close;
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_wakeup(f, varargin)
% May need to fake a sleep event first
if isequal(f.visible, 'on')
    % Execute the CloseClickedFcn
    eventData.LeaveVisible = true;
    xregcallback(f.CloseClickedFcn, f, eventData);
end
% Set the desired properties
set(f, varargin{:});
% Reset the pointer just in case
f.PointerRepository.stackClearAndReset(f);
% Make the figure visible
f.visible = 'on';

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_deleteFigure(src, event)
f = handle(src);
% Save the figure layout
p = mbcprefs('mbc');
d = getpref(p, 'DataEditor');
% Try to serialise the layout
try
    d.LayoutData = f.serializeDisplayLayout;
    setpref(p, 'DataEditor', d);
    saveprefs(p);
end
    
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [f, fh] = i_getThisHandle
fh = mvf('dataEditor');
f = handle(fh);

