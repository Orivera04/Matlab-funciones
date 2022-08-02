function RR = constraindist(c,X)
%CONSTRAINDIST  Return distance from constraints
%
% G = CONSTRAINDIST(OBJ,X)  returns the distance from the
% constrained region for each point in X.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:57:41 $ 

if isempty( c.Model ),
    V = repmat( NaN, size( X, 1 ), 1 );
    return
end

X = X(:,variables( c ));

% Project onto sphere and find radii
[YY, r] = map_to_sphere( X, c.Center );

% eval sphereical based interpolant
R = eval( c.Model, YY );

R = transform_radius( R, c.Transform, 'Inverse' );
RR = r - R;
