function varargout = FillTable(varargin)
% FillTable

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.11.4.5 $  $Date: 2004/04/04 03:33:09 $

if nargin==0
    error('cgoppoint::FillTable: insufficient arguments.');
elseif isa(varargin{1},'cgdatasetnode')
    if nargin>1 & ischar(varargin{2})
        switch lower(varargin{2})
        case 'get_callbacks'
            varargout{1} = i_GetCallbacks;
        end
    end
end

%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb = [];
cb.View = @i_View;
%cb.Copy = @i_Copy;
cb.Copy = [];
cb.Click = @i_RuleClick;
cb.Draw = @i_DrawPage;
cb.CreateMenu = @i_CreateMenu;
cb.TableMode = @cb_BottomMode;
cb.Show = @i_Show;
cb.Fill = @cb_Fill;
cb.Enable = @cb_Enable;

%------------------------------------------------------------------
function [d,lyt] = i_DrawPage(d);
%------------------------------------------------------------------
fig = d.Handles.Figure;
bgCol = get(fig,'color');

Top.EditAxis = xregaxes('parent',fig,...
    'visible','off', ...
    'units','pixels', ...
    'position',[0 0 100 100], ...
    'uicontextmenu',d.Handles.ColorBarMenu);
ax = axiswrapper(Top.EditAxis);
set(ax, 'border', [50 50 50 50]);

b = xregpanellayout(fig, ...
    'visible', 'off', ...
    'center', ax);

set(d.Handles.PlotCard,'numcards',3);
attach(d.Handles.PlotCard, b, 3);

d.Top = Top;
d.Table.Factor_i = [];
d.Table.BottomMode = 'tables';
d.Table.TopMode = 'dataset';
d.Table.TablePtr = xregpointer;
d.Table.SetupPlotCB = @i_SetupPlot;
d.Table.RuleUpdateCB = @cb_UpdateDragRule;
d.Table.Cur_Rule = [];
lyt = [];


%------------------------------------------------------------------
function d = i_CreateMenu(d,cb);
%------------------------------------------------------------------
Handles = d.Handles;

% ------- menu 
m = d.ToolsMenu;
tabm.Options = uimenu(m,'label','&Table Fill',...
    'callback',@cb_SetupMenu);
mm = tabm.Options;
tabm.Fill = uimenu(mm,'label','&Fill',...
    'callback',@cb_Fill);
tabm.Enable = uimenu(mm,'label','&Enable Rule',...
    'callback',{@cb_EnableRule,1},...
    'separator','on');
tabm.Disable = uimenu(mm,'label','Di&sable Rule',...
    'callback',{@cb_EnableRule,0});
tabm.Exclude = uimenu(mm,'label','E&xclude Points',...
    'callback',{@cb_EnableRule,-1},'separator','on');
tabm.Include = uimenu(mm,'label','&Include Points',...
    'callback',{@cb_EnableRule,1});
tabm.Promote = uimenu(mm,'label','&Promote Rule',...
    'callback',{@cb_PromoteRule,-1},...
    'separator','on');
tabm.Demote = uimenu(mm,'label','&Demote Rule',...
    'callback',{@cb_PromoteRule,+1});
tabm.Clear = uimenu(mm,'label','&Clear Rule',...
    'callback',@cb_ClearRule,...
    'separator','on');

% ------ context menu for Table Filling list only
m = uicontextmenu('parent',Handles.Figure,'callback',@cb_SetupMenu);
tabm.menu = m;
tabm.Enable(2) = uimenu(m,'label','&Enable Rule',...
    'callback',{@cb_EnableRule,1});
tabm.Disable(2) = uimenu(m,'label','&Disable Rule',...
    'callback',{@cb_EnableRule,0});
tabm.Exclude(2) = uimenu(m,'label','E&xclude Points',...
    'callback',{@cb_EnableRule,-1}, 'separator','on');
tabm.Include(2) = uimenu(m,'label','&Include Points',...
    'callback',{@cb_EnableRule,1});
tabm.Promote(2) = uimenu(m,'label','&Promote Rule',...
    'callback',{@cb_PromoteRule,-1},...
    'separator','on');
