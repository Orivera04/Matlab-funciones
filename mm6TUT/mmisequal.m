function tf=mmisequal(a,b,tol,rtol)
%MMISEQUAL True for Elements Equal Within a Tolerance. (MM)
% MMISEQUAL(A,B,TOL) returns an array the same size as A or B
% containing logical True where abs(A-B)<=TOL.
% MMISEQUAL(A,B,TOL,RTOL) returns an array the same size as
% A or B containing logical True where abs(A-B)<= TOL + RTOL*A.
%
% If A or B is a scalar, it is expanded to match the other argument.
% If TOL is not given, TOL=eps*max(abs(A),abs(B)) is used.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 7/9/99, 4/01/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~isnumeric(a)|~isreal(a)|~isnumeric(b)|~isreal(b)
   error('A and B Must be Real Numeric Arrays.')
end
if nargin==2 | (nargin>2 & isempty(tol))
   tol=eps*max(abs(a),abs(b));
elseif ~isnumeric(tol)|~isreal(tol)|any(tol<eps)
   error('TOL Must be a Real Positive Value.')
end
if any(size(a)~=size(b)) & length(a)~=1 & length(b)~=1
   error('A and B Must be the Same Size or One be a Scalar.')
end
if nargin<4
   tf=abs(a-b)<=tol;
else
   if ~isnumeric(rtol)|~isreal(rtol)|any(rtol<0)
      error('RTOL Must be Real and Nonnegative.')
   end
   tf=abs(a-b)<=(tol+rtol.*a);
end