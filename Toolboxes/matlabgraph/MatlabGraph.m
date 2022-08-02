function MatlabGraph()
%
% MatlabGraph is a series of function calls to display and interact with
% graphical objects. All MatlabGraph commands are relative to a special
% graphics window that you must open first with Open_Graph_Window.  In this
% graphics window you can draw lines, rectangles, circles, arcs, ellipses,
% text, buttons, and text boxes. These graphics objects can be of various
% sizes colors, styles, rotations and filled or unfilled. You can make your
% graphics interactive and animated. A list of MatlabGraph commands 
% follows.
%
% Current version is Matlabgraph 1.2, 14 Jan 2003
%
% Authors, Maj Tom Rathbun and Lt Col Tom Schorsch
%
% h=Open_Graph_Window(width, height, name, x_origin, y_origin)
% Close_Graph_Window(h)
% Wait_For_Key
% pressed = Key_Hit
% c = Get_key
% Wait_For_Mouse_Button
% pressed = Mouse_Button_Pressed
% [x,y] = Get_Mouse_Button
% [x,y] = Get_mouse_Location
% h = Create_Text_Box(x,y,width,height,name,value)
% Clear_Text_Box(name)
% Test_Text_Box(name)
% str = Get_Text_Box(name)
% h = Create_Button(x,y,width,height,name)
% Test_Button(name)
% h = Draw_Line(x1, y1, x2, y2)
% h = Draw_Box(x1, y1, x2, y2)
% h = Draw_Circle(x, y, radius)
% h = Draw_Ellipse(x1, y1, x2, y2)
% h = Draw_Arc(x1, y1, x2, y2, start_angle, stop_angle)
% h = Draw_Polygon(x,y)
% h = Draw_Text(x, y, txt)
% Change_Object_Color(h,color)
% Delete_Object(h)
% Hide_Object(h)
% Move_Object_By(h, xDist, yDist)
% Move_Object_To(h, x, y)
% h = Select_Object
% Show_Object(h)
% Set_Default_Value(property,value)
% Clear_Graph_Window(h)
% r = Get_Random(rmin,rmax,type)
