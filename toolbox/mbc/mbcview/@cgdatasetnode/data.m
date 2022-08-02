function varargout = data(obj, action)
%DATA Create and manage the dataset table view
%
%  CB = DATA(OBJ, 'get_callbacks') returns a structure of function handles
%  to the functions that can be used to create and manage the dataset table
%  view.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.17.2.6 $  $Date: 2004/04/12 23:35:01 $


if nargin>1 && ischar(action)
    switch lower(action)
        case 'get_callbacks'
            varargout{1} = i_GetCallbacks;
    end
end


%-----------------------------------------------------------------------
function cb = i_GetCallbacks
%-----------------------------------------------------------------------
cb.View = @i_View;
cb.Copy = @i_Copy;
cb.Show = @i_Show;
cb.Paste = @i_Paste;
cb.ExprClick = @i_ExprClick;
cb.Draw = @i_DrawDataPage;
cb.Selection = @i_Selection;
cb.ShowIndex = @i_ShowIndex;


%------------------------------------------------------------------
function [d,lyt] = i_DrawDataPage(d)
%------------------------------------------------------------------
Handles = d.Handles;
fig = Handles.Figure;

% Context menu for row header clicks
m = uicontextmenu('parent', fig);
mm = uimenu(m , 'label' , '&Insert above',...
    'callback' , {@cb_InsertRow, 0});
mm = uimenu(m , 'label' , 'Insert &below',...
    'callback' , {@cb_InsertRow, 1});
mm = uimenu(m , 'label' , '&Delete',...
    'callback' , @cb_RemoveRow);
Handles.TableRowMenu = m;

% Table
Handles.Table = cgdatasetgui.table('parent', fig,...
    'visible', 'off', ...
    'RowUIContextMenu', m);
Handles.TableEditListener = handle.listener(Handles.Table, 'DataChanged', @cb_EditClick);
Handles.TableSelListener = handle.listener(Handles.Table, 'SelectionChanged', @cb_SelChange);
Handles.TableColumnRCListener = handle.listener(Handles.Table, ...
    'ColumnHeaderRightClick', @cb_OpenColContext);

lyt = Handles.Table;
d.Handles = Handles;


%------------------------------------------------------------------
function d = i_Show(d)
%------------------------------------------------------------------
pr_ConfigureExprList(d.Handles.ExprList,d.Handles.BottomList);
d.Handles.fm.BmVis = d.Handles.fm.FactorVisBm;


%------------------------------------------------------------------
function d = i_View(d,sel_name)
%------------------------------------------------------------------
% Completely redraw the table
d.Handles.Table.setDataset(d.pD);
set(d.Handles.TopCard,'currentcard',d.currentcard);

if nargin<2
    sel_name = -1;
end
d = pr_RefreshExprList(d,sel_name,'cage');

d = i_ExprClick(d, d.Handles.FactorList);


%------------------------------------------------------------------
function cb_InsertRow(src, evt, pos)
%------------------------------------------------------------------
d = pr_GetViewData;
t = d.Handles.Table;

if nargin<3
    pos = 1;
end

row = double(t.Component.getSelectedRows);
nRows = length(row);
if nRows
    if pos==1
        row = max(row);
    else
        row = min(row)-1;
    end
else
    nRows = 2;
    row = 1;
end

% Add new row to underlying dataset
d.pD.info = d.pD.AddRow([], row, nRows);

% Perform quick refresh of table cell data
t.refresh;


%------------------------------------------------------------------
function cb_RemoveRow(src, evt)
%------------------------------------------------------------------
d = pr_GetViewData;
t = d.Handles.Table;

row = double(t.Component.getSelectedRows);
if ~isempty(row)
    OpPt = d.pD.info;
    
    % Remove data from underlying dataset
    data = get(OpPt, 'data');
    data(row,:) = [];
    OpPt = set(OpPt, 'data',data);
    
    % Convert grids into a block of data
    OpPt = convertGridToBlock(OpPt);
    d.pD.info = OpPt;
    
    % Perform quick refresh of table cell data
    t.refresh;
end


%------------------------------------------------------------------
function cb_EditClick(src,evt)
%------------------------------------------------------------------
% Update the toolbar when the dataset is edited
d = pr_GetViewData;
d = pr_EnableToolbar(d);


%------------------------------------------------------------------
function cb_SelChange(src, evt)
%------------------------------------------------------------------
% Deselect the items in the project expression list
d = pr_GetViewData;
pr_DeselectList(d.Handles.ExprList);


%------------------------------------------------------------------
function cb_OpenColContext(src, evt)
%------------------------------------------------------------------
% Plug into the same context menu that is used on the project list
d = pr_GetViewData;
ExprListFcns(d.nd, d, 'right_click', 'top');


%-----------------------------------------------------------------------
function sel = i_Selection(d)
%-----------------------------------------------------------------------
% Only report a selection when we are trying to open the column context
% menu
sel = d.Handles.Table.getSelectedColumns;
sel = d.Exprs.shown_factors(sel);


%-----------------------------------------------------------------------
function d = i_ShowIndex(d,index)
%-----------------------------------------------------------------------
% Highlight the thing given in index (prob. an error column).
d.Handles.Table.selectColumns(index);

%-----------------------------------------------------------------------
function d = i_ExprClick(d,list)
%-----------------------------------------------------------------------
% Click on exprlist
hList = d.Handles.ExprList;
index = pr_getExprListSelection(hList);
if ~isempty(index)
    % Select appropriate column of table.
    index = index(index<=length(d.Exprs.factor_index));
    % Convert to true dataset index ordering
    oppt_index  = d.Exprs.factor_index(index);
    oppt_index = oppt_index(oppt_index>0);
    if isempty(oppt_index)
        d.Handles.Table.clearSelection;
    else
        d.Handles.Table.selectColumns(oppt_index);
    end
else
    d.Handles.Table.clearSelection;
end


%------------------------------------------------------------------
function data = i_Copy(d)
%------------------------------------------------------------------
% Copying can be delegated entirely to the table object
d.Handles.Table.Component.doCopy;
data = [];

%------------------------------------------------------------------
function i_Paste(d,pastedata)
%------------------------------------------------------------------
% Pasting can be delegated entirely to the table object
d.Handles.Table.Component.doPaste;
