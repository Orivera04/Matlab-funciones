function varargout = cgcalmanager(Action,varargin)
%CGCALMANAGER GUI to manage importing cal files
%
%  cgcalmanager(action,varargin)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.18.4.6 $  $Date: 2004/04/20 23:19:12 $

if nargin==0
    Action = 'create';
end
switch lower(Action)
    case 'gethandle'
        varargout{1} = i_GetHandle;
    case 'precreate'
        varargout{1} = i_CreateFigure(true); % modal dialog
    case 'create'
        i_StartUp(varargin{:});
    case 'choosefile'
        i_StartChooseFile(varargin{1});
       % ---------------- Test functions -------------
    case 'numnodes'
        fh = i_GetHandle;
        ud = get(fh,'userdata');
        num(1) = double(ud.Hand.BlockList.Nodes.Count);
        num(2) = double(ud.Hand.ParamContents.ListItems.Count);
        varargout{1} = num;
    case 'testshow'
        fh = i_CreateFigure(false); % not modal, for test purposes
        set(fh,'visible','on');
        varargout{1}=fh;
    case 'testrun'
        fh = i_CreateFigure(false); % not modal, for test purposes
        c = cgbrowser;
        proj = c.RootNode;
        if nargin>1
            % Select a given item
            i_StartUp(proj,'selectitem',varargin{1});
        else
            i_StartUp(proj);
        end
        set(fh,'visible','on');
end

% ----------------------------------------------
function h = i_GetHandle
% ----------------------------------------------
h = findall(0,'tag','CalManager');

% ----------------------------------------------
function fh = i_CreateFigure(modal)
% ----------------------------------------------

% just incase we have a Calibration Manager hanging around somewhere
fh=i_GetHandle;
delete(fh);
c = cgbrowser;

screensize=get(0,'screensize');
fhWidth = 700; fhHeight = 600;
if modal
    xFig= xregdialog('visible','off',...
        'renderer','painters',...
        'Tag','CalManager',...
        'name','Calibration Manager',...
        'pointer','watch');
else
    xFig= xregfigure('visible','off',...
        'renderer','painters',...
        'Tag','CalManager',...
        'name','Calibration Manager',...
        'pointer','watch');
    
end
if c.GUIExists
    % Center on the browser window
    xregcenterfigure(xFig, [fhWidth fhHeight], c.Figure);
else
    set(xFig, 'position', [100 100 fhWidth fhHeight]);
end
% Hook into figure position persistence
xregpersistfigpos(xFig,'key','CalManager');
fh = double(xFig);

% Fields used to hold cal file contents and information
ud.cal = [];
ud.calfile = '';

% Field to track the source of current view: cal file or project item (or
% neither).
ud.displaysource = '';
ud.displayitem = null(xregpointer,0);

% Fields for undo information
ud.Undo.ptr = [];
ud.Undo.obj = [];

% GUI close callback function
ud.closecallback = '';

% create the various panels
[toolbar,ud]=i_CreateToolbar(fh,ud);
[bottom,ud] = i_CreateBottomPanel(fh,ud);
[link,ud] = i_CreateLinkPanel(fh,ud);
[blocklist,ud] = i_CreateBlockListPanel(fh,ud);
[calfile,ud] = i_CreateCalfilePanel(fh,ud);
[display,ud] = i_CreateDisplayPanel(fh,ud);

g = xreggridbaglayout(fh, 'dimension', [1 3], ...
    'colsizes', [-1 70 -1], ...
    'elements', {blocklist, link, calfile});
sp = xregsplitlayout(fh, ...
    'dividerstyle', 'flat', ...
    'dividerwidth', 4, ...
    'orientation', 'ud', ...
    'minwidth', [135 25], ...
    'top', g, ...
    'bottom', display);

% create the main layout
g2 = xreggridbaglayout(fh,'dimension',[3 1], ...
    'rowsizes',[31 -1 25],...
    'gapy',2, ...
    'elements',{toolbar, sp, bottom});
xFig.LayoutManager = g2;

% Finish up
set(g2,'packstatus','on','visible','on');
set(fh,'userdata',ud,'pointer','arrow');


%---------------------------
function [toolbarlayout,ud]=i_CreateToolbar(fh,ud)

tb = xregGui.uitoolbar('parent',fh,...
    'ResourceLocation',cgrespath);
tb.setRedraw(false);
ud.Hand.ClearMenu = xregGui.uipushtool(tb,'ImageFile','new.bmp',...
    'transparentcolor',[0 255 0], ...
    'ClickedCallback',@i_Clear, ...
    'enable','off', ...
    'tooltip','Clear Calibration File');
but2 = xregGui.uipushtool(tb,'ImageFile','open.bmp',...
    'transparentcolor',[0 255 0], ...
    'ClickedCallback' , @i_LoadFile, ...
    'tooltip','Open Calibration File');
ud.Hand.PasteMenu = xregGui.uipushtool(tb,'ImageFile','paste.bmp',...
    'transparentcolor',[0 255 0], ...
    'tooltip','Paste into Table', ...
    'ClickedCallback',{@i_ApplyData, 'pastedata'}, ...
    'enable','off');
ud.Hand.InitMenu = xregGui.uipushtool(tb,'ImageFile','cgdsfilltable.bmp',...
    'transparentcolor',[0 255 0], ...
    'tooltip','Set Up from Ascii File', ...
    'ClickedCallback',{@i_ApplyData, 'asciifile'}, ...
    'enable','off');
ud.Hand.UndoMenu = xregGui.uipushtool(tb,'ImageFile','undo.bmp',...
    'transparentcolor',[0 255 0], ...
    'tooltip','Undo', ...
    'ClickedCallback',@i_Undo, ...
    'enable','off');
ud.Hand.RedoMenu = xregGui.uipushtool(tb,'ImageFile','redo.bmp',...
    'transparentcolor',[0 255 0], ...
    'tooltip','Redo', ...
    'ClickedCallback',@i_Redo, ...
    'enable','off');
cghelptoolbutton(tb,'CGCALMANAGER','tooltip','Calibration Manager Help');

tb.setRedraw(true); 
toolbarlayout = xregpanellayout(fh, 'packstatus', 'off', 'innerborder',[0 0 0 0], 'center', tb);


%--------------------------------
function [panel,ud] = i_CreateBlockListPanel(fh,ud)

% tree control
tree = actxcontainer(xregGui.treeview([0 0 10 10],fh, ...
    {'MouseMove', 'MotionManager'}));
ud.Hand.TreeListener = handle.listener(tree,'Click',@i_TreeCallback);
tree.Indentation = 20;
tree.LineStyle = 1;
tree.HideSelection = 0;
tree.LabelEdit = 1; % not editable
tree.Appearance = 0; % flat look
tree.BorderStyle = 0; % no border
tree.Parent = fh;

