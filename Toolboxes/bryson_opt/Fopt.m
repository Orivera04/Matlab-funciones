function [t,u,s,tf,nu,la0]=fopt(name,tu,u,tf,s0,k,told,tols,mxit,eta)             
%FOPT - Function OPtimization with terminal constraints, Tf Open
%[t,u,s,tf,nu,la0]=fopt(name,tu,u,tf,s0,k,told,tols,mxit,eta)
% Function file 'name' computes f(s,u)=sdot for flg=1, (Phi,Phis,
% Phit) for flg=2, [fs,fu] for flg=3. Inputs: tu=t(N1,1), u(N1,nc)
% =init. guess of u(tu); s0(ns,1)=init. state, tf=final time, k=
% step size param, told=reltol for ode23; stops when norm(dua)<tols
% or number of iterations > mxit; 0<eta<=1 where d(psi)=-eta*psi is
% desired change in term. constraints on next iteration. Outputs: 
% optimal t,u,s, nu=final adjoint vector, la0=initial adjoint 
% vector. BASIC version AEB '84; MATLAB versions Sun H. Hur '90 and
% Fred A. Wiesinger '91;                         AEB 11/94, 7/16/02  
%
if nargin<10, eta=1; end; if nargin<9, mxit=10; end
[Nu,nc]=size(u); ns=length(s0); it=0; dua=ones(1,nc); 
disp('    Iter.     tf     phi    norm(psi)   dua   dtf');
options=odeset('RelTol',told); pmag=1; dtf=1;
while max([norm(dua) pmag abs(dtf)])>tols,
  % Forward integration storing ts and s(ts):
  [ts,s]=ode23('fopc_f',[0 tf],s0,options,tu,u,name); 
  Ns=length(ts); 
  %
  % Boundary conditions for backward integation:
  u1=u(Nu,:); s1=s(Ns,:);
  [Phi,Phis,Phit]=feval(name,u1',s1',tf,2); np=length(Phi);
  phi=Phi(1); psi=Phi([2:np]); pmag=norm(psi)/sqrt(np-1);
  Phid=Phit+Phis*feval(name,u1',s1',tf,1);
  phid=Phid(1); psid=Phid([2:np]);
  yf=[formm(Phis','c'); zeros(np*(np+1)/2,1)]; ny=length(yf);
  %
  % Backward integration storing tb and y(tb):
  [tb,y]=ode23('fopc_b',[tf 0],yf,options,tu,u,ts,s,name,np);
  Nb=length(tb); 
  %
  % Reverse indices of tb and y:
  tb1=zeros(Nb,1); y1=zeros(Nb,ny);
  for i=1:Nb, tb1(Nb-i+1)=tb(i); y1(Nb-i+1,:)=y(i,:); end
  tb=tb1; y=y1;
  %
  % New (u(tb),tf) from old (u(tb),tf), s(tb), and y(tb):
  Qg=forms(y(1,[np*ns+1:ny])');
  Q=psid*psid'+Qg([2:np],[2:np]); g=psid*phid+Qg([2:np],1);
  nu=-Q\g; la0=formm(y(1,[1:np*ns])',ns)*[1; nu];
  u1=interp1(tu,u,tb); s1=interp1(ts,s,tb);
  u=zeros(Nb,nc); du=u;     
  for i=1:Nb,
    [fs,fu]=feval(name,u1(i,:),s1(i,:),tb(i),3);
    la=formm(y(i,[1:np*ns])',ns); HuPhi=la'*fu;
    Huphi=HuPhi(1,:); Hupsi=HuPhi([2:np],:);
    du(i,:)=-k*(Huphi+nu'*Hupsi)-eta*(psi'/Q)*Hupsi;
    u(i,:)=u1(i,:)+du(i,:);
  end
  dtf=-k*(phid+nu'*psid)-eta*psid'*(Q\psi);
  for j=1:nc, dua(j)=norm(du(:,j))/sqrt(Nb); end
  disp([it tf phi pmag dua dtf]);
  tf=tf+dtf; tu=zeros(Nb,1); s=zeros(Nb,ns); tu=tb; s=s1;
  Nu=Nb; tu(Nb,1)=tf*(1+1e-8);
  if mxit==0; break; end
  if it>=mxit, break, end
  it=it+1;
end
t=zeros(Nb,1); t=tb; 
   
   