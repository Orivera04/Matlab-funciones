function [c,ceq,t,s]=mart_c(p,s0)      
% Subroutine for e04_5_2;              3/97, 9/17/02 
%
Np=length(p); tf=p(Np); optn=odeset('RelTol',1e-5);
[t,s]=ode23('mart_s',[0 tf],s0,optn,p); N=length(t);
rf=s(N,1); uf=s(N,2); vf=s(N,3);
ceq=[rf-1.5237 uf vf-1/sqrt(rf)]; c=[];