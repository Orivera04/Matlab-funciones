function xy = cov(x,y)
%COV	Covariance matrix.
%	COV(X), if X is a vector, returns the variance.  For matrices,
%	where each row is an observation, and each column a variable,
%	COV(X) is the covariance matrix.  DIAG(COV(X)) is a vector of
%	variances for each column, and SQRT(DIAG(COV(X))) is a vector
%	of standard deviations.   COV(X,Y) is COV([X Y]).  
%
%	See also CORRCOEF, STD.

%	J. Little 5-5-86
%	Revised 6-9-88 LS
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n] = size(x);
if nargin > 1
    [my,ny] = size(y);
    if m ~= my | n ~= ny
        error('X and Y must be the same size.');
    end
    x = [x(:) y(:)];
elseif min(size(x)) == 1
    x = x(:);
end
[m, n] = size(x);
x = x - ones(m,1) * (sum(x)/m);
if m == 1
    xy = 0;
else
    xy = x' * x / (m-1);
end
