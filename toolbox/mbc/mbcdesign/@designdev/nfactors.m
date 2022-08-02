function  n= nfactors(D);
% DESIGNDEV/NFACTORS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:16 $

N= length(D);
n= zeros(1,N);

for i= 1:N
	n(i)= nfactors(getModel(D));
	D= D.next;
end
n= n(end:-1:1);