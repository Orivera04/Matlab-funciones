function varargout = shapes_propGUI(varargin)
%
%   GUI to draw different geometric shapes and calculate/display their properties.
%   Please start with 'shapes_proGUI' at command window.
%   
%   There are options to draw three different shapes, which include
%   1) Polygon
%   2) Circle 
%   3) Square/Rectangle
%
%   These shapes may be drawn within the axis limits using mouse left-click for 
%   a new edge and right-click to close the shape in case of polygons. In case 
%   of a circle only two points are needed. These are the points defining the 
%   diameter of the circle. In case of a square or rectangle, the first and second points 
%   indicate the end points of the diagonal. 
%   The first shape is considered as a basis on which any subsequent shapes
%   are drawn as holes. Holes must lie entirely within the base shape. 
%   
%   In the current version of this GUI, the following properties are calculated and
%   displyed.
%   
%   1) Area               (A)
%   2) Center of Gravity  (xs,ys)
%   3) Perimeter          (P)
%   4) Area Moments       (Ix,Iy,Ixy)
%   5) Centroidal Moments (Iu,Iv,Iuv)
%   6) Polar Moment       (Ip)
%   7) Radius of Gyration (ix,iy)
%
%   See INFO for more detailed explanation.

% Author     : Mirza Faisal Baig
% Version    : 1.0
% Date       : March 9, 2004
%
% Variable/Button definitions within the GUIDE:
%
% Options        : Pop down menu with grid and axis limits options
% Draw           : Pop down menu with different shapes drawing option
% Polygon        : Push Button. To draw polygon
% Circle         : Push Button. To draw circle
% Square/Rect.   : Push Button. To draw square or rectangle 
% Compute        : Push Button. To calculate and display the properties of the shape
% CLEAR          : Push Button. To clear and reset
% INFO           : Push Button. To display help
% CLOSE          : Push Button. To close the application


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @shapes_propGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @shapes_propGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% ------------------------------------------------------------------------
function shapes_propGUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
movegui(hObject,'onscreen')             % To display application onscreen
movegui(hObject,'center')               % To display application in the center of screen

set(handles.gridopt,'checked','on');    % Check the grid option on initailly
XLimit = [-10 10];                        % x-axis limits
YLimit = [-10 10];                        % y-axis limits
setspacing(hObject, eventdata,handles,XLimit,YLimit,1,1); % function to set the grid spacing
set(handles.draw_hole,'Visible','Off'); % Make text 'Draw Hole' invisible initially
set(handles.compute,'Enable','Off');    % Disable the compute button
handles.shapes.prop = [];
handles.xp = [];
handles.yp = [];

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = shapes_propGUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in infobutton.
function infobutton_Callback(hObject, eventdata, handles)
open('shapes_propGUI_help.html'); % Open the help file

% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
close(gcbf) % to close GUI

% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
cla;                                   % Clear figure
XLimit = get(handles.axes1,'Xlim');    % Get x-axis limits
YLimit = get(handles.axes1,'Ylim');    % Get y-axis limits
XF = diff(get(handles.axes1,'Xtick')); % x-axis spacing
YF = diff(get(handles.axes1,'Ytick')); % y-axis spacing
setspacing(hObject, eventdata,handles,XLimit,YLimit,XF(1),YF(1)); % set x- and y-axis spacing
set(handles.flag1,'String','1');       % Flag to indicate the number of shapes drawn
set(handles.draw_hole,'Visible','Off');% Make 'Draw Hole' text invisible
set(handles.compute,'Enable','Off');   % Disable the compute button
handles.shapes = [];
handles.xp = [];
handles.yp = [];
guidata(hObject, handles);

% --------------------------------------------------------------------
function gridopt_Callback(hObject, eventdata, handles)
if strcmp(get(handles.gridopt,'checked'),'on')
    set(handles.gridopt,'checked','off')           % To uncheck the grid option
    set(handles.axes1,'XGrid','Off','YGrid','Off') % Make the grid invisible
else 
    set(handles.gridopt,'checked','on')            % To check the grid option
    set(handles.axes1,'XGrid','On','YGrid','On')   % Make the grid visible
end

% --------------------------------------------------------------------
function gridspace_Callback(hObject, eventdata, handles)

