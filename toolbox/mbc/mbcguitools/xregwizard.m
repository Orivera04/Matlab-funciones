function [OK, outputUD] = xregWizard(hParent, wizardName, firstCardFcn, varargin)
%XREGWIZARD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.8.2.3 $  $Date: 2004/02/09 07:34:43 $

% Check tag for duplicates
wizardTagBase = validmlname(wizardName);
wizardTag = wizardTagBase;
i = 1;
while ~isempty(mvf(wizardTag))
	wizardTag = [wizardTagBase sprintf('%d', i)];
	i = i + 1;
end

f = xregdialog('visible','off',...
    'units','pixels',...
    'Name', wizardName,...
    'tag',wizardTag,...
    'closerequestfcn',{@i_cancel},...   
    'color',get(0,'defaultuicontrolbackgroundcolor'));
fh = double(f);

% Set getThisHandle tag
i_getThisHandle(wizardTag);

% Add a property to define the close action
schema.prop(f, 'closeAction', 'string');

% Center the figure on the parent figure
xregcenterfigure(f, [600 250], hParent);

% Create the wizard control buttons
btCancel = xregGui.uicontrol('parent', fh,...
    'style', 'pushbutton', ...
    'string', 'Cancel',...
    'callback', {@i_cancel});

btPrev = xregGui.uicontrol('parent', fh,...
    'style', 'pushbutton', ...
    'string', '< Back',...
	'enable', 'off',...
    'callback', {@i_prev});

btNext = xregGui.uicontrol('parent', fh,...
    'style', 'pushbutton', ...
    'string', 'Next >',...
	'enable', 'off',...
    'callback', {@i_next});

btFinish = xregGui.uicontrol('parent', fh,...
    'style', 'pushbutton', ...
    'string', 'Finish',...
	'enable', 'off',...
    'callback', {@i_finish});

buttonLayout = xreggridbaglayout(fh, ...
    'packstatus', 'off', ...
    'dimension', [1 5],...
    'elements', {[] btCancel btPrev btNext btFinish},...
    'gapx', 7,...
    'border', [0 0 7 0],...
    'colsizes', [-1 65 65 65 65],...
    'rowsizes', 25);

ud.cardLayout = xregcardlayout(fh, 'numcards', 1);

% For wizard use only
ud.navButton.next   = btNext;
ud.navButton.prev   = btPrev;
ud.navButton.cancel = btCancel;
ud.navButton.finish = btFinish;
ud.cardIDs          = {};
ud.prevIDs          = [];
ud.Parent           = hParent;
ud.UserData         = [];

% Define the wizard API interface
iFace.getCardUserdata = @i_getCurrentCardUserdata;
iFace.setCardUserdata = @i_setCurrentCardUserdata;
iFace.setNextButton   = @i_setNextButton;
iFace.setPrevButton   = @i_setPrevButton;
iFace.setFinishButton = @i_setFinishButton;
iFace.setOutputData   = @i_setOutputData;
iFace.setWizardSize   = @i_setWizardSize;
iFace.setUserData     = @i_setUserData;
iFace.getUserData     = @i_getUserData;

% Attach interface to userdata
ud.iFace = iFace;

% Final output arguments
ud.outputUD           = [];

layout = xreggridbaglayout(fh,...
    'dimension', [2 1],...
    'elements', {ud.cardLayout buttonLayout},...
    'gapy', 7,...
    'border', [0 7 0 0], ...
    'rowsizes', [-1 25]);

f.LayoutManager = layout;
f.userdata = ud;

% Create the first card in the wizard
i_openCard(firstCardFcn, varargin{:});

set(layout, 'packstatus', 'on');

% Set the window modal waiting for the visibility to change
showDialog(f);

switch f.closeAction
case 'ok'
    [fh, ud, f] = i_getThisHandle;
	outputUD = ud.outputUD;
	OK = 1;
otherwise
	outputUD = [];
	OK = 0;
end
delete(fh);

%------------------------------------------------------------------------
% WIZARD API FUNCTIONS BELOW
%------------------------------------------------------------------------

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_cancel(src, event)
[fh, ud, f] = i_getThisHandle;
% Give the card a chance to respond to the cancel button
layoutUD = i_getCurrentCardUserdata;
if isfield(layoutUD,'cancelFcn')
   % the cancel function is an optional interface
   feval(layoutUD.cancelFcn, layoutUD, ud.iFace);
end

f.closeAction = 'cancel';
f.visible = 'off';

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_finish(src, event)
[fh, ud, f] = i_getThisHandle;
% Give the card a chance to respond to the finish button
layoutUD = i_getCurrentCardUserdata;
feval(layoutUD.finishFcn, layoutUD, ud.iFace);

