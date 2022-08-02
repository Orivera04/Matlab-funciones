function out=monitordlg(action,varargin)
% MONITORDLG setup dialog for MonitorPlots
%
% out=monitordlg(action,varargin)
%
% With Tp a pointer to a TestPlan will
% create the dialog.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/04 03:30:42 $

switch lower(action)
case 'create'
    out=i_create(varargin{:});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = i_create(Tp,data)

% get the monitor variables
Monitor= getMonitor(Tp.info);
if isempty(Monitor)
	Monitor= struct('values',[],'Xdata','');
	Tp.setMonitor(Monitor);
end
var_names=get(data,'name');

% Need to do initial setup
yvars =  Monitor.values; [tmp,yvals] = intersect(var_names, yvars);
xvars = Monitor.Xdata; [tmp,xval] = intersect(var_names, xvars);

var_names([yvals;xval])=[];

len= 400;
height=450;
Scr=get(0,'screensize');
fPos= [Scr(3)/2-len/2 Scr(4)/2-height/2, len, height];

% Create the dialog
dlg = xregdialog(...
    'Name','Plot Variables Set Up',...
    'Resize','off',...
    'Position',fPos);
set(dlg, 'CloseRequestFcn',{@i_cancel,dlg});   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the Controls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Labels
label(1) = uicontrol('Style','text',...
    'String','Y variable(s):',...
    'HorizontalAlignment','left');
label(2) = uicontrol('Style','text',...
    'String','X variable:',...
    'HorizontalAlignment','left');
label(3) = uicontrol('Style','text',...
    'String','Select variables to plot:',...
    'HorizontalAlignment','left');

% OK/CancelButtons
OKButton = uicontrol('String','OK','Callback',{@i_ok,dlg});
CancelButton = uicontrol('String','Cancel','Callback',{@i_cancel,dlg});
helpBtn = mv_helpbutton(double(dlg),'xreg_monitorSetup');

removexButton = uicontrol('String','No X Data',...
    'callback',{@i_remove_x,dlg},...
    'enable','off');

if ~isempty(xvars)
    set(removexButton,'Enable','on');
end

% x variable editbox
xvaredit = uicontrol(...
    'Style','edit',...
    'String',xvars,...
    'BackgroundColor','w',...
    'Enable','inactive',...
    'HorizontalAlignment','left');

% All variables list
allvariablesList = uicontrol(...
    'Style','list',...
    'String',var_names,...
    'Min',0,'Max',2,...
    'BackgroundColor','w');

% All variables list
yvariablesList = uicontrol(...
    'Style','list',...
    'String',yvars,...
    'Min',0,'Max',2,...
    'BackgroundColor','w');


% Selection buttons
yselectButton = uicontrol('String','>',...
    'FontWeight','bold',...
    'tooltipstring','Add Y variable',...
    'Callback',{@i_add,dlg});

ydeselectButton = uicontrol('String','<',...
    'FontWeight','bold',...
    'tooltipstring','Remove Y variable',...
    'Callback',{@i_remove,dlg});

xselectButton = uicontrol('String','>',...
    'FontWeight','bold',...
    'tooltipstring','Select X variable',...
    'Callback',{@i_xdata,dlg});

%
% Set up userdata
%

ud.buttons.OK = OKButton;
ud.buttons.Cancel = CancelButton;
ud.buttons.yselect = yselectButton;
ud.buttons.ydeselect = ydeselectButton;
ud.buttons.xselect = xselectButton;
ud.buttons.xremove = removexButton;
ud.lists.all = allvariablesList;
ud.lists.y = yvariablesList;
ud.lists.x = xvaredit;
ud.data.data = data;
ud.data.tp = Tp;
ud.out = 0;
set(dlg,'Userdata',ud);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Layouts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


buttonLyt = xreggridlayout(double(dlg),...
    'dimension',[1,7],...
    'elements',{[],OKButton,[],CancelButton,[],helpBtn,[]},...
    'CorrectAlg','on',...
    'ColSizes',[-1,65,7 65,7,65,10],...
    'packstatus','off');

yselectLyt = xreggridlayout(double(dlg),...
    'dimension',[5,1],...
    'elements',{[],yselectButton,[],ydeselectButton,[]},...
    'gapy',5,...
    'CorrectAlg','on',...
    'RowSizes',[-1,20,20,20,-1]);

xselectLyt = xreggridlayout(double(dlg),...
    'dimension',[3,1],...
    'elements',{[],xselectButton,[]},...
    'gapy',5,...
    'CorrectAlg','on',...
    'RowSizes',[-1,20,-1]);

xeditLyt = xreggridlayout(double(dlg),...
    'dimension',[3,2],...
    'elements',{[],xvaredit,[],[],removexButton,[]},...
    'gapy',5,...
    'gapx',10,...
    'CorrectAlg','on',...
    'RowSizes',[-1,20,-1],...
    'ColSizes',[-1,60]);

