function bdteditzerocurvegui(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.5 $   $Date: 2002/04/14 21:46:15 $

if (nargin == 0)
     
load bdteditzerocurvegui

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'Position',[300 250 552 460], ...
	'NumberTitle', 'off', ...
	'MenuBar', 'none', ...
	'Name', 'Zero/Spot Curve Editor', ...
   'Tag','SpecZeroCrvGUI');
h1 = axes('Parent',h0, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'CameraUpVectorMode','manual', ...
	'Color',[1 1 1], ...
	'ColorOrder',mat1, ...
	'Position',[48 130 460 272], ...
	'Tag','AxesEditCurve', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4989106753812637 -0.088560885608856 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.06318082788671026 0.4944649446494466 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',mat2, ...
	'Tag','Axes1Text2', ...
	'Visible','off');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',h1, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.4989106753812637 1.025830258302583 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',12, ...
	'FontWeight','bold', ...
	'ForegroundColor',[0 0.501960784313725 1], ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[15 310 200 25], ...
	'String','Input Zero Curve Editor', ...
	'Style','text', ...
	'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'FontSize',9, ...
	'FontWeight','bold', ...
	'ListboxTop',0, ...
	'Position',[285 15 75 25], ...
	'String','Done', ...
     'Tag','Pushbutton1', ...
     'Callback', ...
     ...
     strcat(['MainGUIHandle = findobj(''Tag'', ''MainGUI''); '...
          'UserDataStruct = get(gca, ''UserData''); '...
          'ZeroRates = UserDataStruct.YPoints; '...
          'CurveDates = round(UserDataStruct.XPoints); '...
          '[CurveDates, SortIndex] = sort(CurveDates); '...
          'ZeroRates = ZeroRates(SortIndex); '...
          'ZeroCurve.CurveDates = CurveDates; '...
          'ZeroCurve.ZeroRates = ZeroRates; '...
          'global GZEROCURVE; '...
          'GZEROCURVE = ZeroCurve; '...
          'close(gcf); '...
          'drawnow; '...
          'ZeroCurveAxesHandle = findobj(''Tag'', ''AxesZeroCurve''); '...
          'ZeroCurveLineHandle = findobj(ZeroCurveAxesHandle, ''type'', ''line''); '...
          'axes(ZeroCurveAxesHandle); '...
          'CurveDates = ZeroCurve.CurveDates; '...
          'ZeroRates =ZeroCurve.ZeroRates; '...
          'if isempty(ZeroCurveLineHandle), line(CurveDates, ZeroRates); '...
          'else, set(ZeroCurveLineHandle, ''XData'', CurveDates, ''YData'', ZeroRates); end;'...
          'plotscale(0.10); '...
          'set(gca, ''YLim'', [0 (max(ZeroRates) + 0.03)]);']));
  h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
	'FontSize',9, ...
	'HorizontalAlignment','left', ...
	'ListboxTop',0, ...
	'Position',[15 15 225 40], ...
     'String', ...
     ...
     strcat(['Place mouse pointer on handles, click, and drag to adjust '...
     'curve. Add handles by clicking on line. Remove handles by right ' ...
     'clicking on line.']), ...
     ... 
     'Style','text', ...
     'Tag','StaticText2');

if nargout > 0, fig = h0; end

%Load the zero curve from disk by calling the LDZEROCRV subroutine
global GZEROCURVE;
global GSETTLE;
global GMATURITY;


%Unpack the zero curve to be manipulated
ZeroCurve = GZEROCURVE;

%Unpack the settle and maturity dates
Settle = GSETTLE;
Maturity = GMATURITY;

if (~isempty(ZeroCurve))

     ZeroRates = ZeroCurve.ZeroRates;
     ZeroRates = ZeroRates(:);
     CurveDates = ZeroCurve.CurveDates;
     CurveDates = CurveDates(:);

     %Specify an initial curve to be manipulated
     FirstRate = ZeroRates(1, 1);
     LastRate = ZeroRates(end, 1);
     FirstDate = CurveDates(1, 1);
     LastDate = CurveDates(end, 1);

     WorkCurveDates = linspace(FirstDate, LastDate, 20);
     WorkZeroRates = interp1(CurveDates, ZeroRates, ...
          WorkCurveDates);

else
     WorkCurveDates = linspace(Settle, Maturity, 8);
     WorkZeroRates = [0.05 0.0575 0.06 0.0625 0.0675 0.0715 0.0725 ...
               0.0725]; 
     
end

%Call the curve editor GUI
bdteditzerocurvegui(WorkCurveDates, WorkZeroRates, ...
     [(min(WorkCurveDates)- 10) (max(WorkCurveDates)+ 8) ...
          0 (max(WorkZeroRates) + 0.03)]);


else

if (nargin==1)
  % this is a callback
  Action = varargin{1};
else
  % this is the first function call
  Action = 'Init';
end

%-----------------------------------------------------------------
% switchyard for Actions
%----------------------------------------------------------------
switch Action
  
  case 'Init'
    % called from workspace
    CurveAxes = editcurveinit(varargin{:});
    
  case 'CurveLine'
    % callback from curve ButtonDownFcn
    if (strcmp('alt', get(gcf, 'SelectionType')))
      % right mouse : shift the whole curve
      % editcurvestartshift
    else
      % left mouse : add a control point
      editcurveaddpoint;
    end

  case 'ControlPoint'
    % callback from control point ButtonDownFcn
    if (strcmp('alt', get(gcf, 'SelectionType')))
      % right mouse : delete the control point
      editcurvedelpoint;
    else
      % left mouse : move the control point
      editcurvestartdrag;
    end

  case 'Dragging'
    % callback from figure WindowButtonMotionFcn
    editcurvedrag;
    
  case 'Drop'
    % callback from figure WindowButtonUpFcn
    editcurvedrop;
    
  otherwise
    % user clicked on something inactive
    
