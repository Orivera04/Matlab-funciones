function g=constraindist(obj,X)
%CONSTRAINDIST  Return distance from constraints
%
% G=CONSTRAINDIST(OBJ,X)  returns the distance from the
% constrained region for each point in X.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:58:00 $

X = X(:,variables( obj ));

% center = obj.xc;
% for j= 1:size(X,2)
%    X(:,j)= X(:,j) - center(j);
% end

n = size( X, 1 );
X = X - obj.xc(ones( 1, n ),:);

g = obj.scalefactor .* ( sum( (X * obj.W) .* X, 2 ) - 1 );
