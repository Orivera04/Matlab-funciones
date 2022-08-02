function g=constraindist(c,X)
%CONSTRAINDIST  Return distance from constraints
%
% G=CONSTRAINDIST(OBJ,X)  returns the distance from the
% constrained region for each point in X.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:59:01 $

[in,g]=xreginterp2d(c.breakrows, c.breakcols, c.table, c.factors, c.le, X);