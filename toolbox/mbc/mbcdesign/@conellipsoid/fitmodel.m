function [c, ok] = model_boundary( c, X )
%FITMODEL Fit an ellipse to data.
%   [C,OK = FITMODEL(C,X), X is a list of points on the boundary of the
%   region to be modeled. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:58:01 $ 

X = X(:,variables( c ));

% Find the minimal enclosing ellipse
[xc, L] = xregfindcenter( X, 'MinEllipse' );

% Constraint settings
c.xc          = xc;
c.W           = L' * L;
c.scalefactor = 1.0;

ok = true;
return

% EOF
