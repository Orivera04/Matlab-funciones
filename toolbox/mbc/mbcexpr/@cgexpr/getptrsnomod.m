function ptrs=getptrsnomod(v)
%GETPTRSNOMOD Return pointers except those inside models
%
%  PTRS = GETPTRSNOMOD(E)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:08:49 $

ptrs = pveceval(v.Inputs, 'getptrsnomod');
ptrs = cat(1, ptrs{:}, v.Inputs(:));
