function pressed = Test_Button(name)
%
% Test_Button(name)
%
% Determines if the user clicked on the button
%
% Inputs
%        name   - the name used to identify the button
% Output
%        pressed - true or false value
%
% Date - 13 Jan 2003
% Author - Maj Thomas Rathbun

% check for character or number
if ~ischar(name)
    % if number then its a handle, use it to get the name
    name = get(name,'String');
end

% find spaces
i=find(name==' ');
call = name;

% remove spaces
call(i) = [];

% guard against wrong name
try
    
    % get flag value
    pressed = getappdata(gcf,call);
    
    % if pressed then clear for next time
    if pressed
        setappdata(gcf,call,0);
    end
catch
    % display error if not found
    error(['No button of name ' call ' was found']);
end