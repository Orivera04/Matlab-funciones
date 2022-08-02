function result = bumpy ( x )
%  BUMPY is a bumpy function with peaks.
%
result = 1.0 ./ ( ( x - 0.3 ).^2 + 0.01 ) ...
       + 1.0 ./ ( ( x - 0.9 ).^2 + 0.04 );