SpacingText = {'X-Axis Spacing:','Y-Axis Spacing:'}; % Text to display on the dialog box
XLimit = get(handles.axes1,'XLim');      % x-axis limits
YLimit = get(handles.axes1,'YLim');      % y-axis limits
XF = diff(get(handles.axes1,'Xtick'));   % x-axis spacing
YF = diff(get(handles.axes1,'Ytick'));   % y-axis spacing
% Text to diaplay on the dialog box
XYSpacingText = {[ num2str(XLimit(1)) ':' num2str(XF(1)) ':' num2str(XLimit(2)) ], ...
                 [ num2str(YLimit(1)) ':' num2str(YF(1)) ':' num2str(YLimit(2)) ]};

% Input Dialog box to enter the grid spacing
XYSpacing  = inputdlg(SpacingText,'Grid Spacing',1,XYSpacingText,'On');
if ~isempty(XYSpacing)
    X1 = XYSpacing{1};       % User defined x-axis spacing and limits
    X1(find(X1)==':') = ' '; 
    X1 = str2num(X1);        % Convert from string to number
    XF = diff(X1);           % x-axis spacing factor
    Y1 = XYSpacing{2};       % User defined y-axis spacing and limits
    Y1(find(Y1)==':') = ' ';
    Y1 = str2num(Y1);        % Convert from string to number
    YF = diff(Y1);           % y-axis spacing factor
    % set the spacing using setspacing function
    setspacing(hObject, eventdata,handles,[X1(1) X1(end)],[Y1(1) Y1(end)],XF(1),YF(1))
end

% --------------------------------------------------------------------
function gridsnap_Callback(hObject, eventdata, handles)
if strcmp(get(handles.gridsnap,'checked'),'on')
    set(handles.gridsnap,'checked','off') % To uncheck the snap option in the options menu
else
    set(handles.gridsnap,'checked','on')  % To check the snap option in the options menu
end

% --------------------------------------------------------------------
function axeslimits_Callback(hObject, eventdata, handles)
XYText = {'X-Axis Range:','Y-Axis Range:'}; % Text to display on the dialog box
XLimit = get(handles.axes1,'XLim');         % Get the current x-axis limit
YLimit = get(handles.axes1,'YLim');         % Get the current y-axis limit
DefaultXYLimits = {['[' num2str(XLimit) ']'],['[' num2str(YLimit) ']']}; % Default limits
XYLimits  = inputdlg(XYText,'Axes Limits',1,DefaultXYLimits,temp1); % Input dislog box to enter the limits

% Check the condition whether the new values are entered by user
if ~isempty(XYLimits),
    XLimit = str2num(XYLimits{1});         % Convert string to number for the x-axis limit
    YLimit = str2num(XYLimits{2});         % Convert string to number for the y-axis limit
    XF = diff(get(handles.axes1,'Xtick')); % x-axis spacing factor
    YF = diff(get(handles.axes1,'Ytick')); % y-axis spacing factor
    % set the limits using the setspacing function
    setspacing(hObject, eventdata,handles,XLimit,YLimit,XF(1),YF(1));
end

% --------------------------------------------------------------------
function drawpoly_Callback(hObject, eventdata, handles)

XLimit = get(handles.axes1,'Xlim');    % Get the current x-axis limit
YLimit = get(handles.axes1,'Ylim');    % Get the current y-axis limit
XF = diff(get(handles.axes1,'Xtick')); % x-axis spacing factor
YF = diff(get(handles.axes1,'Ytick')); % y-axis
i=1; 
finish=1;
while finish == 1,
  [x1(i),y1(i),b(i)]=ginput(1);
  if b(i) == 3,
      break
  end
  if strcmp(get(handles.gridsnap,'checked'),'on'),
      [x(i),y(i)] = snap_to_grid(hObject, eventdata, handles,x1(i),y1(i));
  else
      x(i) = x1(i); y(i) = y1(i);
  end
  if i==1,
      plot(x(i),y(i),'b+');
      setspacing(hObject, eventdata,handles,XLimit,YLimit,XF(1),YF(1))
      hold on
  else
      plot(x(i),y(i),'b+')
      plot([x(i-1);x(i)],[y(i-1);y(i)],'k-')
  end
  i=i+1;
end
conflag1 = str2num(get(handles.flag1,'String'));
handles.shapes(conflag1).prop = calculate_prop(x,y);
display_msg = 0;
if conflag1 == 1,
    xp{conflag1} = num2str([x]);
    yp{conflag1} = num2str([y]);
    set(handles.xbuffer,'String',(xp))
    set(handles.ybuffer,'String',(yp))
