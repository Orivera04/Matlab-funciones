function Wait_For_Mouse_Button
% 
% Wait_For_Mouse_Button
% 
% Waits for a mouse button then returns
%
% Inputs
%        
% Output
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% check for mouse not already being click
if ~getappdata(gcf,'MouseClicked')
    
    % set callback to resume when click
    set(gcf,'WindowButtonDownFcn','uiresume');
    
    % wait for uiresume
    uiwait;
end

% clear mouse click flag
setappdata(gcf,'MouseClicked',0)

% change callback to original
set(gcf,'WindowButtonDownFcn','setappdata(gcf,''MouseClicked'',1)');
    
