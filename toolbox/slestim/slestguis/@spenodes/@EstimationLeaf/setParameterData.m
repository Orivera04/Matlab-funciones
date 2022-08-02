function setParameterData(this, value, row, col)
% SETPARAMETERDATA Update data object properties from parameter table

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:38:55 $

% Property names
columns  = { 'Name', 'Value', 'Estimated', 'InitialGuess', ...
             'Minimum', 'Maximum', 'TypicalValue' };
property = columns{col};

obj = this.Parameters(row);

% Set table data
if strcmp(property, 'Estimated')
  value = mat2str(value);
end
obj.(property) = value;

% Set the dirty flag
this.setDirty
