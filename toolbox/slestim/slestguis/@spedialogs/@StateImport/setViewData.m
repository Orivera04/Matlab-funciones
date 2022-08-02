function setViewData(this)
% SETVIEWDATA Update the view data from the model settings

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:11 $

% Get the handles
Handles = this.Handles;
model   = Handles.ImportTable.getModel;

% Update table
table = LocalCreateTable(this);
model.setData( table );
model.tableRowsUpdated( 0, java.lang.Integer.MAX_VALUE );

% -----------------------------------------------------------------------------
function table = LocalCreateTable( this )
util  = slcontrol.Utilities;
model = this.Node.getRoot.Model;

% Get tunable states
TunableStates = this.TunableStates;

% Get current list of tuned states
TunedStates = get( this.Node.States, {'Block'} );

% Unselected states
NewStates = setdiff( {TunableStates.Block}, TunedStates );

% All states already selected
if isempty(NewStates)
  table = {};
  return;
end

np = length(NewStates);
table = cell(np,2);

% Set state names
table(:,1) = regexprep(NewStates, '\n\r?', ' ');

% Set state sizes
pv = evalStates( util, model, NewStates );
for ct = 1:np
  value = pv(ct).Value;
  sizes = int2str( prod( size(value) ) );
  table{ct,2} = sizes;
end

table = matlab2java(table);
