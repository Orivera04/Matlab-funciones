function xy = corrcoef(x,y)
%CORRCOEF Correlation coefficients.
%	CORRCOEF(X) is a matrix of correlation coefficients formed
%	from array X whose each row is an observation, and each
%	column is a variable.
%	CORRCOEF(X,Y) is the same as CORRCOEF([X Y]).
%
%	If C is the covariance matrix, C = COV(X), then CORRCOEF(X) is
%	the matrix whose (i,j)'th element is
%
%	            C(i,j)/SQRT(C(i,i)*C(j,j)).
%
%	See also COV, STD.

%	J. Little 5-5-86
%	Revised 6-9-88 LS
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin > 1
    c = cov(x,y);
else
    c = cov(x);
end
d = diag(c);
xy = c./sqrt(d*d');
