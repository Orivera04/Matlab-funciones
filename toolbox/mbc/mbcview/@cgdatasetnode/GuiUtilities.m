function varargout = GuiUtilities(varargin)
% This file provides the gui menu functions for manipulating
%  the dataset.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.5 $  $Date: 2004/04/04 03:33:10 $

if nargin==0
   error('cgoppoint::plot: insufficient arguments.');
elseif isa(varargin{1},'cgdatasetnode')
   if nargin>1 & ischar(varargin{2})
      switch lower(varargin{2})
         case 'create'
            varargout{1} = i_Create(varargin{3:end});
         case 'get_callbacks'
            varargout{1} = i_GetCallbacks;
      end
   end
end

%------------------------------------------------------------------
function d = i_Create(d);
%------------------------------------------------------------------
Handles = d.Handles;

% -------- context menus

cb = i_GetCallbacks;

m = uicontextmenu('parent',Handles.Figure,'visible','off',...
   'callback',cb.SetupMenus);

fm.Overwrite = uimenu(m,'label','Treat as &Input',...
   'callback',{cb.overwrite,1});
fm.Evaluate = uimenu(m,'label','Treat as &Output',...
   'callback',{cb.evaluate,0});

% Callback set up in menu setup
fm.AddError = uimenu(m,'label','Create &Error',...
   'separator','on');
fm.CopyDataset = uimenu(m,'label','&Copy Current Values',...
   'callback',{cb.copy_dataset});
fm.Remove = uimenu(m,'label','&Remove from Data Set',...
   'callback',cb.remove);
fm.AddDataset = uimenu(m,'label','Add to &Data Set',...
   'separator','on', ...
   'callback',{cb.add_expr});

vis = [fm.AddError fm.Remove fm.CopyDataset];

fm.PlotVis = [vis ...
   fm.AddDataset];

fm.FactorVisBm = [vis ...
   fm.AddDataset];
fm.FactorVisTp = [vis ...
   fm.Overwrite fm.Evaluate];

fn = fieldnames(fm);
h = [];
for i = 1:length(fn)
   this = fm.(fn{i});
   f = ishandle(this);
   for j = 1:length(f)
      if f(j)
         h = [h this(j)];
      end
   end
end
fm.h = h;
fm.menu = m;
Handles.fm = fm;


% ------- tools menu

m = d.ToolsMenu;

m = uimenu(d.ToolsMenu,'label','&Factors','separator','on',...
   'callback',@cb_SetupMenus);
fm.Factors = m;

fm.Overwrite(2) = uimenu(m,'label','Treat as &Input',...
   'callback',{cb.overwrite,1});
fm.Evaluate(2) = uimenu(m,'label','Treat as &Output',...
   'callback',{cb.evaluate,0});

% Callback set up in menu setup
fm.AddError(2) = uimenu(m,'label','Create &Error', 'separator', 'on');
fm.CopyDataset(2) = uimenu(m,'label','&Copy Current Values',...
   'callback',{cb.copy_dataset});

fm.Remove(2) = uimenu(m,'label','&Remove from Data Set',...
   'callback',cb.remove);
fm.AddDataset(2) = uimenu(m,'label','Add to &Data Set',...
   'callback',{cb.add_expr},...
   'separator','on');


tm.h = [fm.Factors];
tm.FactorBits = tm.h;
tm.PlotBits = tm.h;
tm.LinkBits = [fm.Factors ];
tm.NotLinkBits = [fm.Overwrite(2) fm.Evaluate(2)];

Handles.fm = fm;
Handles.tm = tm;


d.Handles = Handles;
d.CB.EndLinkMain = cb.end_link;

d.Exprs.Linking = 0;
arg1 = d;

%------------------------------------------------------------------
function fstr = i_prettycell(namec);
%------------------------------------------------------------------
fstr = sprintf('%s, ', namec{:});
if ~isempty(fstr)
   fstr = fstr(1:end-2);
