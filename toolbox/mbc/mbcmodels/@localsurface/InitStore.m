function m = InitStore(m,X);
%INITSTORE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:48 $

m.userdefined = InitStore(m.userdefined,X);


[ri,s2,df]= var(m.userdefined);
m= var(m,ri,s2,df);

