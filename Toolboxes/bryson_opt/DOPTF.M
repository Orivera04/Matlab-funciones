function [f,s,u,la]=doptf(p,name,u0,s0,N)
%DOPTF; Disc. OPtim. w. term. Constr., Fwd shooting;
%[f,s,u,la]=doptf(p,name,u0,s0,N) 
% Name must be single quotes; function file 'name' must be in the
% MATLAB path, giving s(i+1) for flg=1, (Phi,Phis,Phid) for flg=2, 
% (fs,fu,fd) for flg=3; p=[la0,nu,tf]; u0=estim. init. control; 
% s0=initial state; tf=estim. final time; N=no. steps;
%                                               3/97, 7/98, 10/8/01
%
ns=length(s0); s=zeros(ns,N+1); la=s; N1=length(p); la0=p([1:ns])';
nu=p([ns+1:N1-1])'; tf=p(N1); dt=tf/N; u=zeros(1,N); s(:,1)=s0;
la(:,1)=la0; optn=optimset('Display','Off','MaxIter',500);
for i=1:N, t=(i-1)*dt; 
  if i==1, u1=u0; else u1=u(i-1); end;
  l1=la(:,i); z0=[u1; l1]; 
  z1=fsolve('dopfu',z0,optn,name,s(:,i),la(:,i),dt,t);
  u(i)=z1(1); la(:,i+1)=z1([2:ns+1]);
  s(:,i+1)=feval(name,u(i),s(:,i),dt,t,1);
  [fs,fu,fd]=feval(name,u1,s(:,i),dt,t,3);
  Hd(i)=la(:,i+1)'*fd;
end;
[Phi,Phis,Phid]=feval(name,u(N),s(:,N+1),dt,tf,2);
Phd=[1 nu']*Phid+sum(Hd); psi=Phi([2:N1-ns]);
f=[la(:,N+1)-Phis'*[1;nu]; psi; Phd];

	