ud.Hand.ILman = xregGui.ILmanager;
ud.Hand.ILman.IL.MaskColor = uint32(255*256*256 + 255);
ud.Hand.ILman.ResourceLocation = cgrespath;
bmp2ind(ud.Hand.ILman,'cgblanknode.bmp');

tree.InsertImagelist(ud.Hand.ILman.IL);

ud.Hand.BlockList = tree;


% Table initialisation controls below the tree
ud.Hand.EditXSize = xregGui.clickedit('parent', fh, ...
    'horizontalalign','right',...
    'min', 0, ...
    'rule', 'int', ...
    'dragging', 'off', ...
    'callback',@i_EditSize, ...
    'enable','off');
ud.Hand.ManTextX = xregGui.labelcontrol('parent',fh, ...
    'string','Rows: ',...
    'LabelAlignment','left', ...
    'LabelSizeMode', 'Absolute', ...
    'LabelSize', 50, ...
    'gap',5,...
    'ControlSize',50, ...
    'control', ud.Hand.EditXSize);

ud.Hand.EditYSize = xregGui.clickedit('parent', fh, ...
    'horizontalalign','right',...
    'min', 0, ...
    'rule', 'int', ...
    'dragging', 'off', ...
    'callback',@i_EditSize, ...
    'enable','off');
ud.Hand.ManTextY = xregGui.labelcontrol('parent',fh, ...
    'string','Columns: ',...
    'LabelAlignment','left', ...
    'LabelSizeMode', 'Absolute', ...
    'LabelSize', 50, ...
    'gap',5,...
    'ControlSize',50, ...
    'control', ud.Hand.EditYSize);

ud.Hand.EditValue = xregGui.clickedit('parent', fh, ...
    'enable','off');
ud.Hand.ValueLabel = xregGui.labelcontrol('parent',fh, ...
    'string', 'Value:',...
    'LabelAlignment','left', ...
    'LabelSizeMode', 'Absolute', ...
    'LabelSize', 35, ...
    'gap',5,...
    'ControlSize',70, ...
    'control', ud.Hand.EditValue);

ud.Hand.SetSizeButton = xregGui.uicontrol(fh, ...
    'style','pushbutton',...
    'string','Apply',...
    'callback',@i_ApplySize,'enable','off'); 
ud.Hand.PrecisionLabel = xregGui.uicontrol(fh,...
    'style','text',...
    'horizontalalignment','left',...
    'string','Precision: ');
ud.Hand.SetPropsButton = xregGui.uicontrol(fh, ...
    'style','pushbutton',...
    'string','Edit Precision...',...
    'callback',@i_PrecEdit,'enable','off'); 

grd1 = xreggridbaglayout(fh, ...
    'dimension', [5 4], ...
    'rowsizes', [20 5 2 20 3], ...
    'colsizes', [105 90 -1 65], ...
    'gapx', 10, ...
    'border', [5 5 5 5], ...  
    'mergeblock', {[3 5], [4 4]}, ...
    'mergeblock', {[1 1], [2 4]}, ...
    'elements', {ud.Hand.ManTextX, [], [], ud.Hand.ManTextY, [], ...
        ud.Hand.ValueLabel, [], [], [], [], ...
        [], [], [], [], [], ...
        [], [], ud.Hand.SetSizeButton});
grd2 = xreggridbaglayout(fh, ...
    'dimension', [2 2], ...
    'gapy', 5, ...
    'gapx', 5, ...
    'border', [5 5 5 3], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 85], ...
    'mergeblock',{[1 2], [1 1]}, ...
    'elements', {ud.Hand.PrecisionLabel, [], [], ud.Hand.SetPropsButton});
pnl1 = xregpanellayout(fh, ...
    'innerborder', [0 0 0 0], ...
    'state','out', ...
    'center',grd1);
pnl2 = xregpanellayout(fh, ...
    'innerborder', [0 0 0 0], ...
    'state','out', ...
    'center',grd2);
grid = xreggridbaglayout(fh, ...
    'dimension',[3,1], ...
    'rowsizes',[-1 62 48], ...
    'elements', {ud.Hand.BlockList, pnl1, pnl2});
panel = xregpaneltitlelayout(fh,'title','Project Calibration Items', ...
    'selectable', 'on', ...
    'center',grid);
ud.Hand.ProjectPanel = panel;  


%------------------------------
function [g1,ud] = i_CreateLinkPanel(fh,ud)

ud.Hand.LinkButton = xregGui.uicontrol(fh, ...
    'style','pushbutton',...
    'callback',@i_Link,...
    'enable', 'off', ...
    'string','<-----------',...
    'tooltip','Set Up from Selected Calibration File Item');
ud.Hand.AutoLinkButton = xregGui.uicontrol(fh, ...
    'style','pushbutton',...
    'callback',@i_AutoLink,...
    'enable', 'off', ...
    'string',' <-- Auto --',...
    'tooltip','Set Up All Matching Calibration File Items');
g1 = xreggridlayout(fh, ...
    'dimension',[4 1], ...
    'correctalg','on',...
    'rowsizes',[-1 25 25 -1], ...
    'rowratios', [1 0 0 2], ...
    'gap',10, ...
    'border', [2 0 2 0], ...
    'elements',{[],ud.Hand.LinkButton,ud.Hand.AutoLinkButton});

%-------------------------------
function [bottom,ud] = i_CreateBottomPanel(fh,ud)

ud.Hand.Close = xregGui.uicontrol(fh,'style','push',...
    'callback','close(gcbf)',...
    'string','Close');
ud.Hand.Message = xregGui.uicontrol(fh,'style','text',...
    'horizontalalignment','left',...
    'enable', 'inactive', ...
    'string','');
pnl = xregGui.panel('parent', fh, ...
    'type', 'in');

bottom= xreggridbaglayout(fh, ...
    'dimension',[3 5],...
    'colsizes',[3 -1 3 7 65], ...
    'rowsizes', [5 19 1], ...
    'mergeblock', {[1 3], [1 3]}, ...
    'mergeblock', {[1 3], [5 5]}, ...
    'elements',{pnl, [], [], ...
        [], ud.Hand.Message, [], ...
        [], [], [], ...
        [], [], [], ...
        ud.Hand.Close});

%---------------------------------
function [display,ud] = i_CreateDisplayPanel(fh,ud)

ud.Hand.TableWrapper = mbctable.simple('parent', fh, 'visible', 'off');
ud.Hand.TableWrapper.table.setBorder([]);

display = xregpaneltitlelayout(fh,...
    'center',ud.Hand.TableWrapper, ...
    'title','Display');
ud.Hand.TableTitle = display;

%---------------------------------
function [grid,ud] = i_CreateCalfilePanel(fh,ud)

%draw listview control
h = xregGui.listview([0 0 100 100],fh, ...
    {'MouseMove', 'MotionManager'; ...
        'ColumnClick', 'xreglvsorter'});
