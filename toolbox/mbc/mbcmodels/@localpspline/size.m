function s=size(ps,dim);
% localpspline/SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:36 $

s= [sum(ps.order) 1];
if nargin==2
   s= s(dim);
end