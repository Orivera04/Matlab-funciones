function Clear_Text_Box(name)
% 
% Clear_Text_Box(name)
%
% Clears the text in the text box
%
% Inputs
%        name   - the name used to identify the text box
% Output
%        none
%
% Date - 13 Jan 2003
% Author - Maj Thomas Rathbun

if ~ischar(name)
    set(name,'String','');
else
    h = findobj('tag',name);
    if ~isempty(h)
        et(h,'String','');
    else
        error(['No text box of name ' name ' was found']);
    end
end