function [c, sp] = getspecialpoints( c, X, sp, fsp )
%GETSPECIALPOINTS Get any data dependent special points
%
%  [C,SP] = GETSPECIALPOINTS(C,X,SP,FSP)
%  NAMES = GETSPECIALPOINTS(C,'Names')
%
%  Sets the center of C to the found center.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:57:46 $ 

if isnumeric( X ),

    X = X(:,variables( c ));
    
    alg = getspecialpointoptions( c ); %%  'LeastSquares';
    center = repmat( NaN, 1, size( c ) );
    center(variables( c )) = xregfindcenter( X, alg );
    if isempty( sp ) | isempty( fsp ),
        sp = center;
    else
        sp(~fsp) = center(~fsp);
    end
    c.Center = center(variables( c ));
    
elseif ischar( X ) && isequal( lower( X ), 'names' ),
    c = { 'Center' };
end
