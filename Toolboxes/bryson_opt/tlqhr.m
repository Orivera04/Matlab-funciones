function [x,u,t,t1b,K]=tlqhr(A,B,Q,N,R,tf,x0,Sf,Mf,psi,t1,tol)
%TLQHR - Tv LQ ctrl w. Hard term. constaints, Riccati soln
%[x,u,t,t1b,K]=tlqhr(tf,x0,Sf,psi,t1,options)                
% TI plant, xdot=Ax+Bu, x(0)=x0, Mf*x(tf)=psi, 2J=xf'*Sf*xf+
% int(0:tf)(x'Q*x+2x'*N*u+u'R*u)dt; (x,u) are (state, control) 
% histories at times t; opt. open-loop ctrl is used from t1 to
% tf to avoid high gains near t=tf;              8/97, 7/14/02
%
[nt,ns]=size(Mf); Qcf=zeros(nt); optn=odeset('RelTol',tol);
yf=[forms(Sf); formm(Mf,'c'); forms(Qcf)]; 
[tb,y]=ode23('tlqh_b',[tf 0],yf,optn,A,B,Q,N,R,Mf); 
Nb=length(tb); un=ones(Nb,1); [dum,N1]=min(abs(tb-t1*un));
t1=tb(N1); N1b=[N1:Nb]; t1b=tb(N1b);
%
% Determine gain matrix K(tb) and uf(tb) from y(tb):
[ns,nc]=size(B); K=zeros(Nb-N1+1,ns*nc); uf=zeros(Nb-N1+1,nc);
n1=ns*(ns+1)/2; n2=nt*ns; n3=nt*(nt+1)/2; ys=y(N1b,[1:n1]);
ym=y(N1b,[1+n1:n1+n2]); yq=y(N1b,[1+n1+n2:n1+n2+n3]);
for i=1:Nb-N1+1, 
 S=forms(ys(i,:)'); M=formm(ym(i,:)',nt); Qc=forms(yq(i,:)'); 
 K(i,:)=formm(R\(N'+B'*(S+M'*(Qc\M))),'r');
 uf(i,:)=(R\(B'*M'*(Qc\psi)))';
end
disp('K(t) and uf(t) computed');
%
% Simulate closed-loop system from 0 to t1:
[ta,xa]=ode23('tlqh_f',[0 t1],x0,optn,A,B,t1b,K,uf);
N2=length(ta); ua=zeros(nc,N2);
for i=1:N2, Kt=formm(interp1(t1b,K,ta(i)),ns);
 uft=interp1(t1b,uf,ta(i)); ua(:,i)=uft'-Kt*xa(i,:)';
end
%
% Simulate open-loop system from t1 to tf using TLQH:
Ns=round((tf-t1)/(.005*tf));
[xc,uc,tc]=tlqh(A,B,Q,N,R,tf-t1,xa(N2,:)',Sf,Mf,psi,Ns);
N3=length(tc); un=ones(1,N3); tc=tc+t1*un;
%
% Combine 0 to t1 and t1 to tf segments:
x=[xa; xc']; u=[ua uc]; t=[ta; tc'];

	
   
   
	