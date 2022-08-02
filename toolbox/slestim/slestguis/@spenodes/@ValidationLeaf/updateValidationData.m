function updateValidationData(this, manager)
% UPDATEVALIDATIONDATA 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/19 01:33:08 $

% Task node
tasknode = this.getRoot;

% Initialize experiments if they already aren't
classes = { 'spenodes.TransientData'; ...
            'spenodes.SteadyStateData'; ...
            'spenodes.FrequencyData' };
for ct = 1:length(classes)
  % Experiment parent nodes
  node = find( tasknode, '-class', classes{ct} );
  PrivateSetEstimationData(node, manager);
  
  % Experiment leaf nodes
  leaves = find( node, '-class', [classes{ct}, 'Leaf'] );
  PrivateSetEstimationData(leaves, manager);
  
  % typeidx:  1: transient, 2: steady-state, 3: frequency domain
  this.ExperimentList{ct} = get( leaves, {'Label'} );
end

% Initialize estimations if they already aren't
h = find(tasknode, '-class', 'spenodes.EstimationLeaf');
for ct = 1:length(h)
  if isempty( h(ct).Estimation )
    h(ct).getDialogInterface( manager );
  end
end

% ---------------------------------------------------------------------------- %
function PrivateSetEstimationData(h, manager)
% Initialize experiments if they already aren't
for ct = 1:length(h)
  if isempty( h(ct).Experiment )
    h(ct).getDialogInterface( manager );
  end
end
