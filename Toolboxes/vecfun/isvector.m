function y=isvector(x)
%ISVECTOR  True for vector functions.
%   ISVECTOR(S) returns 1 if S is a vector function and 0 otherwise.
%
%   See also ISSCALAR, SCALAR, VECTOR.

% Copyright (c) 2001-04-13, B. Rasmus Anthin

y=isa(x,'vector');