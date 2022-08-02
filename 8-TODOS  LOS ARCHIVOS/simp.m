function z = simp(x,y,dim)
%SIMP  Simpson's method numerical integration.
%   Z = SIMP(Y) computes an approximation of the integral of Y via
%   the Simpson's method (with unit spacing) provided Y has an odd 
%   number of elements.  To compute the integral for spacing 
%   different from one, multiply Z by the spacing increment.
%
%   For vectors, SIMP(Y) is the integral of Y. For matrices, SIMP(Y)
%   is a row vector with the integral over each column. For N-D
%   arrays, SIMP(Y) works across the first non-singleton dimension.
%
%   Z = SIMP(X,Y) computes the integral of Y with respect to X using
%   the Simpson's method.  X and Y must be vectors of the same
%   length, or X must be a column vector and Y an array whose first
%   non-singleton dimension is length(X) provided X has an odd 
%   number of elements.  SIMP operates along this dimension.
%
%   Z = SIMP(X,Y,DIM) or SIMP(Y,DIM) integrates across dimension DIM
%   of Y. The length of X must be the same as size(Y,DIM)) provided X 
%   has an odd number of elements.
%
%   Example: If Y = [0 1 2
%                    3 4 5
%                    6 7 8]
%   then simp(Y,1) is [6 8 10] and simp(Y,2) is [2
%                                                8
%                                               14];
%   Class support for inputs X, Y:
%      float: double, single
%
%   See also SUM, CUMSUM, CUMTRAPZ, QUAD, TRAPZ.

%   Modifications of TRAPZ made by Shaun P. Simmons
%   ssimm008@gmail.com

%   Make sure x and y are column vectors, or y is a matrix.

perm = []; nshifts = 0;
if nargin == 3 % simp(x,y,dim)
  perm = [dim:max(ndims(y),dim) 1:dim-1];
  y = permute(y,perm);
  m = size(y,1);
elseif nargin==2 && isscalar(y) % simp(y,dim)
  dim = y; y = x;
  perm = [dim:max(ndims(y),dim) 1:dim-1];
  y = permute(y,perm);
  m = size(y,1);
  x = 1:m;
else % simp(y) or simp(x,y)
  if nargin < 2, y = x; end
  [y,nshifts] = shiftdim(y);
  m = size(y,1);
  if nargin < 2, x = 1:m; end
end
x = x(:);
if length(x) ~= m
  if isempty(perm) % dim argument not given
    error('MATLAB:simp:LengthXmismatchY',...
          'LENGTH(X) must equal the length of the first non-singleton dimension of Y.');
  else
    error('MATLAB:simp:LengthXmismatchY',...
          'LENGTH(X) must equal the length of the DIM''th dimension of Y.');
  end
end

% Make sure x has an odd number of elements.
if mod(m,2) == 0
    error('MATLAB:simp:LengthX',...
          'LENGTH(X) must be an odd number.');
end

% The output size for [] is a special case when DIM is not given.
if isempty(perm) && isequal(y,[])
  z = zeros(1,class(y));
  return;
end

% Sum of parabolic arcs computed with vector-matrix multiply.
size_y = size(y);
c1 = ones(m-1,prod(size_y(2:end))); c1(2:2:end) = 2; 
c2 = ones(m-1,prod(size_y(2:end))); c2(1:2:end-1) = 2; 
z = diff(x,1,1).' * (c1.*y(1:m-1,:) + c2.*y(2:m,:))/3;

siz = size(y); siz(1) = 1;
z = reshape(z,[ones(1,nshifts),siz]);
if ~isempty(perm), z = ipermute(z,perm); end


