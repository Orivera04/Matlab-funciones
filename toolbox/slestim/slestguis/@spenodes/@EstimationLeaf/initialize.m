function initialize(this)
% INITIALIZE  Initialize the object after it has been connected to the
% tree hierarchy. Can traverse the tree at this point.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.14 $ $Date: 2004/04/19 01:33:03 $

parent = this.up;

% Add property listeners
L = [ handle.listener( parent,  'PropertyChange', @LocalEstimationChanged ); ...
      handle.listener( this,  this.findprop('Label'), ...
                       'PropertyPostSet', @LocalLabelChanged) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Initialize estimation data
LocalUpdate(this);

% ---------------------------------------------------------------------------- %
% Create new estimation
function LocalEstimationChanged(this, hEvent)
if strcmp( hEvent.propertyName, 'DATA_CHANGED' )
  LocalUpdate(this);
end

% ---------------------------------------------------------------------------- %
function LocalUpdate(this)
oldest = this.Estimation;
newest = this.up.Estimation;

if isempty( oldest )
  hData = find( this.getRoot, '-class', 'spenodes.TransientData' );
  
  this.Estimation = copy(newest);
  this.Estimation.Description = this.Label;
  this.Estimation.Experiment  = copy(hData.Experiment);
  this.Estimation.Parameters = [];
  this.Estimation.States = [];
else
  % Do nothing for now
end

% Optimization options form
if isempty(this.OptimOptions)
  this.OptimOptions = speforms.OptimOptionForm;
  this.OptimOptions.initialize( this.Estimation.OptimOptions );
end

% Simulation options form
if isempty(this.SimOptions)
  this.SimOptions   = speforms.SimOptionForm;
  this.SimOptions.initialize( this.Estimation.SimOptions );
end

% ---------------------------------------------------------------------------- %
function LocalLabelChanged(this, hData)
if ~isempty(this.Estimation)
  this.Estimation.Description = this.Label;
end
