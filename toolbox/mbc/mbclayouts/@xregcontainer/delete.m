function delete(obj)
%DELETE Delete layout and all contained elements
%
%  Synopsis
%     function  delete(obj)
%
%
%  Description
%     deletes all the elements within the xregcontainer
%
%  Example
%     delete(po);
%
%  See Also
%     methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:16 $

if ishandle(obj.g)
    delete(obj.g);
end
