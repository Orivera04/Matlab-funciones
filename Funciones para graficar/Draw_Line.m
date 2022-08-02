function h = Draw_Line(x1, y1, x2, y2, varargin)
% 
% h = Draw_Line(x1, y1, x2, y2)
%
% Draws a line
%
% Inputs
%        x1            - X coordinate of the starting point
%        y1            - Y coordinate of the starting point
%        x2            - X coordinate of the stopping point
%        y2            - Y coordinate of the stopping point
% Optional
%        'Color'       - color of the circle - Default black
%                        colors are 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
%        'Thickness'   - If the circle is not filled this specifies how thick
%                        to make the line - Default 0.5
%        "style'       - A string indicating the style of the lines - Default '-' (Solid)
%                        Other styles are '--' (dashed), ':' (dotted), '-.' (dash-dotted)
%                        Applies to unfilled circles only
% Output
%        h     - Is a handle to the graphics object
%
% Date - 8 Jan 2003
% Author - Lt Col Tom Schorsch

props = Get_Properties(varargin{:});


% draw the line
h = line([x1 x2],[y1 y2],'color',props.Color, 'LineWidth', props.Thickness, 'LineStyle', props.Style);