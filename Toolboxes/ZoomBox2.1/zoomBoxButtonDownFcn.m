function zoomBoxButtonDownFcn(updateOnlyBox)
%zoomBoxButtonDownFcn Gets cursor position, sets new callbacks.
% 
%   Helper function for ZOOMBOX
if (nargin == 0)
    continualUpdate = 1
end

set(gcf, 'pointer', 'fleur');
setappdata(gca,'ZBzoomBoxStartPosition',get(gca,'currentpoint'));

set(gcf, 'windowButtonMotionFcn', ['zoomBoxWindowButtonMotionFcn(' num2str(updateOnlyBox) ')']);
set(gcf, 'windowButtonUpFcn',     'zoomBoxWindowButtonUpFcn;');

