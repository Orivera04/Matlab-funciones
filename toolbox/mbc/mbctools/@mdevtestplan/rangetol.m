function r=rangetol(TP,coding);
%RANGETOL depreciating code

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:08:12 $


% depreciating code
M= model(TP);
r= ones(1,nfactors(M));
r(:)= Inf;
if nargin==1
    r= invcode(M,r)- invcode(M,zeros(1,length(r)));
end