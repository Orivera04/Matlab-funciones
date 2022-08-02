% Script p1_5_19.m; a quadratic-quadratic pb. using 
% POPN;                               1/93, 3/30/02
%
y=[.5 .4 .3]'; tol=1e-8; mxit=10;
[L,y,ev,evec]=popn('qqp',y,tol,mxit)

