function [col_mat,mark_mat] = MatchColor(obj,col_mat,mark_mat,items,old_col,old_mark,old_items);
% [col_mat,mark_mat] = MatchColor(obj,col_mat,mark_mat,items,old_col,old_mark,old_items);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:31:39 $

if length(old_col)==length(old_items) & length(old_mark)==length(old_items)

for i = 1:length(old_items)
    f = strmatch(old_items{i},items,'exact');
    if length(f)==1
        old_color = old_col{i};
        old_marker = old_mark{i};
        % Do old color and marker exist within new matrix?
        f2 = [];
        for j = 1:length(col_mat)
            if ischar(col_mat{j}) & ischar(old_color) & strcmp(col_mat{j},old_color)
                f2 = j;
                break
            elseif isnumeric(col_mat{j}) & isnumeric(old_color) & all(col_mat{j}==old_color)
                f2 = j;
                break
            end
        end
        %  swap the colors of the old color with the one we are replacing,
        %   to prevent colors being repeated.
        if length(f2)==1
            col_mat{f2} = col_mat{f};
            mark_mat{f2} = mark_mat{f};
        end
        % Set color matrix of the old item to its old colors
        col_mat{f} = old_color;
        mark_mat{f} = old_marker;
    end
end
end