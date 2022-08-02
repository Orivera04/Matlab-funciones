% Script e01_3_1.m; max velocity of a sailboat; 8/97, 6/18/02
%
y=[.5 1 .5 .5 1.5]'; k=-1.2; tol=1e-5; eta=1; mxit=50;
[L,y,f]=pop('slbt',y,k,tol,eta,mxit)