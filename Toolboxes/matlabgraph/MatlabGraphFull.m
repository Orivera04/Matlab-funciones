function MatlabGraph
% h=Open_Graph_Window(width, height, name, x_origin, y_origin)
%
% Opens a graphics window, must be called before any other grahics 
%       command
%
% Inputs
%        width      - The width of the window in pixels
%        height     - The height of the window in pixels
%        name       - A string for the name of the window
%        x_origin   - The x value for the location on the screen for the window
%        y_origin   - The y value for the location on the screen for the window
%
% Close_Graph_Window(h)
%
% Deletes all objectsthen closes the graph window
%
% Inputs
%         h     - Is a handle to the graphics window - Default is current window
%
% Wait_For_Key
%
% Waits for nay key to be press then continues
%
%
% pressed = Key_Hit
%
% Returns a 1 if a key was typed and a 0 otherwise
%
% Inputs
%        
% Output
%       pressed - true false value of whether a key was pressed or not      
%
% c = Get_key
%
% waits for a key click and return the character typed
%
% Inputs
%        
% Output
%       c - character that was type on the keyboard
%
% Wait_For_Mouse_Button
% 
% Waits for a mouse button then returns
%
%
% pressed = Mouse_Button_Pressed
% 
% Returns a 1 if either mouse button was press or a 0 otherwise
%
% Inputs
%        
% Output
%       pressed - true false value of whether a mouse button was pressed
%                 or not
%
% [x,y] = Get_Mouse_Button
%
% Waits for a mouse click then return the x and y coordinates of where 
%       is was clicked
% Inputs
%        
% Output
%       x - X position of the mouse
%       y - Y position of the mouse
%
% [x,y] = Get_mouse_Location
% 
% Returns the x and y coordinates of the current mouse location
%
% Inputs
%        
% Output
%       x - X position of the mouse
%       y - Y position of the mouse
%
% h = Create_Text_Box(x,y,width,height,name,value)
%
% Create a text box that allows to user to enter text in
%
% Inputs
%        x      - X coordinate of the lower left hand point of the box
%        y      - Y coordinate of the lower left hand point of the box
%        width  - The width of the text box
%        height - The height of the text box
%        name   - the name used to identify the text box
%        value  - An initial value to be placed in the text box
% Output
%        h     - Is a handle to the graphics object
%
%
% Clear_Text_Box(name)
%
% Clears the text in the text box
%
% Inputs
%        name   - the name used to identify the text box
% Output
%        none
%
%
% Test_Text_Box(name)
%
% Determines if the user typed in the text box
%
% Inputs
%        name   - the name used to identify the text box
% Output
%        pressed - true or false value
%
% str = Get_Text_Box(name)
%
% Gets the contents of the text box
%
% Inputs
%        name   - the name used to identify the text box
% Output
%        str - a string with the contents of the text box
%
% h = Create_Button(x,y,width,height,name)
%
% Create a button that allows to user to click the mouse in
%
% Inputs
%        x      - X coordinate of the lower left hand point of the
%                 button
%        y      - Y coordinate of the lower left hand point of the
%                 button
%        width  - The width of the button
%        height - The height of the button
%        name   - the name of the button and it is used to identify the
%                 button
% Output
%        h     - Is a handle to the graphics object
%
%
% Test_Button(name)
%
% Determines if the user clicked on the button
%
% Inputs
%        name   - the name used to identify the button
% Output
%        pressed - true or false value
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
%                        colors are 'yellow', 'magenta', 'cyan', 'red',
%                        'green', 'blue', and 'white'
%        'Thickness'   - If the circle is not filled this specifies how
%                        thick to make the line - Default 0.5
%        "style'       - A string indicating the style of the lines 
%                        Default '-' (Solid)
%                        Other styles are '--' (dashed), ':' (dotted),
%                        '-.' (dash-dotted) Applies to unfilled circles 
%                        only
%
% h = Draw_Box(x1, y1, x2, y2)
%
% Draws a box
%
% Inputs
%        x1            - X coordinate of the lower left bounding box
%        y1            - Y coordinate of the lower left bounding box
%        x2            - X coordinate of the upper right bounding box
%        y2            - Y coordinate of the upper right bounding box
% Optional
%        'color'       - color of the circle - Default black
%                        colors are 'yellow', 'magenta', 'cyan', 'red',
%                        'green', 'blue', and 'white'
%        'Filled'      - A true or false value - Default true
%        'Thickness'   - If the circle is not filled this specifies how
%                        thick to make the line - Default 0.5
%        'Style'       - A string indicating the style of the lines 
%                        Default '-' (Solid) Other styles are '--'
%                        (dashed), ':' (dotted), '-.' (dash-dotted)
%                        Applies to unfilled circles only
%        'Rounded'     - A 2 value array with values between 0 and 1 
%                        Default [0,0] Indicates how rounded the corners 
%                        are. [0,0] is not rounded, [1, 1] completely 
%                        rounded like and elipse
%        
% Output
%        h     - Is a handle to the graphics object
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
%                      colors are 'yellow', 'magenta', 'cyan', 'red', 
%                     'green', 'blue', and 'white'
%        'Filled'    - A true or false value - Default true
%        'Thickness' - If the circle is not filled this specifies how 
%                      thick to make the line - default 0.5
%        'Style'     - A string indicating the style of the lines 
%                      Default '-' (Solid) Other styles are '--' 
%                      (dashed), ':' (dotted), '-.' (dash-dotted)
%                      Applies to unfilled circles only
% Output
%        h     - Is a handle to the graphics object
%
% h = Draw_Ellipse(x1, y1, x2, y2)
%
% Draws an Ellipse
%
% Inputs
%        x1          - X coordinate of the lower left bounding box
%        y1          - Y coordinate of the lower left bounding box
%        x2          - X coordinate of the upper right bounding box
%        y2          - Y coordinate of the upper right bounding box
% Optional
%        'Color'     - color of the circle - Default black
%                      colors are 'yellow', 'magenta', 'cyan', 'red',
%                      'green', 'blue', and 'white'
%        'Filled'    - A true or false value - Default true
%        'Thickness' - If the circle is not filled this specifies how 
%                      thick to make the line - Default 0.5
%        'Style'     - A string indicating the style of the lines 
%                      Default '-' (Solid) Other styles are '--' 
%                      (dashed), ':' (dotted), '-.' (dash-dotted)
%                      Applies to unfilled circles only
% Output
%        h     - Is a handle to the graphics object
%
% h = Draw_Arc(x1, y1, x2, y2, start_angle, stop_angle)
%
% Draws an Arc
%
% Inputs
%        x1          - X coordinate of the lower left bounding box
%        y1          - Y coordinate of the lower left bounding box
%        x2          - X coordinate of the upper right bounding box
%        y2          - Y coordinate of the upper right bounding box
%        start_angle - The angle from where the arc is started from
%        stop_angle  - The angle from where the arc is stop
% Optional
%        'Color'     - color of the circle - Default black
%                      colors are 'yellow', 'magenta', 'cyan', 'red',
%                      'green', 'blue', and 'white'
%        'Filled'    - A true or false value - Default true
%        'Rotation'  - is the radians off center in a counter-clockwise 
%                      rotation - Default 0
%        'Thickness' - If the circle is not filled this specifies how 
%                      thick
%                      to make the line - Default 0.5
%        'Style'     - A string indicating the style of the lines 
%                      Default '-' (Solid) Other styles are '--' 
%                      (dashed), ':' (dotted), '-.' (dash-dotted)
%                      Applies to unfilled circles only
% Output
%        h     - Is a handle to the graphics object
%
% h = Draw_Polygon(x,y)
% 
% Draws a polygon
%
% Inputs
%        x             - An array of X coordinate for the points in the
%                        polygon
%        y             - An array of Y coordinate for the points in the
%                        polygon
% Optional
%        'Color'       - color of the circle - Default black
%                        colors are 'yellow', 'magenta', 'cyan', 'red',
%                        'green', 'blue', and 'white'
%        'Filled'      - A true or false value - Default true
%        'Thickness'   - If the circle is not filled this specifies how
%                        thick to make the line - Default 0.5
%        'Style'       - A string indicating the style of the lines 
%                        Default '-' (Solid)
%                        Other styles are '--' (dashed), ':' (dotted),
%                        '-.' (dash-dotted)
%                        Applies to unfilled circles only
%        
% Output
%        h     - Is a handle to the graphics object
%
% h = Draw_Text(x, y, txt)
%
% Displays text on the graphics window
%
% Inputs
%        x                    - X coordinate of the lower left corner 
%                               for the text unless HorizontalAlignment
%                               is changed
%        y                    - Y coordinate of the lower left corner
%                               for the text unless HorizontalAlignment
%                               is changed
%        txt                  - The text to print
% Optional
%        'Color'              - color of the circle - Default black
%                               colors are 'yellow', 'magenta', 'cyan'  
%                               'red', 'green', 'blue', and 'white'
%        'Rotation'           - The rotation of the text - Default 0
%        'HorizontalAlignment'- [ {left} | center | right ]
%        'FontName'           - The name of the text - Default Helvetica
%        'FontSize'           - The size of the text - Default 10
%        'FontAngle'          - [ {normal} | italic | oblique ]
%        'FontWeight'         - [ light | {normal} | demi | bold ]
%        'VerticalAlignment'  - [ top | cap | {middle} | baseline |
%                               bottom ]
% Output
%        h     - Is a handle to the graphics object
%
% Change_Object_Color(h,color)
%
% Changes the color on an object
%
% Inputs
%         h      - Is a handle to the graphics object
%         Color  - color of the circle - Default black
%                  colors are 'yellow', 'magenta', 'cyan', 'red',
%                 'green', 'blue', and 'white'
%
% Delete_Object(h)
%
% Deletes an grphics object and removes it from the window
%
% Inputs
%         h     - Is a handle to the graphics object
%
% Hide_Object(h)
%
% Hides an object on the graphics window but does not delete it
%
% Inputs
%         h     - Is a handle to the graphics window
%
% Move_Object_By(h, xDist, yDist)
%
% Moves an object by an an x and y offset value
%
% Inputs
%         h     - Is a handle to the graphics object 
%         xDist - The x distance to move the object by
%         yDist - The y distance to move the object by
%
% Move_Object_To(h, x, y)
%
% Moves an object to a specific location, not valid for arcs and 
%       polygons
%
% Inputs
%        h     - Is a handle to the graphics object
%        x     - X coordinate to move to
%        y     - Y coordinate to move to
%
% h = Select_Object
%
% Returns a handle of the object selected on the graphics window
%
% Inputs
%
% Output
%        h     - Is a handle to the graphics object
%
% Show_Object(h)
%
% If an object was made invible this function will make it visible again
%
% Inputs
%         h     - Is a handle to the graphics window
%
% Set_Default_Value(property,value)
%
% Changes the default property values until the grphics window is closed
% and reopened
%
% Properities you can set
%        'Color'              - color of the object - Default black
%                               colors are 'yellow', 'magenta', 'cyan', 
%                               'red', 'green', 'blue', and 'white' 
%                               or colors are ‘k’, 'y', 'm', 'c', 'r',
%                               'g', 'b', and 'w' 
%                               or [r,g,b], ex [1,1,0] for yellow
%        'Rotation'           - The rotation of the object (Text and 
%                               Arcs)- Default 0
%        'Filled'             - A true or false value - Default true
%        'Thickness'          - If the circle is not filled this
%                               specifies how thick to make the line – 
%                               Default 0.5
%        'Style'              - A string indicating the style of the 
%                               lines - Default '-' (Solid)
%                               Other styles are '--' (dashed), ':' 
%                               (dotted), '-.' (dash-dotted)
%                               Applies to unfilled circles only
%        'Rounded'            - A 2 value array with values between 0 
%                               and 1 - Default [0,0] Indicates how 
%                               rounded the corners are. [0,0] is no
%                               round, [1, 1] completely rounded like 
%                               and elipse
%        'HorizontalAlignment'- [ {left} | center | right ]
%        'FontName'           - The name of the text - Default Helvetica
%        'FontSize'           - The size of the text - Default 10
%        'FontAngle'          - [ {normal} | italic | oblique ]
%        'FontWeight'         - [ light | {normal} | demi | bold ]
%        'VerticalAlignment'  - [ top | cap | {middle} | baseline | 
%                               bottom ]
%
% Clear_Graph_Window(h)
%
% Deletes all the object in the grphics window
%
% Inputs
%         h     - Is a handle to the graphics window - Default is
%                 current window
%
% r = Get_Random(rmin,rmax,type)
%
% Calculates an random value
%
% Inputs
%        rmin          - The min value of the random number
%        rmax          - The max number of the random value
%        type          - A string of either 'integer' or 'float'
%                        Default float
%        
% Output
%        r     - A random number of the type and range specified above
%