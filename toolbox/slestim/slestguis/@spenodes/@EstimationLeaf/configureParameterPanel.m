function configureParameterPanel(this, ParameterPanel, manager)
% CONFIGUREPARAMETERPANEL 

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/19 01:33:00 $

% Ancestor added listener
L = [ handle.listener( handle(ParameterPanel), ...
                       'AncestorAdded', { @LocalUpdateParameters, manager } ) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Init button callback
h = handle( ParameterPanel.getInitButton, 'callbackproperties' );
h.ActionPerformedCallback = {@LocalInitButton, this };

% Reset button callback
h = handle( ParameterPanel.getResetButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalResetButton, this };

% Save button callback
h = handle( ParameterPanel.getSaveButton, 'callbackproperties' );
h.ActionPerformedCallback = { @LocalSaveButton, this };

% Callback to parameter data table event.
Handles.Table      = ParameterPanel.getParameterTable;
Handles.TableModel = ParameterPanel.getParameterTable.getModel;
h = handle( Handles.TableModel, 'callbackproperties' );
h.TableChangedCallback = { @LocalTableChanged, this };

% Store the handles
this.Handles.Parameter = Handles;

% ---------------------------------------------------------------------------- %
function LocalInitButton(hSrc, hData, this)
rows = this.Handles.Parameter.Table.getSelectedRows + 1;

% Initialize from best value
data = this.Parameters(rows);
for ct = 1:length(data)
  data(ct).InitialGuess = data(ct).Value;
end

% Update table
PrivateTableUpdate(this)
model = this.Handles.Parameter.TableModel;
model.tableRowsUpdated( rows(1) - 1 , rows(end) - 1 )

% ---------------------------------------------------------------------------- %
function LocalResetButton(hSrc, hData, this)
rows = this.Handles.Parameter.Table.getSelectedRows + 1;

% Get parameter objects
source = find(this.getRoot, '-class', 'spenodes.Variables');

% Update parameters & keep Estimated status
newdata = source.Parameters(rows);
selection = get(this.Parameters(rows), {'Estimated'});
this.Parameters(rows) = copy(newdata);
set(this.Parameters(rows), {'Estimated'}, selection);

% Update table
PrivateTableUpdate(this)
model = this.Handles.Parameter.TableModel;
model.tableRowsUpdated( rows(1) - 1 , rows(end) - 1 )

% ---------------------------------------------------------------------------- %
function LocalSaveButton(hSrc, hData, this)
rows = this.Handles.Parameter.Table.getSelectedRows + 1;

% Get parameter objects
source = find(this.getRoot, '-class', 'spenodes.Variables');

% Update parameters
newdata = this.Parameters(rows);
source.Parameters(rows) = copy(newdata);
set(source.Parameters(rows), 'Estimated', 'false')

% ----------------------------------------------------------------------------- %
function LocalTableChanged(hSrc, hData, this)
row = hData.getFirstRow + 1;
col = hData.getColumn   + 1;

% React only to fireTableCellUpdated(row, col);
if (col > 0)
  model = hData.getSource;
  value = model.getValueAt(row - 1, col - 1);
  this.setParameterData( value, row, col );
  
  % Update row for editable & enabled state changes
  model.tableRowsUpdated( row - 1, row - 1 )
end

% ----------------------------------------------------------------------------- %
function LocalUpdateParameters(this, hData, manager)
updateEstimationData(this, manager);

% Update table
PrivateTableUpdate(this)
model = this.Handles.Parameter.TableModel;
model.tableRowsUpdated(0, java.lang.Integer.MAX_VALUE)

% ----------------------------------------------------------------------------- %
% Handle UDD -> JAVA changes
function PrivateTableUpdate(this)
table = getParameterData(this);
model = this.Handles.Parameter.TableModel;
model.setData(table);
