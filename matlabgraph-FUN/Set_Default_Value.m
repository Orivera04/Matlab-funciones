function Set_Default_Value(property,value)
%
% Set_Default_Value(property,value)
%
% Changes the default property values until the grphics window is closed
% and reopened
%
% Properities you can set
%        'Color'              - color of the object - Default black
%                               colors are 'yellow', 'magenta','cyan','red', 'green', 'blue', and 'white' 
%                               or colors are 'y', 'm','c','r', 'g', 'b', and 'w' 
%                               or [r,g,b], ex [1,1,0] for yellow
%        'Rotation'           - The rotation of the object (Text and Arcs)- Default 0
%        'Filled'             - A true or false value - Default true
%        'Thickness'          - If the circle is not filled this specifies how thick
%                               to make the line - Default 0.5
%        'Style'              - A string indicating the style of the lines - Default '-' (Solid)
%                               Other styles are '--' (dashed), ':' (dotted), '-.' (dash-dotted)
%                               Applies to unfilled circles only
%        'Rounded'            - A 2 value array with values between 0 and 1 - Default [0,0]
%                               Indicates how rounded the corners are. [0,0] is no
%                               round, [1, 1] completely rounded like and elipse
%        'HorizontalAlignment'- [ {left} | center | right ]
%        'FontName'           - The name of the text - Default Helvetica
%        'FontSize'           - The size of the text - Default 10
%        'FontAngle'          - [ {normal} | italic | oblique ]
%        'FontWeight'         - [ light | {normal} | demi | bold ]
%        'VerticalAlignment'  - [ top | cap | {middle} | baseline | bottom ]

setappdata(gcf,'Rounded',[0,0])

% get all default properties
props = getappdata(gcf);

if isfield(props,property)
    % set the property value
    setappdata(gcf,property,value);
else
    % display error if not found
    error(['Property ' property ' not found']);
end