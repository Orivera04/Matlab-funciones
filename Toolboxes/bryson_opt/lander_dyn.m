function [f,t,s]=lander_dyn(p,v0,Isp,Tmax)
% Subroutine for lander.m;                          9/11/02
%
ts=p(1); tf=p(2); v1=v0-ts; h1=1-v0*ts-ts^2/2;
optn=odeset('RelTol',1e-4);
[t,s]=ode23('lander_sub',[ts tf],[h1 v1 1]',optn,Isp,Tmax);
N=length(t); f=[s(N,1) s(N,2)];