function out=end(p,k,n)
% XREGPOINTER/END

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:05 $

s = size(p);

if all(s==1)
   out=1;
elseif sum(s>1)==1
   out = max(s);
else
   out = s(k);
end
