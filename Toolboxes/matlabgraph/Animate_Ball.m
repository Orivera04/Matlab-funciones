function Animate_Ball
% This program opens a 400x100 graphics window.  It then draws
% an animation of a circle traveling horizontally across the
% graphic window.  The program will quit when the user presses a key.

% These constants hold the dimensions of the graphics window
Max_X = 400;
Max_Y = 100;

disp('This program will open a graphics window.');
disp('It will then position a circle at the left of the');
disp('window and then make the circle move across the');
disp('window bydrawing and erasing the circle in.');
disp('different positions.');
disp('A key press will end the program.');

Open_Graph_Window (Max_X, Max_Y, 'Animate Ball');

% initialize the position of the circle to the left of the window
X_Pos = 1;
Y_Pos = Max_Y/2;


% draw a black circle
handle = Draw_Circle(X_Pos,Y_Pos, 3, 'Color','red','Filled',true);

while true 
    
    pause(0.05);  % wait a bit so the user can see the circle

    % Update X_pos here, 4 seems a good number of pixels
    % We don't update Y_pos, since we are moving horizontally
    X_Pos = X_Pos + 4;
    
    % Move the ball
    Move_Object_To(handle,X_Pos,Y_Pos)
    
    % Exit when the center of the ball goes off the right side of the window.
    if X_Pos > Max_X
        break
    end
end

% The following waits until the user presses a key before ending
Wait_For_Key;
Close_Graph_Window;
