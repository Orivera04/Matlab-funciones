function [d, cb] = Inputs(nd, d)
%INPUTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.4.4 $  $Date: 2004/02/09 08:21:36 $


cb = i_GetCallbacks;


%------------------------------------------------------------------
function cb = i_GetCallbacks
%------------------------------------------------------------------
cb = [];
cb.Show = @i_Show;
cb.View = @i_View;
cb.Click = @i_Click;
cb.Draw = @i_Draw;
cb.Enable = @i_Enable;


%-----------------------------------------------------------------------
function en = i_Enable(op)
%-----------------------------------------------------------------------
en = ~isempty(op);

%-----------------------------------------------------------------------
function [d,fig] = i_Draw(d)
%-----------------------------------------------------------------------
fig = xregfigure('visible', 'off', 'WindowStyle', 'modal'); %dialog
% Register the figure with CAGE
CGBH = cgbrowser;
CGBH.registersubfigure(double(fig), 'current');
fig.ResourceLocation = cgrespath;
[d,lyt] = i_DrawLyt(d,fig);
fig.LayoutManager = lyt;
set(lyt,'packstatus','on');

%-----------------------------------------------------------------------
function [d,lyt] = i_DrawLyt(d,fig)
%-----------------------------------------------------------------------
ILmanager = get(cgbrowser,'ILmanager');
IL=ILmanager.IL;

Handles.Figure = fig;

mfile = 'cgdatasetnodecb';
callbacks = {'rightclick',mfile;...
        'click',mfile;...
        'keyup',mfile;...
        'dblclick',mfile;...
        'MouseMove','MotionManager'};

[Handles.List,Handles.ListLyt] = ...
    pr_CreateList(double(fig), callbacks, 'top',IL);
Handles.List.Sorted = 0;

Handles.Active = xregGui.uicontrol('parent',Handles.Figure, 'style' , 'push' , ...
   'string' , 'Make Active' , ...
    'visible','off',...
   'callback' , @cb_Active);
Handles.Clear = xregGui.uicontrol('parent',Handles.Figure, 'style' , 'push' , ...
   'string' , 'Clear' , ...
    'visible','off',...
   'callback' , @cb_Clear);


Handles.InputVector = xregGui.uicontrol('parent',Handles.Figure, 'style','edit',...
    'callback',@cb_EditInput,...
    'backgroundcolor','w',...
    'horizontalalignment','left',...
    'visible','off');
Handles.InputName = xregGui.uicontrol('parent',Handles.Figure, 'style','text',...
    'horizontalalignment','left',...
    'fontweight','demi',...
    'fontsize',10,...
    'visible','off');
Handles.InputMsg = xregGui.uicontrol('parent',Handles.Figure, 'style','text',...
    'visible','off');

Handles.InputName2 = xregGui.uicontrol('parent',Handles.Figure, 'style','text',...
    'fontweight','demi',...
    'fontsize',10,...
    'visible','off');

vec = xreggridlayout(fig,'dimension',[1 2],...
    'correctalg','on',...
    'packstatus','off',...
    'gapx',10,...
    'visible','off',...
    'colsizes', [100 -1], ...
    'elements',{Handles.InputName Handles.InputVector});

Handles.InputsCard = xregcardlayout(Handles.Figure,...
    'visible','off',...
   'packstatus','off',...
   'numcards',2);
attach(Handles.InputsCard , vec , 1);
attach(Handles.InputsCard , Handles.InputName2 , 2);

Handles.OK = xregGui.uicontrol('parent',Handles.Figure, 'style' , 'push' , ...
   'string' , 'OK' , ...
    'visible','off',...
   'callback' , @cb_OK);
Handles.Cancel = xregGui.uicontrol('parent',Handles.Figure, 'style' , 'push' , ...
   'string' , 'Cancel' , ...
    'visible','off',...
   'callback' , @cb_Cancel);
Handles.GridMsg = xregGui.uicontrol('parent',Handles.Figure,'style','text',...
    'horizontalalignment','left',...
    'visible','off');
