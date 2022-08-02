function [ceq,c]=latturn_c(p,s0,r0)
% Subroutine for LATTURN;                       9/13/02
%
N=(length(p)-1)/2; u=[p(1:N); p(N+1:2*N)]; tf=p(2*N+1);
[t,s]=odeu('latturn_s',u,s0,tf); N1=length(t);
rf=s(1,N1); vf=s(4,N1); gaf=s(6,N1);
c=[rf-r0-8e4  vf-2500  gaf+5*pi/180];
ceq=[];