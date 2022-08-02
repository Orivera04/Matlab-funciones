function BouncingBall

xsize=500;
ysize=500;
open_graph_window(xsize,ysize);

Set_Default_Value('Filled',true);

for i = 1:3
    x(i)=round(rand(1)*(xsize-1))+1;
    y(i)=round(rand(1)*(xsize-1))+1;;
end
size=5;
for i = 1:3
    theta = rand(1)*2*pi-pi;
    dx(i)=round(cos(theta)*6);
    dy(i)=round(sin(theta)*6);
end
colors = {'r','g','b'};
for i = 1:3
    h(i) = Draw_Circle(x(i),y(i),size,'Color',colors{i});
end

Draw_Text(60, 450, 'Click to Quit', 'Color','blue', 'FontSize',48);


while true
    pause(0.025);
    for i = 1:3
        if x(i)+size>xsize || x(i)-size<0 
            dx(i)=-dx(i); 
        end
        if y(i)+size>ysize || y(i)-size<0 
            dy(i)=-dy(i); 
        end
    end
    Delete_Object(h(1));
    h(1) = draw_circle(x(1),y(1),size,'Color',colors{1});
    Move_Object_To(h(2), x(2), y(2))
    Move_Object_By(h(3), dx(3), dy(3))
    x=x+dx;
    y=y+dy;
    if Mouse_Button_Pressed
        break;
    end;
end
close_graph_window;