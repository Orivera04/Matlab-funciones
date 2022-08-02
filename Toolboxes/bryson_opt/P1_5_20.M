% Script p1_5_20.m; min distance between two
% ellipses using POPN;        10/96, 3/30/02
%
p=[1 1 1 2]'; tol=1e-8; mxit=10;
[L,p,ev,evec]=popn('md2elps',p,tol,mxit)
