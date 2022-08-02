function newlim = xregrbline(xyaxis,startpos)
%XREGRBLINE - a bit like rbbox, but in x or y direction only
% xregrbline(xyaxis) - waits for mouse press on current axis
% xregrbline(xyaxis, startpos)
% xyaxis - a string 'x' and 'y' specifying which direction to draw line
% startpos - 4 element vector [x y width height]

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:34:34 $


% get all the axis/figure settings
if nargin==1
    try
        pt = get(gca, 'CurrentPoint');
        startpos = [pt(1,1:2), 0,0];
    catch
        % figure was deleted
        newlim = [NaN, NaN];
        return;
    end
end

lineH = i_drawline(startpos, xyaxis);

store.motion = get(gcf,'WindowButtonMotionFcn');
store.up  = get(gcf,'WindowButtonUpFcn');

set(gcf, 'WindowButtonMotionFcn', {@i_motiontracker, lineH, xyaxis});
set(gcf, 'WindowButtonUpFcn', {@i_finishline, lineH, store});

uiwait; % wait for button up

l = lineH(2);
x = get(l, 'Xdata');
y = get(l, 'Ydata');

switch xyaxis
case 'x'
  newlim = [min(x), max(x)];
case 'y'
    newlim = [min(y), max(y)];
end

% get rid of the lines
delete(lineH);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lineH = i_drawline(startpos, xyaxis)

ydelta = 0;
xdelta = 0;
X = startpos(1);
Y = startpos(2);
width = startpos(3);
height = startpos(4);

[deltax,deltay] = i_calcdelta;

switch xyaxis
case 'x'
    ydelta = deltay;
    height = 0;
case 'y'
    xdelta = deltax;
    width = 0;
end

% draw lines

% left hand end
linepts = [X-xdelta X+xdelta; Y-ydelta, Y+ydelta];
lineH(1)  = line('Parent',gca,...
    'XData',linepts(1,1:2),...
    'YData',linepts(2,1:2));

% the line
linepts = [X, X+width; Y Y+height];
lineH(2)  = line('Parent',gca,...
    'XData',linepts(1,1:2),...
    'YData',linepts(2,1:2));

% the rh end
linepts = [X+width-xdelta, X+width+xdelta; Y+height-ydelta, Y+height+ydelta];
lineH(3)  = line('Parent',gca,...
    'XData',linepts(1,1:2),...
    'YData',linepts(2,1:2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_updateline(lineH, newPos, xyaxis)

oldX = get(lineH(2), 'XData');
oldY = get(lineH(2), 'YData');

switch xyaxis
case 'x'
    
    addX = newPos(1);
    newX = [oldX, addX];

    % remove x points that are outside the range (oldX(1), newX)
    startX = oldX(1);
    minX = min(startX, addX);
    maxX = max(startX, addX);
    removeX = (newX<minX) | (newX>maxX);
    removeX(1) = 0;
    removeY = false(size(newX));
    newY = [oldY, oldY(1)]; 
    set(lineH(3), 'XData', [newX(end), newX(end)]);
case 'y'

    addY = newPos(2);
    newY = [oldY, addY];
    
    % remove y points that are outside the range (oldY(1), newY)
    startY = oldY(1);
    minY = min(startY, addY);
    maxY = max(startY, addY);
    removeY = (newY<minY) | (newY>maxY);
    removeY(1) = 0;
    removeX = false(size(newY));
    newX = [oldX, oldX(1)];
    set(lineH(3), 'YData',[newY(end), newY(end)]);
end
%
%;

newX(removeX) = []; newY(removeX) = [];
newX(removeY) = []; newY(removeY) = [];

set(lineH(2), 'XData', newX, 'YData', newY);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_finishline(src, evt, lineH, store)

set(gcf, 'WindowButtonMotionFcn', store.motion);
set(gcf, 'WindowButtonUpFcn',store.up);
uiresume;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_motiontracker(src, evt, lineH, xyaxis)
currPos = get(gca,'CurrentPoint');
currPos = currPos(1,1:2);
i_updateline(lineH, currPos, xyaxis);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [deltax,deltay] = i_calcdelta

oldunits=get(gca,'Units');
set(gca,'Units', 'pixel');
apos = get(gca,'Position');
set(gca,'Units', oldunits);

deltapix  = 5;
deltax = (deltapix*diff(get(gca,'Xlim')))/apos(3);                        
deltay = (deltapix*diff(get(gca,'Ylim')))/apos(4);   