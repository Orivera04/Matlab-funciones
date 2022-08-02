function [f,s,la0,nu]=foptn(p,name,s0)   
%FOPTN - Function OPtim. w. term. constr, Tf open, N-r code
% [f,s,la0]=foptn(p,name,s0); integrates plant eqns fwd,
% adjoint eqns bkwd; a NR code since FSOLVE perturbs p=[u nu tf];
% name must be in single quotes; function file 'name' gives
% sdot=f(s,u) for flg=1, perf. index phi, term. constraints psi
% for flg=2, and fs,fu for flg=3; inputs: u(1,N+1)=guess of control
% history; nu(1,nt)=guess of terminal constraint Lagrange multi-
% pliers; tf=guess of final time; s0(ns,1)=initial state; outputs: 
% f=[Hu psi' Phid]; s=optimal state histories;        2/97, 9/14/02
%
Phi=feval(name,0,s0,1,2); nt1=length(Phi); N=length(p)-nt1; 
u=p([1:N]); nu=p([N+1:N+nt1-1]); tf=p(N+nt1); 
[t,s]=odeu(name,u,s0,tf);
[Hu,phi,la0,psi]=odehnu(name,u,s,tf,nu);
[Phi,Phis,Phit]=feval(name,u(:,N),s(:,N),tf,2);  
Phidot=Phit+Phis*feval(name,u(:,N),s(:,N),tf,1);
Phid=Phidot'*[1;nu'];
f=[Hu psi' Phid];


