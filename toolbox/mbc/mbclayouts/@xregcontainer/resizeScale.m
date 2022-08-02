function  resize(obj,scale)
%  Synopsis
%     function  size(obj,scale)
%
%
%  Description
%     resizes the whole xregcontainer by the specified scale
%
%  See Also
%     Methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:35:30 $


p = get(obj.g,'position');
p([3 4]) = p([3 4]).*scale;
set(obj.g,'position',p);





