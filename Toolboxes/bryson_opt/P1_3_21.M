% Script p1_3_21.m; max climb angle or climb rate for 727 at sea level
% using POP; L=ga (flg=1) or V*sin(ga) (flg=2); y=[V ga al]'; lc=
% 2W/(g*rho*S); V^2 in g*l, (thrust,drag,lift) in W=weight; 10/96, 8/97 
%
global flg; flg=2;
W=180000; S=1560; rho=.002203; g=32.2; lc=2*W/(rho*g*S); Vc=sqrt(g*lc);
c=pi/180; y=[300/Vc 7*c 8*c]'; k=-.2; tol=5e-5; eta=1; mxit=70;
[L,y,f]=pop('clmb727',y,k,tol,eta,mxit)
