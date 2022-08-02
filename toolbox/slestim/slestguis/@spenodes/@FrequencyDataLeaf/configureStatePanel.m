function configureStatePanel(this, StatePanel, manager)
% CONFIGURESTATEPANEL 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:39:14 $

% Ancestor added listener
L = [ handle.listener( handle(StatePanel), ...
                       'AncestorAdded', {@LocalUpdateData} ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Get the Java handles
Handles = this.Handles;

% Callback to state data table event.
Handles.StateTableModel = StatePanel.getDataTableModel;
h = handle( Handles.StateTableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalStateTableChanged, this };

% Clear all button callback
h = handle( StatePanel.getClearButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalClearAllCallback, this };

% Import button callback
h = handle( StatePanel.getImportButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalImportCallback, this, manager };

% Store the java handles
this.Handles = Handles;

% ----------------------------------------------------------------------------- %
% Handle JAVA -> UDD changes
function LocalStateTableChanged(hSrc, hData, this)
row = hData.getFirstRow + 1;
col = hData.getColumn + 1;

model = this.Handles.StateTableModel;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  % Cell changed
  value = model.getValueAt(row-1, col-1);
  this.setStateData(value, row, col);
  PrivateTableUpdate(this);
else
  % Other changes
end

% ----------------------------------------------------------------------------- %
function PrivateTableUpdate(this, type)
% Set the state table data
[table, indices] = getStateData(this);

model = this.Handles.StateTableModel;
model.setData(table, indices-1);

if nargin > 1
  model.tableRowsUpdated(0, java.lang.Integer.MAX_VALUE);
else
  model.tableRowsUpdated(0, size(table,1));
end

% ----------------------------------------------------------------------------- %
function LocalUpdateData(this, hData)
PrivateTableUpdate(this, true)

% ---------------------------------------------------------------------------- %
function LocalClearAllCallback(hSrc, hData, this)
parent = find(this.getRoot, '-class', 'spenodes.FrequencyData');
hData  = parent.Experiment.StateData;

% Create state data
newdata = [];
for ct = 1:length( hData )
  newdata = [ newdata; ParameterEstimatorData.StateData( hData(ct) ) ];
end

this.Experiment.StateData = newdata;
PrivateTableUpdate(this, true)

% ----------------------------------------------------------------------------- %
function LocalImportCallback(hSrc, hData, node, manager)
% Opens Data Import dialog when user hits "Import Data"
% Note that the iotable is a singleton object
speimporttable.statetable(manager);
