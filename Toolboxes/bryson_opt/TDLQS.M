function [x,u]=tdlqs(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,Ns) 
%TDLQS - Time-varying Discrete LQ regulator w. Soft TC's
% [x,u]=tdlqs(Ph,Ga,Qd,Nd,Rd,x0,Mf,Qf,psi,Ts,Ns)                  
% Time-varying Discrete LQ controller with Soft TC's; TI plant; 
% x(k+1)=Ph*x(k)+Ga*u(k), ef=Mf*x(N)-psi, 2J=ef'*Qf*ef+sum(0:N)
% [x'(k)*Qd*x(k)+2x'(k)*Nd*u(k)+u'(k)*Rd*u(k)], Ns=no. steps,
% Ts=sample time=tf/N; transition matrix solution; 2/95, 6/18/02
%
% Transition matrix Ph1 of discrete E-L eqns:
[ns,nc]=size(Ga); G1=Ga'/Ph'; R1=Rd-G1*Nd; N1=Nd'-G1*Qd;
G2=Ga/R1; N2=Nd/R1; TM=[Ph-G2*N1 -G2*G1; -Ph'\(Qd-N2*N1) ...
   Ph'\(eye(ns)+N2*G1)]; Ph1=TM^Ns;                          
%
% Partitions transition matrix:
n1=[1:ns]; n2=[ns+1:2*ns]; F1=Ph1(n1,n1); F2=Ph1(n1,n2);
F3=Ph1(n2,n1); F4=Ph1(n2,n2); 
%
% lambda(0) in the TPBVP;
Sf=Mf'*Qf*Mf; a=Mf'*Qf*psi; la0=(F4-Sf*F2)\((Sf*F1-F3)*x0-a);
%
% Optimal state and control sequences
x=zeros(ns,Ns+1); la=x; u=zeros(nc,Ns);
yl=[x0; la0]; x(:,1)=yl(n1); la(:,1)=yl(n2); 
for i=1:Ns
   u(:,i)=-R1\(N1*yl(n1)+G1*yl(n2));
   yl=TM*yl; x(:,i+1)=yl(n1); la(:,i+1)=yl(n2);
end
       
