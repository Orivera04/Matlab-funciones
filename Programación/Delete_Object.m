function Delete_Object(h)
% 
% Delete_Object(h)
%
% Deletes an grphics object and removes it from the window
%
% Inputs
%         h     - Is a handle to the graphics object
%        
% Output
%       
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% loop over the array of handles
for i = 1:length(h)
    delete(h(i));
end