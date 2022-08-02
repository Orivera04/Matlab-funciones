function [f,s,u,la0]=fopcn(p,name,s0,tf)   
%FOPCN - Func. OPtim. w. term. Constr, using  N-R algor. w. FSOLVE
% [f,s,u,la0]=fopcn(p,name,s0,tf); integrates plant eqns fwd., 
% adjoint eqns bkwd; SCALAR u; a N-R code since FSOLVE perturbs 
% p=[u nu]; name must be in single quotes; func. file 'name' give
% sdot=f(s,u) for flg=1, perf. index phi, term. constr. psi for 
% flg=2, & fs,fu for flg=3; inputs: p=[u nu] where u(1,N+1)=guess
% of control history, nu(1,nt)=guess of terminal constraint
% Lagrange multipliers; s0(ns,1)=initial state; tf=spec. final
% time; outputs: f=[Hu psi']; s=optimal state histories; la0=
% initial adjoint vector;                            2/97, 9/14/02
%
Phi=feval(name,0,s0,0,2); nt=length(Phi)-1; N=length(p)-nt; 
u=p(1:N); nu=p(N+1:N+nt); [t,s]=odeu(name,u,s0,tf);
[Hu,phi,la0,psi]=odehnu(name,u,s,tf,nu); f=[Hu psi'];


