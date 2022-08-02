function h = Create_Button(x,y,width,height,name)
% 
% h = Create_Button(x,y,width,height,name)
%
% Create a button that allowes to user to click the mouse in
%
% Inputs
%        x      - X coordinate of the lower left hand point of the button
%        y      - Y coordinate of the lower left hand point of the button
%        width  - The width of the button
%        height - The height of the button
%        name   - the name of the button and it is used to identify the
%                 button
% Output
%        h     - Is a handle to the graphics object
%
% Date - 13 Jan 2003
% Author - Maj Thomas Rathbun

% check for spaces in the name
i=find(name==' ');
call = name;

% remove spaces
call(i) = [];

% create the callback string
str = ['setappdata(gcf, ''' call ''',1);'];

% set the flag to 0
setappdata(gcf,call,0);

% create the control object
h = uicontrol('Style', 'pushbutton', 'String', name,...
    'Position', [x y width height], 'Callback', str);