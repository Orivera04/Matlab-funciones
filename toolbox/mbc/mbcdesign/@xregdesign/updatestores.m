function des=updatestores(des);
%UPDATESTORES  Updates any runtime data stores
%
%  D=UPDATESTORES(D)  updates any runtime data any returns
%  the object with it correctly updated.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:07:54 $

if des.constraintsflag~=des.candstate
   % Re-evaluate constraints
   des=EvalConstraints(des);
end