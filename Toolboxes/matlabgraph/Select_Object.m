function h = Select_Object
% 
% h = Select_Object
%
% Returns a handle of the object selected on the graphics window
%
% Inputs
%
% Output
%        h     - Is a handle to the graphics object
%
% Date - 8 Jan 2003
% Author - Maj Thomas Rathbun

% wait for a mouse click
Wait_For_Mouse_Button;

% get the current object as the selected object
h = gco;