ud.Hand.ParamContents = actxcontainer(h);
ud.Hand.ListListener = handle.listener(h,'Click',@i_ListCallback);
h.InsertSmallIcons(ud.Hand.ILman.IL);

h.View = 3;
h.MultiSelect = 0;
h.LabelEdit = 1;
h.HideSelection = 0;
h.Enabled = 0;
h.Sorted = 0;
h.BorderStyle = 0;
h.Appearance=0;
h.Parent = fh;

cols = {'Name','Size'};
width = [180,60];
hCols= h.ColumnHeaders;
for i = 1:length(cols)
    hItem = hCols.Add;
    set(hItem,'text',cols{i});
    set(hItem,'width',width(i));
end

% Info pane for displaying file information
ud.Hand.CalFileInfo = xregGui.infoPane('parent', fh, ...
    'ListText', {'Calibration file', '';...
        'Total number of items', ''; ...
        'Number of 2D tables', ''; ...
        'Number of 1D tables', ''; ...
        'Number of scalar items', ''});

toppanel = xregpaneltitlelayout(fh, ...
    'selectable', 'on', ...
    'center', ud.Hand.ParamContents, ...
    'title','Calibration File Contents');
bottompanel = xregpaneltitlelayout(fh, ...
    'center', ud.Hand.CalFileInfo, ...
    'title','Calibration File Information');
grid = xreggridbaglayout(fh, ...
    'dimension',[2 1], ...
    'gapy', 2, ...
    'rowsizes',[-1 110],...
    'elements', {toppanel, bottompanel});
ud.Hand.FilePanel = toppanel;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                FINISH               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Finish(src,evt)
% Pass notification on
fh = i_GetHandle;
set(fh, 'visible', 'off');
drawnow('expose');
ud = get(fh, 'userdata');
xregcallback(ud.closecallback, fh, []);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_FillValuePane                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_FillValuePane
% Update the information in the table
fh = i_GetHandle;
ud = get(fh,'userdata');
tw = ud.Hand.TableWrapper;
T = tw.table;
if isempty(ud.displaysource)
    % No valid object selected
    T.clearTable;
    set(ud.Hand.TableTitle,'title','No item selected');
    i_Message('Please select an item');
    set(ud.Hand.ProjectPanel, 'selected', 'off');
    set(ud.Hand.FilePanel, 'selected', 'off');
else
    if strcmp(ud.displaysource, 'project')
        % Calibratable object
        obj = ud.displayitem;
        mtableview(obj.info,tw);
        set(ud.Hand.TableTitle,'title',['Project item: ',obj.getname]);
        set(ud.Hand.ProjectPanel, 'selected', 'on');
        set(ud.Hand.FilePanel, 'selected', 'off');
    else
        obj = ud.displayitem;
        if length(obj) > 1
            obj = obj(1);
        end
        N = obj.name;
        set(ud.Hand.TableTitle,'title',['Calibration File: ',N]);
        switch obj.numaxes
            case 3
                S = size(obj.data.Z);
                if isfield(obj.data,'X')
                    X = obj.data.X;
                    Y = obj.data.Y;
                else
                    X = 0:S(2)-1;
                    Y = 0:S(1)-1;
                end
                T.initTable(obj.data.Z, Y, X);
                T.labelAxes('','');
            case 2
                T.initTable([obj.data.X(:) obj.data.Y(:)], {'Input','Output'},{'',''});
            case 1
                T.initTable(obj.data.X, {obj.name}, '#.######');
            otherwise
                T.clearTable;
        end
        set(ud.Hand.ProjectPanel, 'selected', 'off');
        set(ud.Hand.FilePanel, 'selected', 'on');
    end
    i_Message('');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Cal file contents window       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_FillCalFilePane
fh = i_GetHandle;
ud = get(fh,'userdata');
LI = ud.Hand.ParamContents.ListItems;
LI.Clear;

if isempty(ud.cal)
    % clear listbox and all text fields
    set(ud.Hand.ParamContents,'enabled',false); 
    list_str = ud.Hand.CalFileInfo.ListText;
    list_str(:,2) = {''};
    ud.Hand.CalFileInfo.ListText = list_str;
    set(ud.Hand.ClearMenu, 'enable', 'off');
    set([ud.Hand.AutoLinkButton; ud.Hand.LinkButton], 'enable', 'off');
else
    set(fh,'pointer','watch'); 
    h = ud.Hand;
    set(h.ParamContents,'enabled',true);
    ic = [ ...
            bmp2ind(ud.Hand.ILman,'cgcontconst.bmp') ...
            bmp2ind(ud.Hand.ILman,'cgfullfunction.bmp'), ...
            bmp2ind(ud.Hand.ILman,'cgfulltable.bmp'), ...
        ];
    
    % Add items to list and count each type at the same time
    nScalar = 0;
    n1D = 0;
    n2D = 0;
    for n = 1:length(ud.cal)
        hItem = LI.Add;
        hItem.Key = sprintf('T%d', n);
        hItem.Text = ud.cal(n).name;
        hItem.SmallIcon = ic(ud.cal(n).numaxes);
        switch ud.cal(n).numaxes
            case 3
                n2D = n2D + 1;
                sizestr = sprintf('%d x %d', ud.cal(n).numrows, ud.cal(n).numcols);
            case 2
                n1D = n1D + 1;
                sizestr = sprintf('%d', ud.cal(n).numrows);
            otherwise
                nScalar = nScalar + 1;
                sizestr = '';
        end
        set(hItem, 'SubItems', 1, sizestr);
    end
    
    % Generate information strings
    list_str = ud.Hand.CalFileInfo.ListText;
    [path, file, ext]= fileparts(ud.calfile);
    list_str{1,2} = [file ext];
    list_str{2,2} = sprintf('%d', nScalar + n1D + n2D);
    list_str{3,2} = sprintf('%d', n2D);
    list_str{4,2} = sprintf('%d', n1D);
    list_str{5,2} = sprintf('%d', nScalar);
    ud.Hand.CalFileInfo.ListText = list_str;
    
    % Enable the clear menu button
    set(ud.Hand.ClearMenu, 'enable', 'on');
    set([ud.Hand.AutoLinkButton; ud.Hand.LinkButton], 'enable', 'on');
    set(fh,'pointer','arrow');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up Cal item tree                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_RefreshTree(pPROJ)
fh = i_GetHandle;
ud = get(fh,'userdata');
h = ud.Hand;
PROJ = pPROJ.info;
% Compile block list and disable manual set (there will be no selected item)
treeview(PROJ,'clear', null(xregpointer, 1), h.BlockList);
treeview(PROJ,'add', null(xregpointer, 1), h.BlockList , ud.Hand.ILman, cgtypes.cgtabletype, 1, pPROJ);

% Explicitly add any cgconstants to the tree.  We only expect to find these in
% featurenodes.
F = filterbytype(PROJ, cgtypes.cgfeaturetype);

