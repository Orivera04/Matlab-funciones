function Draw_Demo 
% This program opens a 500x300 graphics window.  It paints a black
% box everywhere the user left clicks in the window.  Finally, it
% exits when the user types a key

% These constants hold the dimensions of the graphics window
Max_X = 500;
Max_Y = 300;

Open_Graph_window(Max_X, Max_Y,'Demo Program');

while true
    if Key_Hit
        break;
    end
    
    % Draw a small Black Box where the left button pressed
    if Mouse_Button_Pressed
        [X_Var, Y_Var] = Get_Mouse_Button;
        Draw_Box(X_Var - 1,Y_Var - 1,X_Var + 1,Y_Var + 1, 'Filled', true);
    end
    
    % important to have a pause in the loop
    pause(0.01)
end
Close_Graph_Window;

