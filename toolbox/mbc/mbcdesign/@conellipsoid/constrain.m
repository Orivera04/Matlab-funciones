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

%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 06:57:59 $

if any( in ),
    
    Xi= X(in,:);   
    for j= 1:size(Xi,2)
        Xi(:,j)= Xi(:,j) - c.xc(j);
    end
    in(in) = c.scalefactor.*(sum((Xi*c.W).*Xi,2)) <= c.scalefactor;

end