f.closeAction = 'ok';
f.visible = 'off';

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_prev(src, event)
[fh, ud, f] = i_getThisHandle;
% Get the previous card ID
currID = get(ud.cardLayout, 'current');
cardID = ud.cardIDs{ud.prevIDs(currID)};
i_openCard(cardID);
if ud.prevIDs(currID) == 1
	i_setPrevButton('off');
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_next(src, event)
[fh, ud, f] = i_getThisHandle;
layoutUD = i_getCurrentCardUserdata;
[nextCardID, localData] = feval(layoutUD.nextFcn, layoutUD, ud.iFace);
if ~isempty(nextCardID)
	currID = get(ud.cardLayout, 'current');
	[ID, ud] = i_openCard(nextCardID, localData);
	ud.prevIDs(ID) = currID;
	i_setPrevButton('on');
	f.userdata = ud;
end
    
%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [ID, ud] = i_openCard(cardID, varargin)
[fh, ud, f] = i_getThisHandle;
% Ensure cardID is a cell array for feval purpose
if ~iscell(cardID)
	cardID = {cardID};
end
% Does cardID exist already?
FOUND = 0;
for i = 1:length(ud.cardIDs)
	if isequal(cardID, ud.cardIDs{i})
		FOUND = 1;
		break;
	end
end
if FOUND
	ID = i;
	layout = getcard(ud.cardLayout, ID);
	fh = layout{1};
end
% Create or open the card
layout = feval(cardID{:}, fh, ud.iFace, varargin{:});
% If this is create we need to add this to the cardLayout
if ~FOUND
	nextID = length(ud.cardIDs) + 1;
	% Does the cardLayout have enough cards?
	if get(ud.cardLayout, 'numcards') < nextID
		set(ud.cardLayout, 'numcards', nextID);
	end
	ID = attach(ud.cardLayout, layout, nextID);
	% Add this cardID on to the end of the list
    [fh, ud, f] = i_getThisHandle;
	ud.cardIDs{ID} = cardID;
	f.userdata = ud;
end
% Set the currentcard
set(ud.cardLayout, 'currentCard', ID);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setNextButton(enable)
[fh, ud, f] = i_getThisHandle;
if isnumeric(enable) | islogical(enable)
	states = {'off' 'on'};
	enable = states{sign(abs(enable))+1};
end
set(ud.navButton.next, 'enable', enable);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setPrevButton(enable)
[fh, ud, f] = i_getThisHandle;
if get(ud.cardLayout, 'current') == 1
	enable = 'off';
end
if isnumeric(enable) | islogical(enable)
	states = {'off' 'on'};
	enable = states{sign(abs(enable))+1};
end
set(ud.navButton.prev, 'enable', enable);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setFinishButton(enable)
[fh, ud, f] = i_getThisHandle;
if isnumeric(enable) | islogical(enable)
	states = {'off' 'on'};
	enable = states{sign(abs(enable))+1};
end
set(ud.navButton.finish, 'enable', enable);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setOutputData(outputUD)
[fh, ud, f] = i_getThisHandle;
ud.outputUD = outputUD;
f.userdata = ud;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function layoutUD = i_getCurrentCardUserdata
[fh, ud, f] = i_getThisHandle;
layout = getcard(ud.cardLayout);
layoutUD = get(layout{1}, 'userdata');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function ID = i_getCurrentCardID
[fh, ud, f] = i_getThisHandle;
ID = get(ud.cardLayout, 'current');

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setCurrentCardUserdata(layoutUD)
[fh, ud, f] = i_getThisHandle;
layout = getcard(ud.cardLayout);
set(layout{1}, 'userdata', layoutUD);

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setWizardSize(Size)
[fh, ud, f] = i_getThisHandle;
if isempty(ud.cardIDs)
    % Only set size if card one is creating
    xregcenterfigure(fh, Size, ud.Parent);
end

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function i_setUserData(UD)
[fh, ud, f] = i_getThisHandle;
ud.UserData = UD;
f.userdata = ud;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function UD = i_getUserData
[fh, ud, f] = i_getThisHandle;
UD = ud.UserData;

%------------------------------------------------------------------------
%
%------------------------------------------------------------------------
function [fh, ud, f] = i_getThisHandle(wizardTag)
persistent thisTag
if nargin > 0
	thisTag = wizardTag;
	return
end
fh = mvf(thisTag);
f  = handle(fh);
ud = f.userdata;
