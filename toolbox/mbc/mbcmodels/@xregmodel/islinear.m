function is= isLinear(m);
% MODEL/ISLINEAR true if all parameters are linear

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:52:22 $

is= numParams(m)>0 & numNLParams(m)==0;
