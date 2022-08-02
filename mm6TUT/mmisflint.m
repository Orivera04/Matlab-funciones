function tf=mmisflint(x,tol)
%MMISFLINT True for Floating Point Integers. (MM)
% MMISFLINT(X) returns an array the size of X containing
% logical TRUE (1) where the elements of X are floating
% point integers. Logical False (0) is returned otherwise.
%
% MMISFLINT(X,Tol) returns logical True where elements in
% X are within Tol of a floating point integer.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 11/18/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~isnumeric(x)|~isreal(x)
   error('X Must be a Real Numeric Array.')
end
if nargin==1
   tf=(x==fix(x));
elseif nargin==2
   tf=(abs(x-floor(x))<=tol)|(abs(x-ceil(x))<=tol);
end
