function [f,t,y]=foptf(p,name,s0,nc)  
% Fcn. OPtim. w. open final Time using Fwd. shooting and FSOLVE;
% nc=no. controls                                   7/97, 2/5/98
%
if nargin<4, nc=1; end; dum=zeros(nc,1);
ns=length(s0); np=length(p); n1=1:ns; la0=p(n1)'; 
nu=p([ns+1:np-1])'; tf=p(np); y0=[s0; la0];
optn=odeset('reltol',1e-4);
[t,y]=ode23([name,'e'],[0 tf],y0,optn);
N=length(t); sf=y(N,n1); laf=y(N,[ns+1:2*ns])'; 
[Phi,Phis,Phit]=feval(name,dum,sf,tf,2);
ydot=feval([name,'e'],tf,y(N,:));
Phidot=Phit+Phis*ydot(n1,1); ef=laf-Phis'*[1;nu];
psi=Phi([2:np-ns]); Phd=[1 nu']*Phidot; f=[ef' psi' Phd];
 	

