function varargout = ImportDlg(varargin)
%IMPORTDLG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.4 $  $Date: 2004/04/04 03:33:11 $

varargout{1} = i_GetCallbacks;
return

%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb = [];
cb.Show = @i_Show;
cb.View = @i_View;
cb.Click = @i_Click;
cb.Setup = @i_Setup;

%-----------------------------------------------------------------------
function [d,lyt] = i_Setup(d)
%-----------------------------------------------------------------------
lyt = [];
return

%-----------------------------------------------------------------------
function d = i_Show(d)
%-----------------------------------------------------------------------

set(d.Dlg.Lyt,'visible','off');

el = get(d.Dlg.MainLyt,'elements');
rows = get(d.Dlg.MainLyt,'rowsizes');
el{3} = []; rows(3) = 0;
set(d.Dlg.MainLyt,'elements',el,...
    'rowsizes',rows);

if d.Dlg.Wizard
    set(d.Dlg.Figure,'name','Data Set Import Wizard');
    set(d.Dlg.ButtonCard, 'currentcard', 2);
    set(d.Dlg.Back, 'enable','off');
    set(d.Dlg.Next, 'enable','on','string','Next ->','callback',@cb_Next);
else
    set(d.Dlg.Figure,'name','Data Set Import');
    set(d.Dlg.ButtonCard, 'currentcard', 1);
    set(d.Dlg.OK, 'callback',@cb_OK);
end
set(d.Dlg.Cancel, 'enable','on','callback',@cb_Cancel);

set(get(d.Dlg.Lyt, 'center'), 'title', 'Select data columns to include in data set');
set(d.Dlg.Title,'string','');
    
set(d.Dlg.TopButton,'imagefile','tick.bmp',...
    'transparentcolor',[255 0 255],...
    'tooltip','Include data columns',...
    'callback',@cb_Include);
set(d.Dlg.BottomButton,'imagefile','cross.bmp',...
    'transparentcolor',[255 0 255],...
    'tooltip','Exclude data columns',...
    'callback',@cb_Exclude);

pr_ConfigureList(d.Dlg.LeftList,d.Dlg.LeftListLyt,...
    {'Name' 'Column' 'Units'},...
    [150 80 80],...
    'Included Columns');
pr_ConfigureList(d.Dlg.RightList,d.Dlg.RightListLyt,...
    {'Name' 'Column' 'Units'},...
    [150 80 80],...
    'Excluded Columns');
set(d.Dlg.MsgPane,'string','');

d.Dlg.LeftList.MultiSelect = true;
d.Dlg.RightList.MultiSelect = true;

set(d.Dlg.Lyt,'visible','on');
set(d.Dlg.Figure,'visible','on','windowstyle','modal');

%-----------------------------------------------------------------------
function d = i_View(d,fact_i)
%-----------------------------------------------------------------------
if nargin<2
    fact_i = [];
end
[d,emptyl] = i_RefreshList(d,d.Dlg.LeftList,1,fact_i);
[d,emptyr] = i_RefreshList(d,d.Dlg.RightList,0,fact_i);
i_doButtons(d,emptyl,emptyr);

%-----------------------------------------------------------------------
function i_doButtons(d,emptyl,emptyr)
%-----------------------------------------------------------------------
if emptyl
    set(d.Dlg.BottomButton,'enable','off');
else
    set(d.Dlg.BottomButton,'enable','on');
end
if emptyr
    set(d.Dlg.TopButton,'enable','off');
else
    set(d.Dlg.TopButton,'enable','on');
end

% Disable Next button if there are no items in the left list
if d.Dlg.LeftList.ListItems.Count==0
    set(d.Dlg.Next, 'enable', 'off');
else
    set(d.Dlg.Next, 'enable', 'on');
end


%-----------------------------------------------------------------------
function d = i_Message(d,mess)
%-----------------------------------------------------------------------
set(d.Dlg.MsgPane,'string',mess);


%-----------------------------------------------------------------------
function d = i_Click(d,list)
%-----------------------------------------------------------------------
switch list
case 'top'
    other = d.Dlg.RightList;
case 'bottom'
    other = d.Dlg.LeftList;
end
pr_DeselectList(other);
emptyl = isempty(pr_getExprListSelection(d.Dlg.LeftList,1));
emptyr = isempty(pr_getExprListSelection(d.Dlg.RightList,1));
i_doButtons(d,emptyl,emptyr);

