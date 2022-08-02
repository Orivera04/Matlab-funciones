function setOutputData(this, value, row, col)
% SETOUTPUTDATA Update data object properties from output table

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:05 $

% Property names
columns  = { 'Block', 'Data', 'Time', 'Weight', 'Length' };
property = columns{col};

data = this.Experiment.OutputData;

% Indices for port name rows. 1-based indexing.
indices = data(1).indices(data);

% Get data objects for I/O ports
idx     = find(row > indices);
rowidx  = row - indices(idx(end));
obj     = data(length(idx));

% Set table data
if (col ~= 3)
  obj.(property){rowidx} = value;
else
  % Time entries are unique per port
  obj.(property) = value;
end

% Set the dirty flag
this.setDirty
