function Change_Object_Color(h,color)
%
% Change_Object_Color(h,color)
%
% Changes the color on an object
%
% Inputs
%         h      - Is a handle to the graphics object
%         Color  - color of the circle - Default black
%                  colors are 'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', and 'white'
% Output
%       
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% change colors
try
    set(h,'EdgeColor',color)
    set(h,'FaceColor',color)
catch
    set(h,'Color',color)
end    