%-----------------------------------------------------------------------
function cb_Next(varargin)
%-----------------------------------------------------------------------
% Go on to assign view
d = pr_GetViewData;
d = pr_ChangeView(d,'assigndlg');
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Cancel(varargin)
%-----------------------------------------------------------------------
% Go back to where we were before
%  (Been working on a temp copy of the dataset, so don't need to do
%   anything to restore old version)
d = pr_GetViewData;
set(d.Dlg.Figure,'visible','off');
d.Dlg.Wizard = 0;
% Addition for empty sessions
if ~isfield(d.Dlg, 'OldViewID')
    % If this session only contains a dataset, then default to factor view 
    % cancel
    d = pr_ChangeView(d, 'factors');
else
    d = pr_ChangeView(d,d.Dlg.OldViewID);
end
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Include(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
fact_i = pr_getExprListSelection(d.Dlg.RightList,1);
d.Dlg.tmp = set(d.Dlg.tmp,fact_i,'factor_type','input');
d = i_Message(d,'');
d = i_View(d,fact_i);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Exclude(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
fact_i = pr_getExprListSelection(d.Dlg.LeftList,1);
d.Dlg.tmp = set(d.Dlg.tmp,fact_i,'factor_type','ignore');
d = i_Message(d,'');
d = i_View(d,fact_i);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function [d,empty] = i_RefreshList(d,list,include,select_index)
%-----------------------------------------------------------------------
select_item = []; old_item = [];
old_i = i_FindNearest(list);
list.ListItems.Clear;

[in_i,out_i,ig_i] = getFactorTypes(d.Dlg.tmp);

if include
    ind = [in_i out_i];
else
    ind = ig_i;
end
indstr = num2str(ind(:));
names = get(d.Dlg.tmp,'orig_name');
for i = 1:length(ind)
    hand = list.ListItems.Add;
    set(hand , 'text' , names{ind(i)});
    set(hand , 'subitems',1,indstr(i,:));
    units = getunits(d.Dlg.tmp,ind(i));
    if ~isempty(units)
       set(hand , 'subitems',2,char(units));
    end
    set(hand , 'selected' , 0);
    if ~isempty(select_index) && any(select_index==ind(i))
        select_item = [select_item hand];
    elseif ~isempty(old_i) && any(old_i==ind(i))
        old_item = [old_item hand];
    end
end
sel = 1;
if length(select_item)==0, select_item = old_item;  sel = 0; end
if length(select_item)
    set(list,'SelectedItem',select_item(1));
    for i = 1:length(select_item)
        set(select_item(i),'selected',sel);
    end
    drawnow; % this is needed to make sure the selected item becomes visible;
    % the drawing doesn't pick up the new list otherwise
    EnsureVisible(select_item(1));
end

empty = (length(select_item)==0 | sel==0);

%-----------------------------------------------------------------------
function fact_i = i_FindNearest(list)
%-----------------------------------------------------------------------
found = 0;
if list.listitems.count>0
   ind = double(list.selecteditem.index);
   while ind>1 && ~found
      if get(list.ListItems.Item(ind),'selected')
         ind = ind-1;
      else
         found = ind;
      end
   end
end
if found
   item = list.ListItems.Item(found);
   fact_i = str2double(item.SubItems(1));
else
   fact_i = [];
end

%-----------------------------------------------------------------------
function cb_OK(varargin)
%-----------------------------------------------------------------------
% Import the data into the dataset. 
% Note that in this case, the CAGE session only consists of the dataset
d = pr_GetViewData;
set(d.Dlg.Figure,'visible','off');
[in_i,out_i,ig_i] = getFactorTypes(d.Dlg.tmp);
if d.Dlg.DeleteExcluded
    d.Dlg.tmp = removefactor(d.Dlg.tmp,ig_i);
end
out_i = find(isDataOnly(d.Dlg.tmp));
%out_i = 1:length(get(d.Dlg.tmp, 'factors'));
d.Dlg.tmp = set(d.Dlg.tmp,out_i,'factor_type','output');
% Copy all the changes we've made
d.pD.info = d.Dlg.tmp;
% Note that because there are no expressions in the dataset, we don't need
% to do a check_eval. This is nice, because check_eval isn't happy
% without an expression or two
d.Exprs.recalc = [0 0 1 0];
d = pr_ChangeView(d,d.OldViewID);
pr_SetViewData(d);
% Update the tree name, ensure it's unique
c = cgbrowser;
CGP = project(d.nd);
myname = getname(d.pD.info);
d.pD.info = d.pD.setname('');
myname = uniquename(CGP, myname);
d.pD.info = setname(d.pD.info, myname);
c.doDrawTree(address(d.nd), 'update');
