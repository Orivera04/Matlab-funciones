% Script p1_5_11.m; numerical soln. of Pb. 1.5.11 
% using POPN; max climb angle (flg=1) or max climb
% rate (flg=2) with const. thrust T; p=[V al ga]; 
%                                   10/96, 3/30/02
%
clear; clear global; global T flg; T=.3; flg=1;
y=[4 .1 .1]'; tol=5e-5; mxit=10;
[L,y,ev,evec]=popn('maxclmb2',y,tol,mxit)
 