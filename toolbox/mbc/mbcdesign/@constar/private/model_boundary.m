function [c, OK] = model_boundary( c, X )
%MODEL_BOUNDARY Boundary modeling of scattered data for CONSTAR objects
%
%  MODEL_BOUNDARY(C,X) where X is a list of points on the boundary of the
%  region to be modeled.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/04/04 03:26:28 $ 

X = X(:,variables(c));

% 2. Project onto sphere and find radii
[Y, R] = map_to_sphere( X, c.Center );
R = transform_radius( R, c.Transform );

% solve interpolation problem, i.e., find f : f(Y(i,:)) = R(i)
if isempty( c.Model ),
    c.Model = xreginterprbf( 'NFactors', size( X, 2 ) );
end
[m, OK] = runfit( c.Model, Y, R );

if OK>0
    c.Model = m;
end
