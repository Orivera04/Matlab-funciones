function [f,t,y]=fopcf1(p,u0,s0,tf)  
%FOPCF1 - Fcn. OPtim. w. terminal Constr. using Fwd. shooting;
%[f,t,y]=fopcf1(p,u0,s0,tf)  
   % p=[la0' nu'] from FOPC solution;  s0(1,ns)= initial state
   % vector; tf=final time; name must be in single quotes;
   % function file 'name' must be on the MATLAB path, giving
   % xdot for flg=1, (Phi,Phis) for flg=2, & (fs,fu) for flg=3;
   % use FSOLVE to iterate p until |f|<ep; problem script must
   % declare name global;                          3/97, 1/1/98
   %
global name uopt; ns=length(s0); la0=p([1:ns])'; n1=length(p);
nu=p([ns+1:n1])'; y0=[s0; la0]; tol=1e-4;
options=odeset('reltol',tol); uopt=u0;
[t,y]=ode23('el_int',[0 tf],y0,options); N=length(t);
sf=y(N,[1:ns])'; laf=y(N,[ns+1:2*ns])'; 
[Phi,Phis]=feval(name,uopt,sf,tf,2);
ef=laf-Phis'*[1;nu]; psi=Phi([2:n1-ns+1]);
f=[ef' psi'];
 	

