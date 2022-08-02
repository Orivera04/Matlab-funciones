function d = constraindistlocal( con, beta, L )
%CONSTRAINDISTLOCAL AReturn distance from local constraints
%
%  D = CONSTRAINDISTLOCAL(C,B,L) returns the distance from the local
%  constrained region for each local point in L. 
%
%  See also CONTWOSTAGE/CONSTRAINDIST.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:59:32 $ 

[lc, msg] = setparams( con.Local, beta );
if isempty( msg ),
    d = constraindist( lc, double( L ) );
else
    % There was an error setting the parameters in the local model.
    % Assume this means we are out of range
    d = repmat( +Inf, size( L, 1 ), 1 );
end
