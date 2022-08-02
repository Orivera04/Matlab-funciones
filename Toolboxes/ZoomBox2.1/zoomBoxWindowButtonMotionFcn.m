function zoomBoxWindowButtonMotionFcn(updateOnlyBox);
%zoomBoxWindowButtonMotionFcn Calculates movement of zoom box.
%
%   Helper function for ZOOMBOX

if nargin < 1
    updateOnlyBox = 0;
end

current_axis = gca;

hZoomBox = getappdata(current_axis,'hZBzoomBox');

zoomBoxStartPosition = getappdata(current_axis, 'ZBzoomBoxStartPosition');

currentPosition=get(current_axis,'currentpoint');

delta = currentPosition - zoomBoxStartPosition;

zoomBoxCurrentPositionX = get(hZoomBox,'xData');
zoomBoxCurrentPositionY = get(hZoomBox,'yData');

zoomBoxCurrentPositionX = zoomBoxCurrentPositionX + delta(1,1);
zoomBoxCurrentPositionY = zoomBoxCurrentPositionY + delta(1,2);

zoomBoxWidth  = span(zoomBoxCurrentPositionX);
zoomBoxHeight = span(zoomBoxCurrentPositionY);

xLimits = get(current_axis,'xlim');
yLimits = get(current_axis,'ylim');

[zoomBoxCurrentPositionX, zoomBoxCurrentPositionY] = ...
    restrictPointsToLimits(zoomBoxCurrentPositionX, zoomBoxCurrentPositionY, xLimits, yLimits);

set(hZoomBox,'xData', zoomBoxCurrentPositionX);
set(hZoomBox,'yData', zoomBoxCurrentPositionY);

currentPosition = get(current_axis,'currentpoint');

setappdata(current_axis,'ZBzoomBoxStartPosition',currentPosition);

hCorners = getappdata(current_axis, 'hZBcorners');

for i = 1:4
    set(hCorners(i),'xdata', zoomBoxCurrentPositionX(i),...
        'ydata', zoomBoxCurrentPositionY(i))
end

refreshAxesAndZoomBoxFromAppData(current_axis, updateOnlyBox)

