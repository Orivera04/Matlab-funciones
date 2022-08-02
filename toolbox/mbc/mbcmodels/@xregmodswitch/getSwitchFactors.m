function factIdx = getSwitchFactors(m)
%GETSWITCHFACTORS Return vector indicating which factors are being switched
%
%  FACTIDX = GETSWITCHFACTORS(M) returns a vector of indicies indicating
%  which factors are being used for switching.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:41 $ 

nf= nfactors(m);
nSwitch = size(m.OpPoints, 2);
factIdx = (nf-nSwitch+1):nf;