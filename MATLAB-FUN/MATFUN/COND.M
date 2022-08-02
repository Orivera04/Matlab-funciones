function y = cond(x)
%COND	Matrix condition number.
%	COND(X) is the ratio of the largest singular value of X
%	to the smallest, which is the condition number of X in 2-norm.
%
%	See also RCOND, NORM, CONDEST, NORMEST.

%	J.N. Little 11-15-85
%	Revised 3-9-87 JNL, 2-11-92 LS.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if length(x) == 0  % Handle null matrix
    y = NaN;
    return
end
if issparse(x)
	error('Matrix must be non-sparse.')
end
s = svd(x);
if any(s == 0)   % Handle singular matrix
    disp('Condition is infinite')
    y = Inf;
    return
end
y = max(s)./min(s);
