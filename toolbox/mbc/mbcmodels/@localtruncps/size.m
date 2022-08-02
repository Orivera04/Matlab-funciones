function s= size(ts,dim)
% LOCALTRUNCPS/SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:16 $
s= [numParams(ts.xreglinear)+length(ts.knots),1];
if nargin>1
   s= s(dim);
end
