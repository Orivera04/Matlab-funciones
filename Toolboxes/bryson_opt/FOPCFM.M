function [f,t,y]=fopcfm(p,name,s0,t1,tf)
%FOPCFM - Fcn. OPtim. w. term. Constr. using Fwd. Multishooting;
%[f,t,y]=fopcfm(p,name,s0,t1,tf)
   % p=[la0; nu; y1] from FOPC solution; y1=[s(t1); la(t1)]'; s0=s(0)
   % (row); t1=intermediate time; tf=final time; name must be in single
   % quotes; two function  files 'namee' and 'name' must on the MATLAB
   % path, 'namee' containing the fwd constraint functions 
   % f=laf'-phis-nu'*psis, psi';                    6/97, 2/98, 6/23/98
%
ns=length(s0); np=length(p); la0=p([1:ns])'; nu=p([ns+1:np-2*ns])';
y1=p([np-2*ns+1:np]); y0=[s0; la0]; optn=odeset('reltol',1e-4);
[tv1,yv1]=ode23([name,'e'],[0 t1],y0,optn); N1=length(tv1);
e1=yv1(N1,:)-y1; [tv2,yv2]=ode23([name,'e'],[t1 tf],y1,optn);
N=length(tv2); yf=yv2(N,[1:ns])'; laf=yv2(N,[ns+1:2*ns])'; 
[Phi,Phis]=feval(name,0,yf,tf,2); ef=laf-Phis'*[1;nu];
psi=Phi([2:np-3*ns+1]); t=[tv1; tv2]; y=[yv1; yv2]; f=[ef' psi' e1];
 	

