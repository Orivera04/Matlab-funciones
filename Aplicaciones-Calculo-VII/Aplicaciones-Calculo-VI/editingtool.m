function editingtool(action)
%Graphic Editing Tool
%
%Usage:
% editingtool('On') - enables the function
% editingtool('Off') - disenables the function
% editingtool - Enables the function if it is Off 
%               or disenables the function if it is On
%
%Description:
% Allows you to edit plots and text by just 
% selecting them with the mouse. 
%
% You can easily move, rotate, change properties etc. of lines
% and text by simply clicking on them or typing specific keys.
%
% A double click will select a specific point within a line.
%
% Works by setting the ButtonDownFcn of the
% current axes and children as editingtool('BtnDown').
%
%The following Key-Press Functions may used with this program
% return - Opens the Java property window of the current object(s)
% delete - Deletes the current object(s)
% insert - Inserts in additional point to the selected line object
% c - copies the current object(s) and places them using the mouse
% d - Draw a line by left-clicking on points and right-click when finished
% t - Insert text by click on a position and typing
%
%NOTES:
% The userdata of the figure is set to a structure.
% The the userdata already contains a structure,
% new fields are added for internal use of the program.
% Some of fields are describes bellow
%              hAx: Current axes
%             hSlc: Handle of line used for point seleccion
%             hObj: List of handles of selected objects
%           NewObj: Used for pasting 
%            index: Index of point within a line
%             hMod: Handle of object that contains a selected point
%           Button: Mouse button selected
%     CurrentPoint: [2x3 double] - Last point selected
%           hLine: Line drawn during rotation
%             Orig: [2x3 double] - Used for rotation of objects
%
%Key Words:
%Edit, Rotate, Move, Delete, Add Lines, Draw
%
%Copy-Left, Alejandro Sanchez-Barba, 2005

if nargin==0
    hFig = get(0,'CurrentFigure');
    if isempty(hFig)
        rundemo
        drawnow
    end
    ud = get(hFig,'UserData');
    if isfield(ud,'manual')
        if strcmp(ud.manual,'On')
            action = 'Off';
        else %off
            action = 'On';
        end
    else
        action = 'On';
    end
elseif strcmpi(action,'On')
    action = 'On';
elseif strcmpi(action,'Off')
    action = 'Off';
end
eval(action)
return

%-----------------------------------------------------------
function BtnDown
hFig = get(0,'CurrentFigure');
hAx = get(hFig,'CurrentAxes');
ud.hAx = hAx;
Button = get(hFig,'SelectionType');
ud = get(hFig,'UserData');
ud.Button = Button;
ud.CurrentPoint = get(hAx,'CurrentPoint');
hObj = get(hFig,'CurrentObject');
ObjType = {get(hObj,'Type')}; %Force to cell
switch ud.Button
    case 'normal' %Move
        %check if it is alredy highlighted
        if strcmpi(get(hObj,'Selected'),'On')
            setptr(hFig,'closedhand');
            set(hFig,'WindowButtonMotionFcn', ...
                'editingtool(''BtnMotion'')',...
                'WindowButtonUpFcn', ...
                'editingtool(''BtnUp'')')
        else
            set(hObj,'Selected','On')
            if all(ud.hObj~=hObj)
                ud.hObj(end+1) = hObj;
            end
            set(hFig,'WindowButtonMotionFcn','',...
                'WindowButtonUpFcn', '');
        end %if
    case 'alt' %Rotate
        cond1 = strcmpi(get(hObj,'Selected'),'On');
        cond2 = (hObj==hAx & strcmpi(get(ud.hObj,'Selected'),'On'));
        if cond1 | cond2
            setptr(hFig,'rotate'); %only valid with newer versions
            ud.hLine = line('XData',[],'YData',[], ...
                'Parent',hAx,'Color','k');
            ud.Orig = ud.CurrentPoint;
            set(hFig,'WindowButtonMotionFcn', ...
                'editingtool(''BtnMotion'')',...
                'WindowButtonUpFcn', ...
                'editingtool(''BtnUp'')')
        else
            set(hObj,'Selected','Off')
            set(hFig,'WindowButtonMotionFcn','',...
                'WindowButtonUpFcn', '');
        end %if
    case 'open'
        if strcmpi(ObjType,'line')
            set(hObj,'Selected','Off')
            x = get(hObj,'Xdata');
            y = get(hObj,'Ydata');
            CurrentPoint = ud.CurrentPoint;
            x0 = CurrentPoint(1,1);
            y0 = CurrentPoint(1,2);
            dist = sqrt((x0 - x).^2 + (y0 - y).^2);
            [dummy,index] = min(dist);
            ud.index = index;
            ud.hMod = hObj;
            marker = get(hObj,'Marker');
            if strcmpi(marker,'.')
                marker = 'o';
            end
            markersize = get(hObj,'MarkerSize');
            markeredgecolor = get(hObj,'MarkerEdgeColor');
            markerfacecolor = get(hObj,'MarkerFaceColor');
            set(ud.hSlc,'Parent',hAx, ...
                'Xdata',x(index),'Ydata',y(index), ...
                'Color','m','Marker',marker, ...
                'MarkerSize',markersize, ...
                'MarkerEdgeColor',markeredgecolor, ...
                'MarkerFaceColor',markerfacecolor, ...
                'Visible','On','Selected','On');
            %Now bring hSlc to the front
			chldrn = get(hAx,'Children');
			chldrn(chldrn == ud.hSlc) = [];
			chldrn = [ud.hSlc; chldrn(:)];
			set(hAx,'Children',chldrn)
        end %if
