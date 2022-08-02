function [t,u,s,nu,la0]=fopc(name,tu,u,tf,s0,k,told,tols,mxit,eta)             
%FOPC - Function OPtim. w. terminal Constraints
%[t,u,s,nu,la0]=fopc(name,tu,u,tf,s0,k,told,tols,mxit,eta)
% Function file 'name' computes f(s,u)=sdot for flg=1, (Phi,Phis) 
% for flg=2, [fs,fu] for flg=3. Inputs: name, tu=t(N1,1), u(N1,nc)
% =initial estimate of u(t); s0(ns,1)=init. state, tf=final time, 
% k=step size param, told=reltol for ode23; stops when norm(dua)<
% tols or number of iterations > mxit; 0<eta<=1 where d(psi)=
% -eta*psi is desired change in term. constraints on next iteration.
% Outputs: optimal t, u, s, nu , and la0=initial adjoint vector; 
% BASIC version AEB '84; MATLAB versions Sun H. Hur '90 and Fred A.
% Wiesinger '91;                                 AEB 11/94, 9/14/02  
%
if nargin<10, eta=1; end; if nargin<9, mxit=10; end;
disp('     Iter.       phi        norm(psi)     dua');
optn=odeset('RelTol',told); ns=length(s0); [dum,nc]=size(u);
it=0; dua=1; pmag=1; 
while max([norm(dua) pmag])>tols,
  % Forward integration storing s(ts) and ts:
  [ts,s]=ode23('fopc_f',[0 tf],s0,optn,tu,u,name); Ns=length(ts);  
  %
  % Boundary conditions for backward integration:
  [Phi,Phis]=feval(name,zeros(nc,1),s(Ns,:)',tf,2); np=length(Phi);
  phi=Phi(1); psi=Phi([2:np]); pmag=norm(psi)/sqrt(np-1);
  yf=[formm(Phis','c'); zeros(np*(np+1)/2,1)]; ny=length(yf);
  %
  % Backward integration storing tb and y(tb):
  [tb,y]=ode23('fopc_b',[tf 0],yf,optn,tu,u,ts,s,name,np);
  Nb=length(tb); 
  %
  % Reverse indices of tb and y:
  tb1=zeros(Nb,1); y1=zeros(Nb,ny);
  for i=1:Nb, tb1(Nb-i+1)=tb(i); y1(Nb-i+1,:)=y(i,:); end
  tb=tb1; y=y1; 
  %
  % New u(tb) from old u(tb), s(tb), and y(tb):
  Qg=forms(y(1,[np*ns+1:ny])'); g=Qg([2:np],1);
  Q=Qg([2:np],[2:np]); nu=-Q\g; 
  la0=formm(y(1,[1:np*ns])',ns)*[1; nu]; 
  s1=interp1(ts,s,tb); u1=interp1(tu,u,tb);
  u=zeros(Nb,nc); du=u;
  for i=1:Nb, 
    [fs,fu]=feval(name,u1(i,:),s1(i,:),tb(i),3);
    la=formm(y(i,[1:np*ns])',ns); HuPhi=la'*fu;
    Huphi=HuPhi(1,:); Hupsi=HuPhi([2:np],:);
    du(i,:)=-k*(Huphi+nu'*Hupsi)-eta*(psi'/Q)*Hupsi;
    u(i,:)=u1(i,:)+du(i,:);
  end
  for j=1:nc, dua(j)=norm(du(:,j))/sqrt(Nb); end
  disp([it phi pmag dua])
  tu=zeros(Nb,1); s=zeros(Nb,ns); tu=tb; s=s1;
  if mxit==0, disp([it phi pmag dua]); break; end
  if it>=mxit, break, end
  it=it+1;
end
t=zeros(Nb,1); t=tb;
   
   