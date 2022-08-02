function q=savespnd(t,t1,q0,R,A,I,s,p)
%
% q=savespnd(t,t1,q0,R,A,I,s,p)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines q(t) satisfying
% q'(t)=r*q+[s*(t<=t1)-p*(t>t1)*...
% exp(-a*t1)]*exp(a*t), with q(0)=q0, 
% r=(R-I)/100; a=(A-I)/100

r=(R-I)/100; a=(A-I)/100; c=r-a; T=t-t1;
if r~=a
   q=q0*exp(r*t)+s/c*(exp(r*t)-exp(a*t))...
      -(p+s*exp(a*t1))/c*(T>0).*(...
      exp(r*T)-exp(a*T));
else % limiting case as a=>r
   q=q0*exp(r*t)+s*t.*exp(r*t)...
      -(p+s*exp(r*t1)).*T.*(T>0).*exp(r*T);
end