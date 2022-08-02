function s= size(m,dim);
%SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:33 $

if nargin==1
   s= size(m.mv3xspline);
else
   s= size(m.mv3xspline,dim);
end   