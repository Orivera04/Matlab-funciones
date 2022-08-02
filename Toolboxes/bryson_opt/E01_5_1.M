% Script e01_5_1.m; NR solution for max velocity of a sailboat;
%                                                 9/96, 6/24/02
%
y=[.6 1 .6 .6 1.3]'; tol=1e-15; mxit=10;
[L,y,ev,evec]=popn('slbt2',y,tol,mxit)