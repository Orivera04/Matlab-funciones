function initialize(this)
% INITIALIZE  Initialize the object after it has been connected to the
% tree hierarchy.  Can traverse the tree at this point.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:39:40 $

parent = find(this.getRoot, '-class', 'spenodes.SteadyStateData');

% Add property listeners
L = [ handle.listener(parent, 'PropertyChange', @LocalIosDataChanged) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Initialize experiment data
LocalUpdate(this);

% ---------------------------------------------------------------------------- %
% Create a new I/O data array from the model
function LocalIosDataChanged(this, hEvent)
if strcmp( hEvent.propertyName, 'DATA_CHANGED' )
  LocalUpdate(this);
end

% ---------------------------------------------------------------------------- %
function LocalUpdate(this)
parent  = find(this.getRoot, '-class', 'spenodes.SteadyStateData');
hExp    = parent.Experiment;

newexp = ParameterEstimatorData.SteadyStateExperiment( hExp );
oldexp = this.Experiment;

if isempty( oldexp )
  this.Experiment = newexp;
else
  this.Experiment = mergedata( oldexp, newexp );
end
