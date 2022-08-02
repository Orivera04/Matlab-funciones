function in=constrain(bd,X,in)
%CONSTRAIN  Constrain a list of points
%   CONSTRAIN(C,X,IN) is a uint8 logical vector indicating which points in 
%   X (N-by-nfactors) are within the constrained region. IN is a uint8 
%   logical vector indicating which points to constrain and which to 
%   ignore, i.e., which points are currently considered to be "in" the 
%   constrained region.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:12:57 $ 

if any( in ) && ~isempty( bd.Model ),
    in = constrain( bd.Model, X, in );
end
