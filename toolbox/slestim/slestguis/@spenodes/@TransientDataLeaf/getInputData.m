function [table, indices]  = getInputData(this)
% GETINPUTDATA Construct input table from data object properties
%
% The output TABLE has two parts: TABLE(1): data
%                                 TABLE(2): indices

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:39:57 $

indata = this.Experiment.InputData;

% Return if no data
if isempty(indata)
  indices = 1;
  data    = { 'The model has no inputs', '.', '.', '.', '.' };
  table   = matlab2java(data);
  return;
end

% Indices for port name rows. 1-based indexing.
indices = indata(1).indices(indata);

% Construct data table
ct = 1;
for m = 1:length(indata)
  current = indata(m);
  data(ct,:) = { regexprep(current.Block, '\n\r?', ' '), '.', '.', '.', '.' };
  ct = ct + 1;
  
  for n = 1:prod(current.Dimensions)
    data(ct,:) = { sprintf('  Channel - %d', n), ...
                   current.Data{n}, ...
                   current.Time, ...
                   current.Weight{n}, ...
                   current.Length{n} };
    ct = ct + 1;
  end
end

table = matlab2java(data);
