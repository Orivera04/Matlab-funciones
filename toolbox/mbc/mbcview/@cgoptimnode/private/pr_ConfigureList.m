function pr_ConfigureList(lh, cols, width);
%PR_CONFIGURELIST 
%
%   Private method to configure any of the list controls in cgoptimnode

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:27:29 $

% INPUTS    :   lh          -   Handle to the ActiveX list
%               cols        -   The column headers in the list control
%               width       -   Default column widths

hCols = lh.ColumnHeaders;
for n = 1:length(cols)
    hItem = invoke(hCols , 'Add');
    set(hItem , 'text' , cols{n});
    set(hItem , 'width' , width(n));
end