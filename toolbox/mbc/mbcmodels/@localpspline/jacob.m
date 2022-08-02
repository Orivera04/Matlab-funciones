function J= jacob(qs,x,symmetric);
% QUADSPLINE/JACOB generates X matrix for regression

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:18 $


% Make J = [-2Bl*(x(x<=k)-k) 1 (x(x<=k)-k).^2       0        ]
%          [-2Bh*(x(x>k)-k)  1      0          (x(x>k)-k).^2 ]
% allow for the case where one is empty and
% then make spline symmetric

if nargin==1
   x=qs.Store.X-datum(qs);
   symmetric=1;
elseif isa(x,'double')
   x= x(:)-datum(qs);
elseif isa(x,'char')
   symmetric=1;
   x=qs.Store.X-datum(qs);
end
if nargin<3
   symmetric=3;
end
if isa(symmetric,'char')
   switch lower(symmetric)
   case 'sym'
      symmetric=1;
   case 'raw'
      symmetric=0;
   end
end

m = (x > qs.knot);
if symmetric
   % Assume symmetry in J if all(m) | all(~m)
   % This is equivalent to adding mirror image points wrt qs.knot
   if sum(m)<qs.order(2)
      x= [x ; qs.knot-(x(~m)-qs.knot)];
   elseif sum(~m)<qs.order(1)
      x= [x ; qs.knot-(x(m)-qs.knot)];
   end
   m = (x > qs.knot) ;
end   

J= [zeros(size(x,1),1) x2fx(qs,x,0)];


% dF/dk
plo= flipud(qs.polylow(:));
phi= flipud(qs.polyhigh(:));

p= [plo(1);  phi(3:end) ; plo(3:end)];

Ji= zeros(size(x));
m= x>qs.knot;
% delR/delk for high x
for i= 2:qs.order(1)
   Ji(m)= Ji(m) - i*p(i)*(x(m)-qs.knot).^(i-1);
end
for j= 2:qs.order(2)
   Ji(~m)= Ji(~m) - j*p(i+j-1)*(x(~m)-qs.knot).^(j-1);
end

J( :,1) = Ji;