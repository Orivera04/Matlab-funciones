function [count,h,parent,post,R] = symbfact(A,f)
%SYMBFACT Symbolic factorization analysis.
%
%	count = SYMBFACT(A) returns the vector of row counts for the upper
%	triangular Cholesky factor of a symmetric matrix whose upper triangle 
%	is that of A, assuming no cancellation during the factorization.  
%	This routine should be much faster than chol(A).
%
%	count = SYMBFACT(A,'col') analyzes A'*A (without forming it explicitly).
%	count = SYMBFACT(A,'sym') is the same as p = symbfact(A).
%
%	There are several optional return values:
%
%	[count,h,parent,post,R] = symbfact(...) also returns
%	     the height of the elimination tree,
%	     the elimination tree itself,
%	     a postordering permutation of the elimination tree,
%	     and a 0-1 matrix R whose structure is that of chol(A).
%
%	See also CHOL, ETREE, TREELAYOUT.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin <= 1,
    op = 'symanalyze';
elseif f(1) == 's' | f(1) == 'S',
    op = 'symanalyze';
elseif f(1) == 'c' | f(1) == 'C',
    op = 'colanalyze';
else 
    error ('Second argument must be ''sym'' or ''col''');
end

if     nargout <= 1
  count = sparsfun(op,A);
elseif nargout == 2
  [count,h] = sparsfun(op,A);
elseif nargout == 3
  [count,h,parent] = sparsfun(op,A);
elseif nargout == 4
  [count,h,parent,post] = sparsfun(op,A);
elseif nargout == 5
  [count,h,parent,post,R] = sparsfun(op,A);
end
