function ptr = getprivateptrs(optim)
%GETPRIVATEPTRS Return pointers which are private to the object
%
%  PTR = GETPRIVATEPTRS(OPTIM)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:53:27 $ 

ptr = [optim.objectiveFuncs, ...
        optim.constraints];