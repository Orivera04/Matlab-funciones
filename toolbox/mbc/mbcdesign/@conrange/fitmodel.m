function [c, ok] = fitmodel( c, X )
%FITMODEL Fit a range constraint to data.
%   [C,OK] = FITMODEL(C,X) where X is a list of points on the boundary of the
%   region to be modeled. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:43 $ 

X = X(:,variables( c ));
a = min( X, [], 1 );
b = max( X, [], 1 );

c.Center    = 0.5 * (b + a);
c.HalfWidth = 0.5 * (b - a);

ok = true;

return

% EOF
