function [f,s,u,la]=doptb(p,name,uf,s0,N)
%DOPTB; Disc. OPtim. w. term. Constr., Bkwd shooting;
%[f,s,u,la]=doptb(p,name,uf,s0,N) 
   % Name must be single quotes; function file 'name' must be
   % in the MATLAB path, giving s(i+1) for flg=1, (Phi,Phis,
   % Phid) for flg=2, (fs,fu,fd) for flg=3; p=[sf,nu,tf]; uf=
   % estim. final control; s0=initial state; tf=estim. final
   % time;  N=no. steps;      		            1/98, 10/8/01
%
ns=length(s0); s=zeros(ns,N+1); la=s; N1=length(p); 
sf=p([1:ns])'; nu=p([ns+1:N1-1])'; tf=p(N1); dt=tf/N;
u=zeros(1,N); s(:,N+1)=sf;
[Phi,Phis,Phid]=feval(name,uf,sf,dt,tf,2);
psi=Phi([2:N1-ns]); la(:,N+1)=Phis'*[1;nu];
optn=optimset('Display','Off','MaxIter',500);
for i=N:-1:1, t=(i-1)*dt; 
  if i==N, u1=uf; else u1=u(i+1); end
  s1=s(:,i+1); z0=[u1; s1];
  z1=fsolve('dopbu',z0,optn,name,s(:,i+1),la(:,i+1),dt,t);
  u(i)=z1(1); s(:,i)=z1([2:ns+1]);
  [fs,fu,fd]=feval(name,u(i),s(:,i),dt,t,3);
  la(:,i)=fs'*la(:,i+1); Hd(i)=la(:,i+1)'*fd;
end; Phd=[1 nu']*Phid+sum(Hd); f=[s(:,1)-s0; psi; Phd(1)];


