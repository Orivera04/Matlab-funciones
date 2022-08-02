function [u,s,nu,la0]=dopc(name,u,s0,tf,k,tol,mxit,eta)
%DOPC - Disc. OPtim. w. term. Constr., tf given; vector u; 
% [u,s,nu,la0]=dopc(name,u,s0,tf,k,tol,mxit,eta); name must be in
% single quotes; function file 'name' should be in the MATLAB path
% and compute f for flg=1, Phi=(phi,psi) and Phis=(phis,psis) for
% flg=2, and (fs,fu) for flg=3; u(nc,N)=initial guess of control
% sequence; s0(ns,1)=initial state; tf=final time; k=step-size
% parameter; u should be scaled so that one unit of each element 
% is of approximately the same significance; stops when both dua 
% & norm(psi)<tol, or no. of iterations >= mxit; 0<eta<= 1 where
% d(psi)=- eta*psi is desired change in term. conditions on next
% iteration; BASIC '84; scalar ctrl MATLAB '94; vector ctrl '96;
% Note Hu is nt1*nc*N (MATLAB 5 & above handles 3-D arrays); 1/98 
%
if nargin<8, eta=1; end; if nargin<7, mxit=10; end
ns=length(s0); [nc,N]=size(u); N1=N+1; dum=zeros(nc,1);
Phi=feval(name,dum,s0,1,0,2); nt1=length(Phi); nt=nt1-1;
s=zeros(ns,N1); la=zeros(ns,nt1); Hu=zeros(nt1,nc,N); dt=tf/N;
nu=zeros(nt,1); dua=1; pmag=1; it=0; s(:,1)=s0; n2=[2:nt1];
disp('     Iter.      phi     norm(psi)      dua')
while max([norm(dua) pmag])> tol,
  % Forward sequencing and store state histories s:
  for i=1:N, s(:,i+1)=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,1); end
  % Performance index, terminal constraints & gradients:
  [Phi,Phis]=feval(name,dum,s(:,N1),dt,N*dt,2); la=Phis';
  phi=Phi(1); psi=Phi(n2); pmag=norm(psi)/sqrt(nt);
  if mxit==0, disp([it  phi pmag]); break; end
    % Backward sequencing, storing Hu(:,i):
  for i=N:-1:1
   [fs,fu]=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,3);
   Hu(:,:,i)=la'*fu; la=fs'*la;
  end
  % nu and la0:
  ga=zeros(nt1,1); Qa=zeros(nt1); n1=[1:nt1]; dua=zeros(nc,1);
  for i=1:N
   ga=ga+Hu(n1,:,i)*Hu(1,:,i)'; Qa=Qa+Hu(n1,:,i)*Hu(n1,:,i)';
  end; g=ga(n2); Q=Qa(n2,n2); nu=-Q\g; la0=la*[1; nu];
  % New u(:,i):
  for i=1:N, Huphi=Hu(1,:,i); Hupsi=Hu(n2,:,i);
   du(:,i)=-k*(Huphi'+Hupsi'*nu)-eta*Hupsi'*(Q\psi);
   dua=dua+norm(du(:,i))/sqrt(N);
  end
  u=u+du; disp([it phi norm(psi) dua'])
  it=it+1; if it>=mxit, break, end
 end
