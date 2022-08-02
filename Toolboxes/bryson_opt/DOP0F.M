function [f,s,u,la]=dop0f(la0,name,u0,s0,tf,N)
%DOP0F; Disc. OPtim. w. 0 term. constr., Fwd shooting;
%[f,s,u,la]=dop0f(la0,name,u0,s0,tf,N) 
% Name must be single quotes; function file 'name' must be in the MATLAB 
% path, giving f for flg=1, (phi,phis) for flg=2, and (fs,fu) for flg=3;
% (u0,la0)=estimate initial (control, adjoint vector); s0=initial state;
% tf=final time; N=number of steps; f=la-phis'=error in final B.C.;	
%                                                          3/97, 6/18/02
%
dt=tf/N; ns=length(s0); s=zeros(ns,N+1); la=s; u=zeros(1,N); s(:,1)=s0;
la(:,1)=la0; optn=optimset('Display','Off');               
for i=1:N, t=(i-1)*dt; 
 if i==1, u1=u0; else u1=u(i-1); end
 l1=la(:,i); p0=[u1; l1]; 
 p=fsolve('dopfu',p0,optn,name,s(:,i),la(:,i),dt,t);
 u(i)=p(1); la(:,i+1)=p([2:ns+1]);
 s(:,i+1)=feval(name,u(i),s(:,i),dt,t,1);
end
[phi,phis]=feval(name,u(N),s(:,N+1),dt,tf,2);
f=la(:,N+1)-phis';

