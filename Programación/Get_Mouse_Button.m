function [x,y] = Get_Mouse_Button
% 
% [x,y] = Get_Mouse_Button
%
% Waits for a mouse click then return the x and y coordinates of where is
%       was clicked
% Inputs
%        
% Output
%       x - X position of the mouse
%       y - Y position of the mouse
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% check for mouse not already being click
if ~getappdata(gcf,'MouseClicked')
    
    % set callback for mouse down event to resume
    set(gcf,'WindowButtonDownFcn','uiresume');

    % wait for uiresume to be called
    uiwait;
end

% get the xy location of the mouse
[x, y] = Get_Mouse_Location;

% clear the mouse clicked flag
setappdata(gcf,'MouseClicked',0);

% change the callback  back to the original one
set(gcf,'WindowButtonDownFcn','setappdata(gcf,''MouseClicked'',1)');
