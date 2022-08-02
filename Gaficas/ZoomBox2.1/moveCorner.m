function moveCorner(hPoint, updateOnlyBox);
%MOVECORNER allows one corner of a box to be moved.
%
%   Helper function to ZOOMBOX. A modification of MOVEPOINT.

if nargin < 2
    continualUpdate = 1;
end

hFcn = @movePointButtonDownFcn;

set(hPoint, 'buttonDownFcn',{hFcn, hPoint, updateOnlyBox});

function movePointButtonDownFcn(h, event, hPoint, updateOnlyBox)

hParentAxes   = get(hPoint,      'parent');
hParentWindow = get(hParentAxes, 'parent');

hFcn = @movePointWindowButtonMotionFcn;
set(hParentWindow, 'windowButtonMotionFcn',{hFcn, hPoint, updateOnlyBox});

hFcn = @movePointWindowButtonUpFcn;
set(hParentWindow, 'windowButtonUpFcn', {hFcn, hPoint});

[foo, bar, quadrant] = findNeighbor(hPoint);

switch quadrant
    case 1
        set(gcf, 'pointer', 'topr');
    case 2
        set(gcf, 'pointer', 'topl');
    case 3
        set(gcf, 'pointer', 'botl');
    case 4
        set(gcf, 'pointer', 'botr');
end


function movePointWindowButtonMotionFcn(h, event, hPoint, updateOnlyBox)

hParentAxes = get(hPoint, 'parent');
currentPoint = get(hParentAxes, 'currentPoint');
x = currentPoint(1,1);
y = currentPoint(1,2);

[horizontalNeighbor, verticalNeighbor] = findNeighbor(hPoint);
parentAxes = get(hPoint,'Parent');
xLimits = get(hParentAxes,'xlim');
yLimits = get(hParentAxes,'ylim');

[x, y] = restrictPointsToLimits(x, y, xLimits, yLimits);

minPercentWidth  = 0.01;
minPercentHeight = 0.05;

needToRefresh = 0;
%Don't want box to get too small.
if isZoomBoxBigEnough('x', x, horizontalNeighbor, minPercentWidth)
    set(  verticalNeighbor, 'xdata', x);
    set(hPoint,'xdata',x);
    needToRefresh = 1;
end

if isZoomBoxBigEnough('y', y,  verticalNeighbor, minPercentHeight)
    set(horizontalNeighbor, 'ydata', y);
    set(hPoint,'ydata',y)
    needToRefresh;
end

if needToRefresh
    refreshAxesAndZoomBoxFromAppData(hParentAxes, updateOnlyBox)
end

function movePointWindowButtonUpFcn(h, event, hPoint);

hParentAxes   = get(hPoint,      'parent');
hParentWindow = get(hParentAxes, 'parent');

set(hParentWindow, 'windowButtonMotionFcn', []);
set(hParentWindow, 'windowButtonUpFcn',     []);
set(gcf, 'pointer', 'arrow');
refreshAxesAndZoomBoxFromAppData(hParentAxes)

function [horizontal_neighbor, vertical_neighbor, quadrant] = findNeighbor(h)

corners = getappdata(gca, 'hZBcorners');

targetXVal  = get(h,       'Xdata');
xVals = cell2mat(get(corners, 'Xdata'));

xMatches = (xVals == targetXVal);

targetYVal  = get(h,       'Ydata');
yVals = cell2mat(get(corners, 'Ydata'));

yMatches = (yVals == targetYVal);

horizontal_index = ~xMatches &  yMatches;
vertical_index =  xMatches & ~yMatches;

horizontal_neighbor = corners(horizontal_index);
vertical_neighbor   = corners(  vertical_index);

isRight = (targetXVal == max(xVals));
isTop   = (targetYVal == max(yVals));

qudrantLookup = [3 4 2 1];

quadrant = qudrantLookup((isTop * 2) + isRight + 1);

function flag = isZoomBoxBigEnough(dimension, currentPosition, neighbor, threshold)

hParentAxis = gca;

switch dimension
    case 'x'
        boxSize = span([get(neighbor, 'xdata'), currentPosition]);
        parentSize = span(get(hParentAxis,'xlim'));
        
    case 'y'
        boxSize = span([get(neighbor, 'ydata'), currentPosition]);
        parentSize = span(get(hParentAxis,'ylim'));
    otherwise
        error ('Valid Arguments for isZoomBoxBigEnough are ''x'' and ''y''. ')
end

percentSize = boxSize/parentSize;
flag = percentSize > threshold;
