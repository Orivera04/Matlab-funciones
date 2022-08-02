function d = pr_RefreshExprList(d,select_index,option,unitfilter)
%d = pr_RefreshExprList(d,select_index,option,unitfilter)
%  option = 'outputs','dataset','feature','project'
% call with select_index = expression index to make that expression selected
% call with select_index = -1 to keep current expression selected

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 08:22:30 $

if nargin<4, unitfilter = []; end
list = d.Handles.ExprList;

if nargin>1
    if select_index<0
        select_index = pr_getExprListSelection(list);
    end
else
    select_index = [];
end

invoke(get(list,'listitems'),'clear');

if isempty(d.Exprs.ptrs)
    ind = [];
    title = '';
else
    switch option
    case {'cage','project'}
        ind = d.Exprs.FilterIndex{1};
        title = 'Project Expressions';
    case {'outputs','all'}
        ind = d.Exprs.FilterIndex{2};
        title = 'Output Expressions (Project and Data Set)';
    case 'feature'
        ind = d.Exprs.FilterIndex{3};
        title = 'Features and Models';
    case 'dataset'
        ind = d.Exprs.FilterIndex{4};
        title = 'Data Set Factors';
    otherwise
        error('invalid option');
    end
end

if isempty(ind)
    pr_ConfigureList(d.Handles.ExprList,d.Handles.BottomList,...
        'empty',...
        'No expressions.',...
        title);
else
    pr_ConfigureExprList(d.Handles.ExprList,d.Handles.BottomList);
    if ~isempty(unitfilter)
        rem = [];
        for n = ind
            if ~isempty(d.Exprs.units(n)) && ~compatible(unitfilter,d.Exprs.units(n))
                rem = [rem n];
            end
        end
        ind = setdiff(ind,rem);
        title = [title ' (filter by ' char(unitfilter) ')'];
    end
    
    set(d.Handles.BottomList,'title',title);
    
    d.Exprs.BottomShown = ind;
    
    select_item = [];
    tradeofftypestr = get(cgtypes.cgtradeofftype, 'typestring');
    for n = ind
        if strcmp(d.Exprs.types(n), 'Feature')
            FeatureOK = i_CheckFeature(d.Exprs.ptrs(n));
        else
            FeatureOK = 1;
        end
        if ~strcmp(d.Exprs.types{n}, tradeofftypestr) && FeatureOK
            hand = list.ListItems.Add;
            set(hand , 'text' , d.Exprs.names{n});
            set(hand , 'smallicon' , d.Exprs.icons(n));
            set(hand , 'subitems',1,d.Exprs.types{n});
            set(hand , 'subitems',2,d.Exprs.infos{n});
            set(hand , 'subitems',3, sprintf('%d', n));
            set(hand , 'selected' , false);
            if ~isempty(select_index) && any(select_index==n)
                select_item = [select_item hand];
            end
        end
    end
    
    if length(select_item)>0
        for n = 1:length(select_item)
            set(select_item(n),'selected', true);
        end
        set(list,'SelectedItem',select_item(1));
        drawnow; % this is needed to make sure the selected item becomes visible;
        % the drawing doesn't pick up the new list otherwise
        EnsureVisible(select_item(1));
    end
end

%--------------------------------------------------------------------------
function FeatureOK = i_CheckFeature(featptr)
%--------------------------------------------------------------------------
% This stops empty and partially empty features being shown in the 
% expression list.
mod = featptr.get('model');
eq = featptr.get('equation');

if ~isempty(mod) && ~isempty(eq)
    FeatureOK = true;
else
    FeatureOK = false;
end
