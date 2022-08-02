function [X,dJ]= NestedJacobian(ps,x,k);
% POLYSPLINE/X2FX generates X matrix for regression

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:56 $


% Make X = [1 (x(x<=k)-k).^2       0        ]
%          [1      0          (x(x>k)-k).^2 ]
% allow for the case where one is empty and
% then make spline symmetric

ps.knot= k;

X= zeros(length(x),sum(ps.order)-1);
dJ= X;
X(:,1)=1;

m = (x > ps.knot) ;
xk= x-ps.knot;

for i=2:ps.order(1)
   % rhs
   X(:,i)= xk.^i;
	dJ(:,i)= -xk.^(i-1);
end
X(~m,2:ps.order(1))=0;
dJ(~m,2:ps.order(1))=0;

i=i-1;
for j=2:ps.order(2)
   % lhs
   X(:,i+j)= xk.^j;
	dJ(:,i+j)= -xk.^(j-1);
end
X(m,i+2:ps.order(2)+i)=0;
dJ(m,i+2:ps.order(2)+i)=0;



