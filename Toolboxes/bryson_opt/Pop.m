function [L,y,f]=pop(name,y,k,tol,eta,mxit)
%POP - gradient code for Para. Opt. Pbs. w. equality constraints
%[L,y,f]=pop(name,y,k,tol,eta,mxit)               
% Parameter OPtimization using a generalized gradient algorithm.
% Outputs L and y (p by 1) are optimum performance index & parameter 
% vector; constraints are f=0 where f is (n by 1) with n < p; user
% must supply a subroutine 'name' that computes L,f,Ly,fy; input y
% is a guess; y should be normalized so that a change of one unit in
% each element of y is approx. of same significance; k is a scalar
% step size parameter; stopping criterion is max(fn,dyn)<tol, where
% fn=norm(f); dyn=norm(dy)/sqrt(p); eta=fraction of constraint
% violation to be removed; mxit=max no iterations;     8/97, 6/18/02 
%
it=0; dyn=1; fn=1; p=length(y);
disp('    it        L        fn         dyn')
while max(fn,dyn) > tol
 [L,f,Ly,fy]=feval(name,y);  fn=norm(f);
 fyi=fy'/(fy*fy');	  % Generalized inverse
 lat=-Ly*fyi; Hy=Ly+lat*fy;  
 dy=-eta*fyi*f-k*Hy'; dyn=norm(dy)/sqrt(p);
 disp([it L fn dyn]); y=y+dy;
 if it> mxit, break, end
 it=it+1;
end







