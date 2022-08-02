function [x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns) 
%TLQS - Time-varying LQ regulator w. Soft term. constraints 
% [x,u,t]=tlqs(A,B,Q,N,R,tf,x0,Mf,Qf,psi,Ns)                  
% Time-invariant plant, finite-time performance index;
% xdot=A*x+B*u, x(0)=x0; 2J=ef'Qf*ef+int(0:tf)(x'*Q*x
% +2*x'*N*u+u'*R*u)dt, ef=Mf*x(tf)-psi; Ns=no. steps in t; 
% (x,u)=(state,control) histories at points t; 2/91, 6/18/02
%
% Transition matrix of E-L eqns, t=tf to t=0:
Qb=Q-N*(R\N'); Ab=A-B*(R\N'); H=[Ab -B*(R\B'); -Qb -Ab'];
Ph=expm(H*tf);	                                             
%
% Partition transition matrix:
ns=length(x0); n1=[1:ns]; n2=[ns+1:2*ns];
F1=Ph(n1,n1); F2=Ph(n1,n2); F3=Ph(n2,n1); F4=Ph(n2,n2); 
%
% Solve for lambda(0) in the TPBVP;
Sf=Mf'*Qf*Mf; a=Mf'*Qf*psi; la0=(F4-Sf*F2)\((Sf*F1-F3)*x0-a);
%
% Optimal state and control histories:
y0=[x0; la0]; t=tf*[0:1/Ns:1]; 
for i=1:Ns+1, y(:,i)=expm(H*t(i))*y0; x(:,i)=y(n1,i); 
   u(:,i)=-R\([N' B']*y(:,i));
end

