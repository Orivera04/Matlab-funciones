function c = not( c )
%NOT Logical NOT of a constraint (inverse of a constraint)
%
%  C = NOT(C) is the inverse of the constraint C, i.e., a point X is in
%  NOT(C) if and only if it is outside of C.
%  
%  See also CONBASE/AND, CONBASE/OR, CONBASE/XOR, CONBOOLEAN.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:10 $ 

c = conboolean( getsize( c ), 'Constraints', c, 'Op', 'None', 'Not', 1 );
