% Script p1_2_06.m; general QPI with linear equality 
% constraints;                         5/98, 6/27/02
%
Q=diag([1 2 3]), R=diag([4 5]), G=[3 2; 1 -1; -4 -3]
c=[-2 3 -1]', S=inv((inv(Q)+G*(R\G'))), K=R\G'*S
u=-K*c, x=G*u+c, Lmin=c'*S*c/2, la=-S*c
%
% Using matrix inversion lemma:
S1=Q-Q*G*((R+G'*Q*G)\(G'*Q)); K1=(R+G'*Q*G)\(G'*Q),
u1=-K1*c, x1=G*u1+c, la1=-S1*c
