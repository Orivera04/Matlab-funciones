function Show_Object(h)
% 
% Show_Object(h)
%
% If an object was made invible this function will make it visible again
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
    % set visibility to on
    set(h(i),'Visible','on');
end