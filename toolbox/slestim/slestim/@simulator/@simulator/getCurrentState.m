function x0 = getCurrentState(this)
% GETCURRENTSTATE 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/03/10 21:55:06 $

% Use the estimation model
Experiment = this.Experiment;
model      = Experiment.Model;

% State vector names from sizes call
[sys, x0, x0_str, ts, x0_ts] = feval(model, [], [], [], 'sizes');

% Set fixed states
for ct = 1:length(Experiment.InitialStates)
  sct = Experiment.InitialStates(ct);
  idxs = find( strcmp(x0_str, sct.Block) );
  if ~isempty(sct.Data) && isempty(sct.Domain)
    x0(idxs) = sct.Data;
  end
end

% Set estimated states
for ct = 1:length(this.States)
  sct = this.States(ct);
  idxs = find( strcmp(x0_str, sct.Block) );
  estidxs = (sct.Estimated == true);
  x0(idxs(estidxs)) = sct.Value(estidxs);
end
