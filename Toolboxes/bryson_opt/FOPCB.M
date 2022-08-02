function [f,t,y]=fopcb(p,name,s0,tf,nc)  
% Function OPtimization w. terminal Constraints using Bkwd. shooting;
%[f,t,y]=fopcb(p,name,s0,tf)  
% p=[sf' nu'] is an estimate from a converged soln. of FOPC; s0=
% desired initial state vector; tf=spec. final time; f=[init. state
% error, psi]; name must be in single quotes; function files 'namee'
% & 'name' must be on the MATLAB path, 'namee' containing the E-L
% eqns, 'name' containing (Phi,Phis); use FSOLVE to iterate p until
% f=0 to desired accuracy;                             3/97, 2/5/98
%
if nargin<5, nc=1; end; dum=zeros(nc,1); ns=length(s0); sf=p([1:ns])'; 
[Phi,Phis]=feval(name,dum,sf,tf,2); nt1=length(Phi);
nu=p([ns+1:ns+nt1-1])'; psi=Phi([2:nt1]); yf=[sf; Phis'*[1; nu]];
tol=1e-5; options=odeset('reltol',tol); 
[t,y]=ode23([name,'e'],[tf 0],yf,options); N=length(t);   
f=[y(N,[1:ns])'-s0; psi];
	
 	

