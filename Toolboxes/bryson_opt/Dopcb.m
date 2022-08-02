function [f,s,u,la]=dopcb(p,name,uf,s0,tf,N)
%DOPCB; Disc. OPtim. w. term. Constr., Bkwd shooting;
%[f,s,u,la]=dop0b(p,name,uf,s0,N) 
% Name must be single quotes; function file 'name' must be 
% in the MATLAB path, giving f for flg=1, (Phi,Phis) for 
% flg=2, and (fs,fu,fus,fuu) for flg=3; p=[sf,nu]; [sf,uf]
% =estim. final (state,control); s0=desired initial state;
% N=number of steps; s(:,1)-s0=error in initial state; 
%                                       4/97, 1/98, 10/8/01
%
ns=length(s0); dt=tf/N; sf=p([1:ns])'; s=zeros(ns,N+1);la=s; 
u=zeros(1,N); [Phi,Phis]=feval(name,uf,sf,dt,tf,2); 
nt1=length(Phi); psi=Phi([2:nt1]); nu=p([ns+1:ns+nt1-1])';
s(:,N+1)=sf; la(:,N+1)=Phis'*[1;nu]; 
optn=optimset('Display','Off');
%
% Backward sequencing of Euler-Lagrange eqns:
for i=N:-1:1, t=(i-1)*dt; 
   if i==N, u1=uf; else u1=u(i+1); end
   s1=s(:,i+1); z0=[u1; s1]; 
   z1=fsolve('dopbu',z0,optn,name,s(:,i+1),la(:,i+1),dt,t);
   u(i)=z1(1); s(:,i)=z1([2:ns+1]);
   [fs,fu]=feval(name,u(i),s(:,i),dt,t,3); 
   la(:,i)=fs'*la(:,i+1);
end
f=[s(:,1)-s0; psi];

	