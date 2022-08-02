function [f,t,y]=fop0f(p,name,s0,tf)  
% Fcn. OPtim. w. 0 term. constr. using Fwd shooting; p=la0' from a 
% converged solution of FOP0; s0(1,ns)=initial state vector, tf=spec. 
% final time; name must be in single quotes; two function files 'namee' 
% & 'name' must be in a directory on the MATLAB path, 'namee' giving
% the EL equations and 'name' giving (phi,phis) for flg=2; use FSOLVE
% to iterate p until f=0 to computer accuracy;            3/97, 8/12/02
%
ns=length(s0); la0=p([1:ns])'; y0=[s0; la0]; tol=1e-5;
optn=odeset('RelTol',tol);
[t,y]=ode23([name,'e'],[0 tf],y0,optn); N=length(t);
sf=y(N,[1:ns])'; [phi,phis]=feval(name,0,sf,tf,2);
f=y(N,[ns+1:2*ns])'-phis';
	
 	

