function y=max(V)
%MAX  Largest values.
%   MAX(V) returns the largest values of the elements
%   of the vector function V.
%
%   See also MIN.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

y=[max(vec2sca(V,1)) max(vec2sca(V,2)) max(vec2sca(V,3))];