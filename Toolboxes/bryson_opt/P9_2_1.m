% Script p9_2_1.m; quadratic pgm. pb. with linear 
% inequality constraint;           12/97, 3/31/02
%
H=2*[1 -.5; -.5 1]; f=[-3 0]'; A=[3 1]; b=3;
p=quadprog(H,f,A,b)
	