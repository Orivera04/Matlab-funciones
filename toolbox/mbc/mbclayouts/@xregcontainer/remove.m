function  remove(obj, index)
%  Synopsis
%     function  remove(obj, index)
%
%  Description
%     Removes an item at index from the xregcontainer
%     and repacks the group.  The item is not deleted,
%     but its reference is removed from the list.
%
%  Example
%
%
%  See Also
%     Methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:24 $


elements = obj.g.elements;

len = length(elements);
if index > len
   error('Index out of range');
end

elements(index)=[];

obj.g.elements = elements;