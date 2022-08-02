function initialize(this)
% INITIALIZE  Initialize the object after it has been connected to the
% tree hierarchy. Can traverse the tree at this point.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/16 22:20:36 $

parent = find(this.getRoot, '-class', 'spenodes.TransientData');

% Add property listeners
L = [ handle.listener( parent, 'PropertyChange', @LocalIosDataChanged ); ...
      handle.listener( this,  this.findprop('Label'), ...
                       'PropertyPostSet', @LocalLabelChanged) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Initialize experiment data
LocalUpdate(this);

% ---------------------------------------------------------------------------- %
% Create new I/O data array from the model
function LocalIosDataChanged(this, hEvent)
if strcmp( hEvent.propertyName, 'DATA_CHANGED' )
  LocalUpdate(this);
end

% ---------------------------------------------------------------------------- %
function LocalUpdate(this)
parent  = find(this.getRoot, '-class', 'spenodes.TransientData');
hExp    = parent.Experiment;

newexp = ParameterEstimatorData.TransientExperiment( hExp );
oldexp = this.Experiment;

if isempty( oldexp )
  this.Experiment = newexp;
  this.Experiment.Description = this.Label;
else
  this.Experiment = mergedata( oldexp, newexp );
end

% ---------------------------------------------------------------------------- %
function LocalLabelChanged(this, hData)
if ~isempty(this.Experiment)
  this.Experiment.Description = this.Label;
end