else
    xp = get(handles.xbuffer,'String');
    yp = get(handles.ybuffer,'String');
    check_inside_poly = inpolygon(x,y,str2num(xp{1}),str2num(yp{1}));
    if all(check_inside_poly) == 1,
        xp{conflag1} = num2str([x]);
        yp{conflag1} = num2str([y]);
    else
        conflag1 = conflag1-1;
        display_msg = 1;
    end
    set(handles.xbuffer,'String',xp)
    set(handles.ybuffer,'String',yp)
end
set(handles.flag1,'String',num2str(conflag1+1));
cla,
xp2 = [];
yp2 = [];
for i = 1:length(xp)
    tempxp2 = str2num(xp{i});
    tempyp2 = str2num(yp{i});
    if isempty(xp2)
        xp2 = [xp2 tempxp2 tempxp2(1)];
        yp2 = [yp2 tempyp2 tempyp2(1)];
    else
        xp2 = [xp2 tempxp2 tempxp2(1) xp2(1)];
        yp2 = [yp2 tempyp2 tempyp2(1) yp2(1)];
    end
end
xp1_len = length(str2num(xp{1}));

fill(xp2(:),yp2(:),'r','EdgeColor','none');
for i = 1:length(xp)
    tempxp2 = str2num(xp{i});
    tempyp2 = str2num(yp{i});
    plot([tempxp2 tempxp2(1)],[tempyp2 tempyp2(1)],'k')
end
handles.xp = xp2;
handles.yp = yp2;
set(handles.compute,'Enable','ON')
set(handles.draw_hole,'Visible','ON')
if display_msg == 1,
    msgbox(['Only holes within the first geometry are allowed in this version. Please redraw the hole.'] ,...
        'Warning','None','modal');
end
guidata(hObject,handles)

% --------------------------------------------------------------------
function drawcircle_Callback(hObject, eventdata, handles)

XLimit = get(handles.axes1,'Xlim');
YLimit = get(handles.axes1,'Ylim');
XF = diff(get(handles.axes1,'Xtick'));
YF = diff(get(handles.axes1,'Ytick'));
[x1,y1] = ginput(1);
if strcmp(get(handles.gridsnap,'checked'),'on'),
    [x1,y1] = snap_to_grid(hObject, eventdata, handles,x1,y1);
end
plot(x1,y1,'+')
setspacing(hObject, eventdata,handles,XLimit,YLimit,XF(1),YF(1))
hold on
[x2,y2] = ginput(1);
if strcmp(get(handles.gridsnap,'checked'),'on'),
    [x2,y2] = snap_to_grid(hObject, eventdata, handles,x2,y2);
end
plot(x2,y2,'+')
x_center = (x1+x2)/2;
y_center = (y1+y2)/2;
radius = sqrt((x1-x2)^2+(y1-y2)^2)/2;
theta = [0:0.02:2*pi];  
x = x_center + radius*cos(theta);
y = y_center + radius*sin(theta);
conflag1 = str2num(get(handles.flag1,'String'));
handles.shapes(conflag1).prop = calculate_prop(x,y);

display_msg = 0;
if conflag1 == 1,
    xp{conflag1} = num2str([x]);
    yp{conflag1} = num2str([y]);
    set(handles.xbuffer,'String',(xp))
    set(handles.ybuffer,'String',(yp))
else
    xp = get(handles.xbuffer,'String');
    yp = get(handles.ybuffer,'String');
    check_inside_poly = inpolygon(x,y,str2num(xp{1}),str2num(yp{1}));
    if all(check_inside_poly) == 1,
        xp{conflag1} = num2str([x]);
        yp{conflag1} = num2str([y]);
    else
        conflag1 = conflag1-1;
        display_msg = 1;
    end
    set(handles.xbuffer,'String',xp)
    set(handles.ybuffer,'String',yp)
end
set(handles.flag1,'String',num2str(conflag1+1));
cla,
xp2 = [];
yp2 = [];
for i = 1:length(xp),
    tempxp2 = str2num(xp{i});
    tempyp2 = str2num(yp{i});
    if isempty(xp2),
        xp2 = [xp2 tempxp2 tempxp2(1)];
        yp2 = [yp2 tempyp2 tempyp2(1)];
    else
        xp2 = [xp2 tempxp2 tempxp2(1) xp2(1)];
        yp2 = [yp2 tempyp2 tempyp2(1) yp2(1)];
    end
end
fill(xp2(:),yp2(:),'r','EdgeColor','none');
for i = 1:length(xp),
    tempxp2 = str2num(xp{i});
    tempyp2 = str2num(yp{i});
    plot([tempxp2 tempxp2(1)],[tempyp2 tempyp2(1)],'k')
