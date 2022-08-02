function [f,s,u,la]=dop0b(sf,name,uf,s0,tf,N)
%DOP0B - Disc. OPtim. w. 0 term. constr., Bkwd shooting;
%[f,s,u]=dop0b(sf,name,uf,s0,tf,N) 
% Name must be single quotes; function file 'name' must be in the MATLAB 
% path, giving f for flg=1, (phi,phis) for flg=2, and (fs,fu) for flg=3;
% (uf,sf)=estim. final (control,state); s0=desired initial state; N=no.
% steps; f=s(:,1)-s0=error in init. state;                12/92, 10/8/01
%
ns=length(sf); dt=tf/N; [phi,phis]=feval(name,uf,sf,dt,1,2); s(:,N+1)=sf; 
la(:,N+1)=phis'; optn=optimset('Display','Off','MaxIter',50);
%
% Backward sequencing of Euler-Lagrange eqns:
for i=N:-1:1, t=(i-1)*dt; 
  if i==N, u1=uf; else u1=u(i+1); end
  s1=s(:,i+1); z0=[u1; s1]; 
  z1=fsolve('dopbu',z0,optn,name,s(:,i+1),la(:,i+1),dt,t);
  u(i)=z1(1); s(:,i)=z1([2:ns+1]);
  [fs,fu]=feval(name,u(i),s(:,i),dt,t,3); la(:,i)=fs'*la(:,i+1);
end
f=s(:,1)-s0;