end


%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb.assign = @cb_Assign;
cb.unassign = @cb_Unassign;
cb.factor_type = @cb_FactorType;
cb.add_error = @cb_AddError;
cb.remove = @cb_Remove;
cb.add_expr = @cb_AddExpr;
cb.show_error = @cb_ShowError;
cb.overwrite = @cb_Overwrite;
cb.evaluate = @cb_Overwrite;
cb.copy_dataset = @cb_CopyDataset;
cb.link = @cb_StartLink;
cb.make_link = @cb_MakeLink;
cb.end_link = @cb_EndLink;
cb.break_link = @cb_BreakLink;
cb.link_menu = @i_SetupLinkMenu;
cb.SetupMenus = @i_SetupMenus;

%-----------------------------------------------------------------------
function cb_SetupMenus(varargin)
%-----------------------------------------------------------------------
% Callback from tools menu
d = pr_GetViewData;
% Work out whether top stuff is selected, or bottom stuff.
page = d.ViewInfo(d.currentviewinfo);
if ~isempty(page.tpselection)
   top_sel = feval(page.tpselection,d);
else
   top_sel = [];
end
if ~isempty(top_sel)
   i_SetupMenus(d,'top',top_sel);
else
   i_SetupMenus(d,'bottom',[]);
end

%-----------------------------------------------------------------------
function i_SetupMenus(d,list,factor_ind)
%-----------------------------------------------------------------------
% find indices to internal data store
expr_ind = pr_getExprListSelection(d.Handles.ExprList);

if nargin<3
   factor_ind = [];
end
switch lower(list)
   case 'bottom'
      sel_ind = expr_ind;
      % Check which menu is being displayed - may need
      %  to make some items invisible.
      set(d.Handles.fm.h,'visible','off');
      set(d.Handles.fm.BmVis,'visible','on');
   case 'top'
      sel_ind = factor_ind;
      set(d.Handles.fm.h,'visible','off');
      set(d.Handles.fm.FactorVisTp,'visible','on');
end
if strcmp(get(d.Handles.fm.AddDataset(1),'visible'),'on')
   set(d.Handles.fm.AddError(1),'separator','off');
else
   set(d.Handles.fm.AddError(1),'separator','on');
end
sel_fact_i = d.Exprs.factor_index(sel_ind);
top_fact_i = d.Exprs.factor_index(factor_ind);


% Is it possible to unassign a factor?
% f = find(sel_fact_i);
% if ~isempty(f)
%     f2 = find(d.pD.canUnassign(sel_fact_i(f)));
% end
% if ~isempty(f) & ~isempty(f2)
%     set(d.Handles.fm.Unassign,'enable','on','userdata',sel_ind(f(f2)));
%     % pass indices to unassign
% else
%     set(d.Handles.fm.Unassign,'enable','off');
% end

