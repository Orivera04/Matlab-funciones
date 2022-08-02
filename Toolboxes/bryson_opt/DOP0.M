function [u,s,la0]=dop0(name,u,s0,tf,k,tol,mxit)
%DOP0 - Disc. OPtim. w. 0 term. Constraints, tf specified, nc controls
%[u,s,la0]=dop0(name,u,s0,tf,k,tol,mxit)
% Inputs: name must be in single quotes; function file 'name' gives 
% s(i+1)=f(s(i),u(i))for flg=1, (phi,phis) for flg=2, and (fs,fu)
% for flg=3; u(nc,N)=estimate of optimal u; s0(ns,1)=initial state;
% tf=final time; k=step size parameter; u should be normalized so
% that elements of du are roughly the same size; stopping criterion
% is max(dua)<tol; mxit=max no iterations; outputs (u,s)=improved
% (u,s) histories; la0=optimal lambda(0) for use with a shooting
% algorithm; BASIC version '84; MATLAB version '94; rev. 6/18/02
%
if nargin<7, mxit=10; end
ns=length(s0); [nc,N]=size(u); s=zeros(ns,N+1); dum=zeros(nc,1);
la=zeros(ns,1); Hu=zeros(N,nc); dua=1; it=0; dt=tf/N; s(:,1)=s0;  
disp('     Iter.       phi        dua');
while norm(dua)>tol,
 % Forward sequencing and store state histories x(:,i):
 for i=1:N, s(:,i+1)=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,1); end
 % Performance index phi and b.c. for backward sequence phis: 
 [phi,phis]=feval(name,dum,s(:,N+1),dt,N*dt,2); la=phis'; 
 % Backward sequencing and store Hu(i);
 for i=N:-1:1
   [fs,fu]=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,3);  
   Hu(i,:)=la'*fu; la=fs'*la;
 end; la0=la;
 % New u(i):
 for j=1:nc,
   du(j,:)=-k*Hu(:,j)'; dua(j)=norm(du(j,:))/sqrt(N);
 end; u=u+du; disp([it phi dua])
 if it>mxit, break, end; it=it+1;
end
