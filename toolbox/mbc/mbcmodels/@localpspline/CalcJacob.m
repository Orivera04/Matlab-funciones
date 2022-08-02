function J= CalcJacob(ps,x);
% localpspline/CALCJACOB calculates jacobian 
%
% J= jacobian(ps,x,IsCoded);
%   IsCoded optional removes datum from x before calculating
%           Jacobian (default=0)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:55 $

J= zeros(size(x,1),size(ps,1));

% constant term
J(:,2)= 1;

m= x>ps.knot;
x= x-ps.knot;
Xrhs= x(m,1);
Xlhs= x(~m,1);

% parameters

B= ps.polyhigh;
k= length(B);
xr= Xrhs;
for i= 2:ps.order(1)
   % rhs contribution to dy/dk
   J(m,1)= J(m,1) - i*B(k-i)*xr;
   % rhs polynomial terms
   xr= xr.*Xrhs;
   J(m,i+1)= xr;
end
xl= Xlhs;
B= ps.polylow;
k= length(B);
for j= 2:ps.order(2)
   % lhs contribution to dy/dk
   J(~m,1)  = J(~m,1) - j*B(k-j)*xl;
   % lhs polynomial terms
   xl= xl.*Xlhs;
   J(~m,i+j)= xl;
end



