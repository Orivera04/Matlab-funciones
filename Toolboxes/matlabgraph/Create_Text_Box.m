function h = Create_Text_Box(x,y,width,height,name,value)
% 
% h = Create_Text_Box(x,y,width,height,name,value)
%
% Create a text box that allowes to user to enter text in
%
% Inputs
%        x      - X coordinate of the lower left hand point of the box
%        y      - Y coordinate of the lower left hand point of the box
%        width  - The width of the text box
%        height - The height of the text box
%        name   - the name used to identify the text box
%        value  - An initial value to be placed in the text box
% Output
%        h     - Is a handle to the graphics object
%
% Date - 13 Jan 2003
% Author - Maj Thomas Rathbun

% test for spaces in the name
i=find(name==' ');
call = name;

% remove spaces
call(i) = [];

% create the callback string
str = ['setappdata(gcf, ''' call ''',1);'];

% set the flag to 0
setappdata(gcf,call,0);

% check for a defult value being supplied by the user
if exist('value')
    % test to see if it is character or number
    if ~isstr(value)
        % convert if number
        value = num2str(value);
    end
else
    % set empty string if not supplied
    value = '';
end

% create the control object
h = uicontrol('Style', 'edit', 'String', value,'tag',name,...
    'Position', [x y width height], 'Callback', str);