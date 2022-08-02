function [x,u,t,tk,K,uf]=tlqsr(A,B,Q,N,R,tf,x0,Mf,Qf,psi,tol) 
%TLQSR - Time-varying LQ ctrl w. Soft TCs - Riccati soln.
%[x,u,t,tk,K]=tlqsr(A,B,Q,N,R,tf,x0,Mf,Qf,psi,tol)                  
% TI plant, xdot=A*x+B*u, x(0)=x0, 2J=ef'Mf'*Qf*Mf*ef+int(0:tf)
% (x'*Q*x+2*x'*N*u+u'*R*u)dt, ef=Mf*x(tf)-psi; (x,u) are 
% (state, control) histories at times t; K is fdbk gain and 
% uf=fdfwd control at times tk;                   8/97, 7/11/02
%
Sf=Mf'*Qf*Mf; gf=-Mf'*Qf*psi; yf=[forms(Sf); gf];
optn=odeset('reltol',tol); 
[tk,y]=ode23('tlqs_b',[tf 0],yf,optn,A,B,Q,N,R); N1=length(tk); 
%
% Gain matrix K(t) and uf(t) from y(t):
[ns,nc]=size(B); K=zeros(N1,ns*nc); n1=ns*(ns+1)/2; 
ys=y(:,[1:n1]); g=y(:,[1+n1:n1+ns])'; uf=zeros(N1,nc); 
for i=1:N1, 
  S=forms(ys(i,:)'); K(i,:)=formm(R\(N'+B'*S),'r');
  uf(i,:)=formm(-R\(B'*g(:,i)),'r');
end
disp('K(t) and uf(t) computed')
%
% Simulate closed-loop system:
[t,x]=ode23('tlqs_f',[0 tf],x0,optn,A,B,tk,K,uf); 
N2=length(t); u=zeros(nc,N2);
for i=1:N2
  Kt=formm(interp1(tk,K,t(i)),ns);
  uft=interp1(tk,uf,t(i)); u(:,i)=uft'-Kt*x(i,:)';
end

	

	
