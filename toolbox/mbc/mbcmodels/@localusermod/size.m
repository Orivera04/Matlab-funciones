function s=size(u,dim);
%SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:44:05 $

s= size(u.userdefined);
if nargin==2
   s= s(dim);
end