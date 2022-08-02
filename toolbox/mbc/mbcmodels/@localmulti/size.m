function s= size(L,dim);
%LOCALMULTI/SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.2 $  $Date: 2004/02/09 07:40:12 $

m= get(L.xregmulti,'currentmodel');
s= [numParams(m),1];
if nargin~=1
   s= s(dim);
end   
return
