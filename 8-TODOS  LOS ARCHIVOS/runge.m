function result = runge ( x )
% RUNGE computes a function that is hard to interpolate over [-5,5].
%
result = 1.0 ./ ( 1.0 + x .* x );