tabm.Demote(2) = uimenu(m,'label','&Demote Rule',...
    'callback',{@cb_PromoteRule,+1});
tabm.Clear(2) = uimenu(m,'label','&Clear Rule',...
    'callback',@cb_ClearRule, 'separator', 'on');

tabm.contextvis = [tabm.Enable(2) tabm.Disable(2) tabm.Exclude(2) ...
        tabm.Include(2) tabm.Promote(2) tabm.Demote(2) tabm.Clear(2)];
tabm.pulldownen = [tabm.Enable(1) tabm.Disable(1) tabm.Exclude(1) ...
        tabm.Include(1) tabm.Promote(1) tabm.Demote(1) tabm.Clear(1)];
Handles.tabm = tabm;

Handles.tm.h = [Handles.tm.h tabm.Options];

d.Handles = Handles;


%-------------------------------------------------------------------------
function d = i_Copy(d)
%-------------------------------------------------------------------------
return


%-----------------------------------------------------------------------
function d = i_Show(d)
%-----------------------------------------------------------------------
set(d.Handles.DataDisplay,'type','table','colorbar',d.Plot.DoColor,...
    'data',[],'factors',[],...
    'cdata',[],...
    'callback',@cb_PlotRules,...
    'tableptr',[]);
ax = get(d.Handles.DataDisplay,'axes');
set(ax,'buttondownfcn',{@selectbox,d.nd,@cb_DragRule});
d.callingviewswitchflag = 0;
pr_SetViewData(d);

set(d.Handles.BottomCard,'currentcard',4);
%-----------------------------------------------------------------------
function d = i_View(d)
%-----------------------------------------------------------------------
% Going to always have something selected in 
% every list ....

% Record the current list from user data (should one exist)
if isfield(d, 'currentlist')
    thislist = d.currentlist;
else
    thislist = 'factors';
end

% Pick up the current selection in each list
d.currentlist =  'tables';
tab_sel_ind = i_GetSelection(d);
d.currentlist =  'factors';    
fac_sel_ind = i_GetSelection(d);
d.currentlist =  'rules';        
rul_sel_ind = i_GetSelection(d);

% Set d.currentlist back to its old value
d.currentlist = thislist;

factor_type = d.pD.get('factor_type');
in_i = find(factor_type==1);
d.Table.in_i = in_i;

d = i_RefreshListTables(d);
d = i_RefreshListRules(d, rul_sel_ind);
d = i_RefreshListFactors(d);
% Click also sets up plot.
d = i_RuleClick(d);

d.CB.Replot = @i_SetupPlot;

% Ensure that multi graph has correct callback and buttondownfcn
ax = get(d.Handles.DataDisplay,'axes');
set(ax,'buttondownfcn',{@selectbox,d.nd,@cb_DragRule});
set(d.Handles.DataDisplay,'callback', @cb_PlotRules);

set(d.Handles.DataDisplay,'uicontextmenu',d.Handles.ColorBarMenu);


