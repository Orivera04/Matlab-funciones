function doom
%DOOM  Fly through a 3D scene 
%      like in a first-person shooter in god mode
%
%      Mouse   : Look up, down, left, and right
%
%      'w'     : Move forward
%      's'     : Move backward
%      'a'     : Move left
%      'd'     : Move right
%      'Space' : Move up
%      'Ctrl'  : Move down
%      'Shift' : Accelerate movement (in combination with other key)
%      'm'     : Toggle up/down (mouse inversion)
%      'q'     : Toggle mouse motion capture
%      'Esc'   : Close figure
%
%      Example: 
%        z = peaks;       
%        surf (z)
%        axis off
%        doom
%        set (gca, 'CameraPosition', [-10, -10, 0])
%        set (gca, 'CameraTarget', [10, 10, 0])
%
%      For best performance, it might be useful to adjust the character repeat speed
%      under XP/Start menu/Control Panel/Keyboard Properties/Speed/Character Repeat/:
%      Repeat delay: Short(est)
%      Repeat rate: Fast(est)

% Version 1.3: drawnow cures freezing on some graphic cards
% Version 1.2: Initially, bring the current figure into focus
% Version 1.1: Mouse motion capture can be toggled via key 'q'
%
% Joerg J. Buchholz, Hochschule Bremen, buchholz@hs-bremen.de, 2005

% DOOM_MOUSE_INVERTED has to be global for communication between
% function key_pressed, where DOOM_MOUSE_INVERTED is altered and 
% function mouse_moved, where DOOM_MOUSE_INVERTED is used 
global DOOM_MOUSE_INVERTED

% Initialize global variable DOOM_MOUSE_INVERTED
%  1: push mouse -> camera look up
% -1: push mouse -> camera look down
DOOM_MOUSE_INVERTED = 1;

% DOOM makes only sense in 3D scenes
view(3)

% Freeze aspect ratio properties to enable rotation of 3D objects 
% and override stretch-to-fill
axis vis3d

% Make motion and rotation more realistic
set (gca, 'Projection', 'perspective')

% The lower left postion of a docked window is always [1 1],
% which is inconsistent with the definition of the position property.
% Therefore, it is not possible to position the mouse cursor 
% at the center of a docked window.
% -> Undock the window
set (gcf, 'WindowStyle', 'normal') 

% Define the callback routines that capture
% 1. if the mouse has been moved or
% 2. if a key has been pressed
set (gcf, 'WindowButtonMotionFcn', @mouse_moved);
set (gcf, 'KeyPressFcn', @key_pressed);

% Bring the current figure into focus
% (and make it visible) 
figure (gcf)

% Position the mouse cursor at the center of the current figure
figure_center;


function [x_center, y_center] = figure_center
% This function is a DOOM helper function
% It computes the center of the current figure
% and positions the mouse curser 
% at the center of the current figure 

% Joerg J. Buchholz, Hochschule Bremen, buchholz@hs-bremen.de, 2005

% Get the position of the current figure
figure_position = get (gcf, 'position');

% Calculate the center coordinates of the current figure
x_center = figure_position(1) + figure_position(3)/2;
y_center = figure_position(2) + figure_position(4)/2;

% Position the mouse cursor at the center of the current figure
set (0, 'PointerLocation', [x_center, y_center]);


function [dist, ch, ga, delta_axis, camera_position, camera_target] = polar_coordinates;
% This function is a DOOM helper function
% It computes the polar coordinates of the current view vector,
% the plot box scaling vector, the current camera position, and the current camera target

% Joerg J. Buchholz, Hochschule Bremen, buchholz@hs-bremen.de, 2005

% Get the current camera position 
camera_position = get (gca, 'CameraPosition');

% Get the current camera target
camera_target = get (gca, 'CameraTarget');

% The camera view vector points from the camera position 
% to the camera target
camera_view = camera_target - camera_position;

% Get the scaling (minimum and maximum values) of the current axis
ax = axis;

