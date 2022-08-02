function z = silhouette( c, factors, x, y, res )
%SILHOUETTE A short description of the function
%
%  SILHOUETTE(C,F,X,Y,R), where C is a constraint model, F is a pair of
%  indices to the factors to project the constraint onto, X and Y are the
%  values of those two factors that the silhouette is required at and R is
%  the resolution in the other directions.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:20 $ 

z = [];
