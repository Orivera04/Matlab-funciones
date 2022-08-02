function y=isconst(f,dim)
%ISCONST  True for constant function.
%   ISCONST(F,DIM) returns 1 if F in component DIM is constant
%   and 0 otherwise.
%   F must be of type vector and DIM is an integer from 1 to 3.

% Copyright (c) 2001-04-13, B. Rasmus Anthin.

error(nargchk(2,2,nargin))
y=isconst(vec2sca(f,dim));