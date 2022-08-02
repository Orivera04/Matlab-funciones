function x0 = getInitFreeVal(opt)
%GETINITFREEVAL Get the initial free values for the optimization
%
%  x0 = GETOUTPUTINFO(COS) returns the intial values of the free variables
%  used in the optimization. These values are set by the user in the 'Free
%  Variable Set Up' dialog when the optimization is run.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:13 $ 

x0 = opt.x0;
