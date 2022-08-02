function cmp= modelcmp(m1,m2);
% TRUNCPS/MODELCMP

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:19 $

cmp= get(m1.xreg3xspline,'numknots') == get(m2.xreg3xspline,'numknots');
