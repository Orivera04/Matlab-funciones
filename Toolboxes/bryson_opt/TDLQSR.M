function [x,u,K,uf]=tdlqsr(Ad,Bd,Qd,Nd,Rd,x0,Cf,Qf,yf,Ts,Ns)
%TDLQSR - Time-varying Discrete LQ controller with Soft TC's,
% [x,u,K,uf]=tdlqsr(Ad,Bd,Qd,Nd,Rd,x0,Cf,Qf,yf,Ts,Ns)
% RICCATI MATRIX solution; TI plant, x(k+1)=Ad*x(k)+Bd*u(k), x(0)=x0;
% ef=Qf*Cf*x(N)-yf, 2J=ef'*Qf*ef+sum(0:N)[x'(k)*Qd*x(k)+2x'(k)*Nd*u(k)
% +u'(k)*Rd*u(k)]; Ns=number of steps; Ts=tf/Ns; computes bkwd Riccati
% matrix S(i) & vector lb(i), stores fdbk gain matrix K(i) & fdfwd
% vector uf(i); simulates closed-loop system;             7/97, 6/4/02
%           
% Sequences S(k) & lb(k) backward :
[ns,nc]=size(Bd); x=zeros(ns,Ns+1); u=zeros(nc,Ns); K=zeros(nc,ns,Ns);
uf=u; S=Cf'*Qf*Cf; lb=Cf'*Qf*yf;
for k=Ns:-1:1,
  Zxx=Qd+Ad'*S*Ad; Zxu=Nd+Ad'*S*Bd; Zuu=Rd+Bd'*S*Bd;
  K1=Zuu\Zxu'; uf(:,k)=Zuu\(Bd'*lb);
  S=Zxx-Zxu*K1; lb=(Ad-Bd*K1)'*lb; K(:,:,k)=K1;
end 
%       
% Sequences closed-loop system forward:
x(:,1)=x0;
for k=1:Ns, 
  u(:,k)=uf(:,k)-K(:,:,k)*x(:,k); x(:,k+1)=Ad*x(:,k)+Bd*u(:,k);
end 
	