function varargout = LinkDlg(varargin)
%LINKDLG

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.10.4.4 $  $Date: 2004/04/04 03:33:12 $

varargout{1} = i_GetCallbacks;
return

%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb = [];
cb.Show = @i_Show;
cb.View = @i_View;
cb.Setup = @i_Setup;
cb.Click = @i_Click;
cb.Enable = @i_Enable;

%-----------------------------------------------------------------------
function [d,lyt] = i_Setup(d)
%-----------------------------------------------------------------------
lyt = [];
return

%-----------------------------------------------------------------------
function en = i_Enable(op)
%-----------------------------------------------------------------------
en = ~isempty(op);

%-----------------------------------------------------------------------
function d = i_Show(d)
%-----------------------------------------------------------------------
set(d.Dlg.Lyt,'visible','off');
el = get(d.Dlg.MainLyt,'elements');
rows = get(d.Dlg.MainLyt,'rowsizes');
el{3} = d.Dlg.Checks; rows(3) = 30;rows(1) = 0;
set(d.Dlg.MainLyt,'elements',el,...
    'rowsizes',rows);
set(d.Dlg.Figure,'name','Link Data Set');

set(d.Dlg.ButtonCard, 'currentcard', 1);
set(d.Dlg.OK, 'callback',@cb_OK);
set(d.Dlg.Cancel, 'enable','on','callback',@cb_Cancel);

%%%%% UNITS CHECKBOX - TO BE ENABLED SOMETIME AFTER VERSION 1 %%%%%%%
%set(d.Dlg.Check1,'callback',@cb_Units,...
%    'value',d.CheckUnits,...
%    'string','Check units');
%set(d.Dlg.Checks,'elements',{d.Dlg.Check1 [] [] []});

% Remove this line when units are disabled
set(d.Dlg.Checks,'elements',{[] [] [] []});

set(d.Dlg.TopButton,'imagefile','cglinkbut.bmp',...
    'transparentcolor',[0 255 0],...
    'tooltip','Link factor',...
    'enable','on',...
    'callback',@cb_Link);
set(d.Dlg.BottomButton,'imagefile','cgbreaklinkbut.bmp',...
    'transparentcolor',[0 255 0],...
    'enable','on',...
    'tooltip','Break link',...
    'callback',@cb_BreakLink);
set(get(d.Dlg.Lyt, 'center'), 'title', 'Select factor in left list and link in right list.');
d.LinkDlg.LeftIndex = [];
d.LinkDlg.RightIndex = [];
% Take a copy of the current dataset.
d.Dlg.tmp = d.pD.info;

% Work out possible groups - cannot allow more than one assignment per group.
% Build up a temp oppoint containing all inputs.
%d.Dlg.tmp = CheckGroup(d.Dlg.tmp);
d.LinkDlg.Group = get(d.Dlg.tmp,'group');

set(d.Dlg.Lyt,'visible','on');
set(d.Dlg.Figure,'visible','on','closerequestfcn',@cb_Cancel, 'WindowStyle', 'modal');

%-----------------------------------------------------------------------
function d = i_View(d)
%-----------------------------------------------------------------------
d = i_RefreshLeftList(d);
d = i_RefreshRightList(d);
d = i_ButtonState(d);

%-----------------------------------------------------------------------
function d = i_Message(d,mess)
%-----------------------------------------------------------------------
if ~isempty(mess)
    set(d.Dlg.MsgPane,'string',mess);
    pause(1.5);
end
set(d.Dlg.MsgPane,'string','');
%------------------------------------------------------------------
function fstr = i_prettycell(namec);
%------------------------------------------------------------------
fstr = '';
for i = 1:length(namec)
    fstr = [fstr namec{i} ', '];
end
fstr = fstr(1:end-2);

