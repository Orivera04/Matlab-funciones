function h = Draw_Text(x, y, txt, varargin)
% 
% h = Draw_Text(x, y, txt)
%
% Displays text on the graphics window
%
% Inputs
%        x                    - X coordinate of the lower left corner for
%                               the text unless HorizontalAlignment is changed
%        y                    - Y coordinate of the lower left corner for
%                               the text unless HorizontalAlignment is changed
%        txt                  - The text to print
% Optional
%        'Color'              - color of the circle - Default black
%                               colors are 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
%        'Rotation'           - The rotation of the text - Default 0
%        'HorizontalAlignment'- [ {left} | center | right ]
%        'FontName'           - The name of the text - Default Helvetica
%        'FontSize'           - The size of the text - Default 10
%        'FontAngle'          - [ {normal} | italic | oblique ]
%        'FontWeight'         - [ light | {normal} | demi | bold ]
%        'VerticalAlignment'  - [ top | cap | {middle} | baseline | bottom ]
% Output
%        h     - Is a handle to the graphics object
%
% Date - 8 Jan 2003
% Author - Lt Col Tom Schorsch
% Modified by Maj Thomas Rathbun


props = Get_Properties(varargin{:});

% draw the text
h = text(x,y,txt,'FontName',props.FontName,'Rotation',props.Rotation,'FontAngle',props.FontAngle,...
    'Color', props.Color,'FontSize',props.FontSize,'HorizontalAlignment',props.HorizontalAlignment,...
    'FontWeight',props.FontWeight,'VerticalAlignment',props.VerticalAlignment,'LineStyle','none');
end
