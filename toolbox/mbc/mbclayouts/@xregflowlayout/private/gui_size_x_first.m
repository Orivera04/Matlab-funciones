function  handles = gui_size_x_first(handles)
%  Synopsis
%     function  gui_size_x_first(handles)
%
%  Description
%     Sizes width of all objects to the same size as that of the first
%
%     Handles is an array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:53 $

handles(2:end,3)=handles(1,3);
