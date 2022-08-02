function freedummynormptr(LT)
%FREEDUMMYNORMPTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:19 $

% free the pointer to the dummy normaliser
dummyNorm = get(LT.cgnormfunction,'x');
freeptr(dummyNorm);