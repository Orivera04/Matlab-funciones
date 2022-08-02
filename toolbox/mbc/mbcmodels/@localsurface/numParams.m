function n= numParams(L)
%NUMPARAMS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:24 $

n= size(L,1)-sum(double(L)==0);