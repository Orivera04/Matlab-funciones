function  G= gopt(X,des)
% DES_MULTIMOD/GOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:37 $

G= -evalpev(des,X);
