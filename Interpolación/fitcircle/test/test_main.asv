% TEST_MAIN : Script to cover most of the code in fitcircle. Doesn't test
% erroneous inputs, etc. at the moment. Note, this file should produce at
% least one warning.

% Richard Brown

clc

% Random set of points
x = randn(2, 20);

% Linear fit
[z, r, residual] = fitcircle(x, 'linear');

% Nonlinear fit
[z, r, residual] = fitcircle(x);

% Adjust parameters 

% set maxits low: should generate a warning, as 2 iterations won't be
% enough
[z, r, residual] = fitcircle(x, 'maxits', 2);

% set tolerance lower
[z, r, residual] = fitcircle(x, 'tol', 1e-10);

% set both
[z, r, residual] = fitcircle(x, 'ma', 1000, 't', 1e-8);
