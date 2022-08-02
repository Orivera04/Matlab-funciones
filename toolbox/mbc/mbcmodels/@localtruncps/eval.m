function y= eval(ts,x)
% LOCALTRUNCPS/EVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:57 $

beta=double(ts.xreglinear);

y = polyval_mex(beta(1:ts.order),x);

m= ts.order-1;
for i=1:length(ts.knots);
   rhs= x>ts.knots(i);
   y(rhs)= y(rhs) + beta(m+i+1)*(x(rhs)-ts.knots(i)).^m;
end


