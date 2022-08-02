function Wait_For_Key
% 
% Wait_For_Key
%
% Waits for nay key to be press then continues
%
% Inputs
%        
% Output
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% check for key not already being click
if ~getappdata(gcf,'KeyClicked')
    
    % set callback to resume
    set(gcf,'KeyPressFcn','uiresume');
    
    % wait for uiresume
    uiwait;
end

% clear KeyClicked
setappdata(gcf,'KeyClicked',0)

% set callback back to orginal
set(gcf,'KeyPressFcn','setappdata(gcf,''KeyClicked'',1)');

