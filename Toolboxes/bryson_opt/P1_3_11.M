% Script p1_3_11.m; max gamma (flg=1) or max climb rate (flg=2)
% with const. thrust T using POP; p=[V al ga];   10/96, 6/27/02
%
clear; clear global; global T flg; T=.2; flg=2;
y=[4 .1 .1]'; k=-10; tol=5e-5; eta=1; mxit=50; 
[L,y,f]=pop('maxclmb1',y,k,tol,eta,mxit)
	