%-----------------------------------------------------------------------
function cb_BottomMode(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
d.Table.BottomMode = varargin{3};
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function [d,rule_selected] = i_RefreshListRules(d,sel_ind)
%-----------------------------------------------------------------------

list = d.Handles.TFListRight;
if isempty(sel_ind), sel_ind = 0; end
factor_type = d.pD.get('factor_type');
in_i = find(factor_type==1);
d.Table.in_i = in_i;
rules = d.pD.get('rules');

numstr = num2str([1:length(rules)]');
factors = d.pD.get('factors');

rule_selected = (length(rules)>0);
if ~rule_selected
    switch d.Table.TopMode
    case 'dataset'
        tt = 'Click and drag over axes to create new rule';
    otherwise
        tt = 'Select data set view to edit rules';
    end
    pr_ConfigureList(list,d.Handles.TFListLytRight,...
        'empty','Click and drag over Data Set plot to create rules',...
        'Table filling rules (optional)',tt);
else
    switch d.Table.TopMode
    case 'dataset'
        tt = 'Click and drag on axes to create or edit rules';
    otherwise
        tt = 'Select data set view to edit rules';
    end
    pr_ConfigureList(list,d.Handles.TFListLytRight,...
        {'Order','Factor','Status','Rule'},...
        [40,200,80,400],...
        'Table filling rules (optional)',tt);
    set(list,'multiselect',0);
    set(list,'sortorder',0);
    set(list,'sortkey',0);
end

done_sel = 0;
[factstr,rulestr,state,index] = info(rules,factors);
for i = 1:length(factstr)
   hand = list.ListItems.Add;
   switch state(i)
   case 0
      icon = bmp2ind(d.ILmanager,'cross.bmp');
      status = 'Disabled';
   case 1
      icon = bmp2ind(d.ILmanager,'cgdsinclude.bmp');
      status = 'Include';
   case -1
      icon = bmp2ind(d.ILmanager,'cgdsexclude.bmp');
      status = 'Exclude';
   end
   set(hand , 'text',numstr(index(i),:));
   set(hand , 'subitems',1, factstr{i});
   set(hand , 'subitems',2,status);
   set(hand , 'subitems',3,rulestr{i});
   set(hand.ListSubItems.Item(2),'reporticon',icon);
   set(hand , 'smallicon' , 0);
   if index(i)==sel_ind
      set(hand , 'selected' , 1);
      done_sel = 1;
   else
      set(hand , 'selected' , 0);
   end
end

if rule_selected & ~done_sel
    set(list.ListItems.Item(1),'selected',1);
end

%-----------------------------------------------------------------------
function d = i_RefreshListFactors(d)
%-----------------------------------------------------------------------
%list = d.Handles.ExprList;
list = d.Handles.TFListMid;
factors = d.pD.get('factors');
factor_type = d.pD.get('factor_type');
out_i = find((factor_type==1) | (factor_type==2));

if isempty(out_i)
    pr_ConfigureList(list,d.Handles.TFListLytMid,...
        'empty',...
        'No suitable factors defined',...
        'Factor to fill table');
else
    pr_ConfigureList(list,d.Handles.TFListLytMid,...
        {'Factor','Information','Index'},...
        [200,400,0],...
        'Factor to fill table');
end
set(list,'multiselect',0);

sel_ind = d.Table.Factor_i;
if isempty(sel_ind), sel_ind = 0; end

factstr = num2str([1:length(factors)]');

done_sel = 0;
for i = 1:length(out_i)
    fact_i = out_i(i);
    info = '';
    % Ensure that correct icon is picked out of list
    indtoicon = find(d.Exprs.factor_index == fact_i);
    icon = d.Exprs.icons(indtoicon);
    hand = list.ListItems.Add;
    set(hand , 'text' , factors{fact_i});
    set(hand , 'subitems',1,info);
    set(hand , 'subitems',2,factstr(fact_i,:));
    set(hand , 'smallicon' , icon);
    if fact_i==sel_ind
        set(hand , 'selected' , 1);
        done_sel = 1;
    else
        set(hand , 'selected' , 0);
    end
end
if ~done_sel & length(out_i)>0
    set(list.ListItems.Item(1),'selected',1);
end


%-----------------------------------------------------------------------
function d = i_RefreshListTables(d)
%-----------------------------------------------------------------------
%list = d.Handles.ExprList;
list = d.Handles.TFListLeft;
[icons,tptrs,names,teval,needptrs,axesptrs] = i_BuildTableList(d);

if isempty(tptrs)
    pr_ConfigureList(list,d.Handles.TFListLytLeft,...
        'empty',...
        'No tables in project.',...
        'Table to fill');
else
    pr_ConfigureList(list,d.Handles.TFListLytLeft,...
        {'Table','Inputs','Information','Index'},...
        [200,150,400,0],...
        'Table to fill');
end
set(list,'multiselect',0);

d.Table.TablePtrList = tptrs;
if isempty(tptrs)
    sel_ind = [];
    d.Table.TablePtr = xregpointer;
else
    sel_ind = find(tptrs==d.Table.TablePtr);
end
if isempty(sel_ind), sel_ind = 0; end

numstr = num2str([1:length(tptrs)]');

done_sel = 0;
for i = 1:length(tptrs)
    if teval(i)
        info = '';
    else
        info = i_InputsRequired('Inputs required: ',needptrs{i});
    end
    fcn = i_InputsRequired('',axesptrs{i});
    hand = list.ListItems.Add;
    set(hand , 'text' , names{i});
    set(hand , 'subitems',1,fcn);
    set(hand , 'subitems',2,info);
    set(hand , 'subitems',3,numstr(i,:));
    set(hand , 'smallicon' , icons(i));
    if i==sel_ind
        set(hand , 'selected' , 1);
        done_sel = 1;
    else
        set(hand , 'selected' , 0);
    end
end
if ~done_sel & length(tptrs)>0
    set(list.ListItems.Item(1),'selected',1);
end


%-----------------------------------------------------------------------
function [icons,ptrs,names,eval,needptrs,axesptrs] = i_BuildTableList(d)
%-----------------------------------------------------------------------
ptrs = [];names = []; eval = []; icons = []; needptrs = []; axesptrs = [];
pr = project(d.nd);
nds = filterbytype(pr,cgtypes.cgtabletype);
for i = 1:length(nds)
    % Get ptr to table object
    ptr = getdata(nds{i});
    if ptr.isfill
        icons = [icons bmp2ind(d.ILmanager,iconfile(nds{i}))];
        ptrs = [ptrs ptr];
        [thiseval,need,axes] = i_check_eval(d.pD.info,ptr);
        eval = [eval thiseval];
        axesptrs = [axesptrs {axes}];
        needptrs = [needptrs {need}];
        names = [names {ptr.getname}];
    else
        % Don't include any tables that cannot 
        % be filled, e.g. cgnormalisers
    end
end

%-------------------------------------------------------------------
function [valid,need,t_ptrs] = i_check_eval(oppoint,tptr);
%-------------------------------------------------------------------
valid = 1;
need = [];
t_ptrs = get(tptr.info,'axesptrs');
ptrlist = oppoint.ptrlist;
factor_type = get(oppoint,'factor_type');
ptrlist = ptrlist(find(factor_type==1));
for i = 1:length(t_ptrs)
    if ~any(t_ptrs(i)==ptrlist)
        valid = 0;
        need = [need t_ptrs(i)];
    end
end

%-----------------------------------------------------------------------
function str = i_InputsRequired(str1,ptrs)
%-----------------------------------------------------------------------
str = '';
for j = 1:length(ptrs)
    if isvalid(ptrs(j))
        str = [str ptrs(j).getname ', '];
    end
end
if ~isempty(str)
    str = [str1 str(1:end-2) '.'];
else
    str = [str1 'none.'];
end

%-----------------------------------------------------------------------
function ind = i_GetSelection(d)
%-----------------------------------------------------------------------
switch d.currentlist
case 'rules'
    col = 0;
    list = d.Handles.TFListRight;    
case 'tables'
    col = 3;
    list = d.Handles.TFListLeft;
case 'factors'
    col = 2;
    list = d.Handles.TFListMid;
end
ind = pr_getExprListSelection(list,col);

%-----------------------------------------------------------------------
function d = i_RuleClick(d,list)
%-----------------------------------------------------------------------
% Refresh the Bottom Title
d.Table.Cur_Rule = [];
if ~isfield(d, 'currentlist') | isempty(d.currentlist)
    d.currentlist = 'tables';
end
switch d.currentlist
case 'tables'
    d = i_TableClick(d);
case 'rules'
    d = i_RulesClick(d);
case 'factors'
    d = i_FactorsClick(d);
end

%-----------------------------------------------------------------------
function d = i_FactorsClick(d)
%-----------------------------------------------------------------------
ind = i_GetSelection(d);
d.Table.Factor_i = ind;
d = i_SetupPlot(d);

%-----------------------------------------------------------------------
function d = i_TableClick(d)
%-----------------------------------------------------------------------
ind = i_GetSelection(d);
d.Table.TablePtr = d.Table.TablePtrList(ind);
d = i_SetupPlot(d);

%-----------------------------------------------------------------------
function d = i_RulesClick(d)
%-----------------------------------------------------------------------
% Put selected rule onto colorbar

opdata = d.pD.get('data');
if any(size(opdata)==0)
    mess = 'Data set is empty.';
    ind = [];
else
    ind = i_GetSelection(d);
end
if ~isempty(ind)
    d.Table.Cur_Rule = ind;
end
d = i_SetupPlot(d);
return


%-----------------------------------------------------------------------
function d = i_SetupPlot(d)
%-----------------------------------------------------------------------

% Work out factor list and data
factor_type = d.pD.get('factor_type');
in_i = find(factor_type==1);
out_i = d.Table.Factor_i;
mess = '';
if isempty(out_i)
    out_i = find(factor_type==2);
    if isempty(out_i)
        mess = {'Data set has no output factors', '','Return to Factors Information and add an output'};
    elseif length(out_i)==1
        d.Table.Factor_i = out_i;
    else
        mess = 'Select an output factor.';
    end
elseif ~isvalid(d.Table.TablePtr)
    mess = 'Select a table to fill.';
else
    [valid,need] = i_check_eval(d.pD.info,d.Table.TablePtr);
    if ~valid
        mess = {['Cannot fill table ' d.Table.TablePtr.getname],...
                i_InputsRequired('Inputs required: ',need)};
    elseif ~d.Table.TablePtr.isfill
        mess = ['Table ' d.Table.TablePtr.getname ' is not set up.'];
    end
end
    
if isempty(mess)
    opdata = d.pD.get('data');
    valid = find(~all(isnan(opdata(:,in_i))));
    in_i = in_i(valid);
    opfactors = d.pD.getFactorsAndUnits;
    factors = [{'Data set point'} opfactors(in_i) opfactors(out_i)];
    data = [[1:size(opdata,1)]' opdata(:,in_i) opdata(:,out_i)];
    
    displayunits = junit;
    unitstr = char(displayunits);
    
    valid = ~any(all(isnan(data)));
    pevdata = [];
    % single plot
    if  ~valid
        mess = [opfactors{out_i} ' cannot be evaluated.'];
    else
        inputs = repmat(1,size(data,2),1);
        tptr = d.Table.TablePtr;
        if ~isvalid(tptr)
            mess = 'Cannot fill table.';
        end
    end
end
d.Plot.ViewEnable = {'off' 'off' 'off'};
if isempty(mess)
    if ~d.callingviewswitchflag
        d.Plot.ViewEnable = {'on' 'on' 'on'};
        axesptrs = tptr.get('axesptrs');
        if length(axesptrs)==1
            d.Plot.ViewEnable(2) = {'off'};
            if strmatch(d.Table.TopMode, 'line', 'exact')
                d.Table.TopMode = 'line';
            else
                d.Table.TopMode = 'dataset';                
                pr_SetViewData(d);
                % Set the current plot card to dataset 
                chgviewcb = get(d.Handles.plm.View(5), 'callback');
                d.callingviewswitchflag = 1;
                pr_SetViewData(d);
                feval(chgviewcb{1}, d.Handles.plm.View(5), [], 'dataset');
            end
        end
    end
    d.callingviewswitchflag = 0;    
    pr_SetViewData(d);    
    titlestr = ['Filling table ' tptr.getname ', from factor ' opfactors{out_i}];
    switch d.Table.TopMode
    case 'dataset'
        
        [col_mat,mark_mat] = ColorMatrix(d.Handles.Legend,1);
        index = Apply(d.pD.get('rules'),opdata);
        set(d.Handles.DataDisplay,...
            'title',titlestr,'yunit',unitstr,...
            'data',data,'factors',factors,...
            'tableptr',tptr,...
            'tableindex',index,...
            'markercolor',col_mat,'marker',mark_mat,...
            'fillmask',inputs);
        i_PlotRules(d,in_i);
    case 'surface'
        [SX,SY,SZ,PX,PY,PZ,SPZ,names,sOK] = i_GetTableData(tptr,d.pD,out_i);
        if sOK
            lim = pr_graphlim([],[],SX,SY,SZ);
            lim = pr_graphlim(lim,d.Top.EditAxis,PX,PY,PZ);
            ef = d.Plot.ShowError;
            pr_PlotSurface(d.Top.EditAxis,lim,ef,SX,SY,SZ,PX,PY,PZ,SPZ);
            set(get(d.Top.EditAxis,'title'),'string',titlestr, 'interpreter', 'none');
            set(get(d.Top.EditAxis,'xlabel'),'string',names{1}, 'interpreter', 'none');
            set(get(d.Top.EditAxis,'ylabel'),'string',names{2}, 'interpreter', 'none');
            set(get(d.Top.EditAxis,'zlabel'),'string','Table', 'interpreter', 'none');
        else
            % Problem - revert back to data set plot and inform user
            set(d.Handles.PlotCard,'currentcard',1);
            d.Table.TopMode = 'dataset';
            uiwait(errordlg('Unexpected error when plotting', 'Table Fill', 'modal'));
        end
    case {'multiline','line'}
        [SX,SY,SZ,PX,PY,PZ,SPZ,names,sOK] = i_GetTableData(tptr,d.pD,out_i);
        if sOK
            lim = pr_graphlim([],[],SX,SY,SZ);
            lim = pr_graphlim(lim,d.Top.EditAxis,PX,PY,PZ);
            ef = d.Plot.ShowError;
            flip = d.Plot.SwapAxes;
            pr_PlotMultiLine(d.Top.EditAxis,lim,ef,flip,names,SX,SY,SZ,PX,PY,PZ,SPZ);
            set(get(d.Top.EditAxis,'title'),'string',titlestr, 'interpreter', 'none');
            set(get(d.Top.EditAxis,'ylabel'),'string','Table', 'interpreter', 'none');
        else
            % Problem - revert back to data set plot and inform user
            set(d.Handles.PlotCard,'currentcard',1); 
            d.Table.TopMode = 'dataset';
           uiwait(errordlg('Unexpected error when plotting', 'Table Fill', 'modal'));
        end 
    end
    set(d.Handles.TopCard,'currentcard',d.currentcard);
    i_RefreshBottomTitle(d, 'message');
else
    pr_Message(d,mess);
    done_index = [];
    i_RefreshBottomTitle(d, 'blank'); 
end

% Final check to see if all points have been excluded by user
% If so, fill table button should be disabled
rules = d.pD.get('rules');
data = d.pD.get('data');
index = Apply(rules, data);
if ~isempty(index) & isempty(mess)
    fillenable = 'on';
else
    fillenable = 'off';
end
set(d.Handles.TFFillButton, 'enable', fillenable);
set(d.Handles.tabm.Fill, 'enable', fillenable);    

%-----------------------------------------------------------------------
function cb_PlotRules(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
i_PlotRules(d,d.Table.in_i);

%-----------------------------------------------------------------------
function i_PlotRules(d,in_i)
%-----------------------------------------------------------------------
in_i = [in_i d.Table.Factor_i];
xfac = get(d.Handles.DataDisplay,'currentxfactor');
yfac = get(d.Handles.DataDisplay,'currentyfactor');
if xfac==1
    xfac = 0;
else
    xfac = in_i(xfac-1);
end
if yfac==1
    yfac = 0;
else
    yfac = in_i(yfac-1);
end
cb = @cb_UpdateDragRule;
plot(d.pD.get('rules'),get(d.Handles.DataDisplay,'axes'),xfac,yfac,cb,d.Table.Cur_Rule);

%-----------------------------------------------------------------------
function cb_SetupMenu(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
switch d.Table.BottomMode
    case 'rules'
        d.currentlist = 'rules';
        set(d.Handles.tabm.contextvis,'visible','on');
        rules = d.pD.get('rules');
        if isempty(rules)
            set(d.Handles.tabm.Clear,'enable','off');
        else
            set(d.Handles.tabm.Clear,'enable','on');
        end
        ind = i_GetSelection(d);
        if ~isempty(ind)
            state = get(rules,ind,'state');
        end
        if ~isempty(rules) & state~=0
            set(d.Handles.tabm.Disable,'enable','on');
            set(d.Handles.tabm.Enable,'enable','off');
        else
            set(d.Handles.tabm.Disable,'enable','off');
            set(d.Handles.tabm.Enable,'enable','on');
        end
        if ~isempty(rules) & state~=-1
            set(d.Handles.tabm.Exclude,'enable','on');
        else
            set(d.Handles.tabm.Exclude,'enable','off');
        end
        if ~isempty(rules) & state~=1
            set(d.Handles.tabm.Include,'enable','on');
        else
            set(d.Handles.tabm.Include,'enable','off');
        end
        if ~isempty(rules) & state==0
            set(d.Handles.tabm.Include,'enable','off');
            set(d.Handles.tabm.Exclude,'enable','off');
        end

        if ~isempty(rules)
            set([d.Handles.tabm.Promote d.Handles.tabm.Demote],'enable','on');
        else
            set([d.Handles.tabm.Promote d.Handles.tabm.Demote],'enable','off');
        end
    case 'tables'
        d.currentlist = 'tables';
        set(d.Handles.tabm.contextvis,'visible','off');
        set(d.Handles.tabm.pulldownen,'enable','off');
    case 'factors'
        d.currentlist = 'factors';
        set(d.Handles.tabm.contextvis,'visible','off');
        set(d.Handles.tabm.pulldownen,'enable','off');
end

return

%-----------------------------------------------------------------------
function cb_UpdateRule(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
d = i_UpdateRule(d);
d = feval(d.Plot.TableCB,[],[],3,d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function d = i_UpdateRule(d)
%-----------------------------------------------------------------------
ind = i_GetSelection(d);
rules = d.pD.get('rules');
if ~isempty(ind)
    rule = rules(ind);
    rule.enable = 0;
    rules(ind) = rule;
    d.pD.info = d.pD.set('rules',rules);
end
d = i_RefreshListRules(d,ind);

%-----------------------------------------------------------------------
function cb_UpdateDragRule(src,ev,xlim,ylim)
%-----------------------------------------------------------------------
d = pr_GetViewData;
xfac = get(d.Handles.DataDisplay,'currentxfactor');
yfac = get(d.Handles.DataDisplay,'currentyfactor');
rules = d.pD.get('rules');
ind = i_GetSelection(d);
rules = update(rules,ind,xlim,ylim);
d.pD.info = d.pD.set('rules',rules);
d = i_View(d);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_DragRule(src,ev,xlim,ylim)
%-----------------------------------------------------------------------
d = pr_GetViewData;
xfac = get(d.Handles.DataDisplay,'currentxfactor');
yfac = get(d.Handles.DataDisplay,'currentyfactor');
x_i = xfac - 1;
y_i = yfac - 1;
allfacs = [d.Table.in_i d.Table.Factor_i];
if x_i>0
    x_fi = allfacs(x_i);
else
    x_fi = 0;
end

if y_i>0 
    y_fi = allfacs(y_i);
else
    y_fi = 0;
end
rules = d.pD.get('rules');
rules = add(rules,[xlim(1) ylim(1)],[xlim(2) ylim(2)],[x_fi,y_fi]);
rules = set(rules, length(rules), 'state', 1);
d.pD.info = d.pD.set('rules',rules);
d.Table.BottomMode = 'rules';
%d = i_View(d,length(rules));
d = i_View(d);
pr_SetViewData(d);


%-----------------------------------------------------------------------
function cb_PromoteRule(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
currlist = d.currentlist;
d.currentlist = 'rules';
ind = i_GetSelection(d);
d.currentlist = currlist;
rules = d.pD.get('rules');
[rules,newind] = reorder(rules,ind,varargin{3});
if newind~=ind
    d.pD.info = d.pD.set('rules',rules);
    d = i_View(d);
    pr_SetViewData(d);
end

%-----------------------------------------------------------------------
function cb_ClearRule(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
currlist = d.currentlist;
d.currentlist = 'rules';
ind = i_GetSelection(d);
d.currentlist = currlist;
rules = d.pD.get('rules');
if ~isempty(ind)
    rules = clear(rules,ind);
    d.pD.info = d.pD.set('rules',rules);
    d = i_View(d);
    pr_SetViewData(d);
end
return

%-----------------------------------------------------------------------
function cb_EnableRule(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
currlist = d.currentlist;
d.currentlist = 'rules';
ind = i_GetSelection(d);
d.currentlist = currlist;
if ~isempty(ind)
    rules = d.pD.get('rules');
    value = varargin{3};
    rules = set(rules,ind,'state',value);
    d.pD.info = d.pD.set('rules',rules);
    d = i_View(d);
    pr_SetViewData(d);
end
return


%-----------------------------------------------------------------------
function cb_Fill(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
tptr = d.Table.TablePtr;
ok = [];
[ok, err] = FillTable(d.pD.info,tptr,d.Table.Factor_i);
if ok
    % Show the table history if user has asked for it
    if get(d.Handles.TFCheck, 'value')
        cghistorymanager('create', tptr);
    end
else
    errordlg(err, 'Table Fill', 'modal');
end

%-----------------------------------------------------------------------
function [SX,SY,SZ,PX,PY,PZ,SPZ,names, OK] = i_GetTableData(tptr,opptr,fact_i)
%-----------------------------------------------------------------------

% Optimistically assume that the surface data can be retrieved from the
% data set
OK = true;

axesptrs = tptr.get('axesptrs');
axes = tptr.get('axes');
if ~iscell(axes)
    % Need to set up dummy second axis for plot routine
    axes = [{axes} {1}];
end
ptrlist = opptr.get('ptrlist');
opdata = opptr.get('data');
index = Apply(opptr.get('rules'),opdata);
SX = []; SY = []; SZ = []; PX = []; PY = []; PZ = [];
names = [];
for i = 1:length(axesptrs)
    names = [names {axesptrs(i).getname}];
    f = find(axesptrs(i)==ptrlist);
    if ~isempty(f)
        f = f(1);
    else        
        OK = false;
    end
    switch i
        case 1
            PX = opdata(index,f);
            SX = axes{i};
        case 2
            PY = opdata(index,f);
            SY = axes{i};
    end
end
if ~isempty(SX) & ~isempty(SY)
    [SX,SY] = ndgrid(SX,SY);
end
PZ = opdata(index,fact_i);
SZ = tptr.get('values');
SZ = SZ';
SPZ = opptr.i_eval(tptr);
SPZ = SPZ(index);

%-----------------------------------------------------------------------
function btitle = i_RefreshBottomTitle(d, mess)
%-----------------------------------------------------------------------

switch mess
    case 'blank'
        btitle = '';
    case 'message'

        ftype = get(d.pD.info, 'factor_type');
        out_i = find(ftype == 2);
        if get(d.Handles.TFListLeft, 'selecteditemindex') == -1
            btitle = 'No table selected for filling';
        elseif get(d.Handles.TFListMid, 'selecteditemindex') == -1
            btitle = 'No model selected to fill table with';
        elseif isempty(out_i)
            btitle = 'No output factors in data set';
        else
            TabName = get(get(d.Handles.TFListLeft, 'selecteditem'), 'Text');
            ModName = get(get(d.Handles.TFListMid, 'selecteditem'), 'Text');
            DSName = d.pD.getname;
            btitle = ['Filling table ',TabName, ' with output factor ', ModName, ' from ',DSName];
        end
end

set(d.Handles.TFTextTop, 'title', btitle);

%-----------------------------------------------------------------------
function en = cb_Enable(op)
%-----------------------------------------------------------------------
d = pr_GetViewData;
pr = project(d.nd);
t_nds = filterbytype(pr,cgtypes.cgtabletype);
fillflag = 0;
for i = 1:length(t_nds)
    % Look through the table nodes until a table
    % is found that can be filled
    pT = getdata(t_nds{i});
    fillflag = pT.isfill;
    if fillflag
        break;
    end
end
data = get(op, 'data');
if fillflag & ~isempty(op) & ~isempty(data)
    en = 1;
else
    en = 0;
end
