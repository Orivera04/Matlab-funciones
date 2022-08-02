function N = xlogy(X, Y)
% XLOGY - Logarithm
%
% XLOGY(X,Y) returns the N for which X ^ N = Y.
% XLOGY is defined as LOG(Y) elementswise divided by LOG(X).
%
% N is defined as one for all elements where X equals one, and
% also for elements where X and Y are equal. 
%
% Jasper Menger, November 2005

% Validate inputs
if nargin < 2
    error('Not enough inputs provided');
end
if not(size(X, 1) == size(Y, 1)) | not(size(X, 2) == size(Y, 2))
    error('Inputs X and Y should be of equal size');
end

ix    = (X ~= 1) & (Y ~= 1) & (X ~= Y);
N     = zeros(size(X));
N(ix) = log(Y(ix)) ./ log(X(ix));