% Is it possible to assign?
% set(d.Handles.fm.Assign,'enable','off','label','&Assign');
% set(d.Handles.fm.Link,'enable','off','label','&Link');
% if length(factor_ind)==1 & length(expr_ind)==1
%     ptrs = ExpandPtrs(d.pD.info,d.Exprs.ptrs(expr_ind),d.Exprs.factor_index(expr_ind));
%     % Check that bottom expression is a single item
%     if length(ptrs)==1 & d.pD.canAssign(top_fact_i,d.Exprs.ptrs(expr_ind))
%         % pass index to assign
%         label = ['&Assign ' d.Exprs.names{factor_ind} ' to ' d.Exprs.names{expr_ind}];
%         set(d.Handles.fm.Assign,'enable','on',...
%             'label',label,...
%             'userdata',[factor_ind , expr_ind]);
%     end
%     if length(ptrs)==1 & d.pD.canLink(top_fact_i,d.Exprs.ptrs(expr_ind))
%         label = ['&Link ' d.Exprs.names{factor_ind} ' to ' d.Exprs.names{expr_ind}];
%         set(d.Handles.fm.Link,'enable','on',...
%             'label',label,'userdata',[factor_ind , expr_ind]);
%     end
% elseif length(factor_ind)==2
%     %Or:  two things selected in top, one of them assignable (and unassigned)
%     [ok,order] = canAssign(d.pD.info,top_fact_i);
%     if ok
%         label = ['&Assign ' d.Exprs.names{factor_ind(order(1))} ' to ' ...
%                 d.Exprs.names{factor_ind(order(2))}];
%         set(d.Handles.fm.Assign,'enable','on','userdata',factor_ind(order),...
%             'label',label);
%     end
%     linkstatus = [d.pD.canLink(top_fact_i(1),top_fact_i(2)) d.pD.canLink(top_fact_i(2),top_fact_i(1))];
%     if sum(linkstatus)==2
%         label = ['&Link ' d.Exprs.names{factor_ind(1)} ' and ' d.Exprs.names{factor_ind(2)}];
%     elseif linkstatus(1)
%         label = ['&Link ' d.Exprs.names{factor_ind(1)} ' to ' d.Exprs.names{factor_ind(2)}];
%     elseif linkstatus(2)
%         label = ['&Link ' d.Exprs.names{factor_ind(2)} ' to ' d.Exprs.names{factor_ind(1)}];
%     end
%     if sum(linkstatus)>0
%         set(d.Handles.fm.Link,'enable','on',...
%             'label',label,'userdata',factor_ind);
%     end
% end

% % Link factor
% if length(sel_fact_i)==1 & sel_fact_i~=0 & d.pD.canLink(sel_fact_i)
%     set(d.Handles.fm.Link,'enable','on','userdata',sel_ind);
% else
%     set(d.Handles.fm.Link,'enable','off');
% end
% f = find(sel_fact_i);
% f2 = find(d.pD.islink(sel_fact_i(f)));
% if ~isempty(f2)
%     set(d.Handles.fm.BreakLink,'enable','on','userdata',sel_ind(f(f2)));
% else
%     set(d.Handles.fm.BreakLink,'enable','off');
% end

%%%%%%% BEGINNING OF CHECKING FOR THE MENUS %%%%%%%%%

% If the project expression list is blank, then ensure that the links menu item is disabled
% if isempty(expr_ind)
%     set(d.Handles.fm.Link,'enable','off');
% else
%     set(d.Handles.fm.Link,'enable','on');
% end

% Possible to set overwrite flag? (Only need to do this for a factor-click)
f = find(canOverwrite(d.pD.info,top_fact_i));
if ~isempty(f)
   set(d.Handles.fm.Overwrite,'enable','on','userdata',factor_ind(f));
   needTick = find(canOverwrite(d.pD.info, top_fact_i(f)) == 2);
   if ~isempty(needTick)
      set(d.Handles.fm.Overwrite,'enable', 'off');
   end
else
   set(d.Handles.fm.Overwrite,'enable','off');
end

% Possible to clear overwrite flag? (Evaluate)
f = find(canEvaluate(d.pD.info,top_fact_i));
if ~isempty(f)
   set(d.Handles.fm.Evaluate,'enable','on','userdata',factor_ind(f));
   needTick = find(canEvaluate(d.pD.info, top_fact_i(f)) == 2);
   if ~isempty(needTick)
      set(d.Handles.fm.Evaluate,'enable', 'off');
   end
else
   set(d.Handles.fm.Evaluate,'enable','off');
end

% Possible to remove factor?
remove_ind = sel_ind(find(sel_fact_i));
if ~isempty(remove_ind)
   set(d.Handles.fm.Remove,'enable','on','userdata',remove_ind);
else
   set(d.Handles.fm.Remove,'enable','off');
end

% Check if any of selection in bottom list are not in dataset
%  We can add these as new factors.
f = find(~sel_fact_i);
if ~isempty(f)
   set(d.Handles.fm.AddDataset,'enable','on','userdata',sel_ind(f));
