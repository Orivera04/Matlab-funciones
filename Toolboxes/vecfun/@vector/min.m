function y=min(V)
%MIN  Smallest values.
%   MIN(V) returns the smallest values of the elements
%   of the vector function V.
%
%   See also MAX.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

y=[min(vec2sca(V,1)) min(vec2sca(V,2)) min(vec2sca(V,3))];