function Hide_Object(h)
% 
% Hide_Object(h)
%
% Hides an object on the graphics window but does not delete it
%
% Inputs
%         h     - Is a handle to the graphics window
%        
% Output
%       
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% loop over the array of handles
for i = 1:length(h)
    % set visibility to off
    set(h(i),'Visible','off');
end