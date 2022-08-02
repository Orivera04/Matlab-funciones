function pressed = Test_Text_Box(name)
%
% Test_Text_Box(name)
%
% Determines if the user typed in the text box
%
% Inputs
%        name   - the name used to identify the text box
% Output
%        pressed - true or false value
%
% Date - 13 Jan 2003
% Author - Maj Thomas Rathbun

% check if the name is a character or a number
if ~ischar(name)
    % if a number then it is a handle, use the handle to get the name
    name = get(name,'tag');
end

% look for spaces in the name
i=find(name==' ');
call = name;

% remove spaces
call(i) = [];

% use try catch in case the user used the wrong name
try
    % check the flag
    pressed = getappdata(gcf,call);
    
    % if pressed clear the flag for next time
    if pressed
        setappdata(gcf,call,0);
    end
catch
    % display an error if the name does not match
    error(['No text box of name ' call ' was found']);
end