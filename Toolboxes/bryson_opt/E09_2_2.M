% Script e09_2_2.m; linear programming pb. in 2D with 5 constraints;    	      
% min L=c^T*y with Ay <= b;                           12/97, 6/24/02
%
disp('Min c^T*y subject to Ay <= b'); 
c=[-5 -1]', A=[-1 0; 0 -1; 1 1; 3 1; 1 -2], b=[0 0 6 12  2]',
y=linprog(c,A,b) 
