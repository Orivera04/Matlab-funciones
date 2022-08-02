function d = size(obj,dim)
%SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:04:11 $

if nargin < 2
   d = [1 count(obj)];
else
   if dim == 2
   	d = count(obj);
	else
      d = 1;
   end
end
