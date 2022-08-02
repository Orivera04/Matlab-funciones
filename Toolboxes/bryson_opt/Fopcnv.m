function [f,s,la0]=fopcnv(p,name,s0,tf,nc)   
%FOPCNV - Func. OPtim. w. term. Constr, using  N-R algor. w. FSOLVE;
% [f,s,la0]=fopcnv(p,name,s0,tf,nc); E-L eqns, plant eqns fwd., adjoint
   % eqns bkwd; vector u (nc components); a N-R code since FSOLVE
   % perturbs p=[uv nu']; name must be in single quotes; func. file
   % 'name' computes sdot=f(s,u) for flg=1, Phi=[phi; psi] for flg=2,
   % and fs,fu for flg=3; inputs: uv=u(1,nc*(N+1))=guess of control
   % histories; nu(1,nt)=guess of terminal constraint Lagrange
   % multipliers; tf=spec. final time; s0=initial state (ns by 1);
   % outputs: f=[Hu(1,nc*(N+1) psi']; s=optimal state histories;
   % la0=initial adjoint vector;                      2/97, 9/13/97
	%
	ns=length(s0); Phi=feval(name,zeros(nc,1),s0,1,2); nt1=length(Phi);  
	N1=(length(p)-nt1+1)/nc; s=zeros(ns,N1); Hu=zeros(1,N1*nc);
   for i=1:nc, u(i,[1:N1])=p([N1*(i-1)+1:N1*i]); end;
   nu=p([N1*nc+1:N1*nc+nt1-1]);
   [t,s]=odeu(name,u,s0,tf);
   [Hu,phi,la0,psi]=odehnuv(name,u,s,tf,nu);
   f=Hu(1,:); if nc>1, for i=2:nc, f=[f Hu(i,:)]; end; end;
   f=[f psi'];


