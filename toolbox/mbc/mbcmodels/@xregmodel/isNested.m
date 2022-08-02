function is= isNested(m);
% MODEL/ISNESTED tests whether the model is nested

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:30:23 $

nl= numNLParams(m);
n= numParams(m);
% has less nonlinear parameters than total number of parameters
is= nl>=1 & nl<n;