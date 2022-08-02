function [x,y] = Get_mouse_Location
% 
% [x,y] = Get_mouse_Location
% 
% Returns the x and y coordinates ofthe current mouse location
%
% Inputs
%        
% Output
%       x - X position of the mouse
%       y - Y position of the mouse
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% get location from the CurrentPoint property
[xy] = get(gcf,'CurrentPoint');

% separate the x and y values to separate variables
x = xy(1);
y = xy(2);