function y = xregrbfeval(kernelString, X, C, W, B)
%XREGRBFEVAL Evaluate a given RBF kernel
%
%  Y = XREGRBFEVAL(KERNELSTRING, X, C, W, B) evaluates the specified
%  kernel.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:31:05 $ 

y = mx_rbfeval( kernelString, X', C', W'.^2, B );
