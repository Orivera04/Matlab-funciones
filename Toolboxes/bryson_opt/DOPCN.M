function [f,s,la0,nu]=dopcn(p,name,s0,tf)   
% Discrete OPtimization w. terminal Constraints, NR code; plant eqns.
% sequenced forward, adjoint eqns. backward; uses FSOLVE to find
% p=[u(i) nu] to make f=[Hu(i) psi]=0; function file 'name' computes s(i+1)
% =f[s(i),u(i)] for flg=1, (Phi,Phis) for flg=2, and (fs,fu) for flg=3
% (same file used by DOPC); inputs: p=[u(i) nu] where u=guess of control
% sequence (1 by N), nu=guess of terminal constraint Lagrange multipliers; 
% tf=spec. final time; s0=initial state (ns by 1); outputs: f=(Hu psi); 
% s=optimal state sequence, la0=optimal la0, nu=optimal nu;  5/98, 5/27/02
%						  
ns=length(s0); Phi=feval(name,0,s0,1,0,2); nt=length(Phi)-1;
N=length(p)-nt; s=zeros(ns,N+1); la=s; Hu=zeros(1,N); 
u=p([1:N]); nu=p([N+1:N+nt]);
%
% Forward sequencing and store s(:,i):
dt=tf/N; s(:,1)=s0;
for i=1:N, s(:,i+1)=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,1); end
%
% Backward sequencing and store Hu(i) & psi:
[Phi,Phis]=feval(name,0,s(:,N+1),dt,tf,2); psi=Phi([2:nt+1]); 
la=Phis'*[1;nu']; for i=N:-1:1,
 [fs,fu]=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,3); Hu(i)=la'*fu; la=fs'*la;
end; la0=la; f=[Hu psi'];


