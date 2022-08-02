function out = getunits(em)
% ExportModel\getunits
% U = getunits(E)
%   Units is a column cell array of strings
%   The first element of units is the output units and hence
%   units has length numfactors+1 (or be empty if there are no units)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:29 $
out = em.units;