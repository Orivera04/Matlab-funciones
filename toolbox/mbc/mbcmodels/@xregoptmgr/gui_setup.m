function varargout = gui_setup(Omgr,action, displayoptions, varargin)
%GUI_SETUP  GUI for altering xregoptmgr settings
%
%  [Omgr,OK] = GUI_SETUP(Omgr, 'figure', displayoptions, varargin) creates
%  a blocking GUI for choosing the xregoptmgr options and altering its
%  settings.  OK indicates whether the user pressed 'OK' or 'CANCEL'.
%  displayoptions is an optional cell array of properties and values:
%
%  displayoptions = {'expanded', 1, ...
%                    'title', titlestr, ...
%                    'topname',algname, ...
%                    'basiclayout', false}
%
%  'title' is used to label the figure and 'topname' as the label for the
%  toplevel algorithm. 'expanded' is used to specify if the tree should be
%  expanded on opening. 'basiclayout' is used to show only the basic
%  options.
%
%  LYT =GUI_SETUP(Omgr,'layout',displayoptions, FIG,P, varargin) creates a
%  layout object in the figure FIG which updates the dynamic copy of a
%  model in the pointer P.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.2.3 $  $Date: 2004/02/09 07:56:49 $

switch action
    case 'figure'
        if nargin < 3
            displayoptions = {};
        end
        [Omgr, OK] = i_createfig(Omgr, displayoptions, varargin{:});
        varargout{1} = Omgr;
        varargout{2} = OK;
    case 'layout'
        hFig = varargin{1};
        p = varargin{2};
        if nargin >5
            otherArgs = varargin{3:end};
        end
        % defaults
        expanded = 1;
        topname = getname(p.info);
        basiclayout = false;

        % change the defaults if provided
        for i = 1:2:length(displayoptions)
            Property = displayoptions{i};
            Value = displayoptions{i+1};
            switch lower(Property)
                case 'expanded'
                    expanded = Value;
                case 'topname'
                    topname = Value;
                case 'basiclayout'
                    basiclayout = Value;
                otherwise
                    error('Not a valid display option')
            end
        end

        [lyt, OK] =i_createlyt(hFig,p,topname, expanded, basiclayout, otherArgs);
        set(lyt,'visible','on');
        varargout{1} = lyt;
        varargout{2} = OK;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Omgr, OK] = i_createfig(Omgr, displayoptions, varargin)

% defaults
expanded = 1;
title = 'Optimization Setup';
topname = getname(Omgr);
%show all guisetable options
basiclayout = false;

% change the defaults if provided
for i = 1:2:length(displayoptions)
    Property = displayoptions{i};
    Value = displayoptions{i+1};
    switch lower(Property)
        case 'title'
            title = Value;
        case 'expanded'
            expanded = Value;
        case 'topname'
            topname = Value;
        case 'basiclayout'
            basiclayout = Value;
        otherwise
            error('Not a valid display option')
    end
end

% create the figure to display the xregoptmgr results
fsize= [500 500];
xFig= xregfigure('Name',title,...
    'menubar','none',...
    'color',get(0,'defaultuicontrolBackgroundcolor'),...
    'NumberTitle','off',...
    'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
    'visible','off',...
    'units','pixels',...
    'tag','OptimMgrGui');
% hFig is a udd, need a figure handle so use double
hFig = double(xFig);

set(hFig,'pointer','watch');

%center the figure
xregcenterfigure(hFig, fsize);

p=xregGui.RunTimePointer(Omgr);
LinkToObject(p,hFig);

[lyt,OK]=i_createlyt(hFig, p, topname, expanded, basiclayout, varargin{:});

set(lyt,'visible','on');
% add ok, cancel
okbtn=uicontrol('style','pushbutton',...
    'parent',hFig,...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'');');
cancbtn=uicontrol('style','pushbutton',...
    'parent',hFig,...
    'string','Cancel',...
    'callback','set(gcbf,''tag'',''cancel'');');

