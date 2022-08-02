function cb_handles = factors(node, arg)
%FACTORS 
% CB_FUNCHANDLES = FACTORS( DATASETNODE, 'get_callbacks' ) returns a 
%  structure of function handles CB_FUNCHANDLES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.9.2.4 $  $Date: 2004/04/04 03:33:14 $

% all we can do here is return the callback structure
if nargin>1 && ischar( arg ) && strcmpi(arg, 'get_callbacks')
   cb_handles = i_GetCallbacks;
end

%------------------------------------------------------------------
function cb=i_GetCallbacks
%------------------------------------------------------------------
cb = [];
cb.View = @i_View;
cb.Show = @i_Show;
cb.Copy = @i_Copy;
cb.ExprClick = @i_ExprClick;
cb.FactorClick = @i_FactorClick;
cb.Selection = @i_Selection;
cb.ShowIndex = @i_ShowIndex;


%-----------------------------------------------------------------------
function d = i_Show(d)
%-----------------------------------------------------------------------
pr_ConfigureExprList(d.Handles.ExprList,d.Handles.BottomList);

pr_ConfigureList(d.Handles.FactorList,d.Handles.TopList,...
    {'Factor' , 'Status' , 'Information','Index'},...
    [150 , 150,  500, 0],...
    'Data Set Factors');

set(d.Handles.FactorList,'sortorder',0);
set(d.Handles.FactorList,'sortkey',1);
d.Handles.fm.BmVis = d.Handles.fm.FactorVisBm;
d.Handles.FactorList.FullRowSelect = 1;


%-----------------------------------------------------------------------
function ind = i_ListIndex
%-----------------------------------------------------------------------
ind = 3;


%-----------------------------------------------------------------------
function d = i_View(d,sel_index)
%-----------------------------------------------------------------------
if nargin<2
    sel_index = -1;
end
if d.pD.isempty
    help = {'Data set is empty.', ...
        '',...
        'Select project expressions below',...
        'and right-click to add to data set,',...
        'or use File -> Import -> Data to fill data set.'};
    pr_Message(d,help);
else
    % set up top list display
    set(d.Handles.TopCard,'currentcard',d.currentcard);
    % Got to make visible first, otherwise invoke(ensurevisible) fails
    i_RefreshList(d,-1);
end
d = pr_RefreshExprList(d,sel_index,'project');
d = i_ExprClick(d);



%-----------------------------------------------------------------------
function sel = i_Selection(d)
%-----------------------------------------------------------------------
sel = pr_getExprListSelection(d.Handles.FactorList,i_ListIndex);



%-----------------------------------------------------------------------
%
% Factor view
%
%-----------------------------------------------------------------------


%-----------------------------------------------------------------------
%
% Selection of new item
%  - generate appropriate links between lists
%
%-----------------------------------------------------------------------


%-----------------------------------------------------------------------
function d = i_ExprClick(d,l)
%-----------------------------------------------------------------------
i_SetListLinks(d,d.Handles.ExprList,d.Handles.FactorList,pr_ExprListIndex,i_ListIndex);

%-----------------------------------------------------------------------
function d = i_FactorClick(d,l)
%-----------------------------------------------------------------------
i_SetListLinks(d,d.Handles.FactorList,d.Handles.ExprList,i_ListIndex,pr_ExprListIndex);


%-----------------------------------------------------------------------
function i_SetListLinks(d,List1,List2,i1,i2)
%-----------------------------------------------------------------------
if List1.ListItems.Count==0 || List2.ListItems.Count==0
    % nothing in list
    return
end

ind1 = pr_getExprListSelection(List1,i1);

% Check what is currently selected in other box.
% If multi selection, deselect all.
if ~isempty(ind1)
    pr_DeselectList(List2);
end

%-----------------------------------------------------------------------
function d = i_ShowIndex(d,index)
%-----------------------------------------------------------------------
% Highlight the thing given in index
%  (prob. an error)
fact_i = d.Exprs.factor_index(index);

