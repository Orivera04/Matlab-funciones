function c = Get_key
% 
% c = Get_key
%
% waits for a key click and return the character typed
%
% Inputs
%        
% Output
%       c - character that was type on the keyboard
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% check for key not already being click
if ~getappdata(gcf,'KeyClicked')
 
    % assign a key callback function which resumes
    set(gcf,'KeyPressFcn','uiresume');
    
    % wait for uiresume to be called
    uiwait;
end

% get the key that was type
c = Get_Key_Value;

% clear flag tht a key was type
setappdata(gcf,'KeyClicked',0)

% reset callback to the original one
set(gcf,'KeyPressFcn','setappdata(gcf,''KeyClicked'',1)');