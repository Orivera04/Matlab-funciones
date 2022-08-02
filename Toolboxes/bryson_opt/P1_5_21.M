% Script p1_5_21.m; max climb angle (flg=1) or climb 
% rate (flg=2) for 727 at sea level using POPN; 
% y=[V ga al]'; lc=2W/(g*rho*S); V^2 in g*l, (thrust,
% drag,lift) in W=weight;              10/96, 3/30/02
%
clear; clear global; global flg; flg=1; tol=1e-5; 
mxit=50; c=pi/180; y=[1 7*c 8*c]';
[L,y,ev,evec]=popn('clmb727',y,tol,mxit)
	
