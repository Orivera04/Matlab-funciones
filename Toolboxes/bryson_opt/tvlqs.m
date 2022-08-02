function [t,y]=tvlqs(name,tf,s0,Mf,Qf,psi)
%[t,y]=tvlqs(name,tf,s0,Mf,Qf,psi)
% TVLQS - Time-Varying LQ opt. w. Soft term. constraints; dot(s)=
% A(t)*s+B(t)*u; 2J=ef'Qf*ef+int(0:tf)(u'*R*u)dt, ef=Mf*s(tf)-psi;
% u=control histories at points t; subroutine 'name' must give 
% dot(y) for EL eqns, given (t,y) where y=[s; la];   8/02, 9/13/02
%
% Backward transition matrix from t=tf to t=0:
ns=length(s0); phf=eye(2*ns); optn=odeset('RelTol',1e-5); 
for i=1:2*ns
 [t,s]=ode23(name,[tf 0],phf(:,i),optn); ph(:,i)=s(length(t),:)';
end
%
% Partition backward transition matrix:
n1=1:ns; n2=1+ns:2*ns;
F1=ph(n1,n1); F2=ph(n1,n2); F3=ph(n2,n1); F4=ph(n2,n2);
%
% Find sf=s(tf) and la0=lambda(0) in the TPBVP;
Sf=Mf'*Qf*Mf; a=Mf'*Qf*psi; sf=(F1+F2*Sf)\(s0+F2*a);
la0=(F3+F4*Sf)*sf-F4*a;
%
% Optimal state and adjoint histories:
[t,y]=ode23(name,[0 tf],[s0; la0],optn);