else
   set(d.Handles.fm.AddDataset,'enable','off');
end



% Check factor types of top list selection
% if ~isempty(sel_ind)
%     f = find(sel_fact_i);
% else
%     f = [];
% end
% if isempty(f)
%     set(d.Handles.fm.FactorType,'enable','off');
% else
%     set(d.Handles.fm.FactorType,'enable','on');
%     [in_i,out_i,ig_i] = getFactorTypes(d.pD.info,d.Exprs.factor_index(sel_ind(f)));
%     set(d.Handles.fm.type,'checked','off','userdata',sel_ind(f));
%     if ~isempty(out_i)
%         set(d.Handles.fm.type([2 4]),'checked','on');
%     end
%     if ~isempty(in_i)
%         set(d.Handles.fm.type([1 5]),'checked','on');
%     end
%     if ~isempty(ig_i)
%         set(d.Handles.fm.type([3 6]),'checked','on');
%     end
%     % Only factors unique to dataset may be ignored.
%     f2 = find(d.pD.isUniqueToDataset(d.Exprs.factor_index(sel_ind(f))));
%     if isempty(f2)
%         set(d.Handles.fm.type([3 6]),'enable','off');
%     else
%         set(d.Handles.fm.type([3 6]),'enable','on','userdata',sel_ind(f(f2)));
%     end
% end

[ptrs,linkptrs,names,units,cr_flag,value_ind,return_ind] = ...
   ExpandPtrs(d.pD.info,d.Exprs.ptrs(sel_ind),sel_fact_i);
sel_return_ind = sel_ind(return_ind);


% Copy to dataset: Single item selected?
% Additionally - don't allow this feature if the dataset is empty
if length(ptrs)==1 & length(sel_ind)==1 & d.Exprs.eval(sel_ind) & ~isempty(get(d.pD.info, 'data'))
   set(d.Handles.fm.CopyDataset,'enable','on','userdata',sel_ind);
   %        'label',['&Copy Snapshot of ' d.Exprs.names{sel_ind}]);
else
   set(d.Handles.fm.CopyDataset,'enable','off');
   %set(d.Handles.fm.CopyDataset,'label','&Copy Snapshot');
end

% Specials (eg features) use actual ptrs, not link.
if ~isempty(linkptrs)
   sp = find(isvalid(linkptrs));
   ptrs(sp) = linkptrs(sp);
end

% two items plotted - generate error?
%  Ensure both can be evaluated.
set(d.Handles.fm.AddError,'enable','off');
if length(ptrs)==2 & all(d.Exprs.eval(sel_return_ind))
   % find matching error
   [exists,ind,dir] = i_SubExprExists(d.Exprs.ErrPtrs,ptrs(1),ptrs(2),'reverse');
   if isempty(ind)
      % check units
      un1 = units{1}; un2 = units{2};
      if isempty(un1) | ~isempty(un2) | compatible(un1,un2)
         set(d.Handles.fm.AddError,'enable','on',...
            'callback',@cb_AddError,'userdata',sel_ind);
      end
   else
      set(d.Handles.fm.AddError,'enable','on','callback',@cb_ShowError,...
         'userdata',ind);
   end
end


%-------------------------------------------------
function [exists,ind,dir] = i_SubExprExists(ErrPtrs,ptr2,ptr1,opt);
%-------------------------------------------------

dir = 0; exists = 0; ind = [];

