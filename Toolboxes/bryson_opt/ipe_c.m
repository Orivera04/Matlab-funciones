function [c,ceq]=ipe_c(p,s0)      
% Subroutine for Pb. p.3.13a;         4/98, 3/29/02 
%
N=length(p)-2; u=p([1:N+1]); tf=p(N+2);
[t,s]=odeu('ipen',u,s0,tf);  
thf=s(1,N+1); yf=s(2,N+1); qf=s(3,N+1); vf=s(4,N+1); 
ceq=[thf-pi yf qf vf]; c=[];