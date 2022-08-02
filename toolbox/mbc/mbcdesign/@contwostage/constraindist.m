function d = constraindist( con, X )
%CONSTRAINDIST  Return distance from constraints
%
%   G = CONSTRAINDIST(OBJ,X)  returns the distance from the constrained
%   region for each point in X. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:59:31 $ 

nlf   = getsize( con.Local );      % number of local factors
ngf   = nfactors( con.Global{1} ); % number of global factors 
ngm   = numel( con.Global );       % number of globasl models
b     = zeros( ngm, 1 );           % local model parameters
    
if size( X, 2 ) ~= nlf + ngf,
    error( 'X has the wrong number of factors' );
end

if isa( X, 'sweepset' ),  %% CHECK ME!
    d = X(:,1,:);
    d(:) = 0;
    for i = 1:size( X, 3 ),
        for j = 1:ngm,
            b(j) = eval( con.Global{j}, mean( X(:,nlf+1:end,i) ) );
        end
        d(:,:,i) = constraindistlocal( con, b, X(:,1:nlf,i) );
    end
    
else
    X = double( X );
    neval = size( X, 1 );
    d = zeros( neval, 1 );
    b = zeros( neval, ngm );
    for j = 1:ngm,
        b(:,j) = eval( con.Global{j}, X(:,nlf+1:end) );
    end
    for i = 1:neval;
        d(i) = constraindistlocal( con, b(i,:)', X(i,1:nlf) );
    end
end
