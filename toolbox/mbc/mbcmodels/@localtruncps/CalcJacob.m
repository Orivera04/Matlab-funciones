function J= CalcJacob(ts,x);
% TRUNCPS/CALCJACOB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:42:51 $


nk= length(ts.knots);

J= zeros(length(x),numParams(ts.xreglinear)+nk);

X= x2fx(ts,x);

J(:,nk+1:end)= X(:,Terms(ts.xreglinear));

m= ts.order;
p= double(ts.xreglinear);
for i= 1:length(ts.knots);
   rhs= x>ts.knots(i);
	if any(rhs)
		J(rhs,i)= J(rhs,i) - (m-1)*p(m+i)*(x(rhs,:)-ts.knots(i)).^(m-2);
	end
end
