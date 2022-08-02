function [f,s,u,la]=dopcf(p,name,u0,s0,tf,N)
%DOPCF; Disc. OPtim. w. term. Constr., Fwd shooting;
%[f,s,u,la]=dopcf(p,name,u0,s0,tf,N) 
% Name must be single quotes; function file 'name' must be 
% in the MATLAB path, giving s(i+1) for flg=1, (Phi,Phis) 
% for flg=2, (fs,fu) for flg=3; p=[la0,nu]; u0=estimated
% initial control; s0=initial state; N=number of steps;
%                                        4/97, 1/98, 10/8/01
%
dt=tf/N; ns=length(s0); s=zeros(ns,N+1); la=s; N1=length(p); 
la0=p([1:ns])'; nu=p([ns+1:N1])'; u=zeros(1,N); u(1)=u0; 
s(:,1)=s0; la(:,1)=la0; optn=optimset('Display','Off');
for i=1:N, t=(i-1)*dt; 
  if i==1, u1=u0; else u1=u(i-1); end;
  l1=la(:,i); z0=[u1; l1]; 
  z1=fsolve('dopfu',z0,optn,name,s(:,i),la(:,i),dt,t);
  u(i)=z1(1); la(:,i+1)=z1([2:ns+1]);
  s(:,i+1)=feval(name,u(i),s(:,i),dt,t,1);
end
[Phi,Phis]=feval(name,u(N),s(:,N+1),dt,tf,2);
psi=Phi([2:N1-ns+1]);
f=[la(:,N+1)-Phis'*[1;nu]; psi];


	