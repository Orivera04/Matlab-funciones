function n= size(m,dim);
% MODEL/SIZE size of a model is size of the paramter vector (returned by double(m))

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:09 $

p= double(m);
n= [length(p) nfactors(m)];

if nargin>1
   n= n(dim);
end