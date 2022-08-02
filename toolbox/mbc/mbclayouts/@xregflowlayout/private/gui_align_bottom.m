function  handles=gui_align_bottom(handles,offset)
%  Synopsis
%     function  handles=gui_align_bottom(handles,offset)
%
%  Description
%     Aligns all objects against the bottom of the first object in order.
%
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:43 $


% input is a matrix of positions
p_base=handles(1,2);
handles(2:end,2)=p_base+offset;  
