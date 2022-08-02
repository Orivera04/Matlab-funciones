function [c, OK] = fitmodel( c, X )
%FITMODEL Boundary modeling of scattered data for CONSTAR objects
%
%  FITMODEL(C,X), X is a list of points on the boundary of the region 
%  to be modeled.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.3 $    $Date: 2004/04/04 03:26:26 $ 

X = X(:,variables( c ));
nf = size( X, 2 );

% 2. Project onto sphere and find radii
[Y, R] = map_to_sphere( X, c.Center );
R = transform_radius( R, c.Transform );

% solve interpolation problem, i.e., find f : f(Y(i,:)) = R(i)
if isempty( c.Model ),
    c.Model = xreginterprbf( 'NFactors', nf );
elseif nfactors( c.Model ) ~= nf,
    om = getFitOpt( c.Model );
    c.Model = xreginterprbf( 'NFactors', nf );
    c.Model = setFitOpt( c.Model, om );
end
[m, OK] = runfit( c.Model, Y, R );

if OK>0
    c.Model = m;
end
