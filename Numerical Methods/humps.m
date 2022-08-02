function result = humps ( x )
%  HUMPS computes a function that has three roots, and some humps.
%
result = 1.0 ./ ( ( x - 0.3 ).^2 + 0.01 ) ...
       + 1.0 ./ ( ( x - 0.9 ).^2 + 0.04 ) + 2 * x - 5.2