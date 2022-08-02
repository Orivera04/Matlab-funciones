% Script p1_3_09.m; min radius turn (flg=1) or max turn rate (flg=2) of
% a glider using POP; charac. length lc=2m(eta)/(rho*S*Cla); V in units 
% of sqrt(g*lc), r in lc; y=[V al sg]; solved with FMINCON in p1_3_09c,
% and with POPN in p1_5_09;                              10/96, 7/17/02
%
clear global; global ga flg; ga=.1; flg=1; y0=[4.4 .058 .49]'; k=-1e-3;
tol=1e-4; eta=1; mxit=50; [L,y,f]=pop('minturn',y0,k,tol,eta,mxit)

