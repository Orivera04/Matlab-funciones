function f=newton(u,el)
% Subroutine for e02_3_3.m; determines uo for given ratio of el=l/a 
% where a=r(0);                                             1/30/98
%
f=(3/(4*u)+u-7*u^3/4+u^3*log(u))/(1+u^2)^2-el;