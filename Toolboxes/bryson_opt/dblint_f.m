function [f,t,s]=dblint_f(p,s0)
% Subroutine for e09_3_1a; 9/17/02
%
optn=odeset('RelTol',1e-5);
[t,s]=ode23('dblint_s',[0 1],s0,optn,p);
N=length(t); f=-s(N,1); 