% Script p1_5_02.m; rect. box of max volume in
% ellipsoid with a=1, b=2, c=3 using POPN;
%                               10/96, 3/30/02
%
y=[1 2 3]'; tol=5e-5; mxit=50; 
[L,y,ev,evec]=popn('rctelps2',y,tol,mxit)


	