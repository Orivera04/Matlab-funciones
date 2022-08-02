function S = spaugment(A,c)
%SPAUGMENT Express a least squares problem as a larger linear system.
%	S = SPAUGMENT(A,c) creates the sparse, square, symmetric indefinite
%	matrix S = [c*I A; A' 0].  This matrix is related to the least
%	squares problem
%	        min norm(b - A*x)
%	by
%	        r = b - A*x
%	        S * [r/c; x] = [b; 0].
%
%	The optimum value of the residual scaling factor c, involves
%	min(svd(A)) and norm(r), which are usually too expensive to compute.
%	S = SPAUGMENT(A), without a specified value of c, uses the
%	default set by SPPARMS, which is usually max(max(abs(A)))/1000.
%
%	The augmented matrix is used automatically by the sparse
%	linear equation solvers, \ and /, for nonsquare problems.
%
%	See also SPPARMS.

%	C. Moler, 4-30-91, 6-1-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2
   c = spparms('aug_rel')*max(max(abs(A))) + spparms('aug_abs');
end
[m,n] = size(A);
S = [sparse(1:m,1:m,c(1)) A; A' sparse(n,n)];
