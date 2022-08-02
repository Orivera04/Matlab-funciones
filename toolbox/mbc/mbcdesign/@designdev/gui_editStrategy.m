function [DDobj, OK] = gui_editStrategy(DDobj,action,varargin)
% DESIGNDEV/GUI_EDITSTRATEGY   Gui for editing strategies of a designdev object
%
%  [DDobj,OK] = GUI_EDITSTRATEGY(D) brings up a GUI for manually adding points
%  to a design.   The GUI blocks until OK/Cancel has been pressed
%  OK is set to 0 if cancel was pressed, 1 otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:03:08 $

% Created 1/3/2001

% Note: this dialog is unusual in that no changes are made until OK is pressed
% i.e. the dynamic design pointer is not used for on-the-fly updating


if nargin < 2
   action='create';
end

switch lower(action)
case 'create'
   [DDobj, ret] = i_createFig(DDobj);
case 'layout'
   % no support yet   
end

% --------------------------------------------------------------------
% Function i_createFig
%
% Internal function to wrap layout in a figure object
% --------------------------------------------------------------------
function [DDobj, OK] = i_createFig(DDobj)

scrpos = get(0,'screensize');

f = xregfigure('visible','off',...
   'name','Edit DesignDev Strategy',...
   'units','pixels',...
   'position',[scrpos(3)./2-175 scrpos(4)./2-115 450 300],...
   'tag','EditStrategy',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

f.MinimumSize = [450 300];
fh = double(f);

% Note closeRequestFcn contains a reference to fh and so must be
% defined after the figure itself
set(fh, 'closerequestfcn',{@i_closeRequest, fh, 'cancel'});

% Create a runtime pointer pointing to the designdev object 
pDD = xregGui.RunTimePointer(DDobj);

% Ensure that this pointer is deleted when the figure is closed
pDD.LinkToObject(fh);

textLevel = xregGui.uicontrol('style','text',...
   'parent',fh,...
   'string','Select level :',...
   'position',[0 0 80 25],...
   'horizontalalignment','left');

selectLevel = xregGui.clickedit('parent', fh,...
   'position',[0 0 60 20],...
   'value',length(pDD.info),...
   'dragincrement',1,...
   'clickincrement',1,...
   'min',1,...
   'max',length(pDD.info),...
   'rule','int');

okBtn = xregGui.uicontrol('style','pushbutton',...
   'parent',fh,...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback',{@i_closeRequest, fh, 'ok'});

cancelBtn = xregGui.uicontrol('style','pushbutton',...
   'parent',fh,...
   'string','Cancel',...
   'position',[0 0 65 25],...
   'callback',{@i_closeRequest, fh, 'cancel'});

flow = xregflowlayout(fh,'orientation','right/center','elements',{cancelBtn okBtn selectLevel textLevel},...
   'border',[0 0 -7 0],'gap',10);

% Get the layout which sits in the middle of the figure
layout = i_createLayout(fh, pDD, selectLevel);

% set up a layout
b = xregborderlayout(fh,...
   'container',fh,...
   'center',layout,...
   'south',flow,...
   'innerborder',[10 45 10 10],...
   'packstatus','on');

f.LayoutManager = b;
f.Visible = 'on';
drawnow;

% block until ok/cancel pressed
waitfor(fh, 'tag');

tag = get(fh, 'tag');
% hide figure
set(fh, 'visible', 'off');
switch tag
case 'ok'
   % apply choices
   DDobj = pDD.info;
   OK = 1;
case 'cancel'
   OK = 0;
end
% Make sure the DOE editor is deleted if it is invisible
deh = mvf('DOEeditor');
if ~isempty(deh) & strcmp(get(deh, 'visible'), 'off')
    delete(deh);
end
% Note automatic deletion of pointer;
delete(fh);

return

% --------------------------------------------------------------------
% Function i_closeRequest
%
% Internal function callback for closeing dialog
% --------------------------------------------------------------------
function i_closeRequest(h, eventData, fh, tagString)
set(fh, 'tag', tagString);

% --------------------------------------------------------------------
% Function i_createLayout
%
% Internal function that generates the main layout in the figure
% --------------------------------------------------------------------
function layout = i_createLayout(fh, pDD, selectLevel)

editDesign = xregGui.uicontrol('style','pushbutton',...
   'parent',fh,...
   'string','Edit design',...
   'position',[0 0 75 30]);

editModel = xregGui.uicontrol('style','pushbutton',...
   'parent',fh,...
   'string','Edit model',...
   'position',[0 0 75 30]);

selectFlow = xregflowlayout(fh,'packstatus','off',...
   'orientation','left/center',...
   'elements',{editDesign editModel},...
   'gap',30,...
   'border', [-20 0 0 0]);

textNames = {'Get Constraints Strategy :' 'Modify Design Strategy :',...
		'Set Design Point Strategy :' 'Run Experiment Strategy :'};

numStrategies = length(textNames);

for i = 1:numStrategies
	text{i} = xregGui.uicontrol('style','text',...
		'parent',fh,...
		'string',textNames{i},...
		'position',[0 0 130 20],...
		'horizontalalignment','left');
end

strategyNames = getStrategyNames(pDD.info);

for i = 1:numStrategies
	popup{i} = xregGui.uicontrol('style','popupmenu',...
		'parent',fh,...
		'backgroundcolor','w',...
		'string',char(strategyNames{i}),...
		'position',[0 0 130 20]);
end

for i = 1:numStrategies
	params{i} = xregGui.uicontrol('style','pushbutton',...
		'parent',fh,...
		'string','...',...
		'position',[0 0 20 20]);
end

grid = xreggridlayout(fh,'packstatus','off',...
	'dimension',[5 3],...
	'correctalg','on',...
	'rowsizes',[20 20 20 20 -1],...
	'colsizes',[130 -1 20],...
	'border',[10 10 10 20],...
	'gapy',10,...
	'gapx',10,...
	'elements',[text {[]} popup {[]} params {[]}]);

selectFrame = xregframetitlelayout(fh,'title','Level Options',...
   'center',selectFlow,...
   'innerborder',[10 10 10 10]);

strategyFrame = xregframetitlelayout(fh,'title','Strategy options',...
   'center',grid,...
   'border',[0 0 0 10],...
   'innerborder',[10 10 10 10]);

layout = xregborderlayout(fh,'north',selectFrame,'center',strategyFrame,...
	'innerborder',[0 0 0 70]);

fieldnames = {'getConstraints' 'modifyDesign' 'setDesignPoint' 'runExperiment'};
% Structure of handles to be used in the callbacks being defined below
handles.popup      = popup;
handles.level      = selectLevel;
handles.fieldnames = fieldnames;

% Update popup controls based on pDD
i_updatePopups([], [], handles, pDD)

% Set the relevant callbacks on the popup controls and the level control
list(1) = handle.listener(selectLevel, selectLevel.findprop('Value'), 'PropertyPostSet', {@i_updatePopups, handles, pDD});
list(2) = handle.listener(editDesign ,  editDesign.findprop('Value'), 'PropertyPostSet', {@i_editDesign  , handles, pDD});
list(3) = handle.listener(editModel  ,   editModel.findprop('Value'), 'PropertyPostSet', {@i_editModel   , handles, pDD});

% Set callback for combo boxes
for i = 1:numStrategies
	list(end+1) = handle.listener(popup{i}, popup{i}.findprop('Value'), 'PropertyPostSet', {@i_popupChanged, handles, pDD, i});
end
% Set callback to param editor
for i = 1:numStrategies
	list(end+1) = handle.listener(params{i}, params{i}.findprop('Value'), 'PropertyPostSet', {@i_paramClicked, handles, pDD, i});
end
% Make the listeners persistent to the figure by inventing a new property 'LayoutListeners'
f = handle(fh);
p = schema.prop(f, 'LayoutListeners', 'mxArray');
f.LayoutListeners = list;

% --------------------------------------------------------------------
% Function i_updatePopups
%
% Internal function that updates the popup menu boxs
% based on the object in the pointer
% --------------------------------------------------------------------
function i_updatePopups(h, event, handles, pDD)

% Get the level we are at from the level indicator and convert the 
% designdev to a cell array
index = handles.level.value;
objs  = DesignDev2Cell(pDD.info);
% Match the name of the function handle to a name in the popup string
for i = 1:length(handles.fieldnames)
	% Get the callback from the relevant field in the object
	callback = objs{index}.(handles.fieldnames{i});
	% Get the string version of the function handle
	str2find = lower(expandCallback(callback));
	% Get the strings in the popup
	strings  = lower(handles.popup{i}.string);
	% Try to find the string in the list
	j = strmatch(str2find,strings);
	% If it isn't there just display the first one in red to indicate
	% an error. Once it's been reset i_popupChanged will turn the strings black
	if isempty(j)
		j = 1;
		handles.popup{i}.ForegroundColor = 'r';
	else
		handles.popup{i}.ForegroundColor = 'k';
	end
	handles.popup{i}.value = j;
end

% --------------------------------------------------------------------
% Function i_popupChanged
%
% Internal function that updates the object when a popup changes
% --------------------------------------------------------------------
function i_popupChanged(h, event, handles, pDD, i)

% Get the level we are at from the level indicator and convert the 
% designdev to a cell array
index = handles.level.value;
objs  = DesignDev2Cell(pDD.info);
fieldname = handles.fieldnames{i};
% Get the new value of the popup control and ths string associated with 
% that value
value  = event.AffectedObject.value;
string = event.AffectedObject.string(value,:);
% Popup strings are set to red when the strategy doesn't match a know strategy
% so after changing they must be reset to black.
event.AffectedObject.ForegroundColor = 'k';
% Remove any trailing whitespace and convert to a function handle
strategyName = deblank(string);
% Create a strategy object to get its default params
strategyObject = getObjectFromCallback(strategyName);
% Set the field of the designdev object which has changed
objs{index}.(fieldname) = strategyName;
% Update the pointer
pDD.info = Cell2DesignDev(objs);

% --------------------------------------------------------------------
% Function i_paramClicked
%
% Internal function that get params from the selected strategy
% --------------------------------------------------------------------
function i_paramClicked(h, event, handles, pDD, i)
% Ignore the buttonUp event
if event.AffectedObject.value == 0
	return
end
% Get the level we are at from the level indicator and convert the 
% designdev to a cell array
index = handles.level.value;
objs  = DesignDev2Cell(pDD.info);
fieldname = handles.fieldnames{i};
% Get the function handle for the current strategy
callback = objs{index}.(fieldname);
strategyName = expandCallback(callback);
% Create a strategy object and the current params
[strategyObject params] = getObjectFromCallback(callback);
% Call setParams of this strategy
params = setparams(strategyObject, params{:});
% Update the calling syntax
objs{index}.(fieldname) = {strategyName params{:}};
% Update pointer
pDD.info = Cell2DesignDev(objs);

% --------------------------------------------------------------------
% Function i_editDesign
%
% Internal function callback for editing current design
% --------------------------------------------------------------------
function i_editDesign(h, event, handles, pDD)
% Ignore the buttonUp event
if event.AffectedObject.value == 0
	return
end
% Get the level we are at from the level indicator and convert the 
% designdev to a cell array
index = handles.level.value;
objs = DesignDev2Cell(pDD.info);

% create a tree containing best design
bestDesign = objs{index}.design;
s=struct('designs',{{designobj(model(bestDesign)),bestDesign}},'parents',[0 1],'chosen',2);
deh=xregdesigneditor;
xregdesigneditor(deh,'loadtree',s);

% wait for it to close then delete it
waitfor(deh, 'visible', 'off');

s=xregdesigneditor(deh,'savetree');
% Copy the new best design into the DesignDev object
objs{index}.design = s.designs{s.chosen};

% Update the pointer
pDD.info = Cell2DesignDev(objs);

% --------------------------------------------------------------------
% Function i_editModel
%
% Internal function callback for editing current design model
% --------------------------------------------------------------------
function i_editModel(h, event, handles, pDD)
% Ignore the buttonUp event
if event.AffectedObject.value == 0
	return
end
% Get the level we are at from the level indicator and convert the 
% designdev to a cell array
index = handles.level.value;
objs = DesignDev2Cell(pDD.info);
% Create a pointer to the best design and a design
m = model(objs{index}.design);
% Open the model setup gui
[m, OK] = gui_modelsetup2(m);
% Did the user press the OK button?
if OK
	objs{index}.design = model(objs{index}.design, m);
	% Update the pointer
	pDD.info = Cell2DesignDev(objs);
end
