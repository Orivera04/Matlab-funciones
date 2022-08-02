function setenableprop(h,enableState,uistyle)
%SETENABLEPROP Sets the enable property of uicontrols while maintaining the 
%              correct background color.
% Inputs:
%   h           - handle to uicontrol to enable/disable.
%   enableState - enable property value: 'on' or 'off'.
%   uistyle     - the uicontrol style, e.g., 'edit', 'popupmenu'.
%
%   If uistyle is not specified.  This function will determine which control is
%   being set and take the appropriate action.  If a vector of handles is passed
%   in with no uistyle specified, the appropriate action will be taken for each
%   of the controls.
%
% Outputs:
%   none

%   Author(s): P. Pacheco
%   Copyright 1988-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/04/08 20:54:56 $ 

error(nargchk(2,3,nargin));

if isempty(h), return; end

% Background colors.
enabledColor = 'White';
disabledColor = get(0,'defaultUicontrolBackgroundColor');

if strcmp(lower(enableState),'on'),  bgColor = enabledColor;
else                                 bgColor = disabledColor;
end

for indx = 1:length(h),
    
    % If the object is not a uicontrol, do not change it's backgroundcolor
    if isprop(h(indx), 'Style'), uistyle = get(h(indx), 'Style');
    else,                        uistyle = 'nostyle'; end
    
    switch uistyle
    case {'edit','popupmenu'}
        set(h(indx), 'Enable', enableState, 'Background', bgColor);
        
    otherwise  % In case someone uses this function for other uis.
        set(h(indx), 'Enable', enableState);
    end
end

drawnow;

% [EOF] setenableprop.m
