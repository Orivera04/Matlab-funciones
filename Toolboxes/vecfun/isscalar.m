function y=isscalar(x)
%ISSCALAR  True for scalar functions.
%   ISSCALAR(S) returns 1 if S is a scalar function and 0 otherwise.
%
%   See also ISVECTOR, SCALAR, VECTOR.

% Copyright (c) 2001-04-13, B. Rasmus Anthin

y=isa(x,'scalar');