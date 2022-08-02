function G = constraindist(c,X)
%CONSTRAINDIST  Return distance from constraints
%
%   G = CONSTRAINDIST(OBJ,X)  returns the distance from the constrained
%   region for each point in X.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 06:57:29 $ 

% Setup default output
%   By default all points are inside and since on the boundary is inside
%   and not( 0 ) is also inside, we use default values of zero.
G = zeros( size( X, 1 ), 1 );

nc = length( c.Constraints ); % number of constraints
if nc == 0,
    return
end


switch lower( c.Op ),
    case 'none',
        if nc ~= 1,
            warning( 'Invalid boolean constraint object' );
        end
        G = constraindist( c.Constraints{1}, X );
        
    case 'and',
        G = constraindist( c.Constraints{1}, X );
        for i = 2:nc,
            G = max( G, constraindist( c.Constraints{i}, X ) );
        end
        
    case 'or',
        G = constraindist( c.Constraints{1}, X );
        for i = 2:nc,
            G = min( G, constraindist( c.Constraints{i}, X ) );
        end
        
    case 'xor',
        if nc ~= 2,
            warning( 'Invalid boolean constraint object' );
        end
        G = constraindist( c.Constraints{1}, X ) .* ...
            constraindist( c.Constraints{2}, X );
    otherwise
        warning( 'Invalid boolean constraint object' );
end

% 'not' the constraints
if c.Not,
    G = -G;
end

% EOF
