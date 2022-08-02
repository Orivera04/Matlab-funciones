function setModelData(this)
% SETMODELDATA Update the model data from the view settings

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:38:10 $

% Get the Java handles
Handles = this.Handles;

% Get selected rows
selection = Handles.ImportTable.getSelectedRows + 1;

util  = slcontrol.Utilities;
model = this.Node.getRoot.Model;

TunableStates = this.TunableStates;
TunableStateNames = {TunableStates.Block};
States = this.Node.States;

% Get selected states
TunedStates = get( this.Node.States, {'Block'} );
NewStates = setdiff( TunableStateNames, TunedStates );

if all( selection > 0 )
  NewStates = NewStates(selection);

  % Evaluate new states
  pv = evalStates( util, model, NewStates );
  
  % Add states
  for ct = 1:length(NewStates)
    block  = pv(ct).Block;
    value  = pv(ct).Value;
    
    hPar = ParameterEstimator.State(block, value);
    hPar.Ts = pv(ct).Ts;
    
    States = [ States; speforms.StateForm(hPar) ];
  end
end

% Sort by state name
[dummy, idxs]  = sort( get(States, {'Block'}) );
this.Node.States = States( idxs );
