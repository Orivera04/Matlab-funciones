function h = Draw_Polygon(x,y, varargin)
% 
% h = Draw_Polygon(x,y)
% 
% Draws a polygon
%
% Inputs
%        x             - An array of X coordinate for the points in the polygon
%        y             - An array of Y coordinate for the points in the polygon
% Optional
%        'Color'       - color of the circle - Default black
%                        colors are 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
%        'Filled'      - A true or false value - Default true
%        'Thickness'   - If the circle is not filled this specifies how thick
%                        to make the line - Default 0.5
%        'Style'       - A string indicating the style of the lines - Default '-' (Solid)
%                        Other styles are '--' (dashed), ':' (dotted), '-.' (dash-dotted)
%                        Applies to unfilled circles only
%        
% Output
%        h     - Is a handle to the graphics object
%
% Date - 8 Jan 2003
% Created by Maj Thomas Rathbun

props = Get_Properties(varargin{:});

x(end+1) = x(1);
y(end+1) = y(1);

if props.Filled
    h = fill(x, y,props.Color,'LineWidth',5,'EdgeColor',props.Color);    % fill the polygon
else
    h = line(x, y, 'color', props.Color, 'LineWidth', props.Thickness,'LineStyle',props.Style);     % draw the polygon outline
end    
