function zoomBoxWindowButtonUpFcn
%zoomBoxWindowButtonUpFcn Removes callbacks when button released.
%
%   Helper function for ZOOMBOX

zoomBoxWindowButtonMotionFcn

rmappdata(gca, 'ZBzoomBoxStartPosition')

set(gcf, 'windowButtonMotionFcn', []);
set(gcf, 'windowButtonUpFcn',     []);
set(gcf, 'pointer', 'arrow');    