for n = 1:length(F)
    F{n} = getconstants(F{n})';
end
C = unique([F{:}]);

nodes = h.BlockList.Nodes;
icon = bmp2ind(ud.Hand.ILman, 'cgcontconst.bmp');
for n = 1:length(C)
    % add a tree node for this cgconstant
    NewNode= nodes.Add([],4,sprintf('K%d;S0', double(C(n))),C(n).getname,icon);
    NewNode.Tag = double(C(n));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up Cal item size pane           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_FillCalItemPane
fh = i_GetHandle;
ud = get(fh,'userdata');

if ~strcmp(ud.displaysource, 'project')
    % Disable all table property editing devices
    editEn = {'off';'off';'off'};
    applyEn = 'off';
    % Disable precision panel
    precEn = 'off'; precStr = '';
    % Set editors to zeros
    xyMin = {0; 0};
    xyzVals = {0; 0; 0};
else
    obj = ud.displayitem;
    item = obj.info;
    precEn = 'on'; precStr = char(get(item, 'precision'));
    if isa(item, 'cgconstant')
        editEn = {'off';'off';'on'};
        applyEn = 'on';
        xyMin = {1; 1};
        xyzVals = {1; 1; getvalue(item)};
    else
        editEn = {'off';'off';'off'};
        applyEn = 'off';
        xyMin = {0; 0};
        xyzVals = {0; 0; 0};
        
        % Work out whether sizes can be altered
        if ~issizelocked(item)
            if isa(item, 'cglookuptwo')
                editEn{1} = 'on';
                editEn{2} = 'on';
            elseif isa(item, 'cgnormfunction')
                editEn{1} = 'on';
            elseif isa(item, 'cgnormaliser')
                % Need to check whether the parent is a lookupone (no
                % changes allowed in this case
                parents = get(item, 'flist');
                if ~(length(parents)==1 && parents(1).isa('cglookupone'))
                    editEn{1} = 'on';
                end
            end
        end
        
        % Get actual sizes and min values
        % Also get default init value and whether value editor is enabled
        V = get(item, 'values');
        sz = size(V);
        if isa(item, 'cglookuptwo')
            if ~isempty(V)
                xyzVals = {sz(1); sz(2); round(mean(V(:)))};
                xyMin = {2; 2};
                applyEn = 'on';
            end
            editEn{3} = 'on';
            
        elseif isa(item, 'cgnormfunction')
            if ~isempty(V)
                xyzVals = {sz(1); 2; round(mean(V(:)))};
                xyMin = {2; 0};
                applyEn = 'on';
            else
                xyzVals{2} = 2;
            end
            editEn{3} = 'on';
            
        elseif isa(item, 'cgnormaliser')
            if ~isempty(V)
                xyzVals{1} = sz(1);
                xyzVals{2} = 2;
                xyMin = {2; 0};
                applyEn = 'on';
            else
                xyzVals{2} = 2;
            end
        end
    end
end

% Disable Apply button if no editing is allowed or if a zero size is
% currently set
set(ud.Hand.SetSizeButton, 'enable', applyEn);

% Set size/value editors to appropriate state
set([ud.Hand.EditXSize; ud.Hand.EditYSize], {'min'}, xyMin);
set([ud.Hand.EditXSize; ud.Hand.EditYSize; ud.Hand.EditValue], {'value'}, xyzVals);
set([ud.Hand.ManTextX; ud.Hand.ManTextY; ud.Hand.ValueLabel] , {'enable'}, editEn);

% Set precision panel to appropriate state
set([ud.Hand.PrecisionLabel; ud.Hand.SetPropsButton], 'enable', precEn);
set(ud.Hand.PrecisionLabel, 'string', ['Precision: ' precStr]);

% Set clipboard/ascii enable state off if no editors are enabled
if all(strcmp(editEn, 'off'))
    set([ud.Hand.PasteMenu, ud.Hand.InitMenu], 'enable', 'off');
else
    set([ud.Hand.PasteMenu, ud.Hand.InitMenu], 'enable', 'on');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load calibration info from a file   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OK = i_ChooseFile
OK = true;
fh = i_GetHandle;
set(fh,'pointer','watch');
ud = get(fh,'userdata');
h = ud.Hand;

% Let the user choose what to import
inputObj = cgcalinput;
[inputObj, calinfo] = gui_import( inputObj );
% calinfo is empty if the user aborted etc
if isempty(calinfo)
    OK = false;
    set(fh,'pointer','arrow');
    return
end
calfile = get(inputObj, 'filename');
if isempty(ud.cal)
    ud.cal = calinfo;
    ud.calfile = calfile;
else
    % Check for name matches and if there are any then keep new info
    L = length(calinfo);
    hw = xregGui.waitdlg('Parent', fh, 'Message', 'Appending new file...');
    hw.Waitbar.Max = L;
    
    names = lower({ud.cal.name}); 
    for n = 1:L
        ind = strmatch(lower(calinfo(n).name), names, 'exact');
        if isempty(ind)
            % append
            names = [names, {calinfo(n).name}];
            ud.cal = [ud.cal, calinfo(n)];
        else
            % replace
            ud.cal(ind) = calinfo(n);
        end
        hw.Waitbar.Value = n;
    end
    ud.calfile = [ud.calfile, '; ' calfile];
    delete(hw); 
end
set(fh,'userdata',ud);
set(fh,'pointer','arrow');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmatically select a tree node %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NODE_FOUND = i_SelectTreeNode(pItem)
% Attempt to find the tree node corresponding to the pointer pItem
fh = i_GetHandle;
ud = get(fh,'userdata');
nds = ud.Hand.BlockList.Nodes;
NODE_FOUND = false;
if nargin
    % Look for a node corresponding to the given item
    for n = 1:nds.Count
        pFromNode = assign(xregpointer, sscanf(nds.Item(n).Key, 'K%d;S0'));
        if pFromNode==pItem
            NODE_FOUND = true;
            nds.Item(n).Selected = true;
            break
        elseif pFromNode.isa('cgcontainer')
            if pFromNode.getdata==pItem
                NODE_FOUND = true;
                nds.Item(n).Selected = true;
                break
            end
        end
    end
else
    % Select the first node on tree
    if nds.Count
        pItem = assign(xregpointer, sscanf(nds.Item(1).Key, 'K%d;S0'));
        if pItem.isa('cgcontainer');
            pItem = pItem.getdata;
        end
        nds.Item(1).Selected = true;
        NODE_FOUND = true;
    end
    
end
if NODE_FOUND
    ud.displaysource = 'project';
    ud.displayitem = pItem;
    set([ud.Hand.PasteMenu, ud.Hand.InitMenu], 'enable', 'on');
else
    ud.displaysource = '';
    ud.displayitem = null(xregpointer, 0);
    set([ud.Hand.PasteMenu, ud.Hand.InitMenu], 'enable', 'off');
end

set(fh, 'userdata', ud);
i_FillCalItemPane;
i_FillValuePane;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Message                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_setCloseCallback(cb)
fh = i_GetHandle;
ud = get(fh,'userdata');
ud.closecallback = cb;
set(fh, 'userdata', ud);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Message                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Message(str)
fh = i_GetHandle;
ud = get(fh,'userdata');
if isempty(str)
    % Construct a default string giving the user some info on the selected
    % object
    if strcmp(ud.displaysource, 'project')
        if ud.displayitem.isa('cglookuptwo')
            NR = size(ud.displayitem.get('values'), 1);
            NC = size(ud.displayitem.get('values'), 2);
            str = sprintf('(%d x %d) 2D table', NR, NC);
            if ud.displayitem.issizelocked
                str = [str '.  The size of this item has been locked.'];
            end
        elseif ud.displayitem.isa('cgconstant')
            str = 'Scalar item';
        else
            NR = size(ud.displayitem.get('values'), 1);
            str = sprintf('%d element 1D table', NR);
            if ud.displayitem.issizelocked
                str = [str '.  The size has been locked.'];
            end
        end
        
    elseif strcmp(ud.displaysource, 'calfile')
        switch ud.displayitem.numaxes
            case 3
                str = sprintf('(%d x %d) 2D table', ud.displayitem.numrows, ud.displayitem.numcols);
            case 2
                str = sprintf('%d element 1D table', ud.displayitem.numrows);
            otherwise
                str = 'Scalar item';
        end
    end
    
end
set(ud.Hand.Message,'string',str);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up undo store                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_SetForUndo(ptr)
fh = i_GetHandle;
ud = get(fh,'userdata');
if isempty(ptr)
    % Clear the undo buffer
    ud.Undo.obj = [];
    ud.Undo.ptr = [];
    set([ud.Hand.UndoMenu ud.Hand.RedoMenu],'enable','off');
else
    % Setup the undo buffer
    ud.Undo.ptr = ptr;
    if length(ptr)==1
        ud.Undo.obj = {info(ptr)};
    else
        ud.Undo.obj = info(ptr);
    end
    set([ud.Hand.UndoMenu ud.Hand.RedoMenu],{'enable'},{'on'; 'off'});
    
end
set(fh,'userdata',ud);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Undo                                          %
% The Undo store is also used as the redo store %
% There is only one level of undo but more than %
% one object may need undo'ing hence the loop   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_PerformUndo
fh = i_GetHandle;
ud = get(fh,'userdata');
if ~isempty(ud.Undo.ptr) && (length(ud.Undo.ptr) == length(ud.Undo.obj))
    for n = 1:length(ud.Undo.ptr)
        obj = ud.Undo.obj{n};
        ud.Undo.obj{n} = ud.Undo.ptr(n).info; % store redo/undo object
        ud.Undo.ptr(n).info = obj; % Perform the undo/redo
    end
    set(fh,'userdata',ud);
    i_RefreshIcons;
    i_FillValuePane; 
else
    i_SetForUndo([]);
    set([ud.Hand.RedoMenu ud.Hand.UndoMenu],'enable','off');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Only refresh the icons, not the structure %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_RefreshIcons
fh = i_GetHandle;
ud = get(fh,'userdata');
h = ud.Hand;
IL = ud.Hand.ILman;
nodes = h.BlockList.nodes;
for n = 1:double(nodes.count)
    thisNode = nodes.Item(n);
    key = thisNode.key;
    pindex= assign(xregpointer,sscanf(key,'K%d;S0'));
    ic = bmp2ind(IL,pindex.iconfile);
    thisNode.image = ic;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transfer data from a load structure %
% to a calibration item               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [status, msg] = i_TransferToTable(pItem, Vstruct)
% Vstruct is a structure containing the fields:
%    name
%    description
%    info
%    data
%    numaxes
%    numrows
%    numcols
%
% The data field may contain a combination of X/Y/Z fields.  This structure
% is the same as that used by cgcalinput. (X is the column normaliser
% breakpoints, Y the row ones)
%
% status is a numeric code indicating the outcome of the operation:
%    0 means the operation was successful
%    1 means the data didn't match the type of object in pItem
%    2 means the size of the data caused a problem
%    3 means that the expression object rejected the data for
%          some reason (e.g. because of non-increasing breakpoints)
%
% If the inputs are vectors then the status and msg outputs will be a
% vector and cell array respectively.

Nitems = length(Vstruct);

status = zeros(1, Nitems);
msg = repmat({''}, 1, Nitems);

pItem = pItem(:)';
LUobj = info(pItem);
if ~iscell(LUobj)
    LUobj = {LUobj};
end

% vectors to hold undo information for any other objects that are altered
% (normalisers, for example)
pAdditional = null(xregpointer, 0);
objAdditional = {};
for n = 1:Nitems
    % Check that the data in Vstruct matches the type of object in pItem
    itemAxes = 2;
    if isa(LUobj{n}, 'cglookuptwo')
        itemAxes = 3;
    elseif isa(LUobj{n}, 'cgconstant')
        itemAxes = 1;
    end
    if itemAxes~=Vstruct(n).numaxes
        status(n) = 1;
        msg{n} = 'Incorrect data type for object.';
        continue
    end
    
    % Size checking is rolled together with actually changing the data as
    % they are both dependent on the type of object being used
    if isa(LUobj{n}, 'cgconstant')
        if Vstruct(n).numrows==1 && Vstruct(n).numcols==1
            LUobj{n} = setvalue(LUobj{n}, Vstruct(n).data.X);
        else
            status(n) = 2;
            msg{n} = 'Calibration constants can only be filled with a scalar value.';
        end
    else
        if isa(LUobj{n}, 'cglookuptwo')
            objSize = size(get(LUobj{n}, 'values'));
            if all(size(Vstruct(n).data.Z)>=2)
                ok = i_sizecheck(objSize, size(Vstruct(n).data.Z), issizelocked(LUobj{n}), getname(LUobj{n}));
                if ok
                    try
                        LUobj{n} = set(LUobj{n},'matrix',{Vstruct(n).data.Z Vstruct(n).info});
                        % Check whether normalisers should be set up
                        if length(Vstruct(n).data.X)>=2 
                            pX = get(LUobj{n}, 'x');
                            X = pX.info;
                            ok = i_sizecheck(length(get(X,'values')), length(Vstruct(n).data.X), issizelocked(X), getname(X));
                            if ok
                                nBP = length(Vstruct(n).data.X);
                                NewMat = [Vstruct(n).data.X(:) (0:nBP-1)'];
                                X = set(X, 'matrix',{NewMat Vstruct(n).info},...
                                    'description','');
                                pAdditional = [pAdditional, pX];
                                objAdditional = [objAdditional, {X}];
                            end
                        end
                        if length(Vstruct(n).data.Y)>=2
                            pY = get(LUobj{n}, 'y');
                            Y = pY.info;
                            ok = i_sizecheck(length(get(Y,'values')), length(Vstruct(n).data.Y), issizelocked(Y), getname(Y));
                            if ok
                                nBP = length(Vstruct(n).data.Y);
                                NewMat = [Vstruct(n).data.Y(:) (0:nBP-1)'];
                                Y = set(Y, 'matrix',{NewMat Vstruct(n).info},...
                                    'description','');
                                pAdditional = [pAdditional, pY];
                                objAdditional = [objAdditional, {Y}];
                            end
                        end
                    catch
                        [x y] = lasterr;
                        status(n) = 3;
                        msg{n} = ['Error copying values: ' x];
                    end
                end
            else
                status(n) = 2;
                msg{n} = 'Table must be at least (2x2) elements.';
            end
            
        elseif isa(LUobj{n}, 'cglookupone')
            objSize = size(get(LUobj{n}, 'values'));
            if length(Vstruct(n).data.X) == length(Vstruct(n).data.Y) ...
                    && length(Vstruct(n).data.X)>=2
                ok = i_sizecheck(objSize(1), length(Vstruct(n).data.X), issizelocked(LUobj{n}), getname(LUobj{n}));
                if ok
                    try
                        LUobj{n} = set(LUobj{n}, 'matrix', {[Vstruct(n).data.X(:) Vstruct(n).data.Y(:)] Vstruct(n).info}); 
                    catch
                        [x y] = lasterr;
                        status(n) = 3;
                        msg{n} = ['Error copying values: ' x];
                    end

                else
                    status(n) = 2;
                    msg{n} = 'Unable to change size of table.';
                end
            else
                status(n) = 2;
                msg{n} = 'X and Y columns must be the same length and have at least 2 elements.';
            end
            
        elseif isa(LUobj{n}, 'cgnormfunction')
            objSize = size(get(LUobj{n}, 'values'));
            if length(Vstruct(n).data.Y)>=2
                ok = i_sizecheck(objSize(1), length(Vstruct(n).data.Y), issizelocked(LUobj{n}), getname(LUobj{n}));
                if ok
                    try
                        LUobj{n} = set(LUobj{n},'matrix',{Vstruct(n).data.Y(:) Vstruct(n).info});
                        % Check whether normalisers should be set up
                        if length(Vstruct(n).data.X)>=2
                            pX = get(LUobj{n}, 'x');
                            X = pX.info;
                            ok = i_sizecheck(length(get(X,'values')), length(Vstruct(n).data.X), issizelocked(X), getname(X));
                            if ok
                                nBP = length(Vstruct(n).data.Y);
                                NewMat = [Vstruct(n).data.X(:) (0:nBP-1)'];
                                X = set(X, 'matrix',{NewMat Vstruct(n).info},...
                                    'description','');
                                pAdditional = [pAdditional, pX];
                                objAdditional = [objAdditional, {X}];
                            end
                        end
                    catch
                        [x y] = lasterr;
                        status(n) = 3;
                        msg{n} = ['Error copying values: ' x];
                    end
                end
            else
                status(n) = 2;
                msg{n} = 'Table must be at least 2 elements long.';
            end
            
        elseif isa(LUobj{n}, 'cgnormaliser')
            objSize = size(get(LUobj{n}, 'values'));
            if isempty(Vstruct(n).data.Y)
                Vstruct(n).data.Y = (0:Vstruct(n).numrows-1)';
            end
            if length(Vstruct(n).data.X) == length(Vstruct(n).data.Y) ...
                    && length(Vstruct(n).data.X)>=2
                ok = i_sizecheck(objSize(1), length(Vstruct(n).data.X), issizelocked(LUobj{n}), getname(LUobj{n}));
                if ok
                    try
                        LUobj{n} = set(LUobj{n}, 'matrix', {[Vstruct(n).data.X(:) Vstruct(n).data.Y(:)] Vstruct(n).info});
                    catch
                        [x y] = lasterr;
                        status(n) = 3;
                        msg{n} = ['Error copying values: ' x];
                    end
                else
                    status(n) = 2;
                    msg{n} = 'Unable to change size of normalizer.';
                end
                
            else
                status(n) = 2;
                msg{n} = 'X and Y columns must be the same length and have at least 2 elements.';
            end
        end
        if ~any(strcmp(Vstruct(n).name, {'asciifile', 'pastedata', 'manualreset'}))
            % Set new description if data is from a calfile
            LUobj{n} = set(LUobj{n}, 'description', Vstruct(n).description);
        end
    end
end

% Place the items that worked into the undo store, then update the pointers
% with the new copies
itemsUpdated = (status==0);
i_SetForUndo([pItem(itemsUpdated), pAdditional]);
passign([pItem(itemsUpdated), pAdditional], [LUobj(itemsUpdated), objAdditional]);



function ok = i_sizecheck(oldSize, newSize, islocked, name)
if all(oldSize==newSize) || all(oldSize==0)
    ok = true;
else
    if islocked
        h = errordlg(sprintf('The size of %s has been locked and cannot be altered.', name), ...
        'MBC Toolbox', 'modal');
        waitfor(h);
        ok = false;
    else
        ans = questdlg(sprintf('This operation will change the size of %s.  Do you want to continue?', name), ...
            'MBC toolbox', 'Continue', 'Cancel', 'Continue');
        if strcmp(ans, 'Continue')
            ok = true;
        else
            ok = false;
        end
    end
end




%--------------------------------------
% Callback from clicking item on the tree
%--------------------------------------
function i_TreeCallback(src, evt)
%--------------------------------------
% Retrieve pointer to object from the node's key
pNode = assign(xregpointer, sscanf(evt.Source.SelectedItem.Key, 'K%d;S0'));
if pNode.isa('cgcontainer')
    pNode = pNode.getdata;
end
fh = i_GetHandle;
ud = get(fh,'userdata');
if ~strcmp(ud.displaysource, 'project') ...
        || isempty(ud.displaysource) ...
        || ud.displayitem~=pNode
    
    ud.displaysource = 'project';
    ud.displayitem = pNode;
    set(fh, 'userdata', ud);
    
    i_FillCalItemPane;
    i_FillValuePane;
end

%--------------------------------------
% Callback from clicking item on the list
%--------------------------------------
function i_ListCallback(src, evt)
%--------------------------------------
% Retrieve index to information from the item's key
idx = sscanf(evt.Source.SelectedItem.Key, 'T%d');
fh = i_GetHandle;
ud = get(fh,'userdata');
if ~strcmp(ud.displaysource, 'calfile') ...
        || isempty(ud.displaysource) ...
        || ~strcmp(ud.displayitem.name, ud.cal(idx).name)
    
    ud.displaysource = 'calfile';
    ud.displayitem = ud.cal(idx);
    set(fh, 'userdata', ud);
    
    i_FillCalItemPane;
    i_FillValuePane;
    
    % Disable value import from ascii file and clipboard
    set([ud.Hand.PasteMenu, ud.Hand.InitMenu], 'enable', 'off');
end

%--------------------------------------
% Callback from changing size value
%--------------------------------------
function i_EditSize(src,evt)
%--------------------------------------
% Make sure the min of an edited size is 2
src.Min = 2;
% Enable apply if it was disabled
fh = i_GetHandle;
ud = get(fh, 'userdata');
if ud.Hand.EditXSize.Value>0 && ud.Hand.EditYSize.Value>0
    ud.Hand.SetSizeButton.enable = 'on';
end

%--------------------------------------
% Callback from Precision button
%--------------------------------------
function i_PrecEdit(src, evt)
%--------------------------------------
%Handles clicks on tree
fh = i_GetHandle;
ud = get(fh,'userdata');
if strcmp(ud.displaysource, 'project')
    obj = ud.displayitem;
    prec = obj.get('precision');
    size = [400 375];
    figpos = get(fh, 'position');
    pos = [figpos(1:2)+(figpos(3:4)-size)./2 size];  % center in parent
    pr = precedit(prec,pos);
    if ~isempty(pr)
        obj.info = obj.setprecision(pr);
        i_FillCalItemPane;
        i_FillValuePane;
    end
end

%--------------------------------------
% Callback from File loading button
%--------------------------------------
function i_LoadFile(src, evt)
%--------------------------------------
OK = i_ChooseFile;
if OK
    i_FillCalFilePane;
end

%--------------------------------------
% Clear Cal File               
%--------------------------------------
function varargout = i_Clear(src,evt)
%--------------------------------------
fh = i_GetHandle;
ud = get(fh,'userdata');
ud.cal = [];
ud.calfile = '';
if strcmp(ud.displaysource, 'calfile')
    ud.displaysource = '';
    ud.displayitem = null(xregpointer, 0);
end
set(fh,'userdata',ud);

% Update the cal file info pane
i_FillCalFilePane;
% Update rest of gui
i_FillCalItemPane;
i_FillValuePane;

%--------------------------------------
% Undo operation             
%--------------------------------------
function varargout = i_Undo(src,evt)
%--------------------------------------
fh = i_GetHandle;
ud = get(fh,'userdata');
set([ud.Hand.UndoMenu ud.Hand.RedoMenu],{'enable'},{'off'; 'on'});
i_PerformUndo

%--------------------------------------
% Redo operation             
%--------------------------------------
function varargout = i_Redo(src,evt)
%--------------------------------------
fh = i_GetHandle;
ud = get(fh,'userdata');
set([ud.Hand.UndoMenu ud.Hand.RedoMenu],{'enable'},{'on'; 'off'});
i_PerformUndo


%--------------------------------------
% Apply size/value to table             
%--------------------------------------
function varargout = i_ApplySize(src,evt)
%--------------------------------------
fh = i_GetHandle;
ud = get(fh,'userdata');
if strcmp(ud.displaysource, 'project')
    % Set up an appropriate data structure according to the type of object
    % selected and then use subfunction to perform copy
    V = struct('name', 'manualreset', ...
        'description', '', ...
        'info', 'Manually initialised from Calibration Manager', ...
        'data',[], ...
        'numaxes',[], ...
        'numrows',[], ...
        'numcols',[]);
    obj = ud.displayitem.info;
    if isa(obj, 'cglookuptwo')
        V.numrows = ud.Hand.EditXSize.Value;
        V.numcols = ud.Hand.EditYSize.Value;
        V.data.Z = ud.Hand.EditValue.Value*ones(V.numrows, V.numcols);
        V.numaxes = 3;
        % Look to see whether both normalisers are empty - if they are then
        % we'll initialise them too
        pX = get(obj, 'x');
        pY = get(obj, 'y');
        if pX.isempty && pY.isempty
            V.data.X = 0:V.numcols-1;
            V.data.Y = 0:V.numrows-1;
        else
            V.data.X = [];
            V.data.Y = [];
        end
        
    elseif isa(obj, 'cglookupone')
        V.numcols = 1;
        V.numrows = ud.Hand.EditXSize.Value;
        V.numaxes = 2;
        V.data.Y = ud.Hand.EditValue.Value*ones(V.numrows, 1);
        V.data.X = (0:V.numrows-1)';

    elseif isa(obj, 'cgnormfunction')
        V.numrows = ud.Hand.EditXSize.Value;
        V.numcols = 1;
        V.data.Y = ud.Hand.EditValue.Value*ones(V.numrows, 1);
        V.numaxes = 2;
        % Look to see whether the normaliser is empty - if it is then we'll
        % initialise it too
        pX = get(obj, 'x');
        if pX.isempty
            V.data.X = 0:V.numrows-1;
        else
            V.data.X = [];
        end
 
    elseif isa(obj, 'cgnormaliser')
        V.numcols = 1;
        V.numrows = ud.Hand.EditXSize.Value;
        V.numaxes = 2;
        V.data.X = (0:V.numrows-1)';
        V.data.Y = [];
        % Look to see if the normaliser is only used by a single table; in
        % this case we'll kindly initialise it so the output range matches
        % the size of the table
        FL = get(obj, 'Flist');
        if length(FL)==1 && FL.isa('cglookup')
            if FL.isa('cglookuptwo')
                if FL.get('x')==ud.displayitem
                    szInd = 2;
                else
                    szInd = 1;
                end
            else
                szInd = 1;
            end
            L = size(FL.get('values'), szInd);
            if L>=2
                if V.numrows<=L
                    V.data.Y = round(linspace(0, L-1, V.numrows));
                else
                    % Need to pad out ends with repeated breakpoints
                    V.data.Y = [0:(L-1), repmat(L-1, 1, V.numrows-L)];
                end
            end
        end
        
    elseif isa(obj, 'cgconstant')
        V.data.X = ud.Hand.EditValue.Value;
        V.numaxes = 1;
        V.numrows = 1;
        V.numcols = 1;
    end
    
    [status, msg] = i_TransferToTable(ud.displayitem, V);
    if status==0
        % update GUI
        i_RefreshIcons;
        i_FillValuePane;
    end
    
end

%--------------------------------------
% Apply pasted data/ascii file data to table             
%--------------------------------------
function varargout = i_ApplyData(src, evt, source)
%--------------------------------------
fh = i_GetHandle;
ud = get(fh,'userdata');
if strcmp(ud.displaysource, 'project')
    if strcmp(source, 'pastedata')
        h = mbcfoundation.clipboard;
        if h.isNumeric
            data = h.paste;
        else
            data = [];
        end
        info = 'Initialised from clipboard data';
    elseif strcmp(source, 'asciifile');
        curdir = pwd;
        FileDefaults = getpref(mbcprefs('mbc'), 'PathDefaults');
        if ~isempty(FileDefaults.cagedatafiles) && exist(FileDefaults.cagedatafiles,'dir')
            cd(FileDefaults.cagedatafiles);
        end
        [filename, pathname] = uigetfile({'*.txt;*.csv', 'Ascii data file (*.csv, *.txt)'}, 'Select data file');
        cd(curdir);
        if filename==0
            return    
        end
        data = cgcalreadtxt(fullfile(pathname,filename));
        info = 'Initialised from ascii file';
    else
        error('mbc:cgcalmanager:InvalidArgument', 'Unrecognised source.');
    end
    
    if isempty(data)
        h = errordlg('No data was found for importing.', 'MBC Toolbox', 'modal');
        waitfor(h);
        return
    end
    
    % Set up an appropriate data structure according to the type of object
    % selected and then use subfunction to perform copy
    V = struct('name', source, ...
        'description', '', ...
        'info', info, ...
        'data',[], ...
        'numaxes',[], ...
        'numrows',[], ...
        'numcols',[]);
    
    obj = ud.displayitem.info;
    if isa(obj, 'cglookuptwo')
        V.numaxes = 3;
        if isnan(data(1)) && all(size(data)>=2)
            V.data.X = data(1, 2:end);
            V.data.Y = data(2:end, 1);
            V.data.Z = data(2:end, 2:end);
            [V.numrows V.numcols] = size(V.data.Z);
        else
            V.data.X = [];
            V.data.Y = [];
            V.data.Z = data;
            [V.numrows V.numcols] = size(data);
        end
        
    elseif isa(obj, 'cgnormfunction') || isa(obj, 'cgnormaliser')
        V.numaxes = 2;
        V.numcols = 2;
        if size(data, 2)==1
            V.data.X = [];
            V.data.Y = data(:,1);
        else
            V.data.X = data(:,1);
            V.data.Y = data(:,2);
        end
        V.numrows = length(V.data.Y);
    elseif isa(obj, 'cgconstant')
        V.numaxes = 1;
        V.data.X = data;
        [V.numrows V.numcols] = size(data);
        
    end
    
    [status, msg] = i_TransferToTable(ud.displayitem, V);
    if status==0
        % update GUI
        i_RefreshIcons;
        i_FillValuePane;
        i_FillCalItemPane;
    else
        h = errordlg(['Incorrect data for this calibration item.' msg{1}], 'MBC Toolbox', 'modal');
        waitfor(h);
    end
end

%--------------------------------------
% Apply calibration data to an item          
%--------------------------------------
function i_Link(src,evt)
%--------------------------------------
fh = i_GetHandle;
ud = get(fh,'userdata');
try
    FileItem = ud.Hand.ParamContents.SelectedItem;
    ProjectItem = ud.Hand.BlockList.SelectedItem;
catch
    return
end
if isempty(FileItem) || isempty(ProjectItem)
    return
end

calIdx = sscanf(FileItem.Key, 'T%d');
projItem = assign(xregpointer, sscanf(ProjectItem.Key, 'K%d;S0'));
if projItem.isa('cgcontainer')
    projItem = projItem.getdata;
end
[status, msg] = i_TransferToTable(projItem, ud.cal(calIdx));
if status==0
    % update GUI
    i_RefreshIcons;
    i_FillValuePane;
    i_FillCalItemPane;
else
    h = errordlg(['Incorrect data for this calibration item. ' msg{1}], 'MBC Toolbox', 'modal');
    waitfor(h);
end




%--------------------------------------
% Apply calibration data for as many
% items as can be matched by name
%--------------------------------------
function i_AutoLink(src,evt)
%--------------------------------------
fh = i_GetHandle;
ud = get(fh,'userdata');

% Generate a list of cal item names
nds = ud.Hand.BlockList.nodes;
projnames = cell(1, nds.Count);
for n = 1:nds.Count
    projnames{n} = lower(nds.Item(n).Text);
end

% Loop over the Cal file data, locate blocks with matching names and
% collect the matches up.  They will be processed in one go at the end

ptrProjItems = null(xregpointer,0);
idxCalFileItems = [];

calnames = lower({ud.cal.name});


for n = 1:length(calnames)
    matchedidx = strmatch(calnames{n},projnames);
    if ~isempty(matchedidx)
        % Get Project item node by index
        pItem = assign(xregpointer, sscanf(nds.Item(matchedidx(1)).Key, 'K%d;S0'));
        if pItem.isa('cgcontainer')
            pItem = pItem.getdata;
        end
        ptrProjItems = [ptrProjItems, pItem];
        idxCalFileItems = [idxCalFileItems, n];
    end
end

if length(ptrProjItems)
    [status, msg] = i_TransferToTable(ptrProjItems, ud.cal(idxCalFileItems));
    if any(status==0)
        % update GUI
        i_RefreshIcons;
        i_FillValuePane;
        i_FillCalItemPane;
    end
    if any(status~=0)
        % Warn user that some matches failed
        h = warndlg(['The new data could not be applied to some of the matched items.', ...
                'These items have not been updated.'], 'MBC Toolbox', 'modal');
        waitfor(h);
    end
else
    % Warn user that there were no matches
    h = warndlg('No matches were found.', 'MBC Toolbox', 'modal');
    waitfor(h);
end




%--------------------------
function i_StartUp(pPROJ, varargin)
fh = i_GetHandle;
if isempty(fh)
    fh = i_CreateFigure(true); % modal dialog
end
i_RefreshTree(pPROJ);
i_FillCalFilePane;

pStartItem = [];
if nargin>2
    % Process prop/value pairs for other inputs
    for n = 1:2:(length(varargin)-1)
        switch lower(varargin{n})
            case 'selectitem'
                pStartItem = varargin{n+1};
            case 'closecallback'
                i_setCloseCallback(varargin{n+1});
        end
    end    
end
found = false;
if ~isempty(pStartItem)
    % Select a given item
    found = i_SelectTreeNode(pStartItem);
end
if ~found
    % Select the first node
    i_SelectTreeNode;
end
fh = handle(fh);
fh.showDialog;  % This will block because the GUI is modal
i_Finish;

%--------------------------
function i_StartChooseFile(pPROJ)

fh = i_GetHandle;
if isempty(fh)
    i_CreateFigure(true); % modal dialog
    fh = i_GetHandle;
end
if strcmp(get(fh,'visible'),'off')
    i_RefreshTree(pPROJ);
    ud = get(fh, 'userdata');
    ud.displaysource = '';
    ud.displayitem = null(xregpointer,0);
    set(fh, 'userdata', ud);
    i_FillCalItemPane;
    i_FillValuePane;
    OK = i_ChooseFile;
    if OK
        i_FillCalFilePane;

        fh = handle(fh);
        fh.showDialog;
        i_Finish;
    end
else
    OK = i_ChooseFile;
    if OK
        i_FillCalFilePane;
    end
end