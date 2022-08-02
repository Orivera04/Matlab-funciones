function  [m,OK] = rbffit(m,x,y);
%XREGLOLIMOT/RBFFIT  Fit algorithm for LOLIMOT models
%    RBFFIT(M,X,Y) fits the lolimot model M to the nodes X and data Y.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:50:51 $

[m, cost, OK] = run( getFitOpt(m), m, [], x, y );
[m, OK] = InitModel( m, x, y , [] , true); % store the matrices for computing the stats
if ~isempty( cost )
    setFitOpt( m, 'cost', cost );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