panel = xregpanellayout(fig,'center',Handles.GridMsg,...
    'visible','off');
buttons = xreggridlayout(fig,'dimension',[1 3],...
    'elements',{panel Handles.OK Handles.Cancel},...
    'correctalg','on',...
    'packstatus','off',...
    'gapx',10,...
    'colsizes',[-1 70 70],...
    'visible','off');

Handles.InputGrid = xreggridbaglayout(fig,'dimension',[3 2],...
    'correctalg','on',...
    'packstatus','off',...
    'visible','off',...
    'elements',{Handles.InputMsg [] Handles.InputsCard Handles.Clear Handles.Active []},...
    'colsizes',[-1 70],...
    'gapy',10,...
    'gapx',10);
merge(Handles.InputGrid,[1 2],[1 1]);

Handles.MainLyt = xreggridlayout(fig,'visible','off',...
    'correctalg','on',...
    'dimension',[2 1],...
    'elements',{Handles.ListLyt Handles.InputGrid},...
    'gapy',10,...
    'rowsizes',[-1 80]);

frame = xregframetitlelayout(fig,'visible','off',...
    'center',Handles.MainLyt,...
    'border',[0 5 0 0]);

lyt = xregborderlayout(fig,'visible','off',...
    'center',frame,...
    'south',buttons,...
    'innerborder',[0 25 0 0],...
    'border',[5 5 5 5]);

Handles.Lyt = lyt;

d.Inputs = Handles;



%-----------------------------------------------------------------------
function d = i_Show(d)
%-----------------------------------------------------------------------

set(d.Inputs.Figure,'name','Grid Data Set');
pr_ConfigureList(d.Inputs.List,d.Inputs.ListLyt,...
    {'Factor','Type','Range','Index'},...
    [200,100,200,0],...
    'Grid over data set input factors');
set(d.Inputs.Lyt,'visible','on');
set(d.Inputs.Figure,'visible','on','closerequestfcn',@cb_Cancel);
d.Inputs.tmp = d.pD.info;
d.Inputs.tmp = i_EnsureSymDep(d.Inputs.tmp);

%------------------------------------------------------------------
function ind = i_ListIndex
%------------------------------------------------------------------
ind = 3;

%-----------------------------------------------------------------------
function d = i_View(d,sel_name)
%-----------------------------------------------------------------------
% set up top list display
[d.pD.info,d.Inputs.dependant] = SetGroupDependants(d.pD.info);
d = i_RefreshList(d,-1);
d = i_Click(d);



%------------------------------------------------------------------
function d = i_Click(d,list)
%------------------------------------------------------------------
fact_i = pr_getExprListSelection(d.Inputs.List,i_ListIndex);

mess = ''; card = 2;
set(d.Inputs.InputName2,'string','');
factors = get(d.Inputs.tmp,'factors');
type = 'none';
if length(fact_i)~=1
    [in_i,type] = getGridInfo(d.Inputs.tmp);
    f = find(ismember(in_i,fact_i));
    type = type(f);
else
    [detail,type] = getGridInfo(d.Inputs.tmp,fact_i);
    switch type{1}
    case {'grid','constant'}
        mess = {'Enter range or constant for this variable.',...
            'Colon notation may be used to specify range (eg 0:5:20 = 0,5,10,15,20)'};
        valstr = prettify(detail);
        set(d.Inputs.InputVector,'string',valstr,'userdata',detail);
        set(d.Inputs.InputName,'string',factors{fact_i},'userdata',fact_i);
        card = 1;
    case {'block','outputblock'}
        mess = 'Click Clear to remove from block ->';
        set(d.Inputs.InputName2,'string',detail, 'horizontalalignment', 'left');
    case 'table'
        mess = 'Click Clear to clear table data ->';
        set(d.Inputs.InputName2,'string',detail);
    case {'grouplinked','groupconstant','groupgrid','groupgrid','groupblock'}
        mess = 'Click Make Active to make this variable the active group member ->';
        set(d.Inputs.InputName2,'string',detail);
    end
