function delete(obj)
%DELETE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:19:11 $

for i = 1:length(obj.objects)
    delete(obj.objects{i});
end
