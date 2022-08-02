function y= eval_loop(x,PHI,c,N,interact);
%EVAL_LOOP

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:16 $

Ns = size(PHI,2);
y= zeros(size(PHI,1),1);
Yj= y;
Yi=y;

i3=1;  % index to coefficients
y(:)=  PHI*c(i3:i3+Ns-1);
i3 = i3 + Ns;
for i=1:N(1)
   if interact>=1
      % Xi * PHI terms
      Yi(:)=  PHI*c(i3:i3+Ns-1);
      i3 = i3 + Ns;
   else
      % X(i+1) * [1 X1 X1^2] Terms
      Yi(:) = c(i3) + x(:,1).*(c(i3+1) + c(i3+2)*x(:,1));
      i3 = i3 + 3;
   end
   for j=i:N(2)
      if interact>=2
         % X(i+1) * X(j+1) * PHI terms
         Yj(:)=  PHI*c(i3:i3+Ns-1);
         i3 = i3 + Ns;
      else
         % X(i+1) * X(j+1) * [1 X1]  Terms
         Yj = c(i3) + x(:,1).*c(i3+1);
         i3 = i3 + 2;
      end
      for k=j:N(3)
         % X(i+1) * X(j+1) * X(k+1) terms
         Yj(:)= Yj + c(i3)*x(:,k+1);
         i3 = i3 + 1;
      end
      Yi(:)= Yi + x(:,j+1).*Yj; 
   end
   y(:) = y + x(:,i+1).*Yi;
end

