function [f,t,y]=foptb(p,name,s0,nc)  
%FOPTB - Fcn. OPtim. w. open Tf using Bkwd. shooting;
%[f,t,y]=foptb(p,name,s0)
% p=[sf nu tf]; nc=no. controls;         7/97, 7/23//02
%
if nargin<4, nc=1; end; dum=zeros(nc,1); ns=length(s0);
sf=p([1:ns])'; n1=length(p); nu=p([ns+1:n1-1])';
global tf; tf=p(n1); 
[Phi,Phis,Phit]=feval(name,dum,sf,tf,2);
yf=[sf; Phis'*[1;nu]]; psi=Phi([2:n1-ns]);
[t,y]=ode23([name,'e'],[tf 0],yf);
N=length(t); e0=y(N,[1:ns])'-s0; 
ydot=feval([name,'e'],0,yf);  
Phidot=[1 nu']*[Phit+Phis*ydot([1:ns])];
f=[e0; psi; Phidot];
 	
	