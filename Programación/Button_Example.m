h=Open_Graph_Window(500,300,'Example Window');

name = 'Exit';
name2 = 'display text';
name3 = 'b1';
h1 = Create_Button(20,20,40,30,name);
h2 = Create_Button(80,20,80,30,name2);
h3 = Create_Text_Box(180,20,60,30,name3);

while true
    
    pause(0.01)
    if Test_Button(name) 
        Draw_Text(50, 200, 'Click to exit');
        break
    end
    if Test_Button(h2) 
        if Test_text_Box(name3)
            t = Get_Text_Box(name3)
            str = ['You typed ' t ' in the text box'];
            Clear_Text_Box(h3);
        else
            str = 'Nothing was typed';
        end
        t= Draw_Text(50, 200, str);
        pause(2)
        Delete_Object(t)
    end
end

wait_for_mouse_button;
Close_Graph_Window;