end
set(handles.compute,'Enable','ON')
set(handles.draw_hole,'Visible','ON')

if display_msg == 1,
    msgbox(['Only holes within the first geometry are allowed in this version.  Please redraw the hole.'] ,...
        'Warning','None','modal')
end
handles.xp = xp2;
handles.yp = yp2;
guidata(hObject,handles)

% --------------------------------------------------------------------
function drawsquare_Callback(hObject, eventdata, handles)

XLimit = get(handles.axes1,'Xlim');
YLimit = get(handles.axes1,'Ylim');
XF = diff(get(handles.axes1,'Xtick'));
YF = diff(get(handles.axes1,'Ytick'));
[x(1),y(1)] = ginput(1);
if strcmp(get(handles.gridsnap,'checked'),'on'),
    [x(1),y(1)] = snap_to_grid(hObject, eventdata, handles,x(1),y(1));
end
plot(x(1),y(1),'+')
setspacing(hObject, eventdata,handles,XLimit,YLimit,XF(1),YF(1))
hold on
[x(2),y(2)] = ginput(1);
if strcmp(get(handles.gridsnap,'checked'),'on'),
    [x(2),y(2)] = snap_to_grid(hObject, eventdata, handles,x(2),y(2));
end
plot(x(2),y(2),'+')
area_square = abs(x(1)-x(2))*abs(y(1)-y(2));
x = [x(1) x(2) x(2) x(1)];
y = [y(1) y(1) y(2) y(2)];
conflag1 = str2num(get(handles.flag1,'String'));
handles.shapes(conflag1).prop = calculate_prop(x,y);

display_msg = 0;
if conflag1 == 1,
    xp{conflag1} = num2str([x]);
    yp{conflag1} = num2str([y]);
    set(handles.xbuffer,'String',(xp))
    set(handles.ybuffer,'String',(yp))
else
    xp = (get(handles.xbuffer,'String'));
    yp = (get(handles.ybuffer,'String'));
    check_inside_poly = inpolygon(x,y,str2num(xp{1}),str2num(yp{1}));
    if all(check_inside_poly) == 1 
        xp{conflag1} = num2str([x]);
        yp{conflag1} = num2str([y]);
        display_msg = 0;
    else
        conflag1 = conflag1-1;
        display_msg = 1;
    end
    set(handles.xbuffer,'String',xp)
    set(handles.ybuffer,'String',yp)
end
set(handles.flag1,'String',num2str(conflag1+1));
cla,
xp2 = [];
yp2 = [];
for i = 1:length(xp),
    tempxp2 = str2num(xp{i});
    tempyp2 = str2num(yp{i});
    if isempty(xp2),
        xp2 = [xp2 tempxp2 tempxp2(1)];
        yp2 = [yp2 tempyp2 tempyp2(1)];
    else
        xp2 = [xp2 tempxp2 tempxp2(1) xp2(1)];
        yp2 = [yp2 tempyp2 tempyp2(1) yp2(1)];
    end
end
fill(xp2(:),yp2(:),'r','EdgeColor','none');
for i = 1:length(xp),
    tempxp2 = str2num(xp{i});
    tempyp2 = str2num(yp{i});
    plot([tempxp2 tempxp2(1)],[tempyp2 tempyp2(1)],'k')
end
handles.xp = xp2;
handles.yp = yp2;

set(handles.compute,'Enable','ON')
set(handles.draw_hole,'Visible','ON')
if display_msg == 1,
    msgbox(['Only holes within the first geometry are allowed in this version. Please redraw the hole.'] ,...
        'Warning','None','modal')
end
guidata(hObject,handles)

% ------------------------------------------------------------------------
function setspacing(hObject, eventdata, handles,XLimit,YLimit,XF,YF)

xspacing = XLimit(1):XF:XLimit(2);
set(handles.axes1,'XLim',[XLimit(1) XLimit(2)])
set(handles.axes1,'XTick',xspacing)

yspacing = YLimit(1):YF:YLimit(2);
set(handles.axes1,'YLim',[YLimit(1) YLimit(2)])
set(handles.axes1,'YTick',yspacing)
if strcmp(get(handles.gridopt,'checked'),'on')
    set(handles.axes1,'XGrid','On','YGrid','On')
else
    set(handles.axes1,'XGrid','Off','YGrid','Off')
end

% -------------------------------------------------------------------------
function [resx,resy] = snap_to_grid(hObject, eventdata, handles,x,y)

