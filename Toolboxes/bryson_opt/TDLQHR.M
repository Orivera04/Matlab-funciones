function [x,u,K,Kf]=tdlqhr(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,N,nf)        
%TDLQHR - Discrete LQ controller w. HTC's, Riccati solution
%[x,u,K,Kf]=tdlqhr(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,N,nf) 
% TI plant; x(i+1)=Ph*x(i)+Ga*u(i), 2J=x'(N)*Sf*x(N)+sum(0:N)
% [x'(i)Qd*x(i)+2x'(i)*Nd*u(i)+u'(i)*Rd*u(i)], Mf*x(N)=psi;
% N=number of steps; Ts=tf/N; computes bkwd Riccati matrix S(i)
% and aux. matrices M(i), Qc(i); stores K(i) and Kf(i) where
% u(i)=-K(i)*x(i)+Kf(i)*psi; simulation uses open-loop control
% for last nf steps to avoid high gains;          8/97, 6/4/02
%
% Bkwd sequencing of S(i), M(i), Qc(i):
[ns,nc]=size(Ga); [nt,ns]=size(Mf); S=Sf; Qc=zeros(nt); 
K=zeros(nc,ns,N-nf); Kf=zeros(nc,nt,N-nf); M1=Mf;
for i=N:-1:1
 Zxx=Qd+Ph'*S*Ph; Zxu=Nd+Ph'*S*Ga; Zuu=Rd+Ga'*S*Ga;
 Qc=Qc+M1*Ga*(Zuu\Ga')*M1'; M=M1*(Ph-Ga*(Zuu\Zxu'));
 if i<=N-nf
    K(:,:,i)=Zuu\(Zxu'+Ga'*M1'*(Qc\M)); 
   Kf(:,:,i)=(Zuu\Ga')*(M1'/Qc);
 end
 S=Zxx-Zxu*(Zuu\Zxu'); M1=M;                        
end
%
% Simulation of closed-loop system i=1 to N-nf:
x1=zeros(ns,N-nf+1); x1(:,1)=x0; u1=zeros(nc,N-nf);
for i=1:N-nf
 u1(:,i)=-K(:,:,i)*x1(:,i)+Kf(:,:,i)*psi; 
 x1(:,i+1)=Ph*x1(:,i)+Ga*u1(:,i);
end
%
% Simulation i=N-nf+1 to N; optimal open-loop system based
% on x1(:,N-nf+1):
[x2,u2]=tdlqh(Ph,Ga,Qd,Nd,Rd,x1(:,N-nf+1),Sf,Mf,psi,Ts,nf); 
x=[x1 x2(:,[2:nf+1])]; u=[u1 u2];