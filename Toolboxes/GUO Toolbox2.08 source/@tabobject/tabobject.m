function T = tabobject(varargin);

% function T = tabobject(varargin);
% 
% Class constructor for tabobject (inherited from graphicuserobject).
% See the graphicuserobject class constructor for a description
% of the argument list varargin.
% Do not add, delete or change properties of child controls on the
% tabobject itself - these are maintained dynamically.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 1 & isa(varargin(1), 'tabobject')
   T = varargin(1);
else  
   GUO = graphicuserobject(varargin{:});
   T.CurrentTab = 0;
   T.ButtonsHeight = 0;
   T.ButtonsWidth = 0.005;
   T.JumpHeight = 0;
   T.BlankTextHeight = 0;
   T.BlankTextOffset = 0;
   T = class(T, 'tabobject', GUO);
end
