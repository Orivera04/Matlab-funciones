function configureOutputPanel(this, OutputPanel, manager)
% CONFIGUREOUTPUTPANEL 

% Author(s): Bora Eryilmaz, James G. Owen
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:39:13 $

% Ancestor added listener
L = [ handle.listener( handle(OutputPanel), ...
                       'AncestorAdded', {@LocalUpdateData} ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Get the Java handles
Handles = this.Handles;

% Callback to output data table event.
Handles.OutputTableModel = OutputPanel.getDataTableModel;
h = handle( Handles.OutputTableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalOutputTableChanged, this };

% Clear all button callback
h = handle( OutputPanel.getClearButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalClearAllCallback, this };

% Pre-process button callback
h = handle( OutputPanel.getProcessButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalPreProcessCallback, this, manager };

% Import button callback
h = handle( OutputPanel.getImportButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalImportCallback, this, manager };

% Store the java handles
this.Handles = Handles;

% ----------------------------------------------------------------------------- %
% Handle JAVA -> UDD changes
function LocalOutputTableChanged(hSrc, hData, this)
row = hData.getFirstRow + 1;
col = hData.getColumn + 1;

model = this.Handles.OutputTableModel;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  % Cell changed
  value = model.getValueAt(row-1, col-1);
  this.setOutputData(value, row, col);
  PrivateTableUpdate(this);
else
  % Other changes
end

% ----------------------------------------------------------------------------- %
function PrivateTableUpdate(this, type)
% Set the output table data
[table, indices] = getOutputData(this);

model = this.Handles.OutputTableModel;
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
hData  = parent.Experiment.OutputData;

% Create new data
newdata = [];
for ct = 1:length( hData )
  newdata = [ newdata; ParameterEstimatorData.FrequencyData( hData(ct) ) ];
end

this.Experiment.OutputData = newdata;
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
