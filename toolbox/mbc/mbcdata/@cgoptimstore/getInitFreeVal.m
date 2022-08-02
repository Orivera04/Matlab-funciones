function x0 = getInitFreeVal(cos)
%GETINITFREEVAL Get the initial free values for the optimization.
%   X0 = GETINITFREEVAL(OPTIMSTORE) returns the intial values of the free
%   variables used in the optimization.  These values are set by the user
%   in the 'Free Variable Set Up' dialog when the optimization is run. X0
%   is a (NPoints-by-NFreeVar) matrix where NPoints is the number of rows
%   in the Primary data set and NFreeVar is the number of free variables in
%   the optimization.
%
%   See also: CGOPTIMSTORE/GET, CGOPTIMOTIONS/SETFREEVARIABLESMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:54:23 $ 

x0 = getInitFreeVal(cos.cgoptim);