function em = setsymbols(em , s)
% ExportModel/setsymbols
%	E = setname(E,'namestr')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:49 $
if ~iscell(s)
   error('ExportModel\setsymbols: Expects a character array argument')
else
   em.symbols = s;
end
