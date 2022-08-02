function setStateData(this, row, info)
% SETSTATEDATA Update data object properties from state table

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $ $Date: 2004/04/11 00:40:34 $

% Property names
columns = { 'Value', 'InitialGuess', 'Minimum', 'Maximum', 'TypicalValue', 'Ts' };

data = this.States(row);

for col = 1:length(columns)
  property = columns{col};
  data.(property) = info{col};
end

% Set the dirty flag
this.setDirty
