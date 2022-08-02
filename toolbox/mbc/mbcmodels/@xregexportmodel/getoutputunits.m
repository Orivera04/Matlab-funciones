function out = getoutputunits(em)
% ExportModel\getoutputunits
% U = getoutputunits(E)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:26 $

if isempty(em.units)
    out = [];
else
    out = em.units{1};
end