% Compute a scaling vector (maximum - minimum) for all three axes
 delta_axis = [ax(2) - ax(1), ax(4) - ax(3), ax(6) - ax(5)];

% Normalize the camera view vector
% i.e. transform the plot box into a unit cube.
% This is necessary if the scalings of the single axes differ strongly.
% Otherwise, the view rotation would be nonlinear
% (with "faster" and "slower" areas of rotation)
camera_view_normalized = camera_view ./ delta_axis;

% Transform the camera view vector from cartesian to polar coordinates.
% dist is the scalar distance between camera position and target
% ch(i) is the azimuth angle in the earth-fixed (geodetical) x_g-y_g-plane
% ga(mma) is the elevation angle about the view-fixed y_v-axis
dist = norm (camera_view_normalized);
ch = atan2 (camera_view_normalized(2), camera_view_normalized(1));
ga = -asin (camera_view_normalized(3)/dist);


function mouse_moved (src, eventdata)
% This function is a DOOM helper function
% It is called whenever the mouse cursor has been moved 

% Joerg J. Buchholz, Hochschule Bremen, buchholz@hs-bremen.de, 2005

% Define the viewing angle increment (in radians per mouse resolution dot)
angle_step = 0.001;

% Get the current position of the mouse cursor
% with respect to the screen
mouse_position = get (0, 'PointerLocation');

% Get the center position of current figure
% with respect to the screen
[x_center, y_center] = figure_center;

% Calculate the distances (in x and in y direction) 
% the mouse has moved since the last call to this routine
x_delta = mouse_position(1) - x_center;
y_delta = mouse_position(2) - y_center;

% Compute the polar coordinates of the current view vector,
% the plot box scaling vector, the current camera position, and the current camera target
[dist, ch, ga, delta_axis, camera_position, camera_target] = polar_coordinates;

% DOOM_MOUSE_INVERTED has to be global for communication between
% function key_pressed, where DOOM_MOUSE_INVERTED is altered and 
% function mouse_moved, where DOOM_MOUSE_INVERTED is used 
global DOOM_MOUSE_INVERTED

% Compute the new view angles depending on the distances
% the mouse has moved since the last call to this routine.
% DOOM_MOUSE_INVERTED defines whether pushing the mouse 
% makes the camera look up or down.
ch = ch - x_delta*angle_step;
ga = ga - y_delta*angle_step*DOOM_MOUSE_INVERTED;

% The elevation angle gamma is defined between -pi/2 and +pi/2
% and it must not be exactely +/- pi/2,
% because Matlab cannot render the scene 
% if the camera UpVector is aligned with the view vector.
% -> define a safety margin around +/- pi/2
safety_margin = 0.001;

% If the elevation angle exceeds the safety limit around pi/2
if ga > pi/2 - safety_margin

    % set it back to the safety limit
    ga = pi/2 - safety_margin;

% If the elevation angle exceeds the safety limit around -pi/2
elseif ga < -pi/2 + safety_margin

    % set it back to the safety limit
    ga = -pi/2 + safety_margin;

end

% Transform the camera view vector from polar coordinates 
% back to cartesian coordinates
camera_view_normalized = [cos(ga)*cos(ch) cos(ga)*sin(ch) -sin(ga)]*dist;

% Denormalize the camera view vector
% i.e. transform the plot box from the intermediate unit cube 
% back to the original cuboid.
camera_view = camera_view_normalized .* delta_axis;

% The camera target vector is the vector sum 
% of the camera position vector and the camera view vector
set (gca, 'CameraTarget', camera_position + camera_view);

% drawnow cures freezing on some graphic cards
drawnow


function key_pressed (src,eventdata)
% This function is a DOOM helper function
% It is called whenever a key has been pressed
% It can easily be extended by appending a user-defined case block
%
% For best performance, it might be useful to adjust the character repeat speed
% under XP/Start menu/Control Panel/Keyboard Properties/Speed/Character Repeat:
% Repeat delay: Short(est)
% Repeat rate: Fast(est)

% Joerg J. Buchholz, Hochschule Bremen, buchholz@hs-bremen.de, 2005

