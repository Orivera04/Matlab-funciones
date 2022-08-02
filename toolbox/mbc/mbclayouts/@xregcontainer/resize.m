function   resize(obj,new_size)
%  Synopsis
%     function  size(obj,size)
%
%
%  Description
%     resizes the whole package to the specified size
%
%  Example
%     h = [uicontrol uicontrol uicontrol];
%     p = packObject(h,'pl',0);
%     resize(p,[10 10]);
%
%  See Also
%     methods Container

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:29 $



p = get(obj,'Position');
p(3:4) = new_size;
obj = set(obj,'position',p);

