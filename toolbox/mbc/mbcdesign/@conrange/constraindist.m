function g = constraindist(c,X)
%CONSTRAINDIST  Return distance from constraints
%
% G = CONSTRAINDIST(OBJ,X)  returns the distance from the
% constrained region for each point in X.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:42 $ 

X = X(:,variables( c ));
i = ones( size( X, 1 ), 1 );

g = max( abs( X - c.Center(i,:) ) - c.HalfWidth(i,:), [], 2 );
