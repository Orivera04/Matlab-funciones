function configureStatePanel(this, StatePanel, manager)
% CONFIGURESTATEPANEL 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/16 22:20:33 $

% Ancestor added listener
L = [ handle.listener( handle(StatePanel), ...
                       'AncestorAdded', { @LocalUpdateStates, manager } ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Init button callback
h = handle( StatePanel.getInitButton, 'callbackproperties' );
h.ActionPerformedCallback = {@LocalInitButton, this };

% Reset button callback
h = handle( StatePanel.getResetButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalResetButton, this };

% Save button callback
h = handle( StatePanel.getSaveButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalSaveButton, this };

% Callback to combo box event.
Handles.DataSetCombo = StatePanel.getDataSetCombo;
h = handle( Handles.DataSetCombo, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalDataSetChanged, this };

% Callback to state data table event.
Handles.Table      = StatePanel.getStateTable;
Handles.TableModel = StatePanel.getStateTable.getModel;
h = handle( Handles.TableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalTableChanged, this };

% Store the handles
this.Handles.State = Handles;

% ---------------------------------------------------------------------------- %
function LocalInitButton(hSrc, hData, this)
rows = this.Handles.State.Table.getSelectedRows + 1;

% Initialize from best value
h = PrivateGetCurrentStates(this);
data = h(rows);
for ct = 1:length(data)
  data(ct).InitialGuess = data(ct).Value;
end

% Update table
PrivateTableUpdate(this)
model = this.Handles.State.TableModel;
model.tableRowsUpdated( rows(1) - 1 , rows(end) - 1 )

% ---------------------------------------------------------------------------- %
function LocalResetButton(hSrc, hData, this)
rows = this.Handles.State.Table.getSelectedRows + 1;

% Get state objects
source = find(this.getRoot, '-class', 'spenodes.Variables');

% Update states
newdata = source.States(rows);
h = PrivateGetCurrentStates(this);
selection = get(h(rows), {'Estimated'});
h(rows) = copy(newdata);
set(h(rows), {'Estimated'}, selection);
PrivateSetCurrentStates(this, h);

% Update table
PrivateTableUpdate(this)
model = this.Handles.State.TableModel;
model.tableRowsUpdated( rows(1) - 1 , rows(end) - 1 )

% ---------------------------------------------------------------------------- %
function LocalSaveButton(hSrc, hData, this)
rows = this.Handles.State.Table.getSelectedRows + 1;

% Get state objects
source = find(this.getRoot, '-class', 'spenodes.Variables');

% Update states
h = PrivateGetCurrentStates(this);
newdata = h(rows);
source.States(rows) = copy(newdata);
set(source.States(rows), 'Estimated', 'false')

% ----------------------------------------------------------------------------- %
function LocalTableChanged(hSrc, hData, this)
row = hData.getFirstRow + 1;
col = hData.getColumn   + 1;
selected = this.Handles.State.DataSetCombo.getSelectedIndex + 1;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  model = hData.getSource;
  value = model.getValueAt(row - 1, col - 1);
  this.setStateData( value, row, col, selected );
  
  % Update row for editable & enabled state changes
  model.tableRowsUpdated( row - 1, row - 1 )
end

% ----------------------------------------------------------------------------- %
function LocalDataSetChanged(hSrc, hData, this)
PrivateTableUpdate(this);
model = this.Handles.State.TableModel;
model.tableRowsUpdated( 0, java.lang.Integer.MAX_VALUE);

% ----------------------------------------------------------------------------- %
function LocalUpdateStates(this, hData, manager)
combo = this.Handles.State.DataSetCombo;
updateEstimationData(this, manager);

names    = PrivateGetCurrentExperiments(this);
selected = combo.getSelectedItem;
idx = find( strcmp( names, selected ) );

combo.setData(names);

% Reselect the same item
if ~isempty(idx)
  awtinvoke( combo, 'setSelectedIndex', idx-1 );
end

% ----------------------------------------------------------------------------- %
% Handle UDD -> JAVA changes
function PrivateTableUpdate(this)
selected = this.Handles.State.DataSetCombo.getSelectedIndex + 1;
if selected > 0
  table = getStateData(this, selected);
else
  table = [];
end
model = this.Handles.State.TableModel;
model.setData(table);

% ----------------------------------------------------------------------------- %
function states = PrivateGetCurrentStates(this)
selected = this.Handles.State.DataSetCombo.getSelectedIndex + 1;
type = this.ExperimentType;
states = this.States{type}(:,selected);

% ----------------------------------------------------------------------------- %
function states = PrivateSetCurrentStates(this, states)
selected = this.Handles.State.DataSetCombo.getSelectedIndex + 1;
type = this.ExperimentType;
this.States{type}(:,selected) = states;

% ----------------------------------------------------------------------------- %
function names = PrivateGetCurrentExperiments(this)
% 1: transient, 2: steady-state, 3: frequency domain
type  = this.ExperimentType;
data  = this.ExperimentList{type};
names = {data.Name};
