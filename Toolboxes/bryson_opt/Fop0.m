function [t,u,s,la0,Hu]=fop0(name,tu,u,tf,s0,k,told,tols,mxit)             
%FOP0 - Function OPtim. with 0 terminal constraints
%[t,u,s,la0,Hu]=fop0(name,tu,u,tf,s0,k,told,tols,mxit)
% Name must be in single quotes; function file 'name' computes sdot=
% f(s,u) for flg=1, (phi,phis) for flg=2, (fs,fu) for flg=3. Inputs: 
% tu=tu(N1,1), u=u(N1,nc)=initial estimate of u(tu); s0(ns,1)=initial
% state, tf=final time, k=step size parameter, told=reltol for ode23;
% stops when norm(dua)<tols or no. iterations>mxit; outputs: optimal
% t,u,s where t=t(N,1), s=s(N,ns), u=u(N,nc); la0=initial adjoint 
% vector; BASIC version AEB '84; MATLAB versions Sun H. Hur '90, Fred
% A. Wiesinger '91, Paul M. Montgomery '95;        AEB 11/94, 8/16/02  
%
if nargin<8, mxit=10; end; disp('     Iter.       phi        dua'); 
optn=odeset('reltol',told); ns=length(s0); [dum,nc]=size(u); it=0;
dua=1;   
while norm(dua)>tols
   % Forward integration storing s(ts) and ts: 
   [ts,s]=ode23('fop0_f',[0 tf],s0,optn,tu,u,name); Ns=length(ts);
   %
   % Boundary conditions for backward integration:
   [phi,phis]=feval(name,zeros(nc,1),s(Ns,:)',tf,2); laf=phis';
   %
   % Backward integration storing la(tb) and tb:
   [tb,la]=ode23('fop0_b',[tf 0],laf,optn,tu,u,ts,s,name);
   Nb=length(tb); 
   %
   % Reverse indices of tb and la:
   tb1=zeros(Nb,1); la1=zeros(Nb,ns);
   for i=1:Nb; tb1(Nb-i+1)=tb(i); la1(Nb-i+1,:)=la(i,:); end
   tb=tb1; la=la1; la0=la(1,:); 
   %
   % New u(tb) from la(tb), s(tb), and old u(tb):
   u1=zeros(Nb,nc); u1=interp1(tu,u,tb); s1=interp1(ts,s,tb); 
   u=zeros(Nb,nc); du=u; Hu=zeros(Nb,nc); 
   for i=1:Nb, 
     [fs,fu]=feval(name,u1(i,:),s1(i,:),tb(i),3);
     Hu(i,:)=la(i,:)*fu; du(i,:)=-k*Hu(i,:);
     u(i,:)=u1(i,:)+du(i,:);
   end
   for j=1:nc, dua(j)=norm(du(:,j))/sqrt(Nb); end
   disp([it phi dua]); 
   %
   % New tu=tb and s(tb):
   tu=zeros(Nb,1); s=zeros(Nb,ns); tu=tb; s=s1;
   if mxit==0, break; end
   if it>=mxit, break; end
   it=it+1;
end
t=zeros(Nb,1); t=tb;

