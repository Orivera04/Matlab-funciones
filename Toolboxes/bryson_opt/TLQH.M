function [x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns)
%TLQH - Time-varying LQ ctrl w. Htc's, TM method
%[x,u,t]=tlqh(A,B,Q,N,R,tf,x0,Sf,Mf,psi,Ns)                
% TI plant, xdot=Ax+Bu, x(0)=x0, Mf*x(tf)=psi, 2J=xf'*Sf*xf
% +int(0:tf)(x'Q*x+2x'*N*u+u'R*u)dt, Ns=number of steps in t;
% (x,u)=(state,control) histories at t;         8/97, 6/18/02
%
% Bkwd trans. matrix of EL eqns, t=tf to t=0:
Qb=Q-N*(R\N'); Ab=A-B*(R\N'); H=[Ab -B*(R\B'); -Qb -Ab'];
Phi=expm(-H*tf);                        
%
% Partition transition matrix:
[nt,ns]=size(Mf); n1=[1:ns]; n2=[ns+1:2*ns]; 
F1=Phi(n1,n1); F2=Phi(n1,n2); F3=Phi(n2,n1); F4=Phi(n2,n2); 
%
% Solve for xf, nu and la0 in the TPBVP;
Z=[F1+F2*Sf F2*Mf'; Mf zeros(nt)]; b=Z\[x0; psi];
xf=b(n1); nu=b([ns+1:ns+nt]); la0=F3*xf+F4*(Sf*xf+Mf'*nu);
%
% Optimal state and control histories:
xa0=[x0; la0]; t=tf*[0:1/Ns:1]; 
for i=1:Ns+1
 xa(:,i)=expm(H*t(i))*xa0; x(:,i)=xa(n1,i); 
 u(:,i)=-R\(B'*xa(n2,i)+N'*x(:,i));
end