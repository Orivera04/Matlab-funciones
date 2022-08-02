function configurePlotsPanel(this, PlotsPanel, manager)
% CONFIGUREPLOTSPANEL 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/19 01:33:05 $

% Ancestor added listener
L = [ handle.listener( handle(PlotsPanel), ...
                       'AncestorAdded', { @LocalUpdatePanel, manager } ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Plots table model events
Handles.PlotsTableModel = PlotsPanel.getPlotsTable.getModel;
h = handle( Handles.PlotsTableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalPlotsTableChanged, this };

% Options table model events
Handles.OptionsTable      = PlotsPanel.getOptionsTable;
Handles.OptionsTableModel = PlotsPanel.getOptionsTable.getModel;
h = handle( Handles.OptionsTableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalOptionsTableChanged, this };

% Show plots button callback
h = handle( PlotsPanel.getShowButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalShowCallback, this };

% Callback to combo box event.
Handles.DataSetCombo = PlotsPanel.getDataSetCombo;
h = handle( Handles.DataSetCombo, 'callbackproperties' ); 
h.ActionPerformedCallback = { @LocalDataSetChanged, this, manager };

% Store the java handles
this.Handles = Handles;

% ---------------------------------------------------------------------------- %
% Selected experiment changed
function LocalDataSetChanged(hSrc, hData, this, manager)
% Return if no data set to select
row = hData.getSource.getSelectedIndex + 1;
if row <= 0
  return
end

type = this.ExperimentType;
name = this.ExperimentList{type}{row};

% Get experiment of the selected type
classes = { 'spenodes.TransientDataLeaf'; ...
            'spenodes.SteadyStateDataLeaf'; ...
            'spenodes.FrequencyDataLeaf' };
node = find( this.getRoot, '-class', classes{type}, 'Label', name );

% Evaluate numerical experiment object
if isempty(this.Experiment) || ~strcmp(this.Experiment.Description, name) 
  this.Experiment = evalForm( node.Experiment, copy(node.up.Experiment) );
  this.Experiment.Description = name;
  setActivePlots(this);
end

% ----------------------------------------------------------------------------- %
% Show all figures with a valid plot type
function LocalShowCallback(hSrc, hData, this)
plotTypes = this.Fields.Plots(:,2);
plotVis   = ~strcmp( plotTypes, '(none)' );
figures   = this.Views(plotVis);
set( figures, 'Visible', 'on' )

% ----------------------------------------------------------------------------- %
function LocalPlotsTableChanged(hSrc, hData, this)
row = hData.getFirstRow + 1;
col = hData.getColumn   + 1;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  % Cell changed
  model = hData.getSource;
  value = model.getValueAt(row - 1, col - 1);
  this.setPlotsData( value, row, col );
end

% Update options table column visibility.  First column always visible.
visibility = [ true; ~strcmp( this.Fields.Plots(:,2), '(none)' ) ];
this.Handles.OptionsTable.setVisibleColumns( visibility );

% Uncheck all cells of invisible options table columns
this.Fields.Options(:, ~visibility) = {false};
table = getOptionsData(this);
model = this.Handles.OptionsTableModel;
model.setData(table);

% Update figures
setActiveFigures(this)

if (col > 0)
  % Update the plots in each figure
  setActivePlots(this)
end

% ---------------------------------------------------------------------------- %
function LocalOptionsTableChanged(hSrc, hData, this)
row = hData.getFirstRow + 1;
col = hData.getColumn   + 1;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  % Cell changed
  model = hData.getSource;
  value = model.getValueAt(row - 1, col - 1);
  this.setOptionsData( value, row, col );

  % Update plots
  setActivePlots(this)
end

% ---------------------------------------------------------------------------- %
function LocalUpdatePanel(this, hData, manager)
% Initialize Estimation and Experiment list
updateValidationData(this, manager);
estims = find(this.getRoot, '-class', 'spenodes.EstimationLeaf');

% Clear checkboxes if estimation nodes has been modified.
nr = length(estims);
options = this.Fields.Options;
rowdata = cell( nr, 1+ size(this.Fields.Plots,1) );
for ct = 1:nr
  ect = estims(ct);
  
  if (size(options,1) >= ct) && strcmp(options{ct,1}, ect.Label)
    rowdata(ct,:) = options(ct,:);
  else
    rowdata(ct,:) = {ect.Label, false,false,false,false,false,false};
  end
end

this.Fields.Options = rowdata;
PrivateTableUpdates(this);
PrivateComboUpdates(this);

% ----------------------------------------------------------------------------- %
function PrivateTableUpdates(this)
% Set the plots table data
table = getPlotsData(this);
model = this.Handles.PlotsTableModel;
model.setData(table);
model.tableRowsUpdated( 0, java.lang.Integer.MAX_VALUE);

% Set the options table data
table = getOptionsData(this);
model = this.Handles.OptionsTableModel;
model.setData(table);
model.tableRowsUpdated( 0, java.lang.Integer.MAX_VALUE);

% ----------------------------------------------------------------------------- %
function PrivateComboUpdates(this)
combo = this.Handles.DataSetCombo;

% 1: transient, 2: steady-state, 3: frequency domain
type  = this.ExperimentType;
names = this.ExperimentList{type};
selected = combo.getSelectedItem;
idx = find( strcmp( names, selected ) );

combo.setData(names);
drawnow;

% Reselect the same item
if ~isempty(idx)
  awtinvoke( combo, 'setSelectedIndex', idx-1 );
else
  % Initialize figures & plots for the first time
  % Needed to redraw saved plots
  setActivePlots(this);
end
