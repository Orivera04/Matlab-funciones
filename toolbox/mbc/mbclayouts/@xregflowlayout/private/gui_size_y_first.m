function  handles = gui_size_y_first(handles)
%  Synopsis
%     function  gui_size_y_first(handles)
%
%  Description
%     Sizes height of all objects to the same size as that of the first
%
%     Handles is array of positions
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:54 $


handles(2:end,4)=handles(1,4);