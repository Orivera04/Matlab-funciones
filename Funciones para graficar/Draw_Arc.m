function h = Draw_Arc(x1, y1, x2, y2, start_angle, stop_angle, varargin)
% 
% h = Draw_Arc(x1, y1, x2, y2, start_angle, stop_angle)
%
% Draws an Arc
%
% Inputs
%        x1          - X coordinate of the lower left bounding box
%        y1          - Y coordinate of the lower left bounding box
%        x2          - X coordinate of the upper right bounding box
%        y2          - Y coordinate of the uooer right bounding box
%        start_angle - The angle from where the arc is started from
%        stop_angle  - The angle from where the arc is stop
% Optional
%        'Color'     - color of the circle - Default black
%                      colors are 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
%        'Filled'    - A true or false value - Default true
%        'Rotation'  - is the radians off center in a coutner-clockwise rotation - Default 0
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


% calculate center and angles
x_radius = round(abs(x1-x2)/2);
y_radius = round(abs(y1-y2)/2);
x = x1+x_radius;
y = y1+y_radius;

% change angles to randians
start_angle = start_angle*2*pi/360;
stop_angle = stop_angle*2*pi/360;

% compute a vector, Theta, of circle circumference values
DrawResolution = 1/100;     % at 0.01 intervals              
Theta = start_angle:DrawResolution:stop_angle;

% orientation = radians rotated counter-clockwise
co=cos(props.Rotation);
si=sin(props.Rotation);

% Xs and Ys are the coordinates of an ellipsical polygon
Xs = x + x_radius*cos(Theta)*co-si*y_radius*sin(Theta); % calculate all of the x coordinates
Ys = y + x_radius*cos(Theta)*si-co*y_radius*sin(Theta); % calculate all of the y coordinates
      
if props.Filled
    h = fill(Xs, Ys, 'FaceColor',props.Color, 'EdgeColor',props.Color,'LineWidth',5);    % fill the polygon
else
    h = line(Xs, Ys, 'Color', props.Color, 'LineWidth',props.Thickness,'LineStyle',props.Style);     % draw the polygon outline
end    