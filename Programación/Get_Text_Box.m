function str = Get_Text_Box(name)
%
% str = Get_Text_Box(name)
%
% Gets the contents of the text box
%
% Inputs
%        name   - the name used to identify the text box
% Output
%        str - a string with the contents of the text box
%
% Date - 13 Jan 2003
% Author - Maj Thomas Rathbun

% check for name being a character or number
if ~ischar(name)
    
    % if number then its a handle, use it to get the contents of the text
    % box
    str = get(name,'String');
else
    
    % check for spaces in the name
    i=find(name==' ');
    
    % remove spaces
    name(i) = [];
    
    % if name search for the handle
    h = findobj('tag',name);
    
    % check for a match
    if ~isempty(h)
        
        % if found get the value
        str = get(h,'String');
    else
        
        % if not found display an error
        error(['No text box of name ' name ' was found']);
    end
end