mainlyt = xreggridbaglayout(hFig, 'dimension', [2 5], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 10 65 10], ...
    'gapy', 10, ...
    'border', [0 10 0 0], ...
    'mergeblock', {[1 1], [1 5]}, ...
    'elements', {lyt, [], [], okbtn, [], [], [], cancbtn});

ud.figure=hFig;

% top level LayoutManager
xFig.LayoutManager = mainlyt;
set(mainlyt,'packstatus','on');
set(hFig,'visible','on','userdata',ud);
set(hFig,'pointer','arrow');

drawnow;
set(hFig,'windowstyle','modal');
waitfor(hFig,'tag');

tg=get(hFig,'tag');
switch lower(tg)
    case 'ok'
        Omgr=p.info;
        OK=1;
    case 'cancel'
        OK=0;
end
delete(hFig);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tree, OK] = i_createlyt(hFig, p, topname, expanded, basiclayout, varargin)
% create a gridlayout for the xregoptmgr pointed to by p
% topname will provide a label for the top level xregoptmgr

Omgr=p.info;
ud.pointer=p;
ud.figure=hFig;
ud.expandflag = expanded;
ud.basiclayout = basiclayout;

% if the optmgr name, and the option parameter are the same,
% and there are no alternative algorithms
% then don't display the popup
if isequal(topname,getname(Omgr)) && isempty(Omgr.Alternatives)
    ctrl = [];
else
    ctrl= AltSetupUI(Omgr,hFig,varargin{:});
    ctrl=ctrl{1};
end

udh=xregGui.labelcontrol('parent',hFig,...
    'LabelSizeMode','absolute',...
    'LabelSize',240,...
    'ControlSize',150,...
    'visible','off',...
    'border',[0 2 0 2]);


if ~isempty(ctrl)
    % If a control will be displayed, use a colon
    set(udh, 'string',[topname ':']);
    % get enabling from control
    set(udh, 'enable', get(ctrl, 'enable'));
    % popup menu callback
    set(ctrl,'callback',{@i_setAlternatives,udh,[], varargin{:}});
else
    set(udh, 'string',topname);
end

set(udh, 'Control', ctrl);

% Create a tree
tree = xregGui.tree('parent',hFig,...
    'NodeHeight',24);
tree.BackGroundColor = get(0,'defaultuicontrolBackgroundcolor');
tree.PerformDraw = 'off';

root = tree.addNode([],[],topname,udh);

% put the tree in user data
ud.tree = tree;

set(udh, 'userdata', ud);

% a string of the option names for the parent omgrs to help with setting options
OmgrsOptNames = [];
addOptionNodes(tree, root, Omgr, udh, OmgrsOptNames, varargin{:});
if ud.expandflag
    root.expand;
    for i =1:length(tree.nodes)
        tree.nodes(i).expand;
    end
end

tree.PerformDraw = 'on';
tree.redraw;

