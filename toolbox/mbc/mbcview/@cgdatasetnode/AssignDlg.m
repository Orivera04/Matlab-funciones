function varargout = AssignDlg(varargin)
%ASSIGNDLG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.10.4.4 $  $Date: 2004/04/04 03:33:08 $

varargout{1} = i_GetCallbacks;
return

%-----------------------------------------------------------------------
function i_Repack(varargin)
%-----------------------------------------------------------------------
repack(varargin{3});

%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb = [];
cb.Show = @i_Show;
cb.View = @i_View;
cb.Setup = @i_Setup;
cb.Enable = @i_Enable;

%-----------------------------------------------------------------------
function [d,lyt] = i_Setup(d)
%-----------------------------------------------------------------------
d.AssignDlg.Advanced = 0;
lyt = [];
return

%-----------------------------------------------------------------------
function en = i_Enable(op)
%-----------------------------------------------------------------------
d = pr_GetViewData;
en = any(isImported(op));
% Need to also check that there are expressions in the project
if ~isfield(d.Exprs, 'Eptrs') | isempty(d.Exprs.Eptrs)
    en = 0;
end
%-----------------------------------------------------------------------
function d = i_Show(d)
%-----------------------------------------------------------------------
set(d.Dlg.Lyt,'visible','off');
el = get(d.Dlg.MainLyt,'elements');
rows = get(d.Dlg.MainLyt,'rowsizes');
el{3} = d.Dlg.Checks; rows(3) = 60;rows(1) = 35;
set(d.Dlg.MainLyt,'elements',el,...
    'rowsizes',rows);

if d.Dlg.Wizard
    set(d.Dlg.Figure,'name','Data Set Import Wizard');
    set(d.Dlg.ButtonCard, 'currentcard', 2);
    set(d.Dlg.Back, 'enable','on','callback',@cb_Back);
    set(d.Dlg.Next, 'enable','on','string','Finish','callback',@cb_Finish);
else
    d.Dlg.tmp = d.pD.info;
    set(d.Dlg.Figure,'name','Data Set Assign');
    set(d.Dlg.ButtonCard, 'currentcard', 1);
    set(d.Dlg.OK, 'callback',@cb_Finish);
end
set(d.Dlg.Cancel, 'enable','on','callback',@cb_Cancel);

set(d.Dlg.Check1,'callback',@cb_Units,...
    'value',d.CheckUnits,...
    'string','Check units');
set(d.Dlg.Check2,'callback',@cb_Advanced,...
    'value',d.AssignDlg.Advanced,...
    'string','Show all expressions');

%%%%%%% RESET THIS LINE WHEN UNITS REINSTALLED .....
%set(d.Dlg.Checks,'elements',{d.Dlg.Check1 d.Dlg.Check2 [] []});
%%%%%%% ..... AND DELETE THIS ONE
set(d.Dlg.Checks,'elements',{[] d.Dlg.Check2 [] []});
    
set(d.Dlg.TopButton,'imagefile','assign.bmp',...
    'transparentcolor',[255 255 255],...
    'tooltip','Assign Data Column to Project Expression',...
    'enable','on',...
    'callback',@cb_Assign);
set(d.Dlg.BottomButton,'imagefile','unassign.bmp',...
    'transparentcolor',[255 255 255],...
    'enable','on',...
    'tooltip','Unassign Project Expression',...
    'callback',@cb_Unassign);
set(get(d.Dlg.Lyt, 'center'), 'title', 'Match data columns in right list to project expressions in left list');
% set(get(d.Dlg.Lyt, 'center'), 'visible', 'on');
set(d.Dlg.Title,'string',{'' 'Note: Unassigned columns will be treated as output data'});
set(d.Dlg.MsgPane,'string','');

