function xx=mmsubdiv(x,n)
%MMSUBDIV Subdivide Vector Values. (MM)
% MMSUBDIV(X,N) returns a vector formed from X where successive values
% are subdivided into N intervals marked by N-1 linearly spaced points.
%
% For example, MMSUBDIV(X,2) returns the vector:
%
% [X(1) 0.5*(X(1)+X(2)) X(2) 0.5*(X(2)+X(3)) X(3) ...]
%
% The output vector contains N*(length(X)-1)+1 points.
%
% See also MMREPEAT.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/29/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ndims(x)~=2 | prod(size(x))~=length(x)
   error('X Must be a Vector.')
else
   [r,c]=size(x);
end
x=x(:)'; % make x a row vector
xlen=length(x);
n=abs(round(n(1)));
if n<2
   xx=reshape(x,r,c);
else
   xx=repmat(x(1:end-1),n,1);
   d=repmat((0:n-1)'/n,1,xlen-1);
   dx=repmat(diff(x),n,1);
   xx=xx+d.*dx;
   
   xx=[xx(:); x(xlen)];
   if c>1, xx=xx'; end
end
