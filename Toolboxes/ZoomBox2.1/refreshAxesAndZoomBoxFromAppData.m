function refreshAxesAndZoomBoxFromAppData(hParentAxes, updateOnlyBox)
%refreshAxesAndZoomBoxFromAppData refreshes screen elements.
%
% Helper function for ZOOMBOX

if nargin < 2
    updateOnlyBox = 0;
end

hCorners = getappdata(hParentAxes, 'hZBcorners');

xValsCell = get(hCorners, 'Xdata');
yValsCell = get(hCorners, 'Ydata');

for i = 1: length(xValsCell)
    xVals(i) = xValsCell{i};
    yVals(i) = yValsCell{i};
end

xMin = min(xVals);
xMax = max(xVals);
yMin = min(yVals);
yMax = max(yVals);

if ~updateOnlyBox
    hChildAxis = getappdata(hParentAxes,'hZBchildAxes');
    set(hChildAxis, 'xlim', [xMin, xMax]);
    set(hChildAxis, 'ylim', [yMin, yMax]);
end

hZoomBox = getappdata(hParentAxes, 'hZBzoomBox');
set(hZoomBox, 'xData', [xMin, xMin, xMax, xMax]);
set(hZoomBox, 'yData', [yMin, yMax, yMax, yMin]);

drawnow