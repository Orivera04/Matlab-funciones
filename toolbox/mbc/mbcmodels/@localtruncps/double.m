function p= double(m)
% LOCALTRUNCPS/DOUBLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:42:56 $

p= double(m.xreglinear);
p= p(Terms(m.xreglinear));
p=[m.knots(:)
   p];