end

% adjust the positions of the uicontrols
bdtmainaction('adjustres')

end
%-----------------------------------------------------------------
% end of function EDITCURVE
%-----------------------------------------------------------------

function CurveAxes = editcurveinit(XPoints, YPoints, AxisLimits, XLine)

if nargin<3
  AxisLimits = [min(XPoints), max(XPoints), min(YPoints), max(YPoints)];
end
if nargin<4
  XLine = linspace(AxisLimits(1), AxisLimits(2));
end


CurveAxes = findobj('Tag', 'AxesEditCurve');

CurveData.CurveAxes = CurveAxes;
set(CurveData.CurveAxes, 'XLim', AxisLimits(1:2));
set(CurveData.CurveAxes, 'YLim', AxisLimits(3:4));

% Make an escape: click on the axes
set(CurveAxes, 'ButtonDownFcn', 'bdteditzerocurvegui(''Drop'')' );

% Make the spline fit
CurveData.XPoints = XPoints(:);
CurveData.YPoints = YPoints(:);
CurveData.XLine = XLine;
CurveData.YLine = spline(CurveData.XPoints, CurveData.YPoints, ...
    CurveData.XLine);

Line = line( CurveData.XLine, CurveData.YLine, ...
    'ButtonDownFcn', 'bdteditzerocurvegui(''CurveLine'')', ...
    'EraseMode', 'xor', 'Tag', 'CurveLine');

dtaxis;

CurveData.Line = Line;

% Make draggable control points
Points = zeros(length(XPoints),1);
for iline=1:length(XPoints),
  Points(iline) = line(XPoints(iline), YPoints(iline), ...
      'LineStyle','none', 'Marker','s', 'MarkerSize', 5, ...
      'ButtonDownFcn', 'bdteditzerocurvegui(''ControlPoint'')', ...
      'EraseMode', 'xor', ...
      'Tag', 'ControlPoint', 'UserData', iline );
end
CurveData.Points = Points;
CurveData.DragPoint = [];

set(CurveAxes, 'UserData', CurveData);

%----------------------------------------------------------------------
function editcurveaddpoint
CurveData = get(gca, 'UserData');

% location for a new control point
PointerPos = get(CurveData.CurveAxes, 'CurrentPoint');
XNew = PointerPos(1,1);
YNew = spline(CurveData.XPoints, CurveData.YPoints, XNew);
NNew = length(CurveData.XPoints) + 1;

Point = line(XNew, YNew, ...
      'LineStyle','none', 'Marker','s', 'MarkerSize', 5, ...
      'ButtonDownFcn', 'bdteditzerocurvegui(''ControlPoint'')', ...
      'EraseMode', 'xor', ...
      'Tag', 'ControlPoint', 'UserData', NNew );

CurveData.XPoints = [CurveData.XPoints; XNew];
CurveData.YPoints = [CurveData.YPoints; YNew];
CurveData.Points =  [CurveData.Points; Point];

set(CurveData.CurveAxes, 'UserData', CurveData);

%----------------------------------------------------------------------
function editcurvestartdrag
CurveData = get(gca, 'UserData');

CurveData.DragPoint = get(gcbo,'UserData');
CurveData.OldMotionFcn = get(gcf,'WindowButtonMotionFcn');
CurveData.OldUpFcn = get(gcf,'WindowButtonUpFcn');

set(gcf,'WindowButtonMotionFcn', 'bdteditzerocurvegui(''Dragging'')' );
set(gcf,'WindowButtonUPFcn', 'bdteditzerocurvegui(''Drop'')' );

set(CurveData.CurveAxes, 'UserData', CurveData);

%----------------------------------------------------------------------
function editcurvedrag
CurveData = get(gca, 'UserData');

PointerPos = get(CurveData.CurveAxes, 'CurrentPoint');
YPos = PointerPos(1,2);

PointInd = CurveData.DragPoint;
Point = CurveData.Points( PointInd );

set(Point, 'Ydata', YPos);
CurveData.YPoints( PointInd ) = YPos;

% update the spline
CurveData.YLine = spline(CurveData.XPoints, CurveData.YPoints, ... 
    CurveData.XLine);
set(CurveData.Line, 'YData', CurveData.YLine);

set(CurveData.CurveAxes, 'UserData', CurveData);
%----------------------------------------------------------------------
function editcurvedrop
drawnow;
CurveData = get(gca, 'UserData');

set(gcf,'WindowButtonMotionFcn', CurveData.OldMotionFcn);
set(gcf,'WindowButtonUpFcn', CurveData.OldUpFcn);

%----------------------------------------------------------------------
function editcurvedelpoint
CurveData = get(gca, 'UserData');

Point = gcbo; % handle to marked point
DelPoint = get(Point,'UserData'); % index of marked point

% you can not remove the end control points
if ( (CurveData.XPoints(DelPoint)==max(CurveData.XPoints)) | ...
      (CurveData.XPoints(DelPoint)==min(CurveData.XPoints)) )
  return
end

% remove the point from the lists
CurveData.XPoints(DelPoint) = [];
CurveData.YPoints(DelPoint) = [];
CurveData.Points(DelPoint) = [];

% remove the point from the figure
delete(Point);

% renumber the Userdata indices
for i=1:length(CurveData.Points),
  set(CurveData.Points(i), 'UserData', i);
end

% update the spline
CurveData.YLine = spline(CurveData.XPoints, CurveData.YPoints, ... 
    CurveData.XLine);
set(CurveData.Line, 'YData', CurveData.YLine);

set(CurveData.CurveAxes, 'UserData', CurveData);
