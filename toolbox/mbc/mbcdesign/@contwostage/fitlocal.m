function params = fitlocal( con, X )
%FITLOCAL Fits local constraint models to sweeps
%
%  P = FITLOCAL(C,X) fits local constraint models to the sweepset data X. P
%  is a matrix of model parameters with one row per sweep.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/04/04 03:26:31 $

conlocal = con.Local;
nsweeps = size( X, 3 );

params = zeros( nsweeps, numfeats( conlocal ) );

for i = 1:nsweeps,
    % Local data for sweep i
    L = X{i};

    % fit model to sweep i
    [c, ok] = fitmodel( conlocal,  L  );

    % extract parameters
    if ok>0
        params(i,:) = getparams( c, 'Vector' );
    else
        params(i,:) = NaN;
    end
end
