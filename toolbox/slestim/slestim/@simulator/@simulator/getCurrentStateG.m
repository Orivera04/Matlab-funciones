function x0 = getCurrentStateG(this, model, sL, sR)
% GETCURRENTSTATEG 

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.1 $ $Date: 2004/03/10 21:55:07 $

% Use the estimation model
Experiment = this.Experiment;

% State vector names from sizes call
[sys, x0, x0_str, ts, x0_ts] = feval(model, [], [], [], 'sizes');

% Set fixed states
for ct = 1:length(Experiment.InitialStates)
  sct = Experiment.InitialStates(ct);

  idx = find( sct.Block == '/', 1 );
  relpath = sct.Block(idx+1:end);

  % Left subsystem
  blk = sprintf( '%s/Left/%s', model, relpath );
  idxs = find( strcmp(x0_str, blk) );
  if ~isempty(sct.Data) && isempty(sct.Domain)
    x0(idxs) = sct.Data;
  end

  % Right subsystem
  blk = sprintf( '%s/Right/%s', model, relpath );
  idxs = find( strcmp(x0_str, blk) );
  if ~isempty(sct.Data) && isempty(sct.Domain)
    x0(idxs) = sct.Data;
  end
end

% Set estimated states
for ct = 1:length(this.States)
  sct = this.States(ct);
  
  idx = find( sct.Block == '/', 1 );
  relpath = sct.Block(idx+1:end);

  % Left subsystem
  blk = sprintf( '%s/Left/%s', model, relpath );
  idxs = find( strcmp(x0_str, blk) );
  estidxs = (sct.Estimated == true);
  x0(idxs(estidxs)) = sL(estidxs);

  % Right subsystem
  blk = sprintf( '%s/Right/%s', model, relpath );
  idxs = find( strcmp(x0_str, blk) );
  estidxs = (sct.Estimated == true);
  x0(idxs(estidxs)) = sR(estidxs);
end
