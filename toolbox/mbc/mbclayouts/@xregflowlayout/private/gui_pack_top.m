function  handles=gui_pack_top(handles,space)
%  Synopsis
%     function  gui_pack_top(handles,gap)
%
%  Description
%     Packs all objects against the top object in order.
%     The first object is considered to be the  top most desired
%     object and then so on....
%
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:52 $


if isempty(space)
   space = 0;
end
pstart=handles(1,2);
handles(2:end,2)=pstart-[cumsum(handles(2:end,4)+space)];   
