function configureExperimentPanel(this, ExperimentPanel, manager)
% CONFIGUREEXPERIMENTPANEL 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:38:40 $

% Ancestor added listener
L = [ handle.listener( handle(ExperimentPanel), ...
                       'AncestorAdded', {@LocalUpdateExperiments, manager} ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Select button callback
h = handle( ExperimentPanel.getSelectButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalButtonPressed, this, true };

% Clear button callback
h = handle( ExperimentPanel.getClearButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalButtonPressed, this, false };

% Callback to combo box event.
h = handle( ExperimentPanel.getTypeCombo, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalTypeChanged, this };

% Callback to selection table selection event.
Handles.SelectionTable = ExperimentPanel.getSelectionTable;
h = handle( Handles.SelectionTable.getSelectionModel, 'callbackproperties' );
h.ValueChangedCallback = { @LocalSelectionValueChanged, this };

% Callback to selection table event.
Handles.SelectionTableModel = ExperimentPanel.getSelectionTable.getModel;
h = handle( Handles.SelectionTableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalSelectionTableChanged, this };

% Callback to data table event.
Handles.DataTableModel = ExperimentPanel.getDataTable.getModel;
h = handle( Handles.DataTableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalDataTableChanged, this };

% Store the handles
this.Handles.Experiment = Handles;

% ---------------------------------------------------------------------------- %
function LocalButtonPressed(hSrc, hData, this, type)
% type == true  : select all
% type == false : clear all
list = PrivateGetListData(this);
list(:,1) = { type };
PrivateSetListData( this, list );

model = this.Handles.Experiment.SelectionTableModel;
model.setData(list);
model.tableRowsUpdated( 0, size(list,1) - 1);

% ---------------------------------------------------------------------------- %
function LocalTypeChanged(hSrc, hData, this)
row = hData.getSource.getSelectedIndex + 1;
this.ExperimentType = row;
PrivateSelectionTableUpdate(this);

% ----------------------------------------------------------------------------- %
% Handle JAVA -> UDD changes
function LocalDataTableChanged(hSrc, hData, this)
row = hData.getFirstRow + 1;
col = hData.getColumn   + 1;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  model = hData.getSource;
  value = model.getValueAt(row - 1, col - 1);
  selected = this.Handles.Experiment.SelectionTable.getSelectedRow + 1;
  this.setExperimentData( value, row , col, selected );
end

% ----------------------------------------------------------------------------- %
function LocalSelectionTableChanged(hSrc, hData, this)
% Handle JAVA -> UDD changes
row   = hData.getFirstRow + 1;
col   = hData.getColumn   + 1;
model = hData.getSource;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  value = model.getValueAt(row - 1, col - 1);
  data  = PrivateGetListData(this);
  data(row,col) = { value };
  PrivateSetListData( this, data );
elseif ( model.getRowCount > 0 )
  selectionTable = this.Handles.Experiment.SelectionTable;
  awtinvoke( selectionTable, 'setRowSelectionInterval', 0, 0 )
end

% ----------------------------------------------------------------------------- %
function LocalSelectionValueChanged(hSrc, hData, this)
row = this.Handles.Experiment.SelectionTable.getSelectedRow + 1;

% Set the output table data
if hData.getValueIsAdjusting 
  return
end

if (row > 0)
  [table, indices] = getExperimentData(this, row);
else
  table   = matlab2java( {'No data set selected', '.', '.'} );
  indices = 1;
end

model = this.Handles.Experiment.DataTableModel;
model.setData(table, indices-1);
model.tableRowsUpdated( 0, java.lang.Integer.MAX_VALUE );

% ----------------------------------------------------------------------------- %
function LocalUpdateExperiments(this, hData, manager)
updateEstimationData(this, manager);
PrivateSelectionTableUpdate(this)

% ----------------------------------------------------------------------------- %
function list = PrivateGetListData(this)
% 1: transient, 2: steady-state, 3: frequency domain
type = this.ExperimentType;
list = struct2cell( this.ExperimentList{ type } )';

% ----------------------------------------------------------------------------- %
function PrivateSetListData(this, list)
% 1: transient, 2: steady-state, 3: frequency domain
type = this.ExperimentType;
for ct = 1:size(list,1);
  this.ExperimentList{type}(ct).Selected = list{ct,1};
end

% Set the dirty flag
this.setDirty

% ----------------------------------------------------------------------------- %
% Handle UDD -> JAVA changes
function PrivateSelectionTableUpdate(this)
list  = PrivateGetListData(this);
model = this.Handles.Experiment.SelectionTableModel;
model.setData(list);
model.tableRowsUpdated( 0, java.lang.Integer.MAX_VALUE );
