function y=mmwrap(x,s,n)
%MMWRAP Form Matrix From Circular Shifted Vector.
% MMWRAP(X,S,N) returns a matrix created by repeated circular
% shifting of the vector X. If X is a row vector, the result has
% circularly shifted rows. If X is a column vector, the result 
% has circularly shifted columns. X is always the first row
% or column of the result.
% If S is a scalar each row or column is shifted S elements from 
% the previous row or column. If S is positive the shift is to the
% right or down. Negative S shifts to the left or up.
% N is the total number of rows or columns to create.
%
% If S is a vector, the i-th element of S determines the shift for
% the (i+1)-th row or column relative to the preceding one.
% If S is a vector, N is ignored and length(S)+1 rows or columns
% are created.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 7/19/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

xsiz=size(x);
xlen=length(x);
if ndims(x)>2 | prod(xsiz)~=xlen
   error('X Must be a Row or Column Vector.')
end
if nargin<2
   error('Two or Three Input Arguments are Required.')
end
s=s(:);
slen=length(s);
if any(fix(s)~=s)
   error('S Must Contain Integers.')
end
if slen==1 & nargin==2
   error('Missing Third Input Argument.')
elseif slen==1
   if length(n)>1 | fix(n)~=n
      error('N Must be an Integer.')
   end
   s=-s*(0:n-1);
else
   s=[0; -cumsum(s)];
end
x=x(:).';  % consider row case for now
[idxa,idxb]=meshgrid(1:xlen,s);
idxa=mod(idxa+idxb-1,xlen)+1; % wrap indices
y=x(idxa);
if diff(xsiz)<0 % input was a column
   y=y.';
end