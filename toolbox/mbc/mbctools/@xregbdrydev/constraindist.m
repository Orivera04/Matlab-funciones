function RR = constraindist( bd, X )
%CONSTRAINDIST  Return distance from constraints
%
% G = CONSTRAINDIST(OBJ,X)  returns the distance from the
% constrained region for each point in X.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:12:58 $ 

if isempty( bd.Model ),
    RR = [];
else
    RR = constraindist( bd.Model, X );
end
