function out = allowsums(optim)
%ALLOWSUMS Check whether optimization can handle sum objects
%
%  OUT = ALLOWSUMS(OPTIM) returns true if the optimization algorithm can
%  work with sum constraints and sum objectives and false otheriwse.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:52:56 $ 

out = false;

% Check for being a builtin function
if strcmpi(optim.fname, 'mbcOSfmincon') || strcmpi(optim.fname, 'mbcOSNBI')
    out = true;
    return
end

% Check for being a user function that addons has specified as sum-capable
e = cgtools.extensions;
out = any(strcmpi(optim.fname, e.OptimizationSumFunctions));