function configureParameterPanel(this, ParameterPanel, manager)
% CONFIGUREPARAMETERPANEL 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:40:26 $

% Get the Java handles
Handles = this.Handles;

% Add property and AncestorAdded listeners
prop = findprop(this, 'Parameters');
L = [ handle.listener(this, prop, 'PropertyPostSet', @LocalUpdateParameters); ...
      handle.listener(handle(ParameterPanel), ...
                      'AncestorAdded', @LocalUpdatePanel) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Callback to list selection event.
Handles.ParameterList = ParameterPanel.getParameterList;
h = handle( Handles.ParameterList, 'callbackproperties' );
h.ValueChangedCallback = { @LocalValueChanged, this };

% Callback to settings panel event.
Handles.ParameterSettingsPanel = ParameterPanel.getSettingsPanel;
h = handle( Handles.ParameterSettingsPanel, 'callbackproperties' );
h.PropertyChangeCallback = { @LocalPropertyChanged, this };

% Configure the buttons
h = handle( ParameterPanel.getAddButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalAddCallback, this, manager };

h = handle( ParameterPanel.getDeleteButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalDeleteCallback, this };

% Configure the text area
h = handle( ParameterPanel.getEditor, 'callbackproperties' );
h.HyperlinkUpdateCallback = { @LocalTextAreaCallback, this };

% Store the java handles
this.Handles = Handles;

% ----------------------------------------------------------------------------- %
function LocalValueChanged(hSrc, hData, this)
% Selected item wrt the currently visible list
selected = this.Handles.ParameterList.getSelectedIndex + 1;
if (selected > 0) && ~hData.getValueIsAdjusting
  data = this.getParameterData(selected);
  this.Handles.ParameterSettingsPanel.setContent( data );
end

% ----------------------------------------------------------------------------- %
function LocalPropertyChanged(hSrc, hData, this)
if strcmp( char(hData.getPropertyName), 'settings_changed')
  selected = hData.getNewValue + 1;
  info = cell(this.Handles.ParameterSettingsPanel.getContent);
  this.setParameterData( selected, info(2:end) );
end

% ----------------------------------------------------------------------------- %
% Add new items to the list
function LocalAddCallback(hSrc, hData, this, manager)
dlg = this.ParameterDialog;
if isempty(dlg) || ~ishandle(dlg)
  dlg = spedialogs.ParameterImport( this, manager.Explorer );
  this.ParameterDialog = dlg;
end
dlg.show;

% ----------------------------------------------------------------------------- %
function LocalDeleteCallback(hSrc, hData, this)
% Delete selected items from the list
selected = this.Handles.ParameterList.getSelectedIndices + 1;
if all(selected > 0)
  this.Parameters(selected) = [];
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
model = this.Handles.ParameterList.getModel;
type  = javax.swing.event.ListDataEvent.CONTENTS_CHANGED;
model.listChanged(type, 0, java.lang.Integer.MAX_VALUE)

% ----------------------------------------------------------------------------- %
function LocalUpdateParameters(this, hData)
% Update list when list of Parameter objects changes
PrivateListUpdate(this)
model = this.Handles.ParameterList.getModel;
type  = javax.swing.event.ListDataEvent.CONTENTS_CHANGED;
model.listChanged(type, 0, java.lang.Integer.MAX_VALUE)

% Set the dirty flag
this.setDirty

% ----------------------------------------------------------------------------- %
function PrivateListUpdate(this)
% Visible parameter list
list = get( this.Parameters, {'Name'} );

% Set the input table data
model = this.Handles.ParameterList.getModel;
model.setData( list );
