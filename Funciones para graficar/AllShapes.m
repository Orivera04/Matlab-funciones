h=Open_Graph_Window(500, 300, 'Overview');
h = Draw_Arc(250, 200, 300, 300, 30, 270,'Rotation',45);
h = Draw_Box(5, 5, 495, 295, 'Rounded',[.5,.5]);
h = Draw_Box(250, 5, 295, 50, 'Filled',true);
h = Draw_Circle(120, 120, 100, 'Color','red', 'Filled', true)
h = Draw_Circle(120, 120, 50, 'Color','blue', 'Filled', true)
h = Draw_Ellipse(30, 200, 80, 270, 'Thickness',10);
h = Draw_Line(10, 10, 495, 295, 'Style','-.');
[x,y]=ginput(6);
h11 = Draw_Polygon(x,y,'Color',[.5,.5,.5],'Filled',true);
h = Draw_Text(250, 57, 'Cool Text', 'FontSize',24, 'Rotation',90);
name = 'Exit';
name2 = 'display text';
name3 = 'b1';
h1 = Create_Button(20,20,40,30,name);
h2 = Create_Button(80,20,80,30,name2);
h3 = Create_Text_Box(180,20,60,30,name3,'hello');
