function [g]= optConstr(c,X);
%OPTCONSTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:58 $

% find nonlinear constraints
isnonlin=zeros(1,length(c.Constraints));
for n=1:length(c.Constraints)
   isnonlin(n)=~islinear(c.Constraints{n});
end

dim = find(size(X)==length(c.Factors));
g   = zeros(size(X,dim(1)),sum(isnonlin));
if dim==1;
   X=X';
end

m=0;
for n=find(isnonlin)
   m=m+1;
   g(:,m)=constraindist(c.Constraints{n},X);
end