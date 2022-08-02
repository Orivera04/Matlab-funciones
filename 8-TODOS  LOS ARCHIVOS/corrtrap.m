
function y = corrtrap(fname, fpname, a, b)

% Corrected trapezoidal rule y.
% fname - the m-file used to evaluate the integrand,
% fpname - the m-file used to evaluate the first derivative
% of the integrand,
% a,b - endpoinds of the interval of integration.

h = b - a;
y = (h/2).*(feval(fname,a) + feval(fname,b))+ (h.^2)/12.*( ...
   feval(fpname,a) - feval(fpname,b));

   