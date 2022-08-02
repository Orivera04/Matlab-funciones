function Close_Graph_Window(h)
% 
% Close_Graph_Window(h)
%
% Deletes all objectsthen closes the graph window
%
% Inputs
%         h     - Is a handle to the graphics window - Default is current
%                 window
%        
% Output
%       
%
% Date - 8 Jan 2003
% Author - Lt Col Tom Schorsch
% Modified by Maj Thomas Rathbun

% deletes the current graph window
if nargin < 1
    delete(gcf);
else
    delete(h);
end