XLimit = get(handles.axes1,'XLim');
YLimit = get(handles.axes1,'YLim');
XTicks = get(handles.axes1,'XTick');
YTicks = get(handles.axes1,'YTick');

resx=XTicks(find(min(abs(XTicks-x))==abs(XTicks-x)));
resx=resx(1);
resx=sort([xlim resx]); 
resx=(resx(2));

resy=YTicks(find(min(abs(YTicks-y))==abs(YTicks-y)));
resy=(resy(1));
resy=sort([ylim resy]);
resy=(resy(2));

% -------------------------------------------------------------------------
function compute_Callback(hObject, eventdata, handles)
NoOfShapes = length(handles.shapes);
for i = 1:NoOfShapes,
    PropMatrix(i,:) = handles.shapes(i).prop;
end
AreaVector = PropMatrix(:,1);
XsYsMatrix = PropMatrix(:,2:3);
PVector = PropMatrix(:,4);
AreaMomentMatrix = PropMatrix(:,5:7);

if NoOfShapes > 1
    P = sum(PVector);
    AreaShape = AreaVector(1)-sum(AreaVector(2:end));
    xsholes = sum(AreaVector(2:end).*XsYsMatrix(2:end,1));
    ysholes = sum(AreaVector(2:end).*XsYsMatrix(2:end,2));
    xs = (AreaVector(1).*XsYsMatrix(1,1)-xsholes)/AreaShape;
    ys = (AreaVector(1).*XsYsMatrix(1,2)-ysholes)/AreaShape;
    xis = xs;
    yis = ys;
    AreaMomentXHoles = sum(AreaMomentMatrix(2:end,1));
    AreaMomentYHoles = sum(AreaMomentMatrix(2:end,2));
    AreaMomentXYHoles = sum(AreaMomentMatrix(2:end,3));
    AreaMomentX = (AreaMomentMatrix(1,1))-AreaMomentXHoles;
    AreaMomentY = (AreaMomentMatrix(1,2))-AreaMomentYHoles;
    AreaMomentXY = (AreaMomentMatrix(1,3))-AreaMomentXYHoles;
    CentroidalMomentX = (AreaMomentX-AreaShape*yis(1).^2);
    CentroidalMomentY = (AreaMomentY-AreaShape*xis(1).^2);
    CentroidalMomentXY = (AreaMomentXY-AreaShape*xis(1)*yis(1));
else
    AreaShape = AreaVector(1);
    xs = XsYsMatrix(1,1);
    ys = XsYsMatrix(1,2);
    xis = xs;
    yis = ys;
    P = PVector;
    AreaMomentX = AreaMomentMatrix(1,1);
    AreaMomentY = AreaMomentMatrix(1,2);
    AreaMomentXY = AreaMomentMatrix(1,3);
    CentroidalMomentX = AreaMomentX-AreaShape*yis(1)^2;
    CentroidalMomentY = AreaMomentY-AreaShape*xis(1)^2;
    CentroidalMomentXY = AreaMomentXY-AreaShape*xis(1)*yis(1);
end

PolarMoment = AreaMomentX+AreaMomentY;
plot(xs,ys,'bx','lineWidth',2)

RadiusOfGyrationX = sqrt(AreaMomentX/AreaShape);
RadiusOfGyrationY = sqrt(AreaMomentY/AreaShape);
% Display the calculated shapes properties
msgbox([sprintf('  Area:  \n') ...
        sprintf('               A = %0.5g\n', ...
        AreaShape) sprintf('\n') sprintf('  Center of Area: \n') ...
        sprintf('               Xs = %0.5g\n', ... 
        xs) ...
        sprintf('               Ys = %0.5g\n', ...
        ys) sprintf('\n') sprintf('  Perimeter: \n') ...
        sprintf('               P = %0.5g\n', ...
        P) sprintf('\n') sprintf('  Area Moments: \n') ...
        sprintf('               Ix = %0.5g\n', ...
        AreaMomentX) ... 
        sprintf('               Iy = %0.5g\n', ...
        AreaMomentY) ...
        sprintf('               Ixy = %0.5g\n',...
        AreaMomentXY) sprintf('\n') sprintf('  Centroidal Moments: \n') ...
        sprintf('               Iu = %0.5g\n', ...
        CentroidalMomentX) ...
        sprintf('               Iv = %0.5g\n', ...
        CentroidalMomentY) ...
        sprintf('               Iuv = %0.5g\n', ...
        CentroidalMomentXY) sprintf('\n') sprintf('  Polar Moment: \n') ...
        sprintf('               Ip = %0.5g\n' ,...
        PolarMoment) sprintf('\n') sprintf('  Radius of Gyration:                \n') ...
        sprintf('               ix = %0.5g\n',...
        RadiusOfGyrationX) ...
        sprintf('               iy = %0.5g\n ', ...
        RadiusOfGyrationY) sprintf('\n') sprintf('\n')], ...
        'Shape Properties','none','modal');

