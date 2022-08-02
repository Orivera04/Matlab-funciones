function c=mmintersect(a,b,tol)
%MMINTERSECT Set Intersection Within Tolerance. (MM)
% MMINTERSECT(A,B,TOL) for numerical arrays A and B returns the
% the components common to both A and B within a tolerance of +/- TOL.
% If TOL is not given, TOL=0. When elements in A and B differ by
% less than +/- TOL, the element with the smallest absolute value is
% returned. The returned array is sorted.
%
% See also MMUNIQUE, INTERSECT.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 9/28/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==2
   tol=0;
elseif ~isnumeric(tol)|length(tol)>1|(tol<eps)
   error('TOL Must be a Positive Real Scalar.')
end
if ~isnumeric(a)|~isnumeric(b)
   error('A and B Must be Numeric.')
end
row=(ndims(a)==2&(size(a,1)==1) | (ndims(b)==2&size(b,1)==1));
a=mmunique(a(:));
b=mmunique(b(:));
c=sort([a;b]);
d=logical(ones(size(c)));
d(1:end-1)=abs(diff(c))>tol;
c(d)=[];
if row
   c=c.';
end
