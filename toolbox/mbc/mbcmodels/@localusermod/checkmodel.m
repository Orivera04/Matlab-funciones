function OK= checkmodel(U);
% USERLOCAL/CHECKMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:40 $

if isa(U.userdefined,'xregmodel')
   OK= checkmodel(U.userdefined);
else
   error('User defined model is  corrupt');
end