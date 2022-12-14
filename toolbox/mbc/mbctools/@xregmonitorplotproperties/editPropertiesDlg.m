function obj = editPropertiesDlg(obj, index, data, hParent)
% EDITPROPERTIESLDG 
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.6.3 $  $Date: 2004/04/04 03:32:36 $

[OK, newPlot] = i_create(obj.plots(index), data, hParent);
if OK
    obj.plots(index) = newPlot;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [OK, newPlot] = i_create(plot, data, hParent)

dataNames = get(data, 'name');

% Need to do initial setup
[tmp, selectedXIndex] = intersect(dataNames, plot.xName);
[tmp, selectedYIndex] = intersect(dataNames, plot.yNames);

% Remove the currently selected names from the list
dataNames([selectedXIndex; selectedYIndex]) = [];

% Create the dialog
dlg = xregdialog(...
    'Name','Plot Variables Set Up',...
    'Resize','off');

set(dlg, 'CloseRequestFcn',{@i_cancel,dlg});   

xregcenterfigure(dlg, [400 450], hParent);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the Controls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Labels
label(1) = xregGui.uicontrol(...
    'parent',dlg,...
    'Style','text',...
    'String','Y variable(s):',...
    'HorizontalAlignment','left');

label(2) = xregGui.uicontrol(...
    'parent',dlg,...
    'Style','text',...
    'String','X variable:',...
    'HorizontalAlignment','left');

label(3) = xregGui.uicontrol(...
    'parent',dlg,...
    'Style','text',...
    'String','Select variables to plot:',...
    'HorizontalAlignment','left');

% OK/CancelButtons
OKButton = xregGui.uicontrol(...
    'parent',dlg,...
    'String','OK',...
    'Callback',{@i_ok,dlg});

CancelButton = xregGui.uicontrol(...
    'parent',dlg,...
    'String','Cancel',...
    'Callback',{@i_cancel,dlg});

helpBtn = mv_helpbutton(double(dlg),'xreg_monitorSetup');

removexButton = xregGui.uicontrol(...
    'parent',dlg,...
    'String','No X Data',...
    'callback',{@i_remove_x,dlg},...
    'enable','off');

if ~isempty(plot.xName)
    set(removexButton,'Enable','on');
end

% x variable editbox
xvaredit = xregGui.uicontrol(...
    'parent',dlg,...
    'Style','edit',...
    'String',plot.xName,...
    'BackgroundColor','w',...
    'Enable','inactive',...
    'HorizontalAlignment','left');

% All variables list
allvariablesList = xregGui.uicontrol(...
    'parent',dlg,...
    'Style','list',...
    'String',dataNames,...
    'Min',0,'Max',2,...
    'BackgroundColor','w');

% All variables list
yvariablesList = xregGui.uicontrol(...
    'parent',dlg,...
    'Style','list',...
    'String',plot.yNames,...
    'Min',0,'Max',2,...
    'BackgroundColor','w');


% Selection buttons
yselectButton = xregGui.uicontrol(...
    'parent',dlg,...
    'String','>',...
    'parent',dlg,...
    'FontWeight','bold',...
    'tooltipstring','Add Y variable',...
    'Callback',{@i_add,dlg});

ydeselectButton = xregGui.uicontrol(...
    'parent',dlg,...
    'String','<',...
    'FontWeight','bold',...
    'tooltipstring','Remove Y variable',...
    'Callback',{@i_remove,dlg});

xselectButton = xregGui.uicontrol(...
    'parent',dlg,...
    'String','>',...
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
ud.plot = plot;
ud.OK = false;

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

%Implicit waifor on visible property!
ud = get(dlg,'Userdata');
delete(dlg);
newPlot = ud.plot;
OK = ud.OK;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_add(src, evt, dlg)
% get current vars from allvariables list and move to yvariables
% Get userdata
ud = get(dlg,'Userdata');

% get selected values from all
selv = ud.lists.all.Value;
allstr = ud.lists.all.String;

if ~isempty(allstr)
    % Add selected variables to the y list
    ud.lists.y.String = sort([ud.lists.y.String ; allstr(selv)]);
    
    % remove variables from all
    allstr(selv) = [];
    set(ud.lists.all, 'String', allstr, 'Value', 1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_remove(src, evt, dlg)
% remove current y vars
% Get userdata
ud = get(dlg,'Userdata');

% Get selected values from y
selv = ud.lists.y.Value;
ystr = ud.lists.y.String;

if ~isempty(ystr)
    % Add selected variables to the all list
    ud.lists.all.String = sort([ud.lists.all.String ; ystr(selv)]);
   
    % remove variables from y
    ystr(selv) = [];
    set(ud.lists.y, 'String', ystr, 'Value', 1);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_xdata(src, evt, dlg)
% take current var into xvaredit
ud = get(dlg, 'Userdata');

% Get first selected values from all
selv = ud.lists.all.Value(1);
allstr = ud.lists.all.String;

if ~isempty(allstr)
    newXstr = allstr{selv};
    allstr(selv) = [];
    
    % Get old xstr
    oldXstr = ud.lists.x.String;
    if ~isempty(oldXstr)
        % Construct new all str
        allstr = sort([allstr ; {oldXstr}]);    
    end
    % Set all without newXstr and with oldXstr
    set(ud.lists.all, 'String', allstr, 'Value', 1);
    % Set newXstr
    ud.lists.x.String = newXstr;
    % Enable remove XData
    ud.buttons.xremove.Enable = 'on';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_remove_x(src, evt, dlg)

ud = get(dlg,'Userdata');

% get oldXstr
oldXstr = ud.lists.x.String;

if ~isempty(oldXstr)
    ud.lists.all.String = sort([ud.lists.all.String ; {oldXstr}]);
    
    % Ensure that this is a cell array
    ud.lists.x.String = '';
    % Disable remove XData
    ud.buttons.xremove.Enable = 'off';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ok(src,evt,dlg)
ud = get(dlg,'Userdata');

% Update the plot info
ud.plot.yNames = ud.lists.y.String;
ud.plot.xName  = ud.lists.x.String;

% Set the OK flag
ud.OK = true;

set(dlg, 'Userdata', ud, 'Visible', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_cancel(src,evt,dlg)
% Close
set(dlg,'Visible','off');

