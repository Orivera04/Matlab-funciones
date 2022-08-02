function  handles=gui_align_left(handles,offset)
%  Synopsis
%     function  gui_align_left(handles,offset)
%
%  Description
%     Aligns all objects against the left of the first object in order.
%
%     Handles is an array of positions
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:45 $


pleft=handles(1,1);
handles(2:end,1) = pleft+offset;