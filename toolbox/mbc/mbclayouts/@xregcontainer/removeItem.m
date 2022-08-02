function  removeItem(obj, index)
%  Synopsis
%     function  removeItem(obj, index)
%
%  Description
%     Removes an item at index from the xregcontainer
%     and repacks the group
%
%  See Also
%     Methods xregcontainer

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:35:25 $


elements = obj.g.elements;

len = length(elements);
if index > len
   error('Index out of range');
end

delete(elements{index});
select = find((1:len)~=index);
elements = {elements{select}};

obj.g.elements= elements;