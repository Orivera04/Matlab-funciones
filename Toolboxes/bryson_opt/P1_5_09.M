% Script p1_5_09.m; min radius turn (flg=1) or max turn rate
% (flg=2) of a glider; lc=2m(eta)/(rho*S*Cla); V in units of
% sqrt(g*lc), r in lc; y=[V al sg]; also solved with POP in 
% p1_3_09, and with FMINCON in p1_3_09c;      10/96, 8/15/02
%
clear; clear global; global ga flg; ga=.1; flg=1;
y0=[6 .03 .5]'; tol=5e-5; mxit=30; 
[L,y,ev,evec]=popn('minturn2',y0,tol,mxit)
