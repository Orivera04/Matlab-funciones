function n = size(m,dim)
%SIZE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:00:16 $

n = 0;
for i = 1:length(m.Global)
   n = n+ numParams(m.Global{i});
end

n = [n 1];

if nargin == 2
   n = n(dim);
end
