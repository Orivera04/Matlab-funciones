function OK= checkmodel(U);
% USERLOCAL/CHECKMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:57 $

if isa(U.userdefined,'xregmodel')
   OK= checkmodel(U.userdefined);
else
   error('Local surface model is  corrupt');
end