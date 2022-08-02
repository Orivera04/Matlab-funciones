function c = or( c1, c2 )
%XOR Logical EXCLUSIVE OR of two constraints (symmetric difference)
%
%  C = XOR(C1,C2) is the symmetric difference of the constraints C1 and C2,
%  i.e., a point X is in XOR(C1,C2) if and only if it is not inside
%  AND(C1,C2) and it inside C1 or it is inside C2.   
%
%  C1 and C2 must be the same size (as returned by GETSIZE)
%  
%  See also CONBASE/NOT, CONBASE/AND, CONBASE/OR, CONBOOLEAN, GETSIZE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:25 $ 

sz = getsize( c1 );
if sz ~= getsize( c2 ),
    error( 'Both constraints must be the same size' );
end
c = conboolean( sz, 'Constraints', {c1, c2}, 'Op', 'Xor', 'Not', 0 );
