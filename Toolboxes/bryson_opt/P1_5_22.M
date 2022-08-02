% Script p1_5_22.m; min helix radius (flg=1) & max turn rate (flg=2)
% for 727 at sea level using POPN; y=[V al sg]';       1/93, 6/27/02
%
global flg ga; flg=2; ga=0;
p0=[1 .2 1]'; tol=1e-8; mxit=12; 
[L,p,ev,evec]=popn('cltn',p0,tol,mxit);

