function [xOutput, yOutput] = restrictPointsToLimits(xInput, yInput, xLimits, yLimits)
%restrictPointsToLimits Keeps the points inside the limits plus margin.
%
% Helper function for ZOOMBOX

%Needed to keep zoom box selectable (Axes gets priority if overlap)
horizontalMargin = 0.001 * span(xLimits);
verticalMargin   = 0.020 * span(yLimits);


leftOverhang   = max([0 ((xLimits(1) + horizontalMargin)) - xInput']);
rightOverhang  = max([0 (xInput' - (xLimits(2) - horizontalMargin))]);
topOverhang    = max([0 (yInput' - (yLimits(2) -   verticalMargin))]);
bottomOverhang = max([0 ((yLimits(1) +   verticalMargin)) - yInput']);

xOutput        = xInput - rightOverhang + leftOverhang;
yOutput        = yInput - topOverhang + bottomOverhang;