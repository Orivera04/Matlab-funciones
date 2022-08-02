function setStateData(this, value, row, col, selected)
% SETSTATEDATA Update data object properties from state table

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.7 $ $Date: 2004/04/11 00:38:57 $

% Property names
columns  = { 'Block', 'Value',  'Estimated', 'InitialGuess', ...
             'Minimum', 'Maximum', 'TypicalValue' };
property = columns{col};

% 1: transient, 2: steady-state, 3: frequency-domain
type = this.ExperimentType;
data = this.States{type}(:,selected);
obj  = data(row);

% Set table data
if strcmp(property, 'Estimated')
  value = mat2str(value);
end
obj.(property) = value;

% Set the dirty flag
this.setDirty
