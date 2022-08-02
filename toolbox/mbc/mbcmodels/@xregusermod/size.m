function s=size(U,dim)
% xregusermod/SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:42 $

s= [length(U.parameters),1];
if nargin>1
   s= s(dim);
end