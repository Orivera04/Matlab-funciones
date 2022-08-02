function [f,s,la0]=fop0n(p,name,s0,tf)
%FOP0N - Function OPtimization with 0 term. constraints 
%[f,s,la0]=fop0n(p,name,s0,tf)
% Integrates plant eqns fwd., then adjoint eqns bkwd; a N-R 
% code since FSOLVE perturbs p=u to make Hu=0; name must be in
% single quotes; function file 'name' computes sdot=f(s,u) for
% flg=1, (phi,phis) for flg=2, and (fs,fu) for flg=3. Inputs:
% p(:,1)=guess of control history at EQUAL time steps; tf=spec.
% final time; s0(ns,1)=initial state; Outputs: f=Hu; s=optimal
% state histories; la0=initial adjoint vector;    1/98, 9/14/02 			
%
[t,s]=odeu(name,p,s0,tf); 
[f,phi,psi,la0]=odeh(name,p,s,tf); 

