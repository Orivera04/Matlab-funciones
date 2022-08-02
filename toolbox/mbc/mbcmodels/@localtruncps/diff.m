function q=diff(p,m);
% TRUNCPS/DIFF  Differentiate polynomial

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 07:42:55 $




q=p;
c=double(q)';
if nargin<2
   m=1;
end

beta= double(p.xreglinear);
poly= polynom(p);
poly= diff(poly,m);

n= length(beta)-length(p.knots)+1;
for i=1:m
   beta(n:end) = beta(n:end)*(p.order-1);
   p.order=p.order-1;
end

beta= [double(poly);beta(n:end)];

p.xreglinear=update(p.xreglinear,beta);

q= p;
