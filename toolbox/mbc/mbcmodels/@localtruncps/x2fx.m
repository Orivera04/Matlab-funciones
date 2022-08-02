function X= x2fx(ts,x)
% TRUNCPS/X2FX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:19 $

X= zeros(length(x),ts.order+length(ts.knots));

X(:,ts.order)= 1;
if ts.order>1
   X(:,ts.order-1)= x;
   for i=ts.order-2:-1:1
      X(:,i)= x.*X(:,i+1);
   end
end
m= ts.order;
for i=1:length(ts.knots)
   rhs= x>ts.knots(i);
   X(rhs,i+m)= (x(rhs)-ts.knots(i)).^(m-1);
end