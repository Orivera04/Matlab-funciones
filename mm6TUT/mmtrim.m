function x=mmtrim(x,tol)
%MMTRIM Trim Negligible Array Elements. (MM)
% MMTRIM(X) trims the elements of the array X using the
% following rules:
%
% Elements are set to zero that satisfy
% abs(x) < TOL*max(abs(X(:)))
%
% Complex portions of elements are set to zero if
% abs(imag(x)) < TOL*abs(real(x))
%
% Real portions of elements are set to zero if
% abs(real(x)) < TOL*abs(imag(x))
%
% MMTRIM(X,TOL) specifies the tolerance to use.
% TOL=1e-12 is the default.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 2/19/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<1 | ~isnumeric(x)
   error('First Input Argument Must be Numeric.')
end
if nargin<2
   tol=1e-12;
end
if max(size(tol))>1 | tol<eps
   error('Scalar TOL > EPS Required.')
end
m=max(abs(x(:))); % find max abs value
x(abs(x)<tol*m)=0;% first zero negligible elements
if ~isreal(x) % x contains complex elements
   ar=abs(real(x));
   ai=abs(imag(x));
   lidx=ar<tol*ai;            % logical index
   x(lidx)=j*imag(x(lidx));   % zero negligible real parts
   lidx(:)=ai<tol*ar;         % reuse logical index
   x(lidx)=real(x(lidx));     % zero negligible imag parts
end