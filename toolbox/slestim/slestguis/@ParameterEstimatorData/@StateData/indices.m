function rows = indices(this, dataset)
% INDICES Row index of state names in the states data table
%
% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:37:42 $

rows = [];
idx  = 1;

for ct = 1:length(dataset)
  rows = [rows; idx];
  idx  = idx + 1 + prod( dataset(ct).Dimensions );
end
