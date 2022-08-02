function [f,s]=latturn_f(p,s0,r0)
% Subroutine for LATTURN;                       9/13/02
%
N=(length(p)-1)/2; u=[p(1:N); p(N+1:2*N)]; tf=p(2*N+1);
[t,s]=odeu('latturn_s',u,s0,tf); N1=length(t);
f=-abs(s(3,N1));