OK = 1;
tree = xregpanellayout(hFig,'innerborder',[0 0 0 0],'center',tree,'packstatus','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function addOptionNodes(tree, leaf, Omgr, udh, OmgrsOptNames, varargin)
% add the options of Omgr to the tree, attaching them to the leaf

ud = get(udh,'userdata');
basiclayout = ud.basiclayout;

if ~isempty(Omgr.foptions)
    if basiclayout
        gs= find([Omgr.foptions.GuiSetable]==2);
    else
        gs= find([Omgr.foptions.GuiSetable]);
    end
else
    gs = [];
end
n= length(gs);

nodes = cell(n,1);

% set up the flow layouts for each of the options
for i=1:n
    opt= Omgr.foptions(gs(i));
    % add the name of the option
    if ~isempty(OmgrsOptNames)
        ParamName = [OmgrsOptNames '.' opt.Param];
    else
        ParamName = opt.Param;
    end

    cstr= opt.CheckInput;
    if iscell(cstr)
        cstr = cstr{1};
    end

    h = i_labelcontrol(udh, opt, ParamName, varargin{:});

    % add a child node to leaf with full tag OmgrsOptNames.opt.Param and layout h
    nodes{i} = tree.addNode(leaf, tree.relChild, ParamName, h);

    % if we are adding an optmgr recurse inwards and add options
    if strcmp(lower(cstr), 'xregoptmgr')
        addOptionNodes(tree, nodes{i}, opt.Value,udh, ParamName, varargin{:});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h = i_labelcontrol(udh, opt, ParamName, varargin)

ud = get(udh, 'userdata');
hFig = ud.figure;

% create the label control for the options
ctrl=i_OptProps(udh,opt,ParamName, varargin{:});
if iscell(ctrl)
    ctrl=ctrl{1};
end
h=xregGui.labelcontrol('parent',hFig,...
    'LabelSizeMode','absolute',...
    'LabelSize',240,...
    'ControlSize',150,...
    'visible','off',...
    'border',[0 2 0 2]);

nm= opt.Name;
if isempty(nm)
    nm= opt.Param;
end

% If a control will be displayed, use a colon
if ~isempty(ctrl) && ~strcmp(get(ctrl, 'style'), 'checkbox')
    set(h, 'string',[nm ':']);
    % get enabling from control
    set(h, 'enable', get(ctrl, 'enable'));
else
    set(h, 'string',nm);
end

set(h, 'control', ctrl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  h= i_OptProps(udh,opt,ParamName,varargin)

ud = get(udh,'userdata');
hFig = ud.figure;

h={};
cstr= opt.CheckInput;
if iscell(cstr)
    cstr = cstr{1};
end
if ~isempty(cstr) && ischar(cstr)
    if ~isempty(strfind(cstr,'|'))
        sp = strmatch(opt.Value, strread(cstr, '%s', 'delimiter', '|'), 'exact');
        Props= {'style','popupmenu',...
            'string',cstr,...
            'Callback',{@i_setEnumerated,udh,ParamName}...
            'value',sp};
    else
        switch lower(cstr)
            case {'numeric','int'}
                Props= {'style','edit',...
                    'Callback',{@i_setValue,udh,ParamName}...
                    'string',opt.Value};
            case 'vector'
                Props= {'style','edit',...
                    'Callback',{@i_setVector,udh,ParamName}...
                    'string',prettify(opt.Value)};
            case 'range'
                Props= {'style','edit',...
                    'Callback',{@i_setRange,udh,ParamName}...
                    'string',num2str(opt.Value)};
            case 'boolean'
                Props= {'style','checkbox',...
                    'Callback',{@i_setBoolean,udh,ParamName},...
                    'BackGroundColor',get(0,'defaultuicontrolBackgroundcolor'),...
                    'value',opt.Value};
            case 'evalstr'
                Props= {'style','edit',...
                    'Callback',{@i_setChar,udh,ParamName}...
                    'string',opt.Value{1}};
            case 'char'
                Props= {'style','edit',...
                    'Callback',{@i_setChar,udh,ParamName}...
                    'string',opt.Value};
            case 'xregoptmgr'
                h= AltSetupUI(opt.Value,hFig,varargin{:});
                % if the optmgr name, and the option parameter are the same,
                % and there are no alternative algorithms
                % then don't display the popup
                if isequal(getname(opt.Value),opt.Param) && isempty(opt.Value.Alternatives)
                    h = [];
                end
                if ~isempty(h) && ~isempty(opt.Value.Alternatives)
                    % popup menu callback
                    set(h{1},'callback',{@i_setAlternatives,udh,ParamName, varargin{:}});
                end
                Props=[];
            otherwise
                str= evalc('disp(opt.Value)');
                Props= {'style','text',...
                    'string',str};
        end
    end
else
    str= evalc('disp(opt.Value)');
    Props= {'style','text',...
        'string',str};
end

if ~isempty(Props)
    if strcmp(get(hFig,'type'),'figure')
        h{1}= uicontrol('parent',hFig,...
            'horizontalAlignment','Left',...
            'Backgroundcolor','w',...
            'visible','off',...
            Props{:});
    else
        set(hFig,Props{:});
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_setEnumerated(h,EventData,udh,Param)

ud=get(udh,'userdata');
p = ud.pointer;
Omgr = p.info;
i= get(h,'value');
cstr= get(h,'string');
switch class(cstr)
    case 'char'
        if size(cstr,1)>1
            val= deblank(cstr(i,:));
        else
            pbar= [1 findstr(cstr,'|') length(cstr+1)];
            val= cstr(pbar(i):pbar(i+1));
        end
    case 'cell'
        val= cstr{i};
end
set(Omgr,Param,val);
p.info = Omgr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_setValue(h,EventData,udh,Param)

ud=get(udh,'userdata');
p = ud.pointer;
Omgr = p.info;
try
    val= evalin('base',get(h,'string'));
catch
    xregerror('Input Error', ['Scalar numerical input is required for ',Param]);
    set(h,'string',get(Omgr,Param));
    return
end

try
    set(Omgr,Param,val);
catch
    xregerror('Input Error');
    set(h,'string',get(Omgr,Param));
end
p.info = Omgr;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_setVector(h,EventData,udh,Param)

ud=get(udh,'userdata');
p = ud.pointer;
Omgr = p.info;
str = get(h,'string');
val= str2num(str);
if ~isempty(str) && isempty(val)
    xregerror( 'Input Error',['Numeric values are required for ',Param]);
    set(h,'string',prettify(get(Omgr,Param)));
else
    try
        set(Omgr,Param,val);
    catch
        xregerror('Input Error');
        set(h,'string',prettify(get(Omgr,Param)));
    end
    p.info = Omgr;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_setRange(h,EventData,udh,Param)

ud=get(udh,'userdata');
p = ud.pointer;
Omgr = p.info;
try
    val= str2num(get(h,'string'));
    set(Omgr,Param,val);
catch
    xregerror('Input Error');
    set(h,'string',num2str(get(Omgr,Param)));
end
p.info = Omgr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_setChar(h,EventData,udh,Param)

ud=get(udh,'userdata');
p = ud.pointer;
Omgr = p.info;
try
    val= get(h,'string');
    set(Omgr,Param,val);
catch
    xregerror('Input Error');
    set(h,'string',num2str(get(Omgr,Param)));
end
p.info = Omgr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_setBoolean(h,EventData,udh,Param)

ud=get(udh,'userdata');
p = ud.pointer;
Omgr = p.info;
val= get(h,'value');
set(Omgr,Param,val);
p.info = Omgr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function i_setAlternatives(h,EventData,udh, Param, varargin)

ud=get(udh,'userdata');
p = ud.pointer;
Omgr =p.info;
tree = ud.tree;
val=get(h,'value');


if ~isempty(Param)
    OldOM = get(Omgr, Param);
else % we are at the top level
    OldOM = Omgr;
end

if isempty(OldOM.Alternatives) % no change possible
    return
end

[NewOM,OK]=  feval(OldOM.Alternatives{val},varargin{:});
% copy alternatives
if OK
    NewOM.Alternatives= OldOM.Alternatives;
    if ~isempty(Param)
        % change the suboptmgr
        set(Omgr,Param, NewOM);
        p.info = Omgr;
    else % change the toplevel optmgr
        p.info = NewOM;
    end

    % find the node that contains the optmgr
    if isempty(Param) % when we are at the top level
        node = tree.Nodes(1);
    else
        for i = 1:length(tree.Nodes)
            if strcmp(tree.Nodes(i).Tag, Param)
                node = tree.Nodes(i);
            end
        end
    end

    % delete the tree nodes children
    i_deletechildren(node);

    % add the new tree nodes
    addOptionNodes(tree, node, NewOM, udh, Param, varargin{:});

    set(udh, 'userdata', ud);

    if ud.expandflag
        while ~isempty(node)
            node.expand;
            node = node.down;
        end
    end

    tree.redraw;
else
    % alternative not valid
    msgbox('The new alternative is not valid');
    val= find(strcmp(OldOM.name,OldOM.Alternatives));
    set(h,'value',val(1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_deletechildren(node)

while ~isempty(node.down)
    i_deletechildren(node.down)
    delete(node.down.layout);
    delete(node.down);
end
