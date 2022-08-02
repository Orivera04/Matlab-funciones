function y=mmdiffsum(x,dim)
%MMDIFFSUM Differential Sum of Elements. (MM)
% MMDIFFSUM(X) for vector X is [X(1)+X(2) X(2)+X(3) ... X(n-1)+X(n)]
% For matrix X, MMDIFFSUM is the differential sum down each column,
% X(1:n-1,:)+X(2:n,:). For N-D arrays, MMDIFFSUM(X) is the differential
% sum along the first non-singleton dimension of X.
%
% MMDIFFSUM(X,DIM) returns the differential sum along the dimension DIM.
%
% Example: If X = [0 1 2
%                  3 4 5]
%
%          then MMDIFFSUM(X) and MMDIFFSUM(X,1) is [3 5 7]
%          and MMDIFFSUM(X,2) is [1 3
%                                 7 9]
%
% If SIZE(X,DIM)==1, the result is empty.
%
% See also DIFF, CUMSUM.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 2/5/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
   dim=min(find(size(x)>1));      % find first nonsingleton dimension >1
end
if isempty(x)  % empty x
   y=x;        % no work, just return empty
   return
end
xdim=ndims(x);
if prod(size(dim))~=1 | ... % check for weird dim
      round(dim)~=dim | ...
      dim<1 | ...
      dim>xdim
   error('Can''t Decipher DIM Variable.')
end
xsiz=size(x);
n=xsiz(dim);

perm=[dim:xdim 1:dim-1];      % put dim first
x=permute(x,perm);            % permute so dim is row dimension
x=reshape(x,n,prod(xsiz)/n);  % reshape into a 2D array

y=x(1:n-1,:)+x(2:n,:);        % Differential sum along row dimension

xsiz(dim)=n-1;                % new size of dim dimension
y=reshape(y,xsiz(perm));      % put result back in original form
y=ipermute(y,perm);           % inverse permute dimensions