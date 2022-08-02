function updateEstimationData(this, manager)
% UPDATEESTIMATIONDATA 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/19 01:33:04 $

% typeidx:  1: transient, 2: steady-state, 3: frequency domain
h = find( this.getRoot, '-class', 'spenodes.TransientDataLeaf' );
PrivateSetEstimationData(this, 1, h, manager);

h = find( this.getRoot, '-class', 'spenodes.SteadyStateDataLeaf' );
PrivateSetEstimationData(this, 2, h, manager);

h = find( this.getRoot, '-class', 'spenodes.FrequencyDataLeaf' );
PrivateSetEstimationData(this, 3, h, manager);

PrivateSetParameters(this, manager);

% ---------------------------------------------------------------------------- %
% Create experiment data from parent's data
function PrivateSetEstimationData(this, typeidx, h, manager)
olddata   = this.ExperimentList{typeidx};
oldstates = this.States{typeidx};
oldexpers = this.Experiments{typeidx};

% Initialize experiments if they already aren't
newexpers = [];
for ct = 1:length(h)
  if isempty( h(ct).Experiment )
    h(ct).getDialogInterface( manager );
  end
  % REM: May need copy(...) instead of directly accessing the original object.
  newexpers = [newexpers; h(ct).Experiment];
end

% New experiment vector
newdatanames = get( h, {'Label'} );
newdata = struct( 'Selected', false, 'Name', newdatanames );

% Form the new states matrix: one set of states per experiment.
source = find(this.getRoot, '-class', 'spenodes.Variables');
newstates = repmat(source.States, 1, length(newdata) );
if ~isempty(newstates)
  % Reshape since copy returns a handle vector
  newstates = reshape( copy(newstates), [], length(newdata));
end

% Keep selection state for old experiments
if ~isempty(olddata)
  olddatanames = { olddata.Name }';

  % Keep selection state of old experiments
  [dummy, inew, iold] = intersect( newdatanames, olddatanames );
  for ct = 1:length(inew)
    newdata(inew(ct)).Selected = olddata(iold(ct)).Selected;
    
    if ~isempty( oldstates )
      newstates(:,inew(ct)) = mergedata( oldstates(:,iold(ct)), ...
                                         newstates(:,inew(ct)) );
    end
  end
end

this.ExperimentList{typeidx} = newdata;
this.Experiments{typeidx}    = newexpers;
this.States{typeidx}         = newstates;

% ---------------------------------------------------------------------------- %
% Create parameter form objects
function PrivateSetParameters(this, manager)
source = find(this.getRoot, '-class', 'spenodes.Variables');

% Update parameters
newpars = source.Parameters;
oldpars = this.Parameters;
  
% Update or merge
if isempty(oldpars) && ~isempty(newpars)
  this.Parameters = copy(newpars);
elseif isempty(newpars)
  this.Parameters = [];
else
  this.Parameters = mergedata( oldpars, copy(newpars) );
end
