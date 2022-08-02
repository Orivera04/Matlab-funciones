function  handles=gui_align_middle(handles,offset)
%  Synopsis
%     function  gui_align_middle(handles,offset)
%
%  Description
%     Aligns the center of all objects against the center of the first
%     object in order.
%
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:46 $

midp=handles(1,2)+handles(1,4).*0.5;
handles(2:end,2)=midp - handles(2:end,4).*0.5 + offset;
