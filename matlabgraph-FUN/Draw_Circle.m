function h = Draw_Circle(x, y, radius, varargin)
% 
% h = Draw_Circle(x, y, radius)
% 
% Draws a circle
%
% Inputs
%        x           - X coordinate of the center of the circle
%        y           - Y coordinate of the center of the circle
%        radius      - Radius of the circle
% Optional
%        'Color'     - color of the circle - Default black
%                      colors are 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
%        'Filled'    - A true or false value - Default true
%        'Thickness' - If the circle is not filled this specifies how thick
%                      to make the line - default 0.5
%        'Style'     - A string indicating the style of the lines - Default '-' (Solid)
%                      Other styles are '--' (dashed), ':' (dotted), '-.' (dash-dotted)
%                      Applies to unfilled circles only
% Output
%        h     - Is a handle to the graphics object
%
% Date - 8 Jan 2003
% Author - Lt Col Tom Schorsch
% Modified by Maj Thomas Rathbun

props = Get_Properties(varargin{:});

% set position and width and hieght
bx = x-radius;
by = y-radius;
w = radius*2;
h = radius*2;      

if props.Filled
    h= rectangle('Position',[bx,by,w,h],'Curvature',[1,1],'EdgeColor',props.Color,'FaceColor',props.Color,'LineWidth',5);
else
    h= rectangle('Position',[bx,by,w,h],'Curvature',[1,1],'LineWidth',props.Thickness,'EdgeColor',props.Color','LineStyle',props.Style);
end    