function c = or( c1, c2 )
%OR Logical OR of two constraints (union of two constraints)
%
%  C = OR(C1,C2) is the union of the constraints C1 and C2, i.e., a point X
%  is in OR(C1,C2) if and only if it is inside C1 or it is inside C2. 
%
%  C1 and C2 must be the same size (as returned by GETSIZE)
%  
%  See also CONBASE/NOT, CONBASE/AND, CONBASE/XOR, CONBOOLEAN, GETSIZE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:11 $ 

sz = getsize( c1 );
if sz ~= getsize( c2 ),
    error( 'Both constraints must be the same size' );
end

if isa( c2, 'conboolean' ),
    c = or( c2, c1 );
else
    c = conboolean( sz, 'Constraints', {c1, c2}, 'Op', 'Or', 'Not', 0 );
end
