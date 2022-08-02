% Script e09_2_4.m; linear programming pb. in 2D with 6 constraints;
% min L=c^T*y with A*y <= b;                          12/97, 6/25/02
%
disp('Min c^T*y subject to A*y <= b'); format compact; c=[-30 -10]', 
A=[1 1; 1 0; 0 1; -1 -1; -1 0; 0 -1], b=[50 20 36 -16 0 0]',
y=linprog(c,A,b)
