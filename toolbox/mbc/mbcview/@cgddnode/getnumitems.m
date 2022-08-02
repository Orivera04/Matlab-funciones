function N = getnumitems(ddnode)
%GETNUMITEMS Return number of items in variable dictionary
%
%  N = GETNUMITEMS(DD)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:23:22 $ 

N = length(ddnode.ptrlist);