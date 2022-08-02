function destroyobject(optim)
%DESTROYOBJECT Free all private pointers
%
%  DESTROYOBJECT(OPTIM) will free all of the private pointers in the OPTIM
%  object.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:07 $ 


freeptr(getprivateptrs(optim));