end
set(d.Inputs.InputMsg,'string',mess, 'HorizontalAlignment', 'left');
set(d.Inputs.InputsCard,'currentcard',card);
d = i_ButtonState(d,fact_i,type);

%------------------------------------------------------------------
function d = i_ButtonState(d,fact_i,type)
%------------------------------------------------------------------
but = [0 0]; 
clfact = [];
for i = 1:length(fact_i)
    switch type{i}
    case {'table','block','outputblock'}
        but(1) = 1;
        if fact_i(i)
            clfact = [clfact fact_i(i)];
        else
            clfact = [clfact getGridOutputBlock(d.Inputs.tmp)];
        end
    case {'grouplinked','groupconstant','groupgrid','groupgrid','groupblock'}
        if length(fact_i)==1
            but(2) = 1;
        end
    end
end
if but(1)
    set(d.Inputs.Clear,'enable','on','userdata',clfact);
else
    set(d.Inputs.Clear,'enable','off');
end
if but(2)
    set(d.Inputs.Active,'enable','on','userdata',fact_i);
else
    set(d.Inputs.Active,'enable','off');
end
    

%------------------------------------------------------------------
function cb_EditInput(varargin)
%------------------------------------------------------------------
d = pr_GetViewData;

fact_i = get(d.Inputs.InputName,'userdata');
val = str2num(get(d.Inputs.InputVector,'string'));
if any(isnan(val) | isinf(val))
    val = [];
end
oldval = get(d.Inputs.InputVector,'userdata');
switch length(val)
case 0
    %empty - put back old value
    val = oldval;
case 1
    d.Inputs.tmp = set(d.Inputs.tmp,fact_i,'constant',val,'grid_flag',0);
otherwise
    d.Inputs.tmp = set(d.Inputs.tmp,fact_i,'range',val,'grid_flag',1);
end
%group dependants done during view refresh

%tidy up
if ~isempty(val)
    valstr = prettify(val);
else
    valstr = '';
end
set(d.Inputs.InputVector,'string',valstr,'userdata',val);
d = i_View(d);
pr_SetViewData(d);



%-----------------------------------------------------------------------
function cb_OK(varargin)
%-----------------------------------------------------------------------
% Go back to where we were before
d = pr_GetViewData;

%d_ind = find(grid_flag==8);   %dependant
%eval_ind = find(~overwrite);
%eval_ind = setdiff(eval_ind,d_ind);

%d.pD.info = d.tempoppoint;
%d.pd.info = d.pD.set(eval_ind,'grid_flag',0);  %don't grid over these variables
maxsinglelen = 50;
maxlen = 2000;

[ind,types,typestrs,ranges,numpts] = getGridInfo(d.Inputs.tmp);
if any(cellfun('length',ranges)>=maxsinglelen) || numpts>=maxlen
    but = questdlg({'Warning: large data set will be generated.',...
            'Continue?'},'Dataset Viewer','Continue','Cancel','Cancel');
    if strcmp(but,'Cancel')
        return
    end
end
    
% Record the current block length. The range_grid and eval_fill will
% mess about with the block length, which should not be altered by a 
% *manual* gridding action.
currblocklen = get(d.Inputs.tmp, 'blocklen');

d.Inputs.tmp = range_grid(d.Inputs.tmp);
d.Inputs.tmp = eval_fill(d.Inputs.tmp);

% Reset the block length
d.Inputs.tmp = set(d.Inputs.tmp, 'blocklen', currblocklen);

d.pD.info = d.Inputs.tmp;
set(d.Inputs.Figure,'visible','off');
d = pr_ChangeView(d,d.OldViewID);
pr_SetViewData(d);

