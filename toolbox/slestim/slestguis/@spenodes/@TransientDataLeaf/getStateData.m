function [table, indices] = getStateData(this)
% GETSTATEDATA Construct state table from data object properties
%
% The output TABLE has two parts: TABLE(1): data
%                                 TABLE(2): indices

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:00 $

icdata = this.Experiment.InitialStates;

% Return if no data
if isempty(icdata)
  indices = 1;
  data    = { 'The model has no states', '.', '.' };
  table   = matlab2java(data);
  return;
end

% Indices for port name rows. 1-based indexing.
indices = icdata(1).indices(icdata);

% Construct data table
ct = 1;
for m = 1:length(icdata)
  current = icdata(m);
  data(ct,:) = { regexprep(current.Block, '\n\r?', ' '), '.', '.' };
  ct = ct + 1;
  
  for n = 1:prod(current.Dimensions)
    data(ct,:) = { sprintf('  State - %d', n), ...
                   current.Ts, ...
                   current.Data{n} };
    ct = ct + 1;
  end
end

table = matlab2java(data);
