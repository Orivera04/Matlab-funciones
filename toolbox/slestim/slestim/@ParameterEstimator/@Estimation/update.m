function update(this, varargin)
% UPDATE Re-initialize the properties
%
% Requires valid Model.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:42:24 $

% Update parameters & states.
this.Parameters = LocalUpdateParameters( this.Parameters, this );
this.States     = LocalUpdateStates( this.States, this );

% Set properties
set( this, varargin{:} );

% ----------------------------------------------------------------------------- %
function hData = LocalUpdateParameters(hData, this)
util = slcontrol.Utilities;
% Get tunable variables
TunablePars = getTunableParameters(util, this.Model);

% Get list of all already used parameters
TunedVars = getTunedVarNames(util, hData);

% Locate tuned parameters in this list 
% RE: Cannot use INTERSECT because cases like foo.x, foo.y give rise to
% repeated names in TunedVars
[isDefined, idxLoc] = ismember( TunedVars, {TunablePars.Name} );

% Remove undefined parameters
hData = hData(isDefined);

% Reevaluate parameters: update value/reference
idxDef = find(isDefined);
pv = evalParameters( util, this.Model, get(hData, {'Name'}) );
for ct = 1:length(idxDef)
  value  = pv(ct).Value;
  blocks = TunablePars( idxLoc(idxDef(ct)) ).ReferencedBy;
  hData(ct).update(value, 'ReferencedBy', blocks);
end

% New parameters: add only tunable variables with double value
TunableDoubles = TunablePars( strcmp({TunablePars.Type}, 'double') );
[NewPars, idxN] = setdiff( {TunableDoubles.Name}, get(hData, {'Name'}) );

% Create data objects for the new parameters
pv = evalParameters( util, this.Model, NewPars );
for ct = 1:length(idxN)
  name   = pv(ct).Name;
  value  = pv(ct).Value;
  blocks = TunableDoubles(idxN(ct)).ReferencedBy;
  
  hData = [ hData ; ParameterEstimator.Parameter( name, value ) ];
  hData(end).ReferencedBy = blocks;
end

% Sort by parameter name
[dummy, idxs]  = sort( get(hData, {'Name'}) );
hData = hData( idxs );

% ----------------------------------------------------------------------------- %
function hData = LocalUpdateStates(hData, this)
% Get the unique names of the current blocks with states
util = slcontrol.Utilities;
AllStates = getTunableStates(util, this.Model);
AllVals   = evalStates(util, this.Model, {AllStates.Block});
idxN = 1:length(AllStates);

% Check to see if state objects need to be removed or added
if ~isempty(hData)
  % Get the names of the old blocks with states
  oldStates = get( hData, {'Block'} );
  
  % Find the intersection of the new and old blocks with states
  [dummy, inew, iold] = intersect({AllVals.Block}, oldStates);
  
  % Find the state objects that should remain
  hData  = hData(iold);
  
  % Indices of new blocks with states that needs to be added to the list
  idxN = setxor( idxN, inew );
end

% Update the old state objects
for ct = 1:length(hData)
  block = hData(ct).Block;
  idx   = find( strcmp(block, {AllVals.Block}) );
 
  hData(ct).update( AllVals(idx).Value, ...
                    'Ts',     AllVals(idx).Ts, ...
                    'Domain', AllStates(idx).Domain );
end

% Create the state objects for the new blocks with states.
for ct = 1:length(idxN)
  idx = idxN(ct);
  block  = AllVals(idx).Block;
  value  = AllVals(idx).Value;
  
  hData = [ hData ; ParameterEstimator.State( block, value ) ];
  hData(end).Ts = AllVals(idx).Ts;
end

% Sort by block name
[dummy, idxs] = sort( get(hData, {'Block'}) );
hData = hData( idxs );
