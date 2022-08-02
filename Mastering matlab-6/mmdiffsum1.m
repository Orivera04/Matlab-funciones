function y=mmdiffsum1(x,dim)
%MMDIFFSUM Differential Sum of Elements.
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

if nargin==1   % dim not given
  dim=min(find(size(x)>1)); % find first nonsingleton dimension >1
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
tmp=repmat({':'},1,xdim); % cells of ':'
c1=tmp;
c1{dim}=1:xsiz(dim)-1;    % poke in 1:end-1
c2=tmp;
c2(dim)={2:xsiz(dim)};    % poke in 2:end

y=x(c1{:})+x(c2{:});