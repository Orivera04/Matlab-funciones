function [f,t,s]=robo1_fg(p,mu,D)
% Subroutine for Pb. 9.3.14; performance index f for min time
% pick-and-place motion of two-link robot arm;     8/01, 8/1/02
%
% Switch times and final time:
t1=p(1); ths0=p(2); the0=p(3); tf=p(4); us0=1; 
%
% Integrate EOM:
f=tf;
optn=odeset('reltol',1e-4); s0=[0 0 ths0 the0]';
[t,s]=ode23('robo',[0 t1],s0,optn,mu,-us0); N1=length(t); 
[t2,s2]=ode23('robo',[t1,tf/2],s(N1,:),optn,mu,us0);
N2=length(t2); t=[t; t2(2:N2)]; s=[s; s2([2:N2],:)];

