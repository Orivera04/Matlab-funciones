function [u,s,tf,nu,la0]=dopt(name,u,s0,tf,k,tol,mxit,eta)   
%DOPT - Disc. OPTim. w. term. constr., Tf open, multiple controls
% [u,s,tf,nu,la0]=dopt(name,u,s0,tf,k,tol,mxit,eta)
  % Name must be in single quotes; function file 'name' should be in the
  % MATLAB path and compute the s(i) sequence for flg=1, perf. index and
  % term. constr. & gradients (Phi,Phis,Phid) for flg=2, (fs,fu,fd) for
  % flg=3; inputs: u(nc,N)=estimate of optimal control sequence; s0(ns,1)
  % =initial state; tf=estimate of final time; k=step-size parameter;  
  % t and elements of u should be scaled so that one unit of each is of
  % comparable significance; stopping criterion is max[norm(dua) pmag
  % abs(dtf)]<tol or the number of iterations >= mxit; 0<eta<= 1 where
  % d(psi)=-eta*psi is desired change in term. conditions; outputs
  % (u,s,tf)=improved estimates; BASIC version '84; MATLAB version '91;
  % vector control version 9/96, rev. 6/25/98.
%
if nargin<8, eta=1; end; if nargin<7, mxit=10; end 
ns=length(s0); [nc,N]=size(u); N1=N+1; dum=zeros(nc,1); 
Phi=feval(name,dum,s0,1,0,2); nt1=length(Phi); nt=nt1-1;
s=zeros(ns,N1); la=zeros(ns,nt1); Hu=zeros(nt1,nc,N);
nu=zeros(nt,1); dua=1; pmag=1; dtf=1; it=0; s(:,1)=s0;
disp('     Iter.     tf     phi    norm(psi)    dua    dtf')
while max([norm(dua) pmag  abs(dtf)]) > tol,                                        
 % Forward sequencing and store s(:,i):
   dt=tf/N; for i=1:N,  
     s(:,i+1)=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,1); end
 % Perf. index, term. constraints, & B.C.s for bkwd sequences:
   [Phi,Phis,Phid]=feval(name,dum,s(:,N1),dt,N*dt,2);
   phi=Phi(1); psi=Phi([2:nt1]); pmag=norm(psi)/sqrt(nt);
   if mxit==0, disp([it  phi  pmag]); break; end; la=Phis'; 
 % Backward sequencing and store Hu(:,:,i):
   for i=N:-1:1
     [fs,fu,fd]=feval(name,u(:,i),s(:,i),dt,(i-1)*dt,3);
     Hu(:,:,i)=la'*fu; Phid=Phid+la'*fd; la=fs'*la;
   end; phid=Phid(1); n2=[2:nt1]; psid=Phid(n2);
   % nu and la0:
   ga=Phid*phid; Qa=Phid*Phid'; n1=[1:nt1]; dua=zeros(nc,1);
   for i=1:N
     ga=ga+Hu(n1,:,i)*Hu(1,:,i); Qa=Qa+Hu(n1,:,i)*Hu(n1,:,i)';
   end; g=ga(n2); Q=Qa(n2,n2); nu=-Q\g; la0=la*[1;nu];                                       
 % New u(i) and tf:
   for i=1:N, Huphi=Hu(1,:,i); Hupsi=Hu(n2,:,i);
     du(:,i)=-k*(Huphi'+Hupsi'*nu)-eta*Hupsi'*(Q\psi);
     dua=dua+norm(du(:,i))/sqrt(N);
   end
   u=u+du; dtf=-N*k*(phid+nu'*psid)-N*eta*psid'*(Q\psi);  
   disp([it real(tf) real(phi) norm(psi) real(dua) real(dtf)])
   tf=tf+dtf; it=it+1; if it>=mxit, break, end
 end













