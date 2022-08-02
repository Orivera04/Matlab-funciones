
% Delete from this folder !!!

function y = fractp(x)

% Fractional part y of x, where x is a vector or a matrix.

y = zeros(size(x));
ind = find(abs(x - round(x)) >= 100*eps);
y(ind) = x(ind) - floor(x(ind));

