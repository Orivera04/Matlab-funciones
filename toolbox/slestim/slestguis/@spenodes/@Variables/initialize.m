function initialize(this)
% INITIALIZE  Initialize the object after it has been connected to the
% tree hierarchy.  Can traverse the tree at this point.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/11 00:40:31 $

% Add property listeners
parent = this.getRoot;
L = [ handle.listener(parent, 'PropertyChange', @LocalModelChanged) ];
set(L, 'CallbackTarget', this);
this.addListeners(L);

% Initialize estimation variables
LocalUpdate(this);

% ---------------------------------------------------------------------------- %
% Create new parameter and states arrays from the model
function LocalModelChanged(this, hEvent)
if strcmp( hEvent.propertyName, 'MODEL_CHANGED' )
  LocalUpdate(this);
  
  % Send notification to listeners
  this.firePropertyChange('DATA_CHANGED');
end

% ---------------------------------------------------------------------------- %
function LocalUpdate(this)
try
  model = this.getRoot.Model;
  util  = slcontrol.Utilities;
  
  wb = waitbar( 0, 'Please wait while Simulink model is being examined.', ...
                'Name', 'Simulink Parameter Estimation');
  pause(0.2)
  
  waitbar(0.2, wb, 'Getting model parameters');
  LocalUpdateParameters(this, model, util)
  waitbar(0.4, wb);
  pause(0.2)
  
  waitbar(0.6, wb, 'Getting model states');
  LocalUpdateStates(this, model, util)
  waitbar(0.8, wb);
  pause(0.2)
  
  waitbar(1.0, wb, 'Completed.');
  close(wb);
catch
  close(wb)
  rethrow(lasterror)
end

% ---------------------------------------------------------------------------- %
function LocalUpdateParameters(this, model, util)
% Get tunable variables
TunableVars = getTunableParameters(util, model);

% Get list of all already used parameters
TunedVars = getTunedVarNames(util, this.Parameters);

% Locate tuned parameters in this list 
% RE: Cannot use INTERSECT because cases like foo.x, foo.y give rise to
% repeated names in TunedVars
[isDefined, idxLoc] = ismember( TunedVars, {TunableVars.Name} );

% Guard against deleted parameters
if any(~isDefined)
  warndlg( 'Some tuned parameters no longer exist in the model.', ...
           'Parameter Warning', 'modal' )
end

% Remove undefined parameters
this.Parameters = this.Parameters(isDefined);

% Reevaluate parameters: update value/reference
idxDef = find(isDefined);
pv = evalParameters( util, model, get(this.Parameters, {'Name'}) );
for ct = 1:length(idxDef)
  this.Parameters(ct).Value = mat2str( pv(ct).Value, 5 );
  this.Parameters(ct).ReferencedBy = TunableVars( idxLoc(idxDef(ct)) ).ReferencedBy;
end

% ---------------------------------------------------------------------------- %
function LocalUpdateStates(this, model, util)
% Get tunable states
TunableStates = getTunableStates(util, model);

% Get list of all already used states
TunedStates = get( this.States, {'Block'} );

% Locate tuned states in this list 
[isDefined, idxLoc] = ismember( TunedStates, {TunableStates.Block} );

% Guard against deleted parameters
if any(~isDefined)
  warndlg( 'Some states no longer exist in the model.', ...
           'State Warning', 'modal' )
end

% Remove undefined parameters
this.States = this.States(isDefined);

% Reevaluate states: update value
idxDef = find(isDefined);
pv = evalStates( util, model, get(this.States, {'Block'}) );
for ct = 1:length(idxDef)
  this.States(ct).Value = mat2str( pv(ct).Value, 5 );
  this.States(ct).Ts    = mat2str( pv(ct).Ts, 5 );
end
