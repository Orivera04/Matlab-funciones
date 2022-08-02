% Script e09_2_5.m; 2D quadratic programming pb. with 1 constraint;
% J=.5*x'*H*x+f'*x, A*x<=b;                          12/97, 6/24/02
%
H=diag([.5 2]); f=-[1 2]'; A=[3 2]; b=6; 
x=quadprog(H,f,A,b)
