function c = saveobj(c)
%SAVEOBJ Save object method for conboolean objects
%
%  C = SAVEOBJ(C)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:35 $ 

nc = length( obj.Constraints ); % number of constraints
for i = 1:nc,
    c.Constraints{i} = saveobj( c.Constraints{i} );
end
c.conbase = saveobj( c.conbase );
