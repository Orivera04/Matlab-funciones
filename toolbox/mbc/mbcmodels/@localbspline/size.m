function s= size(bs,dim)
%SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:26 $

s= [get(bs.xreg3xspline,'numknots'),0]+size(bs.xreg3xspline); 
if nargin>1
   s= s(dim);
end
