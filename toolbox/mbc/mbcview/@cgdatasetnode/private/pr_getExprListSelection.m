function expr_ind = pr_getExprListSelection(list,itemind)
%PR_GETEXPRLISTSELECTION

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:22:33 $

if nargin<2
    itemind = pr_ExprListIndex;
end
% What happens if ind==0?
expr_ind = [];
if list.ListItems.Count>0 & list.ColumnHeaders.Count>1 & ~isempty(itemind)
    % ie not empty
    expr_select = get(list,'selecteditemindex');
    if ~isempty(expr_select)
        for i = 1:length(expr_select)
            this = list.ListItems.Item(expr_select(i));
            if itemind
                expr_ind = [expr_ind str2double(this.SubItems(itemind))];
            else
                expr_ind = [expr_ind str2double(get(this,'text'))];
            end
        end
        if any(isnan(expr_ind))
            expr_ind = [];
        end
    end
end
