function p= getptrs(T);
% TESTPLAN/GETPTRS list of internal pointers 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:51 $

pbd= T.ConstraintData;
if pbd~=0
    pbd= pbd.preorder('getptrs');
    pbd= [pbd{:}];
else
    pbd= [];
end

p = [ ...
        pbd, ...
        getptrs( T.modeldev ) ];
