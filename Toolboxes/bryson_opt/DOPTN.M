function [f,s,la0]=doptn(p,name,s0)   
%DOPTN - Disc. OPt. w. open Tf, Newton-raphson code; discrete
%[f,s,la0]=doptn(p,name,s0)  
% Euler-Lagrange eqns. with plant eqns. forward, adjoint
% eqns. backward; use FSOLVE to iterate p=[u(i) nu' tf]
% to make f=[Hu(i) psi' Phid]=0. Function file 'name'
% computes s(i+1)=f[s(i),u(i)] for flg=1, (Phi,Phis,Phid)
% for flg=2, and (fs,fu,fd) for flg=3 (same file used by
% DOPT). Inputs: u(1,N)=guess of control sequence, nu=guess 
% of terminal constraint Lagrange multipliers; tf=guess of 
% final time; s0(ns,1)=initial state. Outputs: s=optimal state
% sequence, la0= initial lambda;                 3/97, 7/15/02
%						  
ns=length(s0); Phi=feval(name,0,s0,1,0,2); nt1=length(Phi);
N=length(p)-nt1; s=zeros(ns,N+1); la=s; Hu=zeros(1,N);
u=p([1:N]); nu=p([N+1:N+nt1-1]); tf=p(N+nt1); dt=tf/N;
%
% Forward sequencing and store x(:,i):
s(:,1)=s0; for i=1:N,
 s(:,i+1)=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,1); end;
%
% Backward sequencing and store Hu(i) & Phid:
[Phi,Phis,Phid]=feval(name,0,s(:,N+1),dt,tf,2);
psi=Phi([2:nt1]); la=Phis'*[1;nu']; Phid=Phid'*[1;nu']; 
for i=N:-1:1,
 [fs,fu,fd]=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,3);
 Hu(i)=la'*fu;  Phid=Phid+la'*fd;  la=fs'*la;
end; la0=la;
f=[Hu psi' Phid];