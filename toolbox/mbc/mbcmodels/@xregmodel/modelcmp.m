function c= modelcmp(m1,m2)
% MODEL/MODELCMP compare models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:32 $

c= strcmp(class(m1),class(m2)) & strcmp(char(m1),char(m2));