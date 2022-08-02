function h = Draw_Box(x1, y1, x2, y2, varargin)
% 
% h = Draw_Box(x1, y1, x2, y2)
%
% Draws a box
%
% Inputs
%        x1            - X coordinate of the lower left bounding box
%        y1            - Y coordinate of the lower left bounding box
%        x2            - X coordinate of the upper right bounding box
%        y2            - Y coordinate of the uooer right bounding box
% Optional
%        'color'       - color of the circle - Default black
%                        colors are 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
%        'Filled'      - A true or false value - Default true
%        'Thickness'   - If the circle is not filled this specifies how thick
%                        to make the line - Default 0.5
%        'Style'       - A string indicating the style of the lines - Default '-' (Solid)
%                        Other styles are '--' (dashed), ':' (dotted), '-.' (dash-dotted)
%                        Applies to unfilled circles only
%        'Rounded'     - A 2 value array with values between 0 and 1 - Default [0,0]
%                        Indicates how rounded the corners are. [0,0] is no
%                        round, [1, 1] completely rounded like and elipse
%        
% Output
%        h     - Is a handle to the graphics object
%
% Date - 8 Jan 2003
% Author - Lt Col Tom Schorsch
% Modified by Maj Thomas Rathbun

props = Get_Properties(varargin{:});
   
% switch values if not in lower left upper right format
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

% calculate width and heigth
w = x2-x1;
h = y2-y1;

% draw box
if props.Filled
    h= rectangle('Position',[x1,y1,w,h],'Curvature',props.Rounded,'EdgeColor',props.Color,'FaceColor',props.Color,'LineWidth',5);
else
    h= rectangle('Position',[x1,y1,w,h],'Curvature',props.Rounded,'LineWidth',props.Thickness,'EdgeColor',props.Color,'LineStyle',props.Style);
end  