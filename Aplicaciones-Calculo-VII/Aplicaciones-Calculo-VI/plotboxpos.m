function pos = plotboxpos(h)
%PLOTBOXPOS Returns the position of the plotted axis region
%
% pos = plotboxpos(h)
%
% This function returns the position of the plotted region of an axis,
% which may differ from the actual axis position, depending on the axis
% limits and data aspect ratio.  The position is returned in the same units
% as the those used to define the axis itself.  This function can only be
% used for a 2D plot.
%
% Variables:
%
%   h:      axis handle of a 2D axis
%   pos:    four-element position vector, in same units as h

% Copyright 2006 Kelly Kearney

axisPos = getInUnits(h, 'Position', 'Pixels');

dx = diff(get(h, 'XLim'));
dy = diff(get(h, 'YLim'));
dar = get(h, 'DataAspectRatio');

plotRatio = (dx/dar(1))/(dy/dar(2));
fullRatio = axisPos(3)/axisPos(4);

if plotRatio > fullRatio
    pos(1) = axisPos(1);
    pos(3) = axisPos(3);
    pos(4) = axisPos(3)/plotRatio;
    pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
else
    pos(2) = axisPos(2);
    pos(4) = axisPos(4);
    pos(3) = axisPos(4) * plotRatio;
    pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
end

temp = axes('Units', 'Pixels', 'Position', pos, 'Visible', 'off');
pos = getInUnits(temp, 'Position', get(h, 'Units'));
delete(temp);