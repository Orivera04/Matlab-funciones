function Simulators = getSimulators(this)
% Get simulator objects for the current set of experiments

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/04 03:41:52 $

if ~isempty(this.Simulators)
  SimExps = get(this.Simulators, {'Experiment'});
  if isequal(this.Experiments, [SimExps{:}]')
    Simulators = this.Simulators;
    return
  end
end

Simulators = [];
for ct = 1:length( this.Experiments )
  Experiment = this.Experiments(ct);
  
  if size(this.States, 2) > 1
    States = this.States(:,ct);
  else
    States = this.States;
  end
  
  Simulators = [ Simulators; ...
                 simulator.simulator(Experiment, States, this.SimOptions) ];
end
