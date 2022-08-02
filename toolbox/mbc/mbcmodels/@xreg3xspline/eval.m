function y= eval(m,x)
% xreg3xspline/EVAL evaluate xreg3xspline model
%
% y= eval(m,x)
% This code is vectorised and expects an nxm matrix where n is the number of data 
% points and m is the number of factors. The algorithm used in this function uses 
% PHI functions and a nested form for the cubic.
%
% This is normally called from MODEL/SUBSREF rather than called directly.
% MODEL/SUBSREF does all model transformations.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:43:24 $



% reorder x variable so spline is first
reord= m.reorder;

% Check size of X matrix


if size(x,2)~=length(reord)
   error(sprintf('An Nx%d matrix is required for evaluating',length(reord)));
end

x= x(:,reord);

% Calculate PHI functions for first variable
Tgt=gettarget(m,m.splinevar);
onek= ones(m.poly_order+1,1);
k= [Tgt(1,onek),m.knots(:)',Tgt(1,2*onek)];
PHI = phi_calc(k,m.poly_order,x(:,1));

Ns = size(PHI,2);
N  = order(m.cubic);
% Model Coefficients (stored in parent)
c  = double(m.xreglinear);

y= eval_loop(x,PHI,c,N,m.interact);

return

i3=1;  % index to coefficients
y=  PHI*c(i3:i3+Ns-1);
i3 = i3 + Ns;
for i=1:N(1)
   if m.interact>=1
      % Xi * PHI terms
      Yi=  PHI*c(i3:i3+Ns-1);
      i3 = i3 + Ns;
   else
      % X(i+1) * [1 X1 X1^2] Terms
      Yi = c(i3) + x(:,1).*(c(i3+1) + c(i3+2)*x(:,1));
      i3 = i3 + 3;
   end
   for j=i:N(2)
      if m.interact>=2
         % X(i+1) * X(j+1) * PHI terms
         Yj=  PHI*c(i3:i3+Ns-1);
         i3 = i3 + Ns;
      else
         % X(i+1) * X(j+1) * [1 X1]  Terms
         Yj = c(i3) + x(:,1).*c(i3+1);
         i3 = i3 + 2;
      end
      for k=j:N(3)
         % X(i+1) * X(j+1) * X(k+1) terms
         Yj= Yj + c(i3)*x(:,k+1);
         i3 = i3 + 1;
      end
      Yi= Yi + x(:,j+1).*Yj; 
   end
   y = y + x(:,i+1).*Yi;
end

