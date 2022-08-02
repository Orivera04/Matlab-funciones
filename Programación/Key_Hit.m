function pressed = Key_Hit
% 
% pressed = Key_Hit
%
% Returns a 1 if a key was typed and a 0 otherwise
%
% Inputs
%        
% Output
%       pressed - true false value of whether a key was pressed or not      
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% get KeyClicked flag
pressed = getappdata(gcf,'KeyClicked');


