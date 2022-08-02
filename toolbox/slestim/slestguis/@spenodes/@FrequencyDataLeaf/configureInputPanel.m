function configureInputPanel(this, InputPanel, manager)
% CONFIGUREINPUTPANEL 

% Author(s): Bora Eryilmaz, James G. Owen
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:39:12 $

% Ancestor added listener
L = [ handle.listener( handle(InputPanel), ...
                       'AncestorAdded', {@LocalUpdateData} ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Get the Java handles
Handles = this.Handles;

% Callback to input data table event.
Handles.InputTableModel = InputPanel.getDataTableModel;
h = handle( Handles.InputTableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalInputTableChanged, this };

% Clear all button callback
h = handle( InputPanel.getClearButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalClearAllCallback, this };

% Pre-process button callback
h = handle( InputPanel.getProcessButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalPreProcessCallback, this, manager };

% Import button callback
h = handle( InputPanel.getImportButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalImportCallback, this, manager };

% Store the java handles
this.Handles = Handles;

% ----------------------------------------------------------------------------- %
% Handle JAVA -> UDD changes
function LocalInputTableChanged(hSrc, hData, this)
row = hData.getFirstRow + 1;
col = hData.getColumn + 1;

model = this.Handles.InputTableModel;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  % Cell changed
  value = model.getValueAt(row-1, col-1);
  this.setInputData(value, row, col);
  PrivateTableUpdate(this);
else
  % Other changes
end

% ----------------------------------------------------------------------------- %
function PrivateTableUpdate(this, type)
% Set the input table data
[table, indices] = getInputData(this);

model = this.Handles.InputTableModel;
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
hData  = parent.Experiment.InputData;

% Create new data
newdata = [];
for ct = 1:length( hData )
  newdata = [ newdata; ParameterEstimatorData.FrequencyData( hData(ct) ) ];
end

this.Experiment.InputData = newdata;
PrivateTableUpdate(this, true)

% ----------------------------------------------------------------------------- %
function LocalPreProcessCallback(hSrc, hData, this, manager)
% Open or show the preprocessing GUI (singleton)
% this.openpreprocgui(manager)

% ----------------------------------------------------------------------------- %
function LocalImportCallback(hSrc, hData, node, manager)
% Opens Data Import dialog when user hits "Import Data"
% Note that the iotable is a singleton object
% speimporttable.iotable(manager);
