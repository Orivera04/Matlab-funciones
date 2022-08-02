function in=constrain(c,X,in)
%CONSTRAIN  Constrain a list of points
%
%  IN=CONSTRAIN(C,X,IN)  returns a uint8 logical vector
%  indicating which points in X (N-by-nfactors) are within
%  the constrained region.  IN is a uint8 logical vector
%  indicating which points to constrain and which to ignore,
%  i.e. which points are currently considered to be "in" the
%  constrained region.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:56:07 $

y=constraindist(c, X);

in(in)=in(in) & (y<=0);
