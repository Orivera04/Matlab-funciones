% Script p1_3_02.m; rectangular parallelepiped of max volume
% inscribed in an ellipsoid with semiaxes a=1, b=2, c=3, 
% using POP;                                  10/96, 3/30/02
%
y=[1 2 3]'; k=-.06; tol=1e-4; eta=1; mxit=50;
[L,y,f]=pop('rctelps',y,k,tol,eta,mxit)
