% Script p1_3_20.m; min dist between 2 ellipses 
% using POP;                       1/95, 6/27/02
%
y=[1 1 1 2]'; k=.3; tol=1e-4; eta=1; mxit=100;
[L,y,f]=pop('md2elps',y,k,tol,eta,mxit)
