function  len = length(obj)
%  Synopsis
%     function  len = length(obj)
%
%  Description
%     tests how many handles are in this container
%
%
%  See Also
%     methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:23 $

len = length(obj.g.elements);


