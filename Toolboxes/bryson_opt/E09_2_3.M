% Script e09_2_3.m; linear prog. pb. in 2D with 8 constraints;		      
% min c^T*y with A*y<=b;                         12/97, 8/7/01
%
disp('Min c^T*y subject to A*y <= b'); format compact
c=[7 4]', A=[-2 1; -1 -3; -3 -1; 1 1; -1 0; 0 -1; 1 0; 0 1], 
b=[2 -1 -2 1 0 0 1 1]', y=linprog(c,A,b)
