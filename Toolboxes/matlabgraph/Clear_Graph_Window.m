function Clear_Graph_Window(h)
% 
% Clear_Graph_Window(h)
%
% Deletes all the object in the grphics window
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

% get axis
if nargin < 1
    handle_axis = get(gcf,'Children');
else
    handle_axis = get(h,'Children');
end    

% get objects
handles = get(handle_axis,'Children');

% loop thrrough the handles to deletethe objects
for i=1:length(handles)
    %delete objects
    delete(handles(i));
end