ind = d.Exprs.FilterIndex{5};
tmp = cgoppoint(d.Exprs.ptrs(ind));
tmp = CheckGroup(tmp);
d.AssignDlg.DDindex = ind;
d.AssignDlg.DDgroup = repmat(0,1,length(d.Exprs.ptrs));
d.AssignDlg.DDgroup(d.AssignDlg.DDindex) = get(tmp,'group');
d.AssignDlg.LeftIndex = [];
d.AssignDlg.RightIndex = [];

set(d.Dlg.Lyt,'visible','on');
set(d.Dlg.Figure,'visible','on', 'closerequestfcn',@cb_Cancel, 'WindowStyle', 'modal');

%-----------------------------------------------------------------------
function d = i_View(d)
%-----------------------------------------------------------------------
d = i_RefreshProjectList(d);
d = i_RefreshColumnList(d);

%-----------------------------------------------------------------------
function d = i_Message(d,mess)
%-----------------------------------------------------------------------
set(d.Dlg.MsgPane,'string',mess);

%------------------------------------------------------------------
function fstr = i_prettycell(namec);
%------------------------------------------------------------------
fstr = '';
for i = 1:length(namec)
    fstr = [fstr namec{i} ', '];
end
fstr = fstr(1:end-2);

%-----------------------------------------------------------------------
function cb_Finish(varargin)
%-----------------------------------------------------------------------
% Finish up
d = pr_GetViewData;
set(d.Dlg.Figure,'visible','off');
set(get(d.Dlg.Lyt, 'center'), 'title', '');
[in_i,out_i,ig_i] = getFactorTypes(d.Dlg.tmp);
if d.Dlg.DeleteExcluded
    d.Dlg.tmp = removefactor(d.Dlg.tmp,ig_i);
end
d.Dlg.tmp = eval_fill(d.Dlg.tmp);
% Check names
[d.Dlg.tmp,changed_i,oldnames,newnames] = CheckNames(d.Dlg.tmp,project(d.nd));
if ~isempty(changed_i)
    mess = {'Data columns have names which already exist in project.'};
    if length(changed_i)<5
        mess = [mess {'Changing names of following columns:'}];
        for i = 1:length(changed_i)
            mess = [mess {[oldnames{i} ' to ' newnames{i}]}];
        end
    else
        mess = [mess {'Changing column names.'}];
    end
    uiwait(msgbox(mess,...
        'Data Set Viewer','help','modal'));
end
in_i = find(isAssigned(d.Dlg.tmp));
out_i = find(isDataOnly(d.Dlg.tmp));
d.Dlg.tmp = set(d.Dlg.tmp,out_i,'factor_type','output');
d.Dlg.tmp = set(d.Dlg.tmp,in_i,'factor_type','input');
% Copy all the changes we've made
d.pD.info = d.Dlg.tmp;
d.Exprs.recalc = [0 1 1 0];
d = pr_ChangeView(d,d.OldViewID);
% If data has just been imported then update the data set name - ensure unique
if d.Dlg.Wizard
    c = cgbrowser;
    CGP = project(d.nd);
    myname = getname(d.pD.info);
    d.pD.info = d.pD.setname('');
    myname = uniquename(CGP, myname);
    d.pD.info = setname(d.pD.info, myname);
    c.doDrawTree(address(d.nd), 'update');
