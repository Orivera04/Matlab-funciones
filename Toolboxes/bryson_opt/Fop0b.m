function [f,t,y]=fop0b(sf,name,s0,tf)  
% Fcn. OPtim. w. 0 term. constr. using Bkwd. shooting. Inputs; sf=estimate
% from a converged solution of FOP0; s0=initial state vector; tf=final
% time; name must be in single quotes; function files 'namee' & 'name' 
% must be on the MATLAB path; 'namee' ==> EL eqns, 'name' ==> (phi,phis)
% for flg=2; use FSOLVE to iterate p until f=0 to desired accuracy;
%                                                         3/97, 6/18/02
%
ns=length(s0); [phi,phis]=feval(name,0,sf,tf,2); yf=[sf; phis'];
tol=1e-5; options=odeset('reltol',tol);
[t,y]=ode23([name,'e'],[tf 0],yf,options); N=length(t);
f=y(N,[1:ns])'-s0;
	
 	