if fact_i
    list = d.Handles.FactorList;
    pr_DeselectList(list);
    items = list.ListItems;
    indexColumn = i_ListIndex;
    for i=1:double(items.Count)
        this = items.Item(i);
        thisi = sscanf(this.SubItems(indexColumn), '%d', 1);
        if thisi==index
            set(this,'selected',1);
            break
        end
    end
    d = i_FactorClick(d);
else
    % Must be in bottom list
    pr_ExprListSelect(d.Handles.ExprList,index);
    d = i_ExprClick(d);
end


%-----------------------------------------------------------------------
function data = i_Copy(d)
%-----------------------------------------------------------------------
if d.pD.isempty
   data = [];
else
   % can't just copy table contents - may have a limit on number
   %  of rows.
   %Check for selected columns
   factor_select = pr_getExprListSelection(d.Handles.FactorList,i_ListIndex);
   cols = d.Exprs.factor_index(factor_select);
   if isempty(cols)
      cols = 1:d.pD.get('numfactors');
   end
   data = d.pD.get('data');
   data = data(:,cols);    
   factors = d.pD.get('factors');
   heads = factors(cols);
   
   data={data,heads};
end



%-----------------------------------------------------------------------
function d = i_RefreshList(d,select_index)
%-----------------------------------------------------------------------
list = d.Handles.FactorList;

if nargin>1 
    if select_index<1
        select_index = pr_getExprListSelection(list,i_ListIndex);
    end
else
    select_index = [];
end

list.ListItems.Clear;

ind = find(d.Exprs.factor_index);
indstr = num2str(ind');
names = d.pD.get('assignednames');
overwrites = d.pD.get('isoverwrite');
evaluates = d.pD.get('isevaluation');
factor_type = d.pD.get('factor_type_names');

linked = d.pD.isLink;
data = d.pD.isDataOnly;
[isinput, isoutput] = getIsFactorType(d.pD.info);
select_item = [];
for i = 1:length(ind)
    fact_i = d.Exprs.factor_index(ind(i));
    if linked(fact_i)
        assigntxt = d.Exprs.types{ind(i)};
    elseif data(fact_i) && isoutput(fact_i)
        assigntxt = 'Output: Data';
    elseif isoutput(fact_i)
        if d.Exprs.eval(ind(i))
            assigntxt = ['Output: ' d.Exprs.types{ind(i)}];
        else
            assigntxt = 'Cannot evaluate';
        end
    else
        assigntxt = factor_type{fact_i};
    end
    mainicon = d.Exprs.tpicons(ind(i));
    if linked(fact_i)
        assignicon = bmp2ind(d.ILmanager,'cglink.bmp');
    elseif overwrites(fact_i)
        assignicon = bmp2ind(d.ILmanager,'cgdsoverwrite.bmp');
    elseif evaluates(fact_i) && d.Exprs.eval(ind(i))
        assignicon = bmp2ind(d.ILmanager,'cgdsevaluation.bmp');
    else
        assignicon = 0;
    end
    hand = list.ListItems.Add;
    set(hand , 'smallicon' , mainicon);
    set(hand , 'text' , names{fact_i});
    set(hand , 'subitems',1,assigntxt);
    set(hand.ListSubItems.Item(1),'reporticon',assignicon);
 
    if strcmp(d.Exprs.infos{ind(i)},'In data set')
        set(hand , 'subitems',2,'');
    else
        set(hand , 'subitems',2,d.Exprs.infos{ind(i)});
    end
    set(hand , 'subitems',3,indstr(i,:));

    set(hand , 'selected' , false);
    if ~isempty(select_index) && any(select_index==ind(i))
        select_item = [select_item hand];
    end
end
if length(select_item)>0
    for i = 1:length(select_item)
        set(select_item(i),'selected',true);
    end
    set(list,'SelectedItem',select_item(1));
    EnsureVisible(select_item(1));
end