end %switch
set(hFig,'UserData',ud)
return

%-----------------------------------------------------------
function BtnMotion
hFig = get(0,'CurrentFigure');
ud = get(hFig,'UserData');
hAx = get(hFig,'CurrentAxes');
ud.hAx = hAx;
hObj = ud.hObj;
ObjType = get(hObj,'Type');
n = length(hObj);
if n==1
     ObjType = {ObjType};   
end
LastPoint = ud.CurrentPoint;
CurrentPoint = get(hAx,'CurrentPoint');
switch ud.Button
    case 'normal' %Move
        if ~isempty(ud.hMod)
            xb = get(ud.hMod,'Xdata');
            yb = get(ud.hMod,'Ydata');
            xb(ud.index) = CurrentPoint(1,1);
            yb(ud.index) = CurrentPoint(1,2);
            set(ud.hMod,'Xdata',xb,'Ydata',yb)
            set(ud.hSlc,'Xdata',CurrentPoint(1,1), ...
                'Ydata',CurrentPoint(1,2))
        else
            %Calculate Difference
            dx = CurrentPoint(1,1) - LastPoint(1,1);
            dy = CurrentPoint(1,2) - LastPoint(1,2);
            %Update position on Plot
            for k=1:n
                switch ObjType{k}
                    case 'line'
                        x = get(hObj(k),'XData') + dx;
                        y = get(hObj(k),'YData') + dy;
                        set(hObj(k),'XData',x,'YData',y)
                    case 'text'
                        pos = get(hObj(k),'Position');
                        x = pos(1) + dx;
                        y = pos(2) + dy;
                        set(hObj(k),'Position',[x,y])
                end %switch
            end %for
        end %if
    case 'alt' %Rotate
        xline = [ud.Orig(1,1),CurrentPoint(1,1)];
        yline = [ud.Orig(1,2),CurrentPoint(1,2)];
        set(ud.hLine,'XData',xline,'YData',yline)
        u1 = CurrentPoint(1,1) - ud.Orig(1,1);
        v1 = CurrentPoint(1,2) - ud.Orig(1,2);
        th1 = atan2(v1,u1);
        u2 = LastPoint(1,1) - ud.Orig(1,1);
        v2 = LastPoint(1,2) - ud.Orig(1,2);
        th2 = atan2(v2,u2);
        theta = th1 - th2;
        for k=1:n
            switch ObjType{k}
                case 'line'
                    x = get(hObj(k),'XData');
                    y = get(hObj(k),'YData');
                    rot = [cos(theta), - sin(theta); ...
                            sin(theta), cos(theta)];
                    vec = [x(:) - ud.Orig(1,1), ...
                            y(:) - ud.Orig(1,2)];
                    newvec = (rot*vec')';
                    x = newvec(:,1) + ud.Orig(1,1);
                    y = newvec(:,2) + ud.Orig(1,2);
                    set(hObj(k),'XData',x,'YData',y)
                case 'text'
                    thetaold = get(hObj(k),'Rotation');
                    thetanew = thetaold + theta*180/pi;
                    set(hObj(k),'Rotation',thetanew)
            end %switch
        end %for
end %switch
ud.CurrentPoint = CurrentPoint;
set(hFig,'UserData',ud)
return

%-----------------------------------------------------------
function BtnUp
hFig = get(0,'CurrentFigure');
setptr(hFig,'arrow');
set(hFig,'WindowButtonMotionFcn','',...
    'WindowButtonUpFcn','');
ud = get(hFig,'UserData');
%set hObj to the ones that are selected
% set(ud.hObj,'Selected','Off')
set(ud.NewObj,'Selected','Off')
set(ud.hSlc,'Visible','Off')
% ud.hObj = [];
ud.NewObj = [];
ud.hMod = [];
if strcmp(ud.Button,'alt')
    set(ud.hLine,'XData',[],'YData',[])
end
set(hFig,'UserData',ud)
return

%----------------------------------------------------------
function clean
hFig = get(0,'CurrentFigure');
hAx = get(hFig,'CurrentAxes');
setptr(hFig,'arrow')
ud = get(hFig,'UserData');
Button = get(hFig,'SelectionType');
if strcmpi(Button,'alt')& ~isempty(ud.hObj) %rotate from any point
    BtnDown
    return
end
set(hFig,'WindowButtonMotionFcn','', ...
    'WindowButtonUpFcn','', ...
    'WindowButtonDownFcn','')
set(hAx,'ButtonDownFcn', ...
    'editingtool(''clean'')')
h = get(hAx,'Children');
set(h,'Selected','Off', ...
    'ButtonDownFcn','editingtool(''BtnDown'')')
ud.hObj = [];
ud.NewObj = [];
ud.hMod = [];
ud.index = [];
set(ud.hSlc,'Visible','Off')
set(hFig,'UserData',ud)
return

%----------------------------------------------------------
function KeyPress(src,evnt,op)
hFig = get(0,'CurrentFigure');
hAx = get(hFig,'CurrentAxes');
ud = get(hFig,'UserData');
% evnt.Key = get(hFig,'CurrentCharacter');
if isempty(ud.hObj) & ~any(strcmpi(evnt.Key,{'d','t'}))
    return
end
switch evnt.Key
    case 'return'
        inspect(ud.hObj)
    case 'delete'
        if ~isempty(ud.hMod)
            xb = get(ud.hMod,'Xdata');
            yb = get(ud.hMod,'Ydata');
            xb(ud.index) = [];
            yb(ud.index) = [];
            set(ud.hMod,'Xdata',xb,'Ydata',yb)
            set(ud.hSlc,'Xdata',[], ...
                'Ydata',[])
        else
            delete(ud.hObj)
            clean
            return
        end
    case 'insert'
        %You can only insert a point in the last selected object
        if ~isempty(ud.hMod)
            ud.hObj = ud.hMod;
            ud.hMod = [];
            set(ud.hObj,'Selected','On')
        else
            ud.hObj = ud.hObj(end);
        end
        set(ud.hObj,'ButtonDownFcn', ...
            'editingtool(''DrawBtnDwnFcn'')')
        setptr(hFig,'add');
    case 'c'
        ud.NewObj = copyobj(ud.hObj,gca);
        set(ud.hObj,'Selected','Off')
        setptr(hFig,'hand')
        set(hFig,'WindowButtonMotionFcn', ...
            'editingtool(''WinBtnMtnFcn'')', ...
            'WindowButtonDownFcn', ...
            'editingtool(''clean'')')
    case 'd'
        clean
        ud.hAx = get(hFig,'CurrentAxes');
        setptr(hFig,'add');
        ud.NewObj = line('Xdata',[],'Ydata',[], ...
            'Color','k','LineStyle','-', ...
            'Marker','o','MarkerFaceColor','k', ...
            'MarkerSize',4);
        set(hFig,'WindowButtonDownFcn', ...
            'editingtool(''DrawBtnDwnFcn'')', ...
            'WindowButtonMotionFcn', ...
            'editingtool(''DrawMtnFcn'')')
        set(hAx,'ButtonDownFcn','')
        h = get(hAx,'Children');
        set(h,'ButtonDownFcn','')
    case 't'
        clean
        xyt = ginput(1);
        text(xyt(1),xyt(2),'','Editing','On')
end
set(hFig,'UserData',ud)
return

%-----------------------------------------------------------
function DrawBtnDwnFcn
hFig = get(0,'CurrentFigure');
setptr(hFig,'add');
ud = get(hFig,'UserData');
% state = uisuspend(hFig);
button = get(hFig,'SelectionType');
pt = get(gca,'CurrentPoint');
%inserting new point in an exiting line
if isempty(ud.NewObj)
    x = get(ud.hObj,'Xdata');
    y = get(ud.hObj,'Ydata');
    if any(strcmpi(button,{'open','normal'}))
        %Insert point after nearest point
        x0 = pt(1,1);
        y0 = pt(1,2);
        dist = sqrt((x0 - x).^2 + (y0 - y).^2);
        [dummy,index] = min(dist);
        x(index+1:end+1) = x(index:end);
        y(index+1:end+1) = y(index:end);
        ud.index = index + 1;
        set(hFig,'WindowButtonDownFcn', ...
            'editingtool(''DrawBtnDwnFcn'')', ...
            'WindowButtonMotionFcn', ...
            'editingtool(''DrawMtnFcn'')')
        set(ud.hObj,'Xdata',x,'Ydata',y, ...
            'ButtonDownFcn','')
    else
        x(ud.index) = [];
        y(ud.index) = [];
        set(ud.hObj,'Xdata',x,'Ydata',y, ...
            'ButtonDownFcn','editingtool(''BtnDown'')')
        set(hFig,'WindowButtonDownFcn','', ...
            'WindowButtonMotionFcn','')
        ud.index = [];
        ud.hObj = [];
    end
else %drawing a new line object
    x = get(ud.NewObj,'Xdata');
    y = get(ud.NewObj,'Ydata');
    switch lower(button)
        case {'open','normal'}
            if isempty(x)
                x(end+1) = pt(1,1);
                y(end+1) = pt(1,2);
            else
                x(end) = pt(1,1);
                y(end) = pt(1,2);
            end
            x(end+1) = NaN;
            y(end+1) = NaN;
            set(ud.NewObj,'Xdata',x,'Ydata',y)
        case {'extend','alt'}
            set(ud.NewObj,'Xdata',x(1:end-1),'Ydata',y(1:end-1))
            clean
    end %switch
end %if
% uirestore(state);
set(hFig,'UserData',ud)
return

%-----------------------------------------------------------
function DrawMtnFcn
hFig = get(0,'CurrentFigure');
ud = get(hFig,'UserData');
pt = get(ud.hAx,'CurrentPoint');
if isempty(ud.NewObj) %inserting new point in an exiting line
    x = get(ud.hObj,'Xdata');
    y = get(ud.hObj,'Ydata');
    x(ud.index) = pt(1,1);
    y(ud.index) = pt(1,2);
    set(ud.hObj,'Xdata',x,'Ydata',y)
else %drawing a new line object
    x = get(ud.NewObj,'Xdata');
    y = get(ud.NewObj,'Ydata');
    if isempty(x)
        return
    end %if
    x(end) = pt(1,1);
    y(end) = pt(1,2);
    set(ud.NewObj,'Xdata',x,'Ydata',y)
end %if
return

%-----------------------------------------------------------
function WinBtnMtnFcn
hFig = get(0,'CurrentFigure');
ud = get(hFig,'UserData');
CurrentPoint = get(ud.hAx,'CurrentPoint');
LastPoint = ud.CurrentPoint;
NewObjType = get(ud.NewObj,'Type');
n = length(ud.NewObj);
if n==1
     NewObjType = {NewObjType};   
end
dx = CurrentPoint(1,1) - LastPoint(1,1);
dy = CurrentPoint(1,2) - LastPoint(1,2);
for k=1:n
    switch NewObjType{k}
        case 'line'
            x = get(ud.NewObj(k),'XData') + dx;
            y = get(ud.NewObj(k),'YData') + dy;
            set(ud.NewObj(k),'XData',x,'YData',y)
        case 'text'
            pos = get(ud.NewObj(k),'Position');
            x = pos(1) + dx;
            y = pos(2) + dy;
            set(ud.NewObj(k),'Position',[x,y])
    end %switch
end %for
ud.CurrentPoint = CurrentPoint;
set(hFig,'UserData',ud)
return

%-----------------------------------------------------------
function On
hFig = get(0,'CurrentFigure');
set(0,'DefaultLineCreateFcn','editingtool(''CreateFcn'')')
set(0,'DefaultTextCreateFcn','editingtool(''CreateFcn'')')
if isempty(hFig)
    return
end
ud = get(hFig,'UserData');
ud.hAx = get(hFig,'CurrentAxes');
set(hFig,'DoubleBuffer','On', ...
    'KeyPressFcn',@KeyPress)
%    'KeyPressFcn','editingtool(''KeyPress'')') %older releases
%ud.hAx = get(hFig,'CurrentAxes');
hAx = findobj(get(hFig,'Children'),'Type','Axes');
set(hAx,'XLimMode','manual','YLimMode','manual', ...
    'ButtonDownFcn','editingtool(''clean'')')