%-----------------------------------------------------------------------
function cb_Cancel(varargin)
%-----------------------------------------------------------------------
% Go back to where we were before
%  (Been working on a temp copy of the dataset, so don't need to do
%   anything to restore old version)
d = pr_GetViewData;
set(d.Inputs.Figure,'visible','off');
d = pr_ChangeView(d,d.OldViewID);
pr_SetViewData(d);


%-----------------------------------------------------------------------
function cb_Active(varargin)
%-----------------------------------------------------------------------
% Do something with set group dependants...
% 26/ix/01 - Temporary measure for Beta 1.2
% For Beta 1.2, a group only has two members.
% So for now, this function will just swap the grid flags. 
% A redraw will be needed. 

d = pr_GetViewData;
fact_i = pr_getExprListSelection(d.Inputs.List,i_ListIndex);
allGrp = get(d.Inputs.tmp, 'group');
currGrp = allGrp(fact_i);
grpMembs = find(allGrp==currGrp);
if length(grpMembs) > 2
    errordlg('This formula is invalid. Cannot set active member.', 'Build Grid', 'modal');
else
    allGrid = get(d.Inputs.tmp, 'grid_flag');
    allRange = get(d.Inputs.tmp, 'range');
    allData = get(d.Inputs.tmp, 'data');    
    otherMember = grpMembs(find(grpMembs~=fact_i));
    allGrid(fact_i) = allGrid(otherMember);
    allGrid(otherMember) = 8;
    if ~isempty(allData)
        depLen = length(allRange{otherMember});
        allRange{fact_i} = allData(1:depLen,fact_i);
    else
        allRange{fact_i} = [];
    end
    allRange{otherMember} = [];
    d.Inputs.tmp = set(d.Inputs.tmp, 'grid_flag', allGrid);
    d.Inputs.tmp = set(d.Inputs.tmp, 'range', allRange);    
    [d.Inputs.tmp,d.Inputs.dependant] = SetGroupDependants(d.Inputs.tmp);
    d = i_RefreshList(d,-1);
    d = i_View(d);
    pr_SetViewData(d);
end
    
%-----------------------------------------------------------------------
function cb_Clear(varargin)
%-----------------------------------------------------------------------
d = pr_GetViewData;
fact_i = get(varargin{1},'userdata');
f = find(isImported(d.Inputs.tmp,fact_i));
if ~isempty(f)
    but = questdlg({'Removing factors from block',...
            'will delete imported data.',...
            'Continue?'},'Dataset Viewer','Remove','Cancel','Cancel');
    if strcmp(but,'Cancel')
        return
    end
end

% We need to check to see if clearing this block of imported 
% will invalidate any other factors (e.g. errors)

% OK, want to clear the block. Is the data block linked to a CAGE
% expression ?

cf = get(d.Inputs.tmp, 'created_flag');
ptrlist = get(d.Inputs.tmp, 'ptrlist');
factors = get(d.Inputs.tmp, 'factors');
f = find((cf(fact_i)==0 & ~isvalid(ptrlist(fact_i))) | ...
    cf(fact_i)==1);

if ~isempty(f)
    % Not linked - may be able to remove the factor. Check first
    inv_i = CheckRemove(d.Inputs.tmp,fact_i);
    if ~isempty(inv_i)
        errstr = 'Cannot clear this imported data as this will invalidate the factors : ';
        invstr = i_prettycell(factors(unique(inv_i)));
        errstr = {errstr, '', invstr};
        errordlg(errstr, 'Build Grid', 'modal');
        return;
    end
end

d.Inputs.tmp = ClearGrid(d.Inputs.tmp,fact_i);
% Ensure correct blocklen
d.Inputs.tmp = setblocklen(d.Inputs.tmp);
d.Exprs.recalc = [0 0 1 0];
d = i_View(d);
pr_SetViewData(d);

%------------------------------------------------------------------
function fstr = i_prettycell(namec)
%------------------------------------------------------------------
fstr = '';
for i = 1:length(namec)
    fstr = [fstr namec{i} ', '];
end
fstr = fstr(1:end-2);

