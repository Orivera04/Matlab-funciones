function fp = rungep ( x )
% RUNGEP computes the derivative of the Runge function.
%
fp = - 2.0 * x ./ ( 1.0 + x .* x ).^2;