ud.manual = 'On';
ud.hSlc = line('Xdata',[],'Ydata',[]);
ud.index = [];
ud.hObj = [];
ud.hMod = [];
ud.NewObj = [];
set(hFig,'UserData',ud)
h = get(hAx,'Children');
if iscell(h)
    h = cell2mat(h);
end
set(h,'ButtonDownFcn','editingtool(''BtnDown'')')
return

%---------------------------------------------------------
function CreateFcn
h = get(0,'CallbackObject');
set(h,'ButtonDownFcn','editingtool(''On'')')
return

%-----------------------------------------------------------
function Off
hFig = get(0,'CurrentFigure');
ud = get(hFig,'UserData');
hAx = findobj(get(hFig,'Children'),'Type','Axes');
set(hAx,'XLimMode','auto','YLimMode','auto', ...
    'ButtonDownFcn',[]')
ud.manual = 'Off';
set(hFig,'UserData',ud)
h = get(hAx,'Children');
if iscell(h)
    h = cell2mat(h);
end
set(h,'ButtonDownFcn',[])
set(hFig,'WindowButtonMotionFcn','',...
    'WindowButtonUpFcn','')
set(0,'DefaultLineCreateFcn',[])
set(0,'DefaultTextCreateFcn',[])
return

%-----------------------------------------------------------
function rundemo

subplot(2,1,1)
x = -pi:pi/10:pi;
y = tan(sin(x)) - sin(tan(x));
plot(x,y,'--rs','LineWidth',2,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',3)
hold on
plot(y,-x,'-bo','LineWidth',1,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r',...
    'MarkerSize',5)            
text(pi/2,sin(-pi/4),'\leftarrow sin(-\pi\div4)',...
     'HorizontalAlignment','left')       
 
subplot(2,1,2)  
y = sin(x);
plot(x,y,'b<-')
xlabel('x-axis')
ylabel('y-axis')
title('Title')


return