% Set the movement "distance" of a key pressed ('w', 'a', 's', 'd', ...)
% (default value: 1 percent of the plot box)
step_size = 0.01;

% Set the acceleration factor of a movement if the 'Shift' key is pressed
% together with another key
acceleration = 10;

% Compute the polar coordinates of the current view vector,
% the plot box scaling vector, the current camera position, and the current camera target
[dist, ch, ga, delta_axis, camera_position, camera_target] = polar_coordinates;

% Which key has been pressed?
switch eventdata.Key

    % If the key 's' has been pressed
    case 's'

        % Compute the transformation of an x-step 
        % into the earth-fixed (geodetical) coordinate system.
        % The transformation vector is the first line 
        % of the transformation matrix M_k_g in
        % http://buchholz.hs-bremen.de/rtf/skript/skript10.pdf#Transformationsmatrizen
        delta_x_normalized = [cos(ga)*cos(ch), cos(ga)*sin(ch), -sin(ga)]*step_size;

        % Denormalize the movement vector
        % i.e. transform the plot box from the intermediate unit cube 
        % back to the original cuboid.
        delta_x = delta_x_normalized .* delta_axis;

        % If additionally the 'shift' key has been pressed
        if strcmp (eventdata.Modifier, 'shift')

            % Make a bigger step (Default: 10 times bigger)
            delta_x = delta_x*acceleration;

        end

        % Compute and set the new camera postion and camera target
        set (gca, 'CameraPosition', camera_position - delta_x)
        set (gca, 'CameraTarget', camera_target - delta_x)

    % If the key 'w' has been pressed
    case 'w'

        % Compute the transformation of an x-step 
        % into the earth-fixed (geodetical) coordinate system.
        % The transformation vector is the first line 
        % of the transformation matrix M_k_g in
        % http://buchholz.hs-bremen.de/rtf/skript/skript10.pdf#Transformationsmatrizen
        delta_x_normalized = [cos(ga)*cos(ch), cos(ga)*sin(ch), -sin(ga)]*step_size;

        % Denormalize the movement vector
        % i.e. transform the plot box from the intermediate unit cube 
        % back to the original cuboid.
        delta_x = delta_x_normalized .* delta_axis;

        % If additionally the 'shift' key has been pressed
        if strcmp (eventdata.Modifier, 'shift')

            % Make a bigger step (Default: 10 times bigger)
            delta_x = delta_x*acceleration;

        end

        % Compute and set the new camera postion and camera target
        set (gca, 'CameraPosition', camera_position + delta_x)
        set (gca, 'CameraTarget', camera_target + delta_x)

    % If the key 'a' has been pressed
    case 'a'

        % Compute the transformation of a y-step 
        % into the earth-fixed (geodetical) coordinate system.
        % The transformation vector is the second line 
        % of the transformation matrix M_k_g in
        % http://buchholz.hs-bremen.de/rtf/skript/skript10.pdf#Transformationsmatrizen
        delta_y_normalized = [-sin(ch), cos(ch), 0]*step_size;

        % Denormalize the movement vector
        % i.e. transform the plot box from the intermediate unit cube 
        % back to the original cuboid.
        delta_y = delta_y_normalized .* delta_axis;

        % If additionally the 'shift' key has been pressed
        if strcmp (eventdata.Modifier, 'shift')

            % Make a bigger step (Default: 10 times bigger)
            delta_y = delta_y*acceleration;

        end

        % Compute and set the new camera postion and camera target
        set (gca, 'CameraPosition', camera_position + delta_y)
        set (gca, 'CameraTarget', camera_target + delta_y)

    % If the key 'd' has been pressed
    case 'd'

        % Compute the transformation of a y-step 
        % into the earth-fixed (geodetical) coordinate system.
        % The transformation vector is the second line 
        % of the transformation matrix M_k_g in
        % http://buchholz.hs-bremen.de/rtf/skript/skript10.pdf#Transformationsmatrizen
        delta_y_normalized = [-sin(ch), cos(ch), 0]*step_size;

        % Denormalize the movement vector
        % i.e. transform the plot box from the intermediate unit cube 
        % back to the original cuboid.
        delta_y = delta_y_normalized .* delta_axis;

        % If additionally the 'shift' key has been pressed
        if strcmp (eventdata.Modifier, 'shift')

            % Make a bigger step (Default: 10 times bigger)
            delta_y = delta_y*acceleration;

        end

        % Compute and set the new camera postion and camera target
        set (gca, 'CameraPosition', camera_position - delta_y)
        set (gca, 'CameraTarget', camera_target - delta_y)

    % If the 'control' key has been pressed
    case 'control'

        % Compute the transformation of a z-step 
        % into the earth-fixed (geodetical) coordinate system.
        % The transformation vector is the third line 
        % of the transformation matrix M_k_g in
        % http://buchholz.hs-bremen.de/rtf/skript/skript10.pdf#Transformationsmatrizen
        delta_z_normalized = [sin(ga)*cos(ch), sin(ga)*sin(ch), cos(ga)]*step_size;

        % Denormalize the movement vector
        % i.e. transform the plot box from the intermediate unit cube 
        % back to the original cuboid.
        delta_z = delta_z_normalized .* delta_axis;

        % If additionally the 'shift' key has been pressed
        if strcmp (eventdata.Modifier(1), 'shift')

            % Make a bigger step (Default: 10 times bigger)
            delta_z = delta_z*acceleration;

        end

        % Compute and set the new camera postion and camera target
        set (gca, 'CameraPosition', camera_position - delta_z)
        set (gca, 'CameraTarget', camera_target - delta_z)

    % If the 'space' key has been pressed
    case 'space'

        % Compute the transformation of a z-step 
        % into the earth-fixed (geodetical) coordinate system.
        % The transformation vector is the third line 
        % of the transformation matrix M_k_g in
        % http://buchholz.hs-bremen.de/rtf/skript/skript10.pdf#Transformationsmatrizen
        delta_z_normalized = [sin(ga)*cos(ch), sin(ga)*sin(ch), cos(ga)]*step_size;

        % Denormalize the movement vector
        % i.e. transform the plot box from the intermediate unit cube 
        % back to the original cuboid.
        delta_z = delta_z_normalized .* delta_axis;

        % If additionally the 'shift' key has been pressed
        if strcmp (eventdata.Modifier, 'shift')

            % Make a bigger step (Default: 10 times bigger)
            delta_z = delta_z*acceleration;

        end

        % Compute and set the new camera postion and camera target
        set (gca, 'CameraPosition', camera_position + delta_z)
        set (gca, 'CameraTarget', camera_target + delta_z)

    % If the 'escape' key has been pressed
    case 'escape'

        % Close the current figure
        close (gcf)

    % If the key 'm' has been pressed
    case 'm'

        % DOOM_MOUSE_INVERTED has to be global for communication between
        % function key_pressed, where DOOM_MOUSE_INVERTED is altered and 
        % function mouse_moved, where DOOM_MOUSE_INVERTED is used 
        global DOOM_MOUSE_INVERTED

        % Toggle inversion factor between +1 and -1
        DOOM_MOUSE_INVERTED = - DOOM_MOUSE_INVERTED;

    % If the key 'q' has been pressed
    case 'q'

        % If the mouse motion callback function is empty 
        % because of a previous 'q',
        % i.e. if mouse motion is not captured
        if isempty (get (gcf, 'WindowButtonMotionFcn'))

            % Redefine the mouse motion callback function
           % i.e. mouse motion is captured
            set (gcf, 'WindowButtonMotionFcn', @mouse_moved);
            
            % Position the mouse cursor at the center of the current figure
            figure_center;
        
        % If the mouse motion callback function is defined 
        % i.e. if mouse motion is captured
        else
            
            % Undefine the mouse motion callback function
            % i.e. mouse motion is not captured
            set (gcf, 'WindowButtonMotionFcn', '');

        end

        % drawnow cures freezing on some graphic cards
        drawnow

end