%--------------------------------------------------------------------------
function res = calculate_prop(x,y) 
% Function to calculate the geometric properties of the shape defined by x
% and y inputs. 
% Output:
%        res = [A  xc  yc  P Ix Iy Ixy]
%
%  Where:
%    A       = Area of the shape
%    (xc,yc) = Center of gravity w.r.t x- and y-axes
%    P       = Perimeter of the shape
%    (Ix,Iy) = Area moments of inertia w.r.t x- and y-axes
%    IxIy    = Area moments of inertia w.r.t z-axis

[x,shifts] = shiftdim(x);   % Make sure x is a column vector
[y,shifts] = shiftdim(y);   % Make sure y is a column vector
[rowx,colx] = size(x);      % Number of rows of x
delta_x = x([2:rowx 1])-x;  % Estimate the difference between first and rest of the values in x or dx
delta_y = y([2:rowx 1])-y;  % Estimate the difference between first and rest of the values in y or dy
tempA = y.*delta_x-x.*delta_y; 
A = sum(tempA)/2;      % Area of the shape
tempSx = 6*x.*y.*delta_x-3*x.*x.*delta_y+3*y.*delta_x.*delta_x+delta_x.*delta_x.*delta_y;
Sx = sum(tempSx)/12;   % First moment of the shape w.r.t x-axis
tempSy = 3*y.*y.*delta_x-6*x.*y.*delta_y-3*x.*delta_y.*delta_y-delta_x.*delta_y.*delta_y;
Sy = sum(tempSy)/12;   % First moment of the shape w.r.t y-axis
tempIx = 2*y.*y.*y.*delta_x-6*x.*y.*y.*delta_y-6*x.*y.*delta_y.*delta_y ...
        -2*x.*delta_y.*delta_y.*delta_y -2*y.*delta_x.*delta_y.*delta_y-delta_x.*delta_y.*delta_y.*delta_y;
Ix = sum(tempIx)/12;   % First moment of the shape w.r.t x-axis
tempIy = 6*x.*x.*y.*delta_x -2*x.*x.*x.*delta_y +6*x.*y.*delta_x.*delta_x ...
        +2*y.*delta_x.*delta_x.*delta_x +2*x.*delta_x.*delta_x.*delta_y +delta_x.*delta_x.*delta_x.*delta_y;
Iy = sum(tempIy)/12;   % First moment of the shape w.r.t y-axis
tempIxy = 6*x.*y.*y.*delta_x-6*x.*x.*y.*delta_y+3*y.*y.*delta_x.*delta_x ...
         -3*x.*x.*delta_y.*delta_y+2*y.*delta_x.*delta_x.*delta_y-2*x.*delta_x.*delta_y.*delta_y;
Ixy = sum(tempIxy)/24; % First moment of the shape w.r.t z-axis
tempP = sqrt(delta_x.*delta_x+delta_y.*delta_y);
P = sum(tempP);        % Perimeter of the shape

% To Check for counter clockwise versus clockwise boundaries
if A < 0,
  A = -A;
  Sx = -Sx; Sy = -Sy;
  Ix = -Ix; Iy = -Iy;
  Ixy = -Ixy;
end
xc = Sx/A;  % Center of Gravity w.r.t x-axis
yc = Sy/A;  % Center of Gravity w.r.t y-axis
res = [A  xc  yc  P Ix Iy Ixy];
   
% --------------------------------------------------------------------
function draw_hole_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function pushbutton7_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function optmenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function pushbutton8_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function squaredraw_button_Callback(hObject, eventdata, handles)
drawsquare_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function polydraw_button_Callback(hObject, eventdata, handles)
drawpoly_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function circledraw_button_Callback(hObject, eventdata, handles)
drawcircle_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function flag1_CreateFcn(hObject, eventdata, handles)

% --------------------------------------------------------------------
function flag1_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function xbuffer_CreateFcn(hObject, eventdata, handles)

% --------------------------------------------------------------------
function xbuffer_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ybuffer_CreateFcn(hObject, eventdata, handles)

% --------------------------------------------------------------------
function ybuffer_Callback(hObject, eventdata, handles)