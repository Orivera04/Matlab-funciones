function configureStatePanel(this, StatePanel, manager)
% CONFIGURESTATEPANEL 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:40:27 $

% Get the Java handles
Handles = this.Handles;

% Add property and AncestorAdded listeners
prop = findprop(this, 'States');
L = [ handle.listener(this, prop, 'PropertyPostSet', @LocalUpdateStates); ...
      handle.listener(handle(StatePanel), ...
                      'AncestorAdded', @LocalUpdatePanel) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Callback to list selection event.
Handles.StateList = StatePanel.getStateList;
h = handle( Handles.StateList, 'callbackproperties' );
h.ValueChangedCallback = { @LocalValueChanged, this };

% Callback to settings panel event.
Handles.StateSettingsPanel = StatePanel.getSettingsPanel;
h = handle( Handles.StateSettingsPanel, 'callbackproperties' );
h.PropertyChangeCallback = { @LocalPropertyChanged, this };

% Configure the buttons
h = handle( StatePanel.getAddButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalAddCallback, this, manager };

h = handle( StatePanel.getDeleteButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalDeleteCallback, this };

% Configure the text area
h = handle( StatePanel.getEditor, 'callbackproperties' );
h.HyperlinkUpdateCallback = { @LocalTextAreaCallback, this };

% Store the java handles
this.Handles = Handles;

% ----------------------------------------------------------------------------- %
function LocalValueChanged(hSrc, hData, this)
% Selected item wrt the currently visible list
selected = this.Handles.StateList.getSelectedIndex + 1;
if (selected > 0) && ~hData.getValueIsAdjusting
  data = this.getStateData(selected);
  this.Handles.StateSettingsPanel.setContent( data );
end

% ----------------------------------------------------------------------------- %
function LocalPropertyChanged(hSrc, hData, this)
if strcmp( char(hData.getPropertyName), 'settings_changed')
  selected = hData.getNewValue + 1;
  info = cell(this.Handles.StateSettingsPanel.getContent);
  this.setStateData( selected, info(2:end) );
end

% ----------------------------------------------------------------------------- %
% Add new items to the list
function LocalAddCallback(hSrc, hData, this, manager)
dlg = this.StateDialog;
if isempty(dlg) || ~ishandle(dlg)
  dlg = spedialogs.StateImport( this, manager.Explorer );
  this.StateDialog = dlg;
end
dlg.show;

% ----------------------------------------------------------------------------- %
function LocalDeleteCallback(hSrc, hData, this)
% Delete selected items from the list
selected = this.Handles.StateList.getSelectedIndices + 1;
if all(selected > 0)
  this.States(selected) = [];
end

% ----------------------------------------------------------------------------- %
function LocalTextAreaCallback(hSrc, hData, this)
if strcmp(hData.getEventType.toString, 'ACTIVATED')
  feval( 'hilite_system', char(hData.getDescription), 'find' )
  pause(1);
  feval( 'hilite_system', char(hData.getDescription), 'none' )
end

% ----------------------------------------------------------------------------- %
function LocalUpdatePanel(this, hData)
% Update list
PrivateListUpdate(this)
model = this.Handles.StateList.getModel;
type  = javax.swing.event.ListDataEvent.CONTENTS_CHANGED;
model.listChanged(type, 0, java.lang.Integer.MAX_VALUE)

% ----------------------------------------------------------------------------- %
function LocalUpdateStates(this, hData)
% Update list when list of State objects changes
PrivateListUpdate(this)
model = this.Handles.StateList.getModel;
type  = javax.swing.event.ListDataEvent.CONTENTS_CHANGED;
model.listChanged(type, 0, java.lang.Integer.MAX_VALUE)

% Set the dirty flag
this.setDirty

% ----------------------------------------------------------------------------- %
function PrivateListUpdate(this)
% Visible state list
list = get( this.States, {'Block'} );
list = regexprep(list, '\n\r?', ' ');

% Set the input table data
model = this.Handles.StateList.getModel;
model.setData( list );
