function X= hermiteX(p,values,der);
% TRUNCPS/HERMITEX X matrix to reconstruct model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:43:04 $

if nargin<=2
   der= 0;
end

n= size(p,1);
m= p.order;
nk= length(p.knots);
nv= length(values);

% polynomial part
Xp= hermiteX(polynom(p),values,der);
t=Terms(p);
Xp= Xp(:,t(1:end-nk));

if der>0
   p= diff(p,der);
end
% generate spline terms
xs= x2fx(p,values);
xs= [Xp prod(m-der:m-1)*xs(:,end-nk+1:end)];

X= [zeros(nv,nk) xs];
