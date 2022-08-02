function  handles=gui_pack_left(handles,space)
%  Synopsis
%     function  gui_pack_left(handles,gap)
%
%  Description
%     packs all objects against the left hand object in order.
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:50 $


if isempty(space)
   space = 0;
end

pstart=handles(1,1);
handles(2:end,1)=pstart+[cumsum(handles(1:end-1,3)+space)];   
