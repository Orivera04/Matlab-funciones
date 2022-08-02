% Script p1_3_06.m; general QPI with linear equality constraints;
%                                                      5/98, 3/20/02
%
Q=diag([1 2 3]); R=diag([4 5]); G=[3 2; 1 -1; -4 -3]; c1=[-2 3 -1]';
%
% Analytical solution #1:
S=inv((inv(Q)+G*(R\G'))); K=R\G'*S; u=-(K*c1)', x=(G*u'+c1)'
Lmin=c1'*S*c1/2; la=-S*c1;
%
% Analytical solution #2:
S1=Q-Q*G*((R+G'*Q*G)\(G'*Q)); K1=(R+G'*Q*G)\(G'*Q);
u1=-(K1*c1)', x1=(G*u1'+c1)', la1=-S1*c1;
%
% Using FMINCOM:
p0=[u1 x1]'; optn=optimset('Display','Iter','MaxIter',100);
p=fmincon('qpilin_f',p0,[],[],[],[],[],[],'qpilin_c',optn,Q,R,G,c1); 
u2=p(1:2)', x2=p(3:5)'