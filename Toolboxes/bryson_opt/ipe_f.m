function [f,s]=ipe_f(p,s0)      
% Subroutine for Pb. p.3.13a;                   4/98, 3/29/02 
%
N=length(p)-2; u=p([1:N+1]); tf=p(N+2);
[t,s]=odeu('ipen',u,s0,tf);  
thf=s(1,N+1); yf=s(2,N+1); qf=s(3,N+1); vf=s(4,N+1); 
umax=1; U=0; for i=1:N+1, U=U+abs(abs(u(i))-umax); end 
f=tf+U; 