end
d.Dlg.Wizard = 0;
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Back(varargin)
%-----------------------------------------------------------------------
% Go back to import view
d = pr_GetViewData;
d = pr_ChangeView(d,'importdlg');
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Cancel(varargin)
%-----------------------------------------------------------------------
% Go back to where we were before
%  (Been working on a temp copy of the dataset, so don't need to do
%   anything to restore old version)
d = pr_GetViewData;
d.Dlg.Wizard = 0;
set(d.Dlg.Figure,'visible','off');
set(get(d.Dlg.Lyt, 'center'), 'title', '');
d.Import.Success = 0;
d = pr_ChangeView(d,d.OldViewID);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Units(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
d.CheckUnits = get(d.Dlg.Check1,'value');
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Advanced(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
d.AssignDlg.Advanced = get(d.Dlg.Check2,'value');
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Assign(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
indL = pr_getExprListSelection(d.Dlg.LeftList,d.AssignDlg.LeftIndex);
fact_i = pr_getExprListSelection(d.Dlg.RightList,d.AssignDlg.RightIndex);
ptr = d.Exprs.ptrs(indL);
factors = get(d.Dlg.tmp,'orig_name');
mess = ''; err = 0;
% Checks
if d.CheckUnits
    punit = ptr.grabUnits;
    dunit = getunits(d.Dlg.tmp,fact_i);
    if ~isempty(punit) & ~isempty(dunit)
        if ~compatible(punit,dunit)
            mess = ['Units not compatible: ' char(punit) ', ' char(dunit) '.  Not assigning.'];
            err = 1;
        elseif punit~=dunit
            % Conversion carried out in Assign(cgoppoint)
            mess = ['Converting data column from ' char(dunit) ' to ' char(punit) '.'];
        end
    end
end
% Already assigned?  Remove ptr from old factor
assigned = isAssigned(d.Dlg.tmp,d.Exprs.ptrs);
if assigned(indL) & ~err
    old_fact_i = getFactorIndex(d.Dlg.tmp,ptr);
    if old_fact_i~=fact_i
        d.Dlg.tmp = Unassign(d.Dlg.tmp,old_fact_i);
        mess = ['Assigning ' factors{fact_i} ' to ' d.Exprs.names{indL} ...
                '; unassigning data column ' factors{old_fact_i} '.'];
    else
        mess = [d.Exprs.names{indL} ' is already assigned to data column ' factors{old_fact_i}];
        err = 1;
    end
end
% DD variable in group?  Can only assign one thing - unassign other ones.
gno = d.AssignDlg.DDgroup(indL);
if gno & ~err
    allgroup_i = find(d.AssignDlg.DDgroup==gno);
    group_i = setdiff(allgroup_i,indL);
    f = find(assigned(group_i));
    if ~isempty(f)
        old_fact_i = getFactorIndex(d.Dlg.tmp,d.Exprs.ptrs(group_i(f)));
        if old_fact_i ~= fact_i
            d.Dlg.tmp = Unassign(d.Dlg.tmp,old_fact_i);
            mess = ['Only one assignment permitted within group ' ...
                    i_prettycell(d.Exprs.names(allgroup_i)) '.'];
        end
    end
end
if ~err
    d.Dlg.tmp = assign(d.Dlg.tmp,fact_i,ptr);
end
d = i_Message(d,mess);
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Unassign(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
indL = pr_getExprListSelection(d.Dlg.LeftList,d.AssignDlg.LeftIndex);
ptr = d.Exprs.ptrs(indL);
mess = '';
% Checks
% Already assigned?  Remove ptr from old factor
assigned = isAssigned(d.Dlg.tmp,d.Exprs.ptrs);
if assigned(indL)
    old_fact_i = getFactorIndex(d.Dlg.tmp,ptr);
    d.Dlg.tmp = Unassign(d.Dlg.tmp,old_fact_i);
else
    mess = [d.Exprs.names{indL} ' is not assigned.'];
end
d = i_Message(d,mess);
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function d = i_RefreshProjectList(d)
%-----------------------------------------------------------------------
list = d.Dlg.LeftList;
select_index = pr_getExprListSelection(list,d.AssignDlg.LeftIndex);
select_item = [];
heads = {'Project' 'Units' 'Data Column' 'index'};
widths = [150  80 100 0];
showcol = [1 0 1 1];
if d.CheckUnits
    showcol(2) = 1;
end
f = find(showcol);
heads = heads(f);
widths = widths(f);
map = repmat(0,size(showcol));
map(f) = [1:length(f)] - 1;

pr_ConfigureList(list,d.Dlg.LeftListLyt,heads,widths,'Project Assignments');
list.MultiSelect = 0;

orig_names = get(d.Dlg.tmp,'orig_name');

if d.AssignDlg.Advanced
    ind = d.Exprs.FilterIndex{1};
else
    ind = d.AssignDlg.DDindex;
end
d.AssignDlg.LeftIndex = map(4);

fact_i = getFactorIndex(d.Dlg.tmp,d.Exprs.ptrs(ind));
indstr = num2str(ind(:));
LI = list.ListItems;
for i = 1:length(ind)
   hand = LI.Add;
   set(hand , 'text' , d.Exprs.names{ind(i)});
   icon = bmp2ind(d.ILmanager,d.Exprs.ptrs(ind(i)).iconfile);
   set(hand , 'smallicon' , icon);
   if fact_i(i)
      dsname = orig_names{fact_i(i)};
   else
      dsname = '';
   end
   if showcol(2)
      set(hand , 'subitems',map(2),d.Exprs.unitchar{ind(i)});
   end
   if isempty(dsname)
       % Ensure dsname is a char and not a double matrix
       dsname = '';
   end
   set(hand , 'subitems',map(3),dsname);
   set(hand , 'subitems',map(4),indstr(i,:));
   set(hand , 'selected' , 0);
   if ~isempty(select_index) & any(select_index==ind(i))
      select_item = [select_item hand];
   end
end
if isempty(select_item) & length(ind)>0
   select_item = hand;
end
if length(select_item)
    set(select_item(1),'selected',1);
    set(list,'SelectedItem',select_item(1));
    drawnow; % this is needed to make sure the selected item becomes visible;
    % the drawing doesn't pick up the new list otherwise
    EnsureVisible(select_item(1));
end

%-----------------------------------------------------------------------
function d = i_RefreshColumnList(d)
%-----------------------------------------------------------------------
ind = [];
orig_names = get(d.Dlg.tmp,'orig_name');
[isinput,isoutput,isignored] = getIsFactorType(d.Dlg.tmp);
dsonly = isDataOnly(d.Dlg.tmp);

list = d.Dlg.RightList;
select_index = pr_getExprListSelection(list,d.AssignDlg.RightIndex);
select_item = [];
if d.CheckUnits
    heads = {'Name' 'Column' 'Units'};
    widths = [150 80 80];
else
    heads = {'Name' 'Column'};
    widths = [150 80];
end
pr_ConfigureList(list,d.Dlg.RightListLyt,heads, widths, 'Data Columns');
list.MultiSelect = 0;
d.AssignDlg.RightIndex = 1;
indstr = num2str([1:length(orig_names)]');
assigned = isAssigned(d.Dlg.tmp);
ptrlist = get(d.Dlg.tmp,'ptrlist');
for i = 1:length(orig_names)
   if ~isignored(i) & dsonly(i)
      if assigned(i)
         f = find(d.Exprs.ptrs==ptrlist(i));
         if length(f)==1
            icon = d.Exprs.tpicons(f);
         else
            icon = 0;
         end
      else
         icon = 0;
      end
      hand = list.ListItems.Add;
      set(hand , 'text' , orig_names{i});
      set(hand , 'smallicon' , icon);
      set(hand , 'subitems',1,indstr(i,:));
      if d.CheckUnits
         units = getunits(d.Dlg.tmp,i);
         if ~isempty(units)
            set(hand , 'subitems',2,char(units));
         end
      end
      set(hand , 'selected' , 0);
      if ~isempty(select_index) & any(select_index==i)
         select_item = [select_item hand];
      end
   end
end
if isempty(select_item) & length(orig_names)>0
   select_item = hand;
end
if length(select_item)
    set(select_item(1),'selected',1);
    set(list,'SelectedItem',select_item(1));
    drawnow; % this is needed to make sure the selected item becomes visible;
    % the drawing doesn't pick up the new list otherwise
    EnsureVisible(select_item(1));
end
