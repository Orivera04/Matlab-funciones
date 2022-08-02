function setViewData(this)
% SETVIEWDATA Update the view data from the model settings

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:05 $

% Get the handles
Handles = this.Handles;
model   = Handles.ImportTable.getModel;

% Update table
table = LocalCreateTable(this);
model.setData( table );
model.tableRowsUpdated( 0, java.lang.Integer.MAX_VALUE );

% Clear text field
awtinvoke( Handles.ImportField, 'setText', []);

% -----------------------------------------------------------------------------
function table = LocalCreateTable( this )
util  = slcontrol.Utilities;
model = this.Node.getRoot.Model;

% Get tunable variables
TunableVars = this.TunableVars;

% Get current list of tuned variables
TunedVars = getTunedVarNames(util, this.Node.Parameters);

% Unselected parameters (only tunable variables with double value)
TunableDoubles = TunableVars( strcmp( {TunableVars.Type}, 'double' ) );
NewPars = setdiff( {TunableDoubles.Name}, TunedVars );

% All parameters already selected
if isempty(NewPars)
  table = {};
  return;
end

np = length(NewPars);
table = cell(np,2);

% Set parameter names
table(:,1) = regexprep(NewPars, '\n\r?', ' ');

% Set parameter sizes
pv = evalParameters( util, model, NewPars );
for ct = 1:np
  value = pv(ct).Value;
  sizes = regexprep( num2str(size(value)), ' *', 'x' );
  table{ct,2} = sizes;
end

table = matlab2java(table);
