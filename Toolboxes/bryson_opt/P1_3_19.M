% Script p1_3_19.m; Quadratic-quadratic pb. using 
% POP;                             10/96, 5/27/02
%
y=[.5 .4 .3]'; k=-.2; tol=1e-4; eta=1; mxit=50;
[L,y,f]=pop('qqp',y,k,tol,eta,mxit)
  