if ~isempty(ErrPtrs)
   compare = double([ptr2 ptr1]);
   % find matching error
   cmat = repmat(compare,size(ErrPtrs,1),1);
   f = find(~any((ErrPtrs(:,2:3) - cmat)'));
   if ~isempty(f)
      ind = ErrPtrs(f(1),1);
      dir = 1;
      exists = 1;
   elseif strcmp(lower(opt),'reverse')
      % check reverse order too
      f = find(~any((ErrPtrs(:,[3 2]) - cmat)'));
      if ~isempty(f)
         ind = ErrPtrs(f(1),1);
         dir = -1;
         exists = 1;
      end
   end
end

%-----------------------------------------------------------------------
function [unlinkind, invalidind] = i_InvOrUnlink(op, inv_i, cause_i)
%-----------------------------------------------------------------------
unlinkind = []; invalidind = [];
lptrs = get(op, 'linkptrlist');
ptrs = get(op, 'ptrlist');
for count = 1:length(inv_i)
   if ~any(ismember( double(ptrs(inv_i(count))) , double(ptrs(cause_i{count})) ))
      if all( ismember( double(ptrs(cause_i{count})) , double(lptrs(inv_i(count))) ) )
         % The only reason this factor is invalidated is that its link
         % will be broken
         unlinkind = [unlinkind inv_i(count)];
      else
         % This factor is invalidated because it will not be evaluatable
         invalidind = [invalidind inv_i(count)];
      end
   end
end

%-----------------------------------------------------------------------
function cb_Remove(varargin)
%-----------------------------------------------------------------------
% args:  call handle, []
d = pr_GetViewData;
ind = get(varargin{1},'userdata');
fact_i = d.Exprs.factor_index(ind);
factors = d.pD.get('factors');
overwrite = d.pD.get('isoverwrite');
if ~isempty(fact_i)
   f = find(d.pD.isDataOnly(fact_i));
   if ~isempty(f)
      if length(f)<4
         if length(f)==1
            factor_str = 'factor ';
         else
            factor_str = 'factors ';
         end
         fstr = ['Removing data set ', factor_str, ...
            i_prettycell(factors(fact_i(f)))];
      else
         fstr = 'Removing these factors';
      end
      but = questdlg( sprintf( '%s will permanently delete imported data.', fstr),...
         'Data set Viewer',...
         'Remove','Cancel','Cancel');
      % return UNLESS they've pressed remove
      if ~strcmpi( but, 'Remove' )
         return;
      end

   end
   [inv_i,cause_i] = CheckRemove(d.pD.info,fact_i);
   if ~isempty(inv_i)
      dialog = 1;
      [unlinkind, invalidind] = i_InvOrUnlink(d.pD.info, inv_i, cause_i);
      cause_i = [cause_i{:}];
      cstr = i_prettycell(factors(unique(sort(cause_i))));
      istr = i_prettycell(factors(invalidind));
      ustr = i_prettycell(factors(unlinkind));
      if isempty(istr) & isempty(ustr)
         dialog = 0;
      else
         dialog = 1;
      end
      if dialog
         but = i_AsktoDeleteInvalidatedItems(cstr, istr, ustr);
         switch lower(but)
            case 'cancel'
               return
            case 'continue'
               % Adding invalid indices below now
         end
      end
      fact_i = union(fact_i,inv_i);
   end

   % Addition - Check the inv_i to see if any are linked pointers.
   % If so, find out if the original factor was an input/output
   currPtrs = get(d.pD.info, 'ptrlist');
   for count = 1:length(inv_i)
      f = find(currPtrs == currPtrs(inv_i(count)));
      f = setdiff(f,inv_i(count));
      overwrite = get(d.pD.info,'iseditable');
      ftype = get(d.pD.info, 'factor_type');
      if overwrite(f)
         ftype(f) = 1;
      else
         ftype(f) = 2;
      end
      d.pD.info = set(d.pD.info, 'factor_type', ftype);
   end

   d.pD.info = d.pD.removefactor(fact_i);

   % Have we removed all imported data ?
   % Ensure the block length is correct
   d.pD.info = d.pD.setblocklen;

   % Did we remove any inputs or overwritten outputs?
   %  Have to re-evaluate the exprlist.
   recalc = 0;
   if any(overwrite(fact_i))
      recalc = 1;
   end
   d.Exprs.recalc = [0 recalc 1 0];
   d = view(d.nd,d.CGBH,d);
   pr_SetViewData(d);
end

%-----------------------------------------------------------------------
function but = i_AsktoDeleteInvalidatedItems(cstr, istr, ustr)
%-----------------------------------------------------------------------
CGBH = cgbrowser;
% data is still referenced elsewhere
dh= xregdialog('name','Remove Factor from Data Set',...
   'resize','off');
xregcenterfigure(dh,[350 300],CGBH.Figure);
txt1=uicontrol('parent',dh,...
   'style','text',...
   'horizontalalignment','left',...
   'string',['Removing factor(s) ', cstr, ' will delete and/or unlink the following factors']);
txt2=uicontrol('parent',dh,...
   'style','text',...
   'horizontalalignment','left',...
   'string','Factors that will be deleted:');
% Generate cell array for list box
lististr = i_GetListContents(istr);
lst1=uicontrol('parent',dh,...
   'style','listbox',...
   'string',lististr,...
   'backgroundcolor','w');
txt3=uicontrol('parent',dh,...
   'style','text',...
   'horizontalalignment','left',...
   'string','Factors that will be unlinked:');
listustr = i_GetListContents(ustr);
lst2=uicontrol('parent',dh,...
   'style','listbox',...
   'string',listustr,...
   'backgroundcolor','w');
cont=uicontrol('parent',dh,...
   'style','pushbutton',...
   'string','Continue',...
   'callback',';set(gcbf,''visible'',''off'', ''userdata'', ''continue'');');
cls=uicontrol('parent',dh,...
   'style','pushbutton',...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'', ''userdata'', ''cancel'');');

lyt=xreggridbaglayout(dh,'dimension',[8 3],...
   'rowsizes',[45 15 -1 20 15 -1 20 25],...
   'colsizes',[-1 65 65],...
   'mergeblock',{[1 1],[1 3]},...
   'mergeblock',{[2 2],[1 3]},...
   'mergeblock',{[3 3],[1 3]},...
   'mergeblock',{[4 4],[1 3]},...
   'mergeblock',{[5 5],[1 3]},...
   'mergeblock',{[6 6],[1 3]},...
   'gapx',10, ...
   'border',[10 10 10 10],...
   'packstatus','off',...
   'elements',{txt1,txt2,lst1,[],txt3,lst2,[], [],...
   [],[],[],[],[],[],[],cont, ...
   [],[],[],[],[],[],[],cls});
dh.LayoutManager=lyt;
set(lyt,'packstatus','on');
dh.showDialog(cls);

but = get(dh, 'userdata');
if isempty(but)
   % Have hit kill on the dialog
   but = 'cancel';
end
delete(dh);


%-----------------------------------------------------------------------
function lististr = i_GetListContents(istr)
%-----------------------------------------------------------------------
cp = findstr(istr, ',');
if isempty(cp)
   lististr = istr;
else
   for i = 1:length(cp)
      if i==1
         lististr{1} = istr(1:cp(i) - 1);
      end
      if i < length(cp)
         lististr = [lististr; {istr(cp(i)+1:cp(i+1)-1)}];
      else
         lististr = [lististr; {istr(cp(i)+1:end)}];
      end
   end
end

%-----------------------------------------------------------------------
function cb_AddExpr(varargin)
%-----------------------------------------------------------------------
if nargin<3
   item_opt = 'item';
else
   item_opt = varargin{3};
end
d = pr_GetViewData;
ind = get(varargin{1},'userdata');
ptrs = d.Exprs.ptrs(ind);
needptrs = d.Exprs.need_ptrs(ind);

% Going to have to loop thru each expression we want to add
% to ensure all the required inputs exist
fact_i = [];expsNotadd = [];
for i=1:length(ptrs)
   if isddvariable(ptrs(i).info) | isempty(needptrs{i})
      % Adding a DD variable or an expression with no required inputs
      [d.pD.info,ind_fact_i,mess] = AddExpr(d.pD.info,ptrs(i));
      fact_i = [fact_i ind_fact_i];
   else
      expsNotadd = [expsNotadd i];
   end
end

if ~isempty(expsNotadd)
   messstr =[];namesNotadd = [];
   for i=1:length(expsNotadd)
      namesNotadd = [namesNotadd, ptrs(expsNotadd(i)).getname, ', '];
   end
   namesNotadd = namesNotadd(1:end-2);
   messstr  = 'The following expressions need to have their inputs added to the data set before they can be added :';
   messstr = [messstr, char(10), char(10), namesNotadd];
   msgbox(messstr, 'Data set Viewer');
end

if ~isempty(fact_i)
   overwrite = d.pD.get('isoverwrite');
   recalc = any(overwrite(fact_i));
   d.Exprs.recalc = [0 recalc 1 0];
   % Switch to view the new factor(s)
   d = view(d.nd,d.CGBH,d,fact_i);
   pr_SetViewData(d);
   % Added any values? Do we have any imported data?
   %  Pop up a message saying this might not be the thing to do.
   if ~isempty(mess)
      h=msgbox(mess,'Data set Viewer','help');
      uiwait(h);
   end
end

% %-----------------------------------------------------------------------
% function cb_FactorType(varargin)
% %-----------------------------------------------------------------------
% d = pr_GetViewData;
% ind = get(varargin{1},'userdata');
%
% fact_i = d.Exprs.factor_index(ind);
% if ~isempty(fact_i)
%     ftype = d.pD.str2FactorType(varargin{3});
%     if strcmp(varargin{3},'ignore')
%         % Check whether changing to ignore will invalidate
%         %  any other factors
%         factors = d.pD.get('factors');
%         [inv_i,cause_i] = CheckRemove(d.pD.info,fact_i);
%         if ~isempty(inv_i)
%             cstr = i_prettycell(factors(sort(cause_i)));
%             istr = i_prettycell(factors(inv_i));
%             but = questdlg({['Setting dataset factor(s) ' cstr ] ...
%                     ['to ignore will invalidate factor(s) ' istr '.'] ...
%                     ['Ignore these factors too?']},...
%                 'Dataset Viewer','Ignore','Cancel','Cancel');
%             switch but
%             case 'Cancel'
%                 return
%             case 'Ignore'
%                 % add invalid indices
%                 fact_i = union(fact_i,inv_i);
%                 % break any links
%                 d.pD.info = set(d.pD.info,fact_i,'linkptr',xregpointer);
%                 % Check for creation (ie don't set project exprs to ignore)
%                 %  (just break link)
%                 fact_i = setdiff(fact_i,fact_i(find(~d.pD.isUniqueToDataset(fact_i))));
%             end
%         end
%
%     end
%     oldoverwrite = d.pD.get('isoverwrite');
%     d.pD.info = set(d.pD.info,fact_i,'factor_type',ftype);
%     newoverwrite = d.pD.get('isoverwrite');
%     % Did we change any inputs or overwritten outputs to ignore?
%     %   (input and output are ok)
%     % Or did we create any new inputs or outputs with valid ptrs?
%     %  Have to re-evaluate the exprlist.
%     recalc = 0;
%     if any(oldoverwrite(fact_i)~=newoverwrite(fact_i))
%         recalc = 1;
%     end
%     d.Exprs.recalc = [0 recalc 1 0];
%     d = View(d.nd,d.CGBH,d);
%     pr_SetViewData(d);
% end
%
%
%-------------------------------------------------------------------
function cb_AddError(varargin);
%-------------------------------------------------------------------
d = pr_GetViewData;

index = get(varargin{1},'userdata');
[ptrs,linkptrs,names,units,cr_flag,value_ind] = ...
   ExpandPtrs(d.pD.info,d.Exprs.ptrs(index),d.Exprs.factor_index(index));

if length(ptrs)~=2
   return
end

val = isvalid(linkptrs);
ptrs(find(val)) = linkptrs(find(val));

% Work out a name for the error.
errname = [names{1} '_minus_' names{2}];

right = ptrs(1);
left = ptrs(2);
if any(~isvalid([right left]))
   if length(index)~=2
      error('cannot find factor');
   end
   if ~isvalid(right)
      right = d.Exprs.factor_index(index(1));
      if right==0, error('cannot find factor'); end
   end
   if ~isvalid(left)
      left = d.Exprs.factor_index(index(2));
      if left==0, error('cannot find factor'); end
   end
end
[d.pD.info,e_ptr] = CreateError(d.pD.info,[0 0 1],left,right,errname);

d.Exprs.recalc = [0 0 1 0];
d = view(d.nd,d.CGBH,d,d.pD.get('numfactors'));
pr_SetViewData(d);

%-------------------------------------------------------------------
function cb_ShowError(varargin);
%-------------------------------------------------------------------
d = pr_GetViewData;

index = get(varargin{1},'userdata');

page = d.ViewInfo(d.currentviewinfo);
if ~isempty(page.showindex)
   d = feval(page.showindex,d,index);
   pr_SetViewData(d);
end

%-----------------------------------------------------------------------
function cb_Overwrite(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
ind = get(varargin{1},'userdata');

fact_i = d.Exprs.factor_index(ind);
if ~isempty(fact_i)
   new_val = varargin{3};
   if new_val == 0
      % Check whether any imported data is being set to evaluate.
      %  This will delete the imported data - flag a warning.
      % (NB canOverwrite already prevents errors being altered)
      f = find(d.pD.isUniqueToDataset(fact_i));
      if ~isempty(f)
         factors = get(d.pD.info,'factors');
         fstr = i_prettycell(factors(fact_i(f)));
         but = questdlg({['Setting factors ' fstr] ,...
            'to evaluate will delete imported data.' ...
            'Continue?'},'Data Set Viewer','Evaluate','Cancel','Cancel');
         switch but
            case 'Cancel'
               return
            case 'Evaluate'
               % destroy import flag
               d.pD.info = set(d.pD.info,fact_i(f),'orig_name','');
         end
      end
      % Check if current factor can be evaluated
      % 10/9/01 - Addition to handle ignored factors
      indinfactor_index = find(d.Exprs.factor_index==fact_i);
      if ~d.Exprs.eval(indinfactor_index)
         % If not, set to zero.
         d.pD.info = d.pD.set(fact_i,'data',0);
      end
   end
   if new_val==0
      ftype = 'output';
   else
      ftype = 'input';
   end
   d.pD.info = set(d.pD.info,fact_i,'overwrite',new_val,'grid_flag',0,'factor_type',ftype);
   if new_val==0
      % Setting something to evaluate - recalc.
      d.pD.info = d.pD.eval_fill;
   end
   d.Exprs.recalc = [0 0 1 0];
   d = view(d.nd,d.CGBH,d);
   pr_SetViewData(d);
end

%-----------------------------------------------------------------------
function cb_CopyDataset(varargin)
%-----------------------------------------------------------------------
% Create a new column in dataset, linked to a new value.
% Copy evaluation of ptr into new column.
d = pr_GetViewData;
ind = get(varargin{1},'userdata');
fact_i = d.Exprs.factor_index(ind);

d.pD.info = copyfactor(d.pD.info, fact_i);

% rebuild picture
d.Exprs.recalc = [0 0 1 0];
d = view(d.nd,d.CGBH,d);
pr_SetViewData(d);


%-----------------------------------------------------------------------
%
% Link stuff
%
%-----------------------------------------------------------------------

%-----------------------------------------------------------------------
function cb_StartLink(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
d.Dlg.tmp = d.pD.info;
d = pr_ChangeView(d,'linkdlg');
pr_SetViewData(d);

