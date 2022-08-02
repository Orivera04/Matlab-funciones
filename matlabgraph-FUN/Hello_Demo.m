function Hello_Demo 
% This program opens a 400x100 graphics window.  It then waits 
% for two consecutive left mouse clicks, saves their locations, 
% and uses them to draw a cyan box.  It then waits for one more
% mouse click and places the word 'Hello' in magenta at that 
% position.  Finally, it quits when the user presses a key.

% These constants hold the dimensions of the graphics window
Max_X = 400;
Max_Y = 100;


disp('This program will open a graphics window.');
disp('It will then wait for two left mouse clicks.');
disp('These mouse clicks will define the corners');
disp('of a rectangle which will be drawn on the');
disp('window.  The program will then wait');
disp('for another mouse click, this one defining');
disp('the location of a greeting. After the greeting');
disp('is displayed, the program will wait for you');
disp('to press a key, at which time it will quit.');


Open_Graph_window(Max_X,Max_Y,'Hello Demo');

% Get first two mouse clicks and draw a box 
[X_Upper_Left, Y_Upper_Left] = Get_Mouse_Button;
[X_Lower_Right, Y_Lower_Right] = Get_Mouse_Button;
Draw_Box(X_Upper_Left,Y_Upper_Left,X_Lower_Right,Y_Lower_Right, 'Color','cyan'); 

% Get 3rd mouse click and display text at that location
[X_Text, Y_Text] = Get_Mouse_Button;
Draw_Text(X_Text,Y_Text,'Hello!', 'Color','red');

% waits until the user presses a key to finish the program
Wait_For_Mouse_Button;
Close_Graph_Window;
