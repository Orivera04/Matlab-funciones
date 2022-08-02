function z = trapz(x,y)
%TRAPZ	Trapezoidal numerical integration.
%	Z = TRAPZ(X,Y) computes the integral of Y with respect to X using
%	trapezoidal integration.  X and Y must be vectors of the same length,
%	or X must be a column vector and Y a matrix with as many rows as X.
%	TRAPZ computes the integral of each column of Y separately.
%	The resulting Z is a scalar or a row vector.
%
%	Z = TRAPZ(Y) computes the trapezoidal integral of Y assuming unit
%	spacing between the data points.  To compute the integral for
%	spacing different from one, multiply Z by the spacing increment.
%
%	See also SUM, CUMSUM.

% 	Clay M. Thompson, 10/16/90; Cleve Moler, 1/19/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%   Make sure x and y are column vectors, or y is a matrix.
if nargin < 2, y = x; end
[m,n] = size(y);
if m == 1, y = y(:); m = n; end
if nargin < 2, x = 1:m; end
x = x(:);
if length(x) ~= m
    error('Input arguments must be the same length.');
end

%   Trapezoid sum computed with vector-matrix multiply.

z = diff(x)' * (y(1:m-1,:) + y(2:m,:))/2;
