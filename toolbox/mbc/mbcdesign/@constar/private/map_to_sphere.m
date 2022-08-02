function [Y,R] = map_to_sphere( X, C )
%MAP_TO_SPHERE   Map points to the unit sphere
%   MAP_TO_SPHERE(X) returns the cartesian coordindates of the projections
%   of the points in X onto the sphere.
%   MAP_TO_SPHERE(X,C) uses C has the center of the sphere.
%   [Y,R] = MAP_TO_SPHERE(X) or [Y,R] = MAP_TO_SPHERE(X,C) also returns the
%   the radii of the points in X from the center of the sphere.
%   Points at the origin or the center of the sphere get mapped to north 
%   pole.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:55 $ 

[n,d] = size( X );
if nargin >= 2,
    if any( size(C) ~= [1, d] ),
        error( 'C must be a row vector with the same number of columns as X' );
    end
    X = X - repmat( C, n, 1 );
end
if d < 2,
    Y = sign( X );
    R = abs( X );
end
R = sqrt( sum( X.^2, 2 ) ); % compute radii
ind = find( R <= 0 );
X(ind,1:end-1) = 0; % map points at the origin to the N pole
X(ind,end) = 1;
R(ind) = 1;
Y = X./repmat( R, 1, d );      % project onto sphere

% EOF
