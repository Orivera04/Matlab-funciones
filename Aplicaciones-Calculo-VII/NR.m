
function [r, niter] = NR(f, J, x0, tol, rerror, maxiter, varargin)

% Zero r of the nonlinear system of equations f(x) = 0.
% Here J is the Jacobian matrix of f and x0 is the initial 
% approximation of the zero r.
% Computations are interrupted either if the norm of 
% f at current approximation is less (in magnitude) 
% than the number tol, or if the relative error of two 
% consecutive approximations is smaller than the prescribed 
% accuracy rerror, or if the number of allowed iterations 
% maxiter is attained.
% The second output parameter niter stands for the number
% of performed iterations.

if isempty(tol)
   tol = 100*eps;
end
if isempty(rerror)
   rerror = 100*eps;
end
x0 = x0(:);
Jc = feval(J,x0,varargin{:});
if rcond(Jc) < 1e-10
   error('Try a new initial approximation x0.')
end
xold = x0;
xnew = xold - Jc\feval(f,xold,varargin{:});
for k=1:maxiter
   xold = xnew;
   niter = k+1;
   Jc = feval(J,xold,varargin{:});
   if rcond(Jc) < 1e-10
      error('Try a new initial approximation x0.')
   end
   xnew = xold - Jc\feval(f,xold,varargin{:});
   if (norm(feval(f,xnew,varargin{:})) < tol) |...
         norm(xold - xnew,'inf')/norm(xnew,'inf') < rerror|...
         (niter == maxiter)
      break
   end
end
r = xnew(:);


