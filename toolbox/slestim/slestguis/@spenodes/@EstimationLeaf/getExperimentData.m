function [table, indices] = getExperimentData(this, selected)
% GETEXPERIMENTDATA Construct data table from selected experiment

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:38:47 $

% 1: transient, 2: steady-state, 3: frequency-domain
type  = this.ExperimentType;
outdata = this.Experiments{type}(selected).OutputData;

% Return if no data
if isempty(outdata)
  indices = 1;
  data    = { 'The model has no outputs', '.', '.' };
  table   = matlab2java(data);
  return;
end

% Indices for port name rows. 1-based indexing.
indices = outdata(1).indices(outdata);

% Construct data table
ct = 1;
for m = 1:length(outdata)
  current = outdata(m);
  data(ct,:) = { regexprep(current.Block, '\n\r?', ' '), '.', '.' };
  ct = ct + 1;
  
  for n = 1:prod(current.Dimensions)
    data(ct,:) = { sprintf('  Channel - %d', n), ...
                   current.Length{n}, ...
                   current.Weight{n} };
    ct = ct + 1;
  end
end

table = matlab2java(data);
