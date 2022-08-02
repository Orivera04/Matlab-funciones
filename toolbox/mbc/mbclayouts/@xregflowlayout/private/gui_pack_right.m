function  handles=gui_pack_right(handles,space)
%  Synopsis
%     function  gui_pack_right(handles, gap)
%
%  Description
%     Packs all objects against the right hand object in order.
%     The first object is considered to be the right most desired
%     object and then so on....
%
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:51 $


if isempty(space)
   space = 0;
end

pstart=handles(1,1);
handles(2:end,1)=pstart-[cumsum(handles(2:end,3)+space)];   
