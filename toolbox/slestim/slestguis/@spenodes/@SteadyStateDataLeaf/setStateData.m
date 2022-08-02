function setStateData(this, value, row, col)
% SETSTATEDATA Update data object properties from state table

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:39:44 $

% Property names
columns  = { 'Block', 'Ts', 'Data' };
property = columns{col};

data = this.Experiment.StateData;

% Indices for port name rows. 1-based indexing.
indices = data(1).indices(data);

% Get data objects for I/O ports
idx     = find(row > indices);
rowidx  = row - indices(idx(end));
obj     = data(length(idx));

% Set table data
obj.(property){rowidx} = value;

% Set the dirty flag
this.setDirty