centerLyt = xreggridlayout(double(dlg),...
    'dimension',[6,1],...
    'elements',{[],yselectLyt,[],xselectLyt,[],[]},...
    'gapy',5,...
    'CorrectAlg','on',...
    'RowSizes',[30,-1,30,30,10,30]);

farrightLyt = xreggridlayout(double(dlg),...
    'dimension',[6,1],...
    'elements',{label(1),yvariablesList,label(2),xeditLyt,[],buttonLyt},...
    'gapy',5,...
    'CorrectAlg','on',...
    'RowSizes',[15,-1,15,30,10,25]);

rightLyt = xreggridlayout(double(dlg),...
    'dimension',[1,2],...
    'elements',{centerLyt,farrightLyt},...
    'gapx',10,...
    'CorrectAlg','on',...
    'ColSizes',[20,-1]);

leftLyt = xreggridlayout(double(dlg),...
    'dimension',[2,1],...
    'elements',{label(3),allvariablesList},...
    'gapx',10,...
    'CorrectAlg','on',...
    'RowSizes',[15,-1]);

mainLyt = xreggridlayout(double(dlg),...
    'dimension',[1,2],...
    'elements',{leftLyt,rightLyt},...
    'gapx',20,...
    'ColRatios',[2,3]);

Lyt = xregborderlayout(double(dlg),...
    'container',double(dlg),...
    'center',mainLyt,...
    'innerborder',[0,20,20,20],...
    'packstatus','on');

dlg.showDialog(OKButton);

ud = get(dlg,'Userdata');
delete(dlg);
out = ud.out;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_add(src,evt,dlg)
% get current vars from allvariables list and move to yvariables
% Get userdata
ud = get(dlg,'Userdata');

% get selected values from all
selv = get(ud.lists.all,'Value');
allstr = get(ud.lists.all,'String');

if ~isempty(allstr)
    % Create y str
    ystr = get(ud.lists.y,'String');
    ystr = sort([ystr;allstr(selv)]);
    set(ud.lists.y,'String',ystr);
    
    % remove variables from all
    allstr(selv) = [];
    set(ud.lists.all,'String',allstr);
    set(ud.lists.all,'Value',1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_remove(src,evt,dlg)
% remove current y vars
% Get userdata
ud = get(dlg,'Userdata');

% get selected values from y
selv = get(ud.lists.y,'Value');
ystr = get(ud.lists.y,'String');

if ~isempty(ystr)
    % Create all str
    allstr = get(ud.lists.all,'String');
    allstr = sort([allstr;ystr(selv)]);
    set(ud.lists.all,'String',allstr);
    
    % remove variables from y
    ystr(selv) = [];
    set(ud.lists.y,'String',ystr);
    set(ud.lists.y,'Value',1);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_xdata(src,evt,dlg)
% take current var into xveredit
ud = get(dlg,'Userdata');

% get selected values from all
selv = get(ud.lists.all,'Value');
selv = selv(1);
allstr = get(ud.lists.all,'String');
if ~isempty(allstr)
    xstr = allstr{selv};
    allstr(selv) = [];
    
    % get old xstr
    oldxstr = get(ud.lists.x,'String');
    if ~isempty(oldxstr)
        % construct new all str
        allstr = sort([allstr;oldxstr]);    
    end
    set(ud.lists.all,'String',allstr);
    % set new xstr
    set(ud.lists.x,'String',{xstr});
    
    set(ud.buttons.xremove,'Enable','on');
    set(ud.lists.all,'Value',1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ok(src,evt,dlg)
% update testplan and close
ud = get(dlg,'Userdata');

% get the TestPlan
Tp= ud.data.tp;

% get the Monitor variable
Monitor= getMonitor(Tp.info);

% get the chosen variables.
yvars= get(ud.lists.y,'String');

% need to do match, val is index into list of variables
%[name, val] = intersect(get(ud.data.data,'name'), yvars);

% add the index to the current monitor list.
Monitor.values=yvars;

% Now do xdata
if ~isempty(Monitor.values)
    xvar = get(ud.lists.x,'String');
    %[tmp,val] = intersect(get(ud.data.data,'name'),xvar);
    Monitor.Xdata = xvar;
else
    Monitor.Xdata = [];
end

% Update Monitor
setMonitor(Tp.info,Monitor);

ud = get(dlg,'Userdata');
ud.out = 1;
set(dlg,'Userdata',ud);

set(dlg,'Visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_cancel(src,evt,dlg)
% close
ud = get(dlg,'Userdata');
ud.out = 0;
set(dlg,'Userdata',ud);
set(dlg,'Visible','off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_remove_x(src,evt,dlg)

ud = get(dlg,'Userdata');

% get old xstr
oldxstr = get(ud.lists.x,'String');
if ~isempty(oldxstr)
    allstr = get(ud.lists.all,'String');
    % construct new all str
    allstr = sort([allstr;oldxstr]);
    set(ud.lists.all,'String',allstr);
    
    % set new xstr
    set(ud.lists.x,'String',[]);
    set(ud.buttons.xremove,'Enable','off');
    set(ud.lists.all,'Value',1);
end
