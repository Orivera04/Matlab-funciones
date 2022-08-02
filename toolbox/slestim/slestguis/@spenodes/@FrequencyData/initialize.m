function initialize(this)
% INITIALIZE Initialize the object after it has been connected to the
% tree hierarchy.  Can traverse the tree at this point.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:39:09 $

parent = this.getRoot;

% Add property listeners
L = [ handle.listener(parent, 'PropertyChange', @LocalModelChanged) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Initialize experiment data
LocalUpdate(this);

% ---------------------------------------------------------------------------- %
% Create new experiment and states arrays from the model
function LocalModelChanged(this, hEvent)
if strcmp( hEvent.propertyName, 'MODEL_CHANGED' )
  LocalUpdate(this);
  
  % Send notification to FrequencyDataLeaf UDD objects.
  this.firePropertyChange('DATA_CHANGED');
end

% ---------------------------------------------------------------------------- %
function LocalUpdate(this)
try
  model = this.getRoot.Model;
  
  wb = waitbar(0, 'Compiling model...', 'Name', 'Simulink Parameter Estimation');
  pause(0.2)
  waitbar(0.1, wb, 'Please wait while Simulink model is being compiled.');
  pause(0.2)
  waitbar(0.2, wb);
  pause(0.2)
  
  if isempty(this.Experiment)
    % Create experiment
    this.Experiment = ParameterEstimator.FrequencyExperiment( model );
  else
    % Update experiment
    this.Experiment.update;
  end
  
  waitbar(1.0, wb, 'Compilation complete.');
  pause(0.2)
  close(wb);
catch
  close(wb)
  rethrow(lasterror)
end
