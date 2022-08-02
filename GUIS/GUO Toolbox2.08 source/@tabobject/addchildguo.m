function T = addchildguo(T, ChildGUO, varargin);

% function T = addchildguo(T, ChildGUO, varargin);
% 
% Inserts a (child) graphicuserobject and its corresponding tab button within a tabobject.
% The argument list varargin is passed on to the uicontrol function when creating the tab button.
%
% Copyright (c) SINUS Messtechnik GmbH 2002-2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

n = nchildren(T);
if n > 0
   T = deletechild(T, n);  % Delete old text control - see below
else
   n = 1;
end
BC = get(figure(T), 'Color');
T = uicontrol(T, 'Style', 'pushbutton', 'BackgroundColor', BC, varargin{:});
setchild(T, n, 'Units', 'normalized');
P = getchild(T, n, 'Extent');
if T.ButtonsHeight == 0  % first time through...
   T.ButtonsHeight = P(4);
   T.JumpHeight = 0.3 * T.ButtonsHeight;
   T.BlankTextHeight = 0.2 * T.ButtonsHeight;
   T.BlankTextOffset = 0.05 * T.ButtonsHeight;
end
X = T.ButtonsWidth;
Y = 1 - (T.ButtonsHeight + T.JumpHeight + T.BlankTextOffset);
W = 1.1 * P(3);
setchild(T, n, 'Position', [X Y W T.ButtonsHeight]);
% The last control in T is a text control which is used to blank out
% the lower edge of the active tab button - see also selectchildguo.m
T = uicontrol(T, 'Style', 'text', 'BackgroundColor', BC, 'Position', [X Y-T.BlankTextOffset W T.BlankTextHeight]);
T.ButtonsWidth = T.ButtonsWidth + W;
ChildGUO = set(ChildGUO, 'Units', 'normalized', 'Position', [0 0 1 Y], 'Visible', 'on'); 
T.graphicuserobject = addchildguo(T.graphicuserobject, ChildGUO);
T = selectchildguo(T, n);
