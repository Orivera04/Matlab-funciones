function [col_mat,mark_mat,repeated] = ColorMatrix(obj,n,col_order,marker_order);
% [col_mat,mark_mat] = ColorMatrix(obj,n)
% [col_mat,mark_mat] = ColorMatrix(obj,n,col_order,marker_order)
% [col_mat,mark_mat,repeated] = ColorMatrix(...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:31:38 $

if nargin<3
    col_order = 'bmrygc';
end
if nargin<4
    marker_order = 'ov^<>';
end
if ischar(col_order)
    col_order = cellstr(col_order(:));
elseif isnumeric(col_order) & size(col_order,2)==3
    col_order = num2cell(col_order,2);
elseif ~iscell(col_order)
    col_order = cellstr(('bmrygc')');
end
if ischar(marker_order)
    marker_order = cellstr(marker_order(:));
elseif ~iscell(marker_order)
    marker_order = cellstr(('ov^<>')');
end

% build matrix of colors and marker types
col_i = 1; mark_i = 1;
col_mat = []; mark_mat = [];
for i = 1:n
    col_mat = [col_mat col_order(col_i) ];
    mark_mat = [mark_mat marker_order(mark_i)];
    col_i = rem(col_i,size(col_order,1))+1;
    if col_i == 1
        mark_i = rem(mark_i,length(marker_order))+1;
    end
end
repeated = (n> length(marker_order)*length(col_order));
