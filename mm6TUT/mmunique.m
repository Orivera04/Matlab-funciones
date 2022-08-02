function [b,n]=mmunique(a,tol)
%MMUNIQUE Set Unique Within Tolerance. (MM)
% MMUNIQUE(A,TOL) for an array A returns the components of
% A that are unique within a tolerance of +/- TOL. If TOL is not
% given, TOL=0. When elements differ by less than +/- TOL,
% the element with the largest absolute value is returned.
% The returned array is sorted. A cannot contain NaNs or Infs.
%
% [B,N]=MMUNIQUE(A,TOL) also returns the index vector N where
% B=A(N).
%
% This function is up to 3 times faster than UNIQUE.
%
% See also UNIQUE.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 9/21/99, 12/28/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
   tol=0;
elseif ~isnumeric(tol)|length(tol)>1|(tol<eps)
   error('TOL Must be a Positive Real Scalar.')
end
if ~isnumeric(a) | any(isnan(a)) | any(isinf(a))
   error('A Must be Numeric and Not Contain NaNs or Infs.')
end
[b,n]=sort(a(:));
d=logical(zeros(size(b)));
d(1:end-1)=abs(diff(b))<=tol;
b(d)=[];
if nargout==2
   n(d)=[];
end
if ndims(a)==2 & size(a,1)==1
   b=b.';
   n=n.';
end