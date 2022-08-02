function P = pascal(n,k)
%PASCAL Pascal matrix.
%	PASCAL(N) is the Pascal matrix of order N: a symmetric positive
%	definite matrix with integer entries, made up from Pascal's
%	triangle.  Its inverse has integer entries.
%	PASCAL(N,1) is the lower triangular Cholesky factor (up to signs
%	of columns) of the Pascal matrix.  It is involutary (is its own
%	inverse).
%	PASCAL(N,2) is a transposed and permuted version of PASCAL(N,1)
%	which is a cube root of the identity.

%	Author: N.J. Higham 6-23-89
%	Copyright (c) 1984-94 by The MathWorks, Inc.


if nargin == 1
    k = 0;
end

if max(size(k)) ~= 1
  error('Second argument must be a scalar.')
end

P = diag((-1).^[0:n-1]);
P(:,1) = ones(n,1);

% Generate the Pascal Cholesky factor (up to signs).
for j=2:n-1
    for i=j+1:n
        P(i,j) = P(i-1,j) - P(i-1,j-1);
    end
end

if k == 0
    P = P*P';
elseif k == 2
    P = P';
    P = P(n:-1:1,:);
    for i=1:n-1
        P(i,:) = -P(i,:);
        P(:,i) = -P(:,i);
    end
    if n/2 == round(n/2), P=-P; end
end

