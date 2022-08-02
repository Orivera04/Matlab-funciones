function h = seperation( X )
%SEPERATION   Speration distance of a data set
%   SEPERATION(X) returns the maximum minimun seperation between 
%   the given points, i.e., it calculates
%
%           max       min      | x - y | ,
%         x in X   y in X\x
%
%   where the cartesian coordinates of the data points are given 
%   by the rows of X.
%
%   SEPERATION('demo') plots a graph of seperation vs dimension for 
%   points uniformly randomly ditributed throughout the unit cube.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:58 $ 

if strcmp( X, 'demo' ),
    i_demo;
    h = [];
else
    h = i_seperation( X );
end

return

% ---------------------------------------------------------
function h = i_seperation( X )

d = size( X, 2 );
T = delaunayn( X );

if ~isempty( T ),
    % use the delaunay to search through an optimal set of pairs
    n = size(T,1);
    TT = zeros( (d+1)*n, 2 ); 
    p = 1:n;
    for i = 1:d, 
        TT(p,:) = T(:,[i,i+1]); 
        p = p + n;
    end, 
    TT(p,:) = T(:,[d+1,1]);
    TT = unique( TT, 'rows' );
    
    R = repmat( Inf, size( X, 1 ), 1 );
    for i=1:size(TT,1),
        t1 = TT(i,1);
        t2 = TT(i,2);
        r = sum( ( X(t1,:) - X(t2,:) ).^2 );
        R(t1) = min( R(t1), r );
        R(t2) = min( R(t2), r );
    end
    R = R(~isinf(R));
    h = sqrt( max( R ) );
    
else
    % no delaunay, have to search all pairs
    h = i_bruteforce( X );
    
end

return

% ---------------------------------------------------------
function h = i_bruteforce( X )

npts = size( X, 1 );
    R = repmat( Inf, npts, 1 );
    for i = 1:npts,
        for j = 1:npts,
            if i ~= j,
                R(i) = min( R(i), sum( ( X(i,:) - X(j,:) ).^2 ) );
            end
        end
    end
    h = sqrt( max( R ) );

return

% ---------------------------------------------------------
function i_demo

D = 10;
n = 15;
N = 100;

a = zeros( D, 1 ); 
h = zeros( n, 1 );
for d = 1:D,
    for i = 1:n,
        h(i) = i_seperation( rand( N, d ) );
    end
    a(d) = mean( h );
end

plot( 1:D, a, '.-', 'LineWidth', 2, 'MarkerSize', 24 );
xlabel( 'dimension' );
ylabel( 'seperation' );
title( ['Seperation vs dimension for ' int2str(N) ...
        ' random points in the unit cube'] );

% EOF
