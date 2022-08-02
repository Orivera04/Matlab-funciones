function  handles=gui_align_top(handles,offset)
%  Synopsis
%     function  gui_align_top(handles,offset)
%
%  Description
%     Aligns all objects against the top of the first object in order.
%
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:48 $

p_top=handles(1,2)+handles(1,4);
handles(2:end,2)=p_top-handles(2:end,4)+offset;
