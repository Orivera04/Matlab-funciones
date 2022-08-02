echo on
% The first thing you need to do is open a graph window. The following call
% opens a window that is 500 pixels wide by 400 pxels high and names the
% window demo
h=Open_Graph_Window(500, 400, 'Demo',300,300);
%
% Next we may want to draw some graphics objects. The following function
% calls create a barn
%
% press any key to continue
pause;

Set_Default_Value('Filled',true)
Draw_Box(0,0,500,400,'Color','cyan');

% Ground
Draw_Box(0,0,500,100,'Color','Green');

% Barn   
% Barn Roof
Draw_Circle(400,250,75,'Color','black');

% Barn Body
Draw_Box(325,100,475,250,'Color','red');

% Doors of the Barn
door_handle = Draw_Box(350,100,450,200,'Color','magenta');
Draw_Line(400,100,400,200);

% Sign With Text inserted
Draw_Box(365,218,435,232,'Color','white');
Draw_Text(367,220,'The Barn');

%
% look at the call to Draw_Box under Doors of the Barn. In this case
% draw_box returns a handle to a variable so we can change properties about
% the door. We can save handles to any drawing object in MatlabGraph. The
% following function calls makes the door invisible, then visible then
% changes its color
%
% press any key to continue
pause;
%
Hide_Object(door_handle)
pause(0.5)
Show_Object(door_handle)
pause(0.5)
Change_Object_Color(door_handle,'blue')
%
% Our barn needs a tractor so lets draw it, but this time we will same all
% the handles to the tracter in an array to be able to move the tractor
%
% press any key to continue
pause;

% Tractor

% Bottom of Tractor Body
tractor_handle(1) = Draw_Box(75,150,175,217,'Color','green');
tractor_handle(2) = Draw_Text(81,172,'Deere','Color','black');

% Grill
tractor_handle(3) = Draw_Box(70,150,75,217,'Color','black');

% Top of Tractor Body
tractor_handle(4) = Draw_Box(110,200,175,250,'Color','Green');
tractor_handle(5) = Draw_Line(110,235,125,250,'Color','Cyan');

% Window in the Tractor
tractor_handle(6) = Draw_Line(118,230,130,242);
tractor_handle(7) = Draw_Line(118,230,118,217);
tractor_handle(8) = Draw_Line(145,242,130,242);
tractor_handle(9) = Draw_Line(118,217,145,217);
tractor_handle(10) = Draw_Line(145,217,145,242);

% Smoke Stack   
tractor_handle(11) = Draw_Box(90,217,95,250);

% Tires
tractor_handle(12) = Draw_Circle(175,150,50);
tractor_handle(13) = Draw_Circle(175,150,30,'Color','white');
tractor_handle(14) = Draw_Circle(80,125,25);
tractor_handle(15) = Draw_Circle(80,125,10,'Color','white');
%
% press any key to continue
pause;

% Our tractor will either go out to the fields to work or back to the barn
% depending on what the user wants. If the user clicks on the barn door the
% tractor moves to the barn otherwise it goes to the fields. We use the
% Select_Object function to do this. It will return the handle of the
% object you click on. It the object is the Barn door then the tractor moves
% right otherwise it moves left
%
% let the user select an object
h = Select_Object;
%
% test the object to be the barn door
if h == door_handle
    for i = 1:130
        Move_Object_By(tractor_handle, 2, 0);
        pause(0.001)
    end
else
    for i = 1:130
        Move_Object_By(tractor_handle, -2, 0);
        pause(0.001)
    end
end
%
% We can delete graphics objects by passing their handle to the
% Delete_Object function

% press any key to continue
pause;
%
Delete_Object(tractor_handle)
%
% our scene is missing a sun. Please click a place in the sky to place the
% sun. We will use Get_Mouse_Button to wait for the click and return the x
% and y location, then we can draw the sun there.
%
% press any key to continue
pause;
%
[x,y] = Get_Mouse_Button;
sun_handle = Draw_Circle(x, y, 40, 'Color','yellow');
%
% Alas the demo is ending, the sun is going down
%
% press any key to continue
pause;
%
for i = 1:20
    Move_Object_By(sun_handle, 0, -1);
    pause(0.001)
end
for i = 0:.1:1
    Change_Object_Color(sun_handle,[1,1,i])
    pause(0.2)
end
pause(0.1)
Delete_Object(sun_handle)
%
% Lastly we will wait for the user to type a key then close the graphics
% window
%
% press any key to continue
pause;
%
h = Draw_Text(10, 10, 'Click any key to quit', 'Color','red','FontSize',24,'Rotation',45);

Wait_For_Key
close_graph_window;
echo off