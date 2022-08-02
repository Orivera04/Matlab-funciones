function [f,t,s]=gld_f(p,s0)                            
% Subroutine for Ex. 9.3.2a; s=[V ga h x]';   9/19/02 
%
optn=odeset('RelTol',1e-5); N=length(p)-1; tf=p(N+1); 
[t,s]=ode23('gld_s',[0 tf],s0,optn,p); N1=length(t);  
f=-s(N1,4);		    