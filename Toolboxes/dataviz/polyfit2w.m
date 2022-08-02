function [p, S] = polyfit2w(x,y,z,w,n,m)
%  POLYFIT2W finds the polynomial coefficients of a 
%  function of 2 variables x and y of degrees n and m, respectively,
%  that fit	the data in z in a least-squares sense, using weights w.
%  x,y,z and w can be vectors or matrices of the same size.
% S is a structure containing three elements: the Cholesky factor of the
% Vandermonde matrix, the degrees of freedom and the norm of the residuals.
%
%  [p, S] = polyfit2w(x,y,z,w,n,m)
%
% The weighted regression problem is formulated in matrix format as:
%
%    A'*W*z = A'*W*A*p
%  where the matrix A contains the x,y data
%
%  if n = 3 and m = 1,
%	A = [y.*x.^3  y.*x.^2  y.*x  y x.^3  x.^2  x  ones(length(x),1)]
%  Note that the various xy products are column vectors of length(x).
%
%  The polynomial coeffiecients are ordered as
%	    [p31 p21 p11 p01 p30 p20 p10 p00]' for the computation.                     
%
%  The coefficents of the output p    
%  matrix are arranged as shown:
%
%      p31 p30 
%      p21 p20 
%      p11 p10 
%      p01 p00
%
% The indices on the elements of p correspond to the 
% order of x and y associated with that element.
%
% For a solution to exist, the number of ordered 
% triples [x,y,z] must equal or exceed (n+1)*(m+1).
% Note that m or n may be zero.
%
% To evaluate the resulting polynominal function,
% use POLYVAL2D.

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

% Based on POLYFIT2D by Perry W. Stout 1995
% and LEAST2 by Richard Johnson 1995
% and POLYFIT by The Mathworks

if any((size(x) ~= size(y)) | (size(z) ~= size(y)) | (size(w) ~= size(y)))
	error('X, Y, Z and W must be the same size')
end

x = x(:); y = y(:); z= z(:);  % Switches vectors or matrices to columns
w = w(:);

%  The matrix W could become too large, so take countermeasures: 
%  remove data for w=0 to reduce computations and storage
zindex=find(w==0);
x(zindex) = [];
y(zindex) = [];
z(zindex) = [];
w(zindex) = [];
nw = length(w);

% Construct the weight matrix. Use sparse form to avoid large size.
W = spdiags(w,0,nw,nw);

if length(x) < (n+1)*(m+1)
 error('Number of points must equal or exceed order of polynomial function.')
end

n = n + 1;
m = m + 1; % Increment n and m to equal row, col numbers of p.

% Construct the extended Vandermonde matrix, containing all xy products.
a = zeros(length(x),n*m);

for i1= 1:m
   for j1=1:n
	     a(:,j1+(i1-1)*n) = (x.^(n-j1)).*(y.^(m-i1));
   end
end

V = a'*W*a;
Z = a'*W*z;

% Solve least squares problem. Use QR decomposition for computation.
[Q,R] = qr(V,0);
p1 = R\(Q'*Z);   %  equivalent to p = V\Z
r = Z - V*p1;

% Reform p as a matrix.
p=[];
for i1=1:m
p=[p, p1((n*(i1-1)+1):(n*i1))];
end

% S is a structure containing three elements: the Cholesky factor of the
% Vandermonde matrix, the degrees of freedom and the norm of the residuals.

S.R = R;
S.df = length(y) - (n+m-1);
S.normr = norm(r);
