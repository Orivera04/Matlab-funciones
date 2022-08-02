function h = Draw_Ellipse(x1, y1, x2, y2, varargin)
% 
% h = Draw_Ellipse(x1, y1, x2, y2)
%
% Draws an Ellipse
%
% Inputs
%        x1          - X coordinate of the lower left bounding box
%        y1          - Y coordinate of the lower left bounding box
%        x2          - X coordinate of the upper right bounding box
%        y2          - Y coordinate of the uooer right bounding box
% Optional
%        'Color'     - color of the circle - Default black
%                      colors are 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
%        'Filled'    - A true or false value - Default true
%        'Thickness' - If the circle is not filled this specifies how thick
%                      to make the line - Default 0.5
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
if x1 > x2
    t=x1;
    x1=x2;
    x2=t;
end
if y1 > y2
    t=y1;
    y1=y2;
    y2=t;
end
w = x2-x1;
h = y2-y1;     

if props.Filled
    h= rectangle('Position',[x1,y1,w,h],'Curvature',[1,1],'EdgeColor',props.Color,'FaceColor',props.Color,'LineWidth',5);
else
    h= rectangle('Position',[x1,y1,w,h],'Curvature',[1,1],'LineWidth',props.Thickness,'EdgeColor',props.Color,'LineStyle',props.Style);
end    