%-----------------------------------------------------------------------
function cb_OK(varargin)
%-----------------------------------------------------------------------
% Go back to where we were before
d = pr_GetViewData;
d.Dlg.tmp = eval_fill(d.Dlg.tmp);
d.pD.info = d.Dlg.tmp;
% Addition - clear the status message
d = i_Message(d, '');
set(get(d.Dlg.Lyt, 'center'), 'title', '');
set(d.Dlg.Figure,'visible','off');
d.Exprs.recalc = [0 1 1 0];
d = pr_ChangeView(d,d.OldViewID);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Cancel(varargin)
%-----------------------------------------------------------------------
% Go back to where we were before
%  (Been working on a temp copy of the dataset, so don't need to do
%   anything to restore old version)
d = pr_GetViewData;
% Addition - clear the status message
d = i_Message(d, '');
set(get(d.Dlg.Lyt, 'center'), 'title', '');
set(d.Dlg.Figure,'visible','off');
d = pr_ChangeView(d,d.OldViewID);
% delete(d.Dlg.Figure);
% d.Dlg.Figure = [];
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Units(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
d.CheckUnits = get(d.Dlg.Check1,'value');
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Link(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
fact_i = pr_getExprListSelection(d.Dlg.LeftList,d.LinkDlg.LeftIndex);
indR = pr_getExprListSelection(d.Dlg.RightList,d.LinkDlg.RightIndex);
ptr = d.Exprs.ptrs(indR);
allptrstoFacs = get(d.Dlg.tmp, 'ptrlist');
ptrtobelinked = allptrstoFacs(fact_i);
link_i = d.Exprs.factor_index(indR);

mess = ''; err = 0;

% Check units
if d.CheckUnits
    if ~isvalid(ptr)
        punit = getunits(d.Dlg.tmp,link_i);
    else
        punit = ptr.grabUnits;
    end
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

if ~isvalid(ptr)
    % create new
    [d.Dlg.tmp,f,ptr] = AddCage(d.Dlg.tmp,link_i);
    %  Bit of a fudge here - rely on this to select link.
    d.Exprs.ptrs(indR) = ptr;
end

%---
%factors = get(d.Dlg.tmp,'orig_name');
% Already linked - show message
if isLink(d.Dlg.tmp,fact_i)
    lptr = getlink(d.Dlg.tmp,fact_i);
    if isequal(double(lptr), double(ptr))
        % Trying to link factor to the thing it's already linked to
        mess = [ptrtobelinked.getname ' is already linked to ' lptr.getname '.'];
    else
        mess = ['Breaking link to ' lptr.getname '.'];
    end
end
% factor in group?  Can only assign one thing - unassign other ones.
group = get(d.Dlg.tmp,'group');
gno = group(fact_i);
if gno & ~err
    allgroup_i = find(group==gno);
    group_i = setdiff(allgroup_i,fact_i);
    f = find(isLink(d.Dlg.tmp,group_i));
    if ~isempty(f)
        old_link_ptrs = getlink(d.Dlg.tmp,f);
        if ~all(old_link_ptrs == ptr)
            d.Dlg.tmp = BreakLink(d.Dlg.tmp,group_i);
            mess = ['Only one link permitted within group ' ...
                    i_prettycell(d.Exprs.names(allgroup_i)) '.'];
        end
    end
end
if ~err
    d.Dlg.tmp = Link(d.Dlg.tmp,fact_i,ptr);
end
d = i_Message(d,mess);
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_BreakLink(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
fact_i = pr_getExprListSelection(d.Dlg.LeftList,d.LinkDlg.LeftIndex);

mess = '';
d.Dlg.tmp = BreakLink(d.Dlg.tmp,fact_i);
d = i_Message(d,mess);
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function d = i_ButtonState(d)
%-----------------------------------------------------------------------
fact_i = pr_getExprListSelection(d.Dlg.LeftList,d.LinkDlg.LeftIndex);
indR = pr_getExprListSelection(d.Dlg.RightList,d.LinkDlg.RightIndex);
if ~isempty(indR)
    set(d.Dlg.TopButton,'enable','on');
else
    set(d.Dlg.TopButton,'enable','off');
end
if isLink(d.Dlg.tmp,fact_i)
    set(d.Dlg.BottomButton,'enable','on');
else
    set(d.Dlg.BottomButton,'enable','off');
end

%-----------------------------------------------------------------------
function d = i_Click(d,list)
%-----------------------------------------------------------------------
switch list
case 'top'
    pr_DeselectList(d.Dlg.RightList);
    d = i_RefreshRightList(d);
end
d = i_ButtonState(d);

%-----------------------------------------------------------------------
function d = i_RefreshLeftList(d)
%-----------------------------------------------------------------------
list = d.Dlg.LeftList;
select_index = pr_getExprListSelection(list,d.LinkDlg.LeftIndex);
select_item = [];
title = 'Data Set Factors';
ind = find(canLink(d.Dlg.tmp));
if isempty(ind)
    % Nothing to select
    pr_ConfigureList(d.Dlg.LeftList,d.Dlg.LeftListLyt,...
        'empty','No data set factors may be linked',title);
else
    heads = {'Name' 'Units' 'Linked' 'Index'};
    widths = [150 80 80 0];
    showcol = [1 0 1 1];
    if d.CheckUnits
        showcol(2) = 1;
    end
    f = find(showcol);
    heads = heads(f);
    widths = widths(f);
    map = repmat(0,size(showcol));
    map(f) = [1:length(f)] - 1;
    
    pr_ConfigureList(list,d.Dlg.LeftListLyt,...
        heads,widths,title);
    list.MultiSelect = 0;
    
    d.LinkDlg.LeftIndex = map(4);
    
    islink = isLink(d.Dlg.tmp);
    
    indstr = num2str(ind(:));
    for i = 1:length(ind)
        index = d.Exprs.shown_factors(ind(i));
        hand = list.ListItems.Add;
        set(hand , 'text' , d.Exprs.names{index});
        set(hand , 'smallicon' , d.Exprs.tpicons(index));
        if showcol(2)
            set(hand , 'subitems',map(2),d.Exprs.unitchar{index});
        end
        if islink(ind(i))
            lptr = getlink(d.Dlg.tmp,ind(i));
            set(hand, 'subitems',map(3),lptr.getname);
            icon = bmp2ind(d.ILmanager,'cglink.bmp');
            set(hand.ListSubItems.Item(map(3)),'reporticon',icon);
        end
        set(hand , 'subitems',map(4),indstr(i,:));
        set(hand , 'selected' , 0);
        if ~isempty(select_index) & any(select_index==ind(i))
            select_item = [select_item hand];
        end
    end
end
if length(select_item)
    set(select_item(1),'selected',1);
    set(list,'SelectedItem',select_item(1));
    drawnow; % this is needed to make sure the selected item becomes visible;
    % the drawing doesn't pick up the new list otherwise
    EnsureVisible(select_item(1));
end

%-----------------------------------------------------------------------
function d = i_RefreshRightList(d)
%-----------------------------------------------------------------------
% This call ensures that the lists are updated with the latest changes
% In particular, stops the right hand list claiming that x is linked to
% y when you've just broken the link
pTmp = xregpointer(d.Dlg.tmp);
d.Exprs = pr_makeProjectDisplay(d.Exprs,pTmp,d.nd,d.ILmanager, [0 0 1 0]);
ind = [];
fact_i = pr_getExprListSelection(d.Dlg.LeftList,d.LinkDlg.LeftIndex);
list = d.Dlg.RightList;
select_index = pr_getExprListSelection(list,d.LinkDlg.RightIndex);
select_item = [];
freeptr(pTmp);
title = 'Possible Links';
if isempty(fact_i)
    % Nothing selected
    pr_ConfigureList(d.Dlg.RightList,d.Dlg.RightListLyt,...
        'empty','<- Select a data set factor.',title);
else
    
    % Work out what is valid link for this factor (unassigned factors can be linked)
    ind = find(isValidLink(d.Dlg.tmp, fact_i, d.Exprs.ptrs, d.Exprs.names));
    if isempty(ind)
        % Nothing selected
        pr_ConfigureList(d.Dlg.RightList,d.Dlg.RightListLyt,...
            'empty','No valid links for this factor.',title);
    else
        
        heads = {'Name' 'Units' 'Type' 'Index'};
        widths = [150 80 80 0];
        showcol = [1 0 1 1];
        if d.CheckUnits
            showcol(2) = 1;
        end
        f = find(showcol);
        heads = heads(f);
        widths = widths(f);
        map = repmat(0,size(showcol));
        map(f) = [1:length(f)] - 1;
        pr_ConfigureList(list,d.Dlg.RightListLyt,...
            heads,widths,title);
        list.MultiSelect = 0;
        d.LinkDlg.RightIndex = map(4);
        
        indstr = num2str(ind(:));
        lptr = getlink(d.Dlg.tmp,fact_i);
        for i = 1:length(ind)
            hand = list.ListItems.Add;
            set(hand , 'text' , d.Exprs.names{ind(i)});
            set(hand , 'smallicon' , d.Exprs.tpicons(ind(i)));
            if showcol(2)
                set(hand , 'subitems',map(2),d.Exprs.unitchar{ind(i)});
            end
            set(hand , 'subitems',map(3),d.Exprs.types{ind(i)});
            set(hand , 'subitems',map(4),indstr(i,:));
            set(hand , 'selected' , 0);
            if ~isempty(select_index) & any(select_index==ind(i))
                select_item = [select_item hand];
            end
            if isvalid(lptr) & d.Exprs.ptrs(ind(i))==lptr & isempty(select_index)
                select_item = hand;
            end
        end
        if length(select_item)
            set(select_item(1),'selected',1);
            set(list,'SelectedItem',select_item(1));
            drawnow; % this is needed to make sure the selected item becomes visible;
            % the drawing doesn't pick up the new list otherwise
            EnsureVisible(select_item(1));
        end
    end
end
