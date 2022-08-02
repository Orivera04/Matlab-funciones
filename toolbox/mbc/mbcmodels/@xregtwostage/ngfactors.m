function n= ngfactors(TS)
%XREGTWOSTAGE/NGFACTORS number of global factors
%
%  n= ngfactors(TS)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.3.4.2 $  $Date: 2004/02/09 08:00:02 $

n= nfactors(TS)-nfactors(TS.Local);