%-----------------------------------------------------------------------
function d = i_RefreshList(d,select_index)
%-----------------------------------------------------------------------
list = d.Inputs.List;

select_index = pr_getExprListSelection(list,i_ListIndex);
select_item = [];
list.ListItems.Clear;

[ind,types,typestrs,ranges,numpts] = getGridInfo(d.Inputs.tmp);
factors = get(d.Inputs.tmp,'factors');

indstr = num2str(ind(:));
for i =1:length(types)
    icstr = '';
    if ~isempty(ranges{i})
        rangestr = prettify(ranges{i});
        if length(ranges{i})>1
            rangestr = [rangestr '    (' num2str(length(ranges{i})) ' points)'];
        end
    else
        rangestr = '';
    end
    switch types{i}
    case 'constant'
        icstr = 'cgdsinputconst.bmp';
    case 'grid'
        icstr = 'cgdsinputrange.bmp';
    case 'table'
        icstr = 'cgdsinputrange.bmp';
        rangestr = 'Table axis';
    case 'block'
        icstr = 'cgdatasetnode.bmp';
        rangestr = 'Imported data';
    case 'grouplinked'
        icstr = 'cgdsgplink.bmp';
    case 'groupconstant'
        icstr = 'cgdsgpinputconst.bmp';
    case 'groupgrid'
        icstr = 'cgdsgpinputrange.bmp';
    case 'groupblock'
        icstr = 'cgdatasetnode.bmp';
        rangestr = 'Imported data';
    case 'outputblock'
        icstr = 'cgdatasetnode.bmp';
        rangestr = 'Imported data';
    end
    if isempty(icstr)
        icon = 0;
    else
        icon = bmp2ind(d.ILmanager,icstr);
    end
    
    if ~ind(i)
        name = 'Output Data';
    else
        name = factors{ind(i)};
    end

    hand = list.ListItems.Add;
    set(hand , 'text' , name);
    set(hand , 'subitems',1,typestrs{i});
    set(hand , 'subitems',2,rangestr);
    set(hand , 'subitems',3,indstr(i,:));
    set(hand , 'smallicon' , icon);
    set(hand , 'selected' , 0);
    if ~isempty(select_index) && any(select_index==ind(i))
        select_item = [select_item hand];
    end
end

infostr = ['Current size: ' num2str(get(d.Inputs.tmp,'numpoints')) ' point(s).  '...
        'Projected size: ' num2str(numpts) ' point(s).'];
set(d.Inputs.GridMsg,'string',infostr);


if length(select_item)>0
    for i = 1:length(select_item)
        set(select_item(i),'selected',1);
    end
    set(list,'SelectedItem',select_item(1));
    drawnow; % this is needed to make sure the selected item becomes visible;
    % the drawing doesn't pick up the new list otherwise
    EnsureVisible(select_item(1));
end

%-----------------------------------------------------------------------
function op = i_EnsureSymDep(op)
%-----------------------------------------------------------------------

grid = get(op, 'grid_flag');
oldblocklen = get(op, 'blocklen');
ptrs = get(op, 'ptrlist');

for i=1:length(ptrs)
    if isvalid(ptrs(i)) && isddvariable(ptrs(i).info) && issymvalue(ptrs(i).info)
        symgrid = grid(i);
        if grid(i) ~= 8
            % The symvalue is the independent variable - need to make it dependant
            % when the input dialog is shown
            rhsptrs = getrhsptrs(ptrs(i).info);
            for j = 1:length(rhsptrs)
                % Choose the first right hand side var to be the independent variable
                if ~isconstant(rhsptrs(j).info)
                    rhsind = find(double(ptrs) == double(rhsptrs(j)));
                    grid(rhsind(1)) = symgrid;
                    grid(i) = 8;
                    break;
                end
            end
        else
            % The symvalue is a dependant variable - no action
        end
    end
end

op = set(op, 'grid_flag', grid);
op = set(op, 'blocklen', oldblocklen);
