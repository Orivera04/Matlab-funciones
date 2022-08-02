function pressed = Mouse_Button_Pressed
% 
% pressed = Mouse_Button_Pressed
% 
% Returns a 1 if either mouse button was press or a 0 otherwise
%
% Inputs
%        
% Output
%       pressed - true false value of whether a mouse button was pressed or not      
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% get MouseClicked flag
pressed = getappdata(gcf,'MouseClicked');


