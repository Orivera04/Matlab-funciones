function X= hermiteX(p,values,der);
% POLYNOM/HERMITEX X matrix to reconstruct model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:27 $

Np= size(p,1);
X= zeros(0,Np);
if nargin==2
   der=0;
end
ind= ones(1,Np);
for i=1:der;
   ind= ind(1:Np-1).*(Np-1:-1:1);
   p=diff(p);
   Np=Np-1;
end
V= x2fx(p,values);
V= V.* ind(ones(length(values),1),:);
X= [V zeros(size(V,1),size(X,2)-size(V,2))];
