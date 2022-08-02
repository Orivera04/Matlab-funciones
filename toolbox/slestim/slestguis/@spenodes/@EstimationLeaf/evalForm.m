function evalForm(this)
% EVALFORM Evaluates literal objects to create a numerical estimation object

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/19 01:33:02 $

% Estimation type
type = this.ExperimentType;
idxs = [ this.ExperimentList{type}.Selected ];

% Forms
SelectedExperiments = this.Experiments{type}(idxs);
AllStates      = this.States{type};
AllParameters  = this.Parameters;
if ~isempty(AllStates)
  SelectedStates = AllStates(:, idxs);
else
  SelectedStates = [];
end

% Experiments
% Get experiment of the selected type
classes = { 'spenodes.TransientData'; ...
            'spenodes.SteadyStateData'; ...
            'spenodes.FrequencyData' };
node = find( this.getRoot, '-class', classes{type} );

% Evaluate experiments
experiments = [];
for ct = 1:length(SelectedExperiments)
  experiments = [ experiments; ...
                  evalForm( SelectedExperiments(ct), copy(node.Experiment) ) ];
  experiments(end).Description = SelectedExperiments(ct).Description;
end

% Get list of variable names in model workspace
ModelWS = get_param(this.Estimation.Model, 'ModelWorkspace');
s = whos(ModelWS);
ModelWSVars = {s.name};

% Evaluate parameters
parameters = [];
for ct = 1:length(AllParameters)
  parameters = [ parameters; ...
                 evalForm( AllParameters(ct), ModelWS, ModelWSVars ) ];
end

% Evaluate states
states = [];
for ct = 1:length( SelectedStates(:) )
  states = [ states; ...
             evalForm( SelectedStates(ct), ModelWS, ModelWSVars ) ];
end
states = reshape( states, size(SelectedStates) );

% Evaluate simulation & optimization settings
simopts = evalForm(this.OptimOptions, ModelWS, ModelWSVars );
optopts = evalForm(this.SimOptions,   ModelWS, ModelWSVars );

% Configure estimation
hEst = this.Estimation;
hEst.Experiment   = experiments;
hEst.Parameters   = parameters;
hEst.States       = states;
hEst.OptimOptions = simopts;
hEst.SimOptions   = optopts;
