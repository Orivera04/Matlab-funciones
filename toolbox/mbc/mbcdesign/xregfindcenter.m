function [c,L] = xregfindcenter( x, method )
%XREGFINDCENTER find the center of a set of points
%
%   XREGFINDCENTER(X) finds the center of the points whose cartesian
%   coordinates are given as the rows of X. 
%
%   XREGFINDCENTER(X,'LeastSquares') finds the center in the least squares
%   sense. This is the deafult method. 
%
%   XREGFINDCENTER(X,'MinEllipse') finds the center of the minimal
%   enclosing ellipsoid. 
%
%   [C,L] = FIND_CENTER(X,'MinEllipse') also returns the triangular matrix
%   L that defines the ellipsoid.   
%
%   XREGFINDCENTER('List') returns a cell array of possible options for the
%   center finding algorithms. 


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/04/04 03:27:19 $ 

if nargin < 2, 
    method = 'LeastSquares';
end
if ischar( x ),
    c = { 'LeastSquares', 'MinEllipse' };
    return
end

switch lower( method ),
case {'leastsquares','least-square','leastsquare'},
        L = [];
        c = mean( x, 1 );
case {'minellipse','min-ellipse'},
    [c,L] = i_EllipseOptimize( x, @i_MinVolumeObj, @i_MinVolumeConstraints );
case {'max-ellipse'}, % doesn't work
    [c,L] = i_EllipseOptimize( x, @i_MaxVolumeObj, @i_MaxVolumeConstraints );
otherwise
    error( 'Unknown method for center' );
end

c=c(:)';

%--------------------------------------------------------------------------
function [center, L] = i_EllipseOptimize( points, objective, constraint );

[n,d] = size( points );

% use the middle of the extent of the data at the initial guess for the
% center.
cmin = min( points, [], 1 ); 
cmax = max( points, [], 1 ); 
center0 = 0.5 * (cmax + cmin); 

% Initial guess for ellipse
L0 = diag( sqrt( 1./(cmax - cmin) ) );

% set lower and upper bounds
lower_L = 1e-3 * eye( d ) - tril( repmat( 1e+3, d, d ), -1 );
lb = i_EllipseToColumn( cmin, lower_L );
ub = i_EllipseToColumn( cmax, repmat( 1e+3, d, d ) );

% Inital guess as a column vector
x0 = i_EllipseToColumn( center0, L0 );

% set up options struct
options = optimset( ...
    'tolx',   1e-8, ...
    'tolfun', 1e-8, ...
    'tolcon', 1e-8, ...
    'MaxFunEvals', 1000, ... 
    'LargeScale', 'off', ... % should there be a test to see if this is required?
    'Display', 'off' ); % 'iter', 'off'

% perform optimization
xstar = fmincon( objective, x0, [], [], [], [], lb, ub, constraint, options, points );

% interpret solution
[center, L] = i_ColumnToEllipse( xstar, d );

%--------------------------------------------------------------------------
function f = i_MinVolumeObj( X, points )
% objective function for minimizing volume
[n, d] = size( points );

% [center, L] = i_ColumnToEllipse( col, d )
% f = prod( diag( L ) ); % = det( L )

% the diag of the matrix is stored in the last d entries of X
f = -prod( X(end-d+1:end) ); 

%--------------------------------------------------------------------------
function [g, geq] = i_MinVolumeConstraints( X, points )
% Constraint function for minimizing volume
%
% The ellipse is given by (x-c)'*M*(x-c) = 1 and all data points must
% satisfy (x-c)'*M*(x-c) - 1 < 0 where x is data point (column), c is the
% center of the ellipse (column) and M = L'*L is a positive definite
% matrix.

[n, d] = size( points );
[center, L] = i_ColumnToEllipse( X, d );

g = [points - center(ones( n, 1 ),:)] * L';
g = sum( g .* g, 2 ) - 1;

% There are no equality constraints
geq = [];

%--------------------------------------------------------------------------
function f = i_MaxVolumeObj( X, points )
% objective function for maximizing volume
f = -i_MinVolumeObj( X, points );

%--------------------------------------------------------------------------
function [g, geq] = i_MaxVolumeConstraints( X, points )
% constraint function for maximizing volume
[g, geq] = i_MinVolumeConstraints( X, points );
g = -g;

%--------------------------------------------------------------------------
function col = i_EllipseToColumn( center, L )
% Puts the ellipse infomation into a column vector
% Inverse operation to i_ColumnToEllipse
d = size( center, 2 );
col = zeros( d + 0.5 * d * (d + 1), 1 );

col(1:d) = center;

j = d+1;
for i = 1:d,
    col(j) = diag( L, -d + i );
    j = [ j + i, j(end) + i + 1];
end

%--------------------------------------------------------------------------
function [center, L] = i_ColumnToEllipse( col, d )
% Form the ellipse parameters from the column vector
% Inverse operation to i_EllipseToColumn
center = col(1:d)';
L = zeros( d );
j = d+1;
for i = 1:d,
    L = L + diag( col(j), -d + i );
    j = [ j + i, j(end) + i + 1];
end

%--------------------------------------------------------------------------
% EOF
%--------------------------------------------------------------------------
