function  handles=gui_align_right(handles,offset)
%  Synopsis
%     function  gui_align_right(handles,offset)
%
%  Description
%     Aligns all objects against the right of the first object in order.
%
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:47 $

pright=handles(1,1)+handles(1,3);
handles(2:end,1)=pright-handles(2:end,3)+offset;
