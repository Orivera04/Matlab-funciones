function setParameterData(this, row, info)
% SETPARAMETERDATA Update data object properties from parameter table

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:33 $

% Property names
columns = { 'Value', 'InitialGuess', 'Minimum', 'Maximum', 'TypicalValue' };

data = this.Parameters(row);

for col = 1:length(columns)
  property = columns{col};
  data.(property) = info{col};
end

% Set the dirty flag
this.setDirty
