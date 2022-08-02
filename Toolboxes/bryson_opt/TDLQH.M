function [x,u]=tdlqh(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,N)        
%TDLQH - Discrete LQ controller w. HTC's - trans. matrix soln.
%[x,u]=tdlqh(Ph,Ga,Qd,Nd,Rd,x0,Sf,Mf,psi,Ts,N) 
% TI plant, Mf*x(N)=psi, x(i+1)=Ph*x(i)+Ga*u(i), 2J=x'(N)*Sf*x(N)
% +sum(0:N)[x'(i)Qd*x(i)+2x'(i)*Nd*u(i)+u'(i)Rd*u(i)]; N=no.
% steps; Ts=sample time=tf/N; simulates w. initial state x0 and
% final psi;                                       12/97, 6/18/02
%
% Transition matrix Ph1 of disc. E-L eqns:
[nt,ns]=size(Mf); G1=Ga'/Ph'; R1=Rd-G1*Nd; N1=Nd'-G1*Qd;
G2=Ga/R1; N2=Nd/R1; TM=[Ph-G2*N1 -G2*G1; -Ph'\(Qd-N2*N1) ...
     Ph'\(eye(ns)+N2*G1)]; Ph1=TM^N;                          
%
% Partitions transition matrix:
n1=[1:ns]; n2=[ns+1:2*ns]; F1=Ph1(n1,n1); F2=Ph1(n1,n2);
F3=Ph1(n2,n1); F4=Ph1(n2,n2); 
%
% lambda(0) and nu in the TPBVP;
M1=[Mf*F2 zeros(nt); F4-Sf*F2 -Mf']; M2=[-Mf*F1 eye(nt);
Sf*F1-F3 zeros(ns,nt)]; ln=M1\(M2*[x0;psi]); la0=ln(n1);
nu=ln(ns+1:ns+nt);
%
% Optimal state and control sequences
x=zeros(ns,N+1); la=x; [ns,nc]=size(Ga); u=zeros(nc,N);
yl=[x0; la0]; x(:,1)=yl(n1); la(:,1)=yl(n2); 
for i=1:N, yl=TM*yl; x(:,i+1)=yl(n1); la(:,i+1)=yl(n2); end
for i=1:N, u(:,i)=-Rd\(Nd'*x(:,i)+Ga'*la(:,i+1)); end 
       



	
	
	