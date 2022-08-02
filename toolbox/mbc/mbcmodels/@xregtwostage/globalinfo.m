function xi= globalinfo(TS)
% GLOBALINFO

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 07:59:41 $

xi= xinfo(TS);
nl= nfactors(TS.Local);
xi.Names(1:nl)=[];
xi.Symbols(1:nl)=[];
xi.Units(1:nl)=[];