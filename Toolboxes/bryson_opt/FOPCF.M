function [f,t,y]=fopcf(p,name,s0,tf,nc)  
%FOPCF - Fcn. OPtim. w. terminal Constr. using Fwd. shooting;
% p=[la0' nu'] from FOPC solution;  s0(1,ns)=initial state vector;
% tf=spec. final time; name must be in single quotes; two function
% files 'namee' and 'name' must be in a directory on the Matlab path,
% 'namee' containing the EL equations, 'name' containing (Phi,Phis)
% for flg=2; f=laf'-phis-nu'*psis,psi'; use FSOLVE to iterate p 
% until f=0 to computer accuracy;                      3/97, 8/14/02
%
if nargin<5, nc=1; end; dum=zeros(nc,1); ns=length(s0);
la0=p([1:ns])'; n1=length(p); nu=p([ns+1:n1])'; y0=[s0; la0]; 
tol=1e-3; optn=odeset('reltol',tol); 
[t,y]=ode23([name,'e'],[0 tf],y0,optn);
N=length(t); sf=y(N,[1:ns])'; laf=y(N,[ns+1:2*ns])'; 
[Phi,Phis]=feval(name,dum,sf,tf,2); ef=laf-Phis'*[1; nu];
psi=Phi([2:n1-ns+1]); f=[ef' psi'];
 	

