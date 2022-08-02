function rows = indices(this, dataset)
% INDICES Row index of state names in the states table
%
% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:38:20 $

rows = [];
idx  = 1;

for ct = 1:length(dataset)
  rows = [rows; idx];
  idx  = idx + 1 + length( dataset(ct).Estimated );
end
