function  handles=gui_align_center(handles,offset)
%  Synopsis
%     function  gui_align_center(handles,offset)
%
%  Description
%     Aligns the center of all objects against the center of the first
%     object in order, along a vertical line.
%
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:44 $


pmid=handles(1,1)+handles(1,3).*0.5;
handles(2:end,1)=pmid-handles(2:end,3).*0.5 + offset;
