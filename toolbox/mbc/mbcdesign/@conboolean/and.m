function c = and( c, c2 )
%AND Logical AND of two constraints (intersection of two constraints)
%
%  C = AND(C1,C2) is the intersection of the constraints C1 and C2, i.e., a
%  point X is in AND(C1,C2) if and only if it is inside C1 and it is inside
%  C2.
%
%  C1 and C2 must be the same size (as returned by GETSIZE)
%  
%  See also CONBASE/NOT, CONBASE/OR, CONBASE/OR, CONBOOLEAN, GETSIZE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:26 $ 

% check constraint sizes
sz = getsize( c );
if sz ~= getsize( c2 ),
    error( 'Both constraints must be the same size' );
end

% c is a conboolean
% c2 is any conbase object

if isa( c2, 'conboolean' ),
    if strcmpi( c.Op, 'And' ) && strcmpi( c2.Op, 'And' ) && ~c.Not && ~c2.Not,
        c.Constraints = [ c.Constraints, c2.Constraints ];
        
    elseif strcmpi( c.Op, 'And' ) && ~c.Not,
       c.Constraints{end+1} = c2;
       
   elseif strcmpi( c2.Op, 'And' ) && ~c2.Not,
       [c2, c] = deal( c, c2 ); % swap c and c2
       c.Constraints{end+1} = c2;
   else,
       c = conboolean( sz, 'Constraints', {c, c2}, 'Op', 'And', 'Not', 0 );
   end
else
   if strcmpi( c.Op, 'And' ) && ~c.Not,
       c.Constraints{end+1} = c2;
   else,
       c = conboolean( sz, 'Constraints', {c, c2}, 'Op', 'And', 'Not', 0 );
   end
end
   
