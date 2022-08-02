function [p,S] = least2(x,y,n,w)
%	[p,S] = least2(x,y,n,w) finds the coefficients of a polynomial
%	p(x) of degree n that fits the data, p(x(i)) ~= y(i),
%	in a weighted least-squares sense with weights w(i).
%  The structure S contains additional info.
%	This routine is based on polyfit. 
%
%	See also POLYFIT, POLY, POLYVAL, ROOTS.

% Copyright (c) 1998 by Datatool
%	$Revision: 1.1 $ 

% The regression problem is formulated in matrix format as:
%
%    A'*W*y = A'*W*A*p
%
% where the vector p contains the coefficients to be found.  For a
% 2nd order polynomial, matrix A would be:
%
% A = [x.^2 x.^1 ones(size(x))];

if nargin==4
    if any(size(x) ~= size(w))
        error('X and W vectors must be the same size.')
	end
    else
%		default weights are unity.
        w = ones(size(x));
    end
if any(size(x) ~= size(y))
    error('X and Y vectors must be the same size.')
end
x = x(:);
y = y(:);
w = w(:);

%  remove data for w=0 to reduce computations and storage
zindex=find(w==0);
x(zindex) = [];
y(zindex) = [];
w(zindex) = [];
nw = length(w);

% Construct the matrices. Use sparse form to avoid large weight matrix.
W = spdiags(w,0,nw,nw);

A = vander(x);
A(:,1:length(x)-n-1) = [];

V = A'*W*A;
Y = A'*W*y;

% Solve least squares problem. Use QR decomposition for computation.
[Q,R] = qr(V,0);
    
p = R\(Q'*Y);    % Same as p = V\Y;
r = Y - V*p;     % residuals
p = p';          % Polynomial coefficients are row vectors by convention.

% S is a structure containing three elements: the Cholesky factor of the
% Vandermonde matrix, the degrees of freedom and the norm of the residuals.

S.R = R;
S.df = length(y) - (n-1);
S.normr = norm(r);
