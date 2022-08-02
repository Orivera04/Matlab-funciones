function ptrs=getptrsnosf(v)
%GETPTRSNOSF Return pointers except those inside features
%
%  PTRS = GETPTRSNOSF(EXPR)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:08:50 $

ptrs = pveceval(v.Inputs, 'getptrsnosf');
ptrs = cat(1, ptrs{:}, v.Inputs(:));