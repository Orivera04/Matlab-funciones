function [c,ceq]=robo1_c(p,mu,D)
% Subroutine for Pb. 9.3.14; constraints for min time pick and
% place motion of two-link robot arm;             8/01, 8/1/02
%
% Switch times and final time:
t1=p(1); ths0=p(2); the0=p(3); tf=p(4); us0=1; 
%
% Integrate EOM:
optn=odeset('reltol',1e-4); s0=[0 0 ths0 the0]';
[t,s]=ode23('robo',[0 t1],s0,optn,mu,-us0); N1=length(t); 
[t2,s2]=ode23('robo',[t1,tf/2],s(N1,:),optn,mu,us0); 
N2=length(t2); thsf=s2(N2,3); thef=s2(N2,4); t=[t; t2(2:N2)];
s=[s; s2([2:N2],:)]; ceq(1)=thsf+pi/2; ceq(2)=thef-pi; 
ceq(3)=cos(ths0)+cos(the0+ths0)-D/2;
c=[];
