function x=mmfminc(fun,xo,k,tol,options)
%MMFMINC Function Minimization with Inequality Constraints. (MM)
% X=MMFMINC(FUN,Xo,K,TOL,OPTIONS) find X that minimizes a scalar
% function of a vector argument f(X), subject to a vector of 
% inequality constraints G(X)<=0 as desribed by FUN.
% MMFMINC solves:    min f(X)   subject to  G(X)<=0
%                     X
% A simple penalty function approach is used. The cost function
%         P(X,K(i)) = f(X) + K(i)*sum((G(X)>0).*G(X).^2)
% is minimized using FMINSEARCH for each successive value K(i) using
% TOL(i) as the desired tolerance on X and P(X,K(i)) for the (i)th pass.
% Normally K is strictly increasing and TOL is strictly decreasing.
% OPTIONS is optional parameter structure as returned by OPTIMSET
% to set specific options for FMINSEARCH.
%
% FUN is a function handle or a function M-file that evaluates
% [f,G]=FUN(X), where f=f(X) is a scalar and G=G(X).
%
% See also FMINSEARCH, OPTIMSET, FEVAL.

% Reference: D.A. Wismer and R. Chattergy, Introduction to Nonlinear
% Optimization: A Problem Solving Approach, Elsevier North Holland, NY, 1978.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 7/18/96, v5: 1/14/97, 9/27/99, 2/25/01
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[f,g]=feval(fun,xo);
if length(f)>1
   error('f(X) Must Return a Scalar.')
end

k=sort(abs(k(:)));
klen=length(k);
if length(tol)==1
   tol=repmat(tol,klen,1);
end
x=xo;
if nargin<5
   options=optimset;
end
options=optimset(options,'Display','off');
for i=1:klen
   options=optimset(options,'TolFun',tol(i),'TolX',tol(i));;
   [x,fval,xflag]=fminsearch('mmfminc_',x(:),options,fun,k(i));
   if ~xflag
      disp(['Solution May be Incorrect: ';...
            'Maximum Iterations Reached.';...
            'Increase N, Try New Initial';...
            'Estimates or Increase TOL  '])
      fprintf('Error at K = %.4g\n',k(i))
      return
   end
end
