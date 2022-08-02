function  res = isempty(obj)
%  Synopsis
%     Returns 1 if the xregcontainer has no subcontrols or
%     0 if there are subcontrols
%
%
%  See Also
%     methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:22 $

res = isempty(obj.g.elements);



