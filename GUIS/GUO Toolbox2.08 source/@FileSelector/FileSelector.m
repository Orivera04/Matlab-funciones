function FS = FileSelector(varargin);

% function FS = FileSelector(varargin);
% 
% Class constructor for FileSelector (inherited from graphicuserobject).
% Creates a PopupMenu object with Tag "Select" and a PushButton object with Tag "Browse".
% See the graphicuserobject class constructor for a description
% of the argument list varargin.
% See the FileSelectorDemo function for examples of FileSelector functions.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 1 & isa(varargin(1), 'FileSelector')
   T = varargin(1);
else  
   GUO = graphicuserobject(varargin{:});
   FS = class(struct([]), 'FileSelector', GUO);
   FrameTag = get(FS, 'Tag');
   FS = uicontrol(FS, 'Style', 'popupmenu', 'Tag', 'Select', ...
                  'Position', [0 0 0.8 1], 'String', ' ');
   FS = uicontrol(FS, 'Style', 'pushbutton', 'Tag', 'Browse', ...
                  'Position', [0.8 0 0.2 1], 'String', 'Browse', ...
                  'Callback', ['browsecallback(FileSelector(''Position'', [0 0 0.001 0.001]), ''' FrameTag ''')']);
                  % Display of dummy FileSelector suppressed with Position [0 0 0.001 0.001]
   % Handles are used directly in the callback functions because the
   % FileSelector object is not available. 
   % It's OK to modify the String property of the PopupMenu, 
   % but never change e.g. Parent, Position or Units in this way!
   warning off;
   h = childhandles(FS);
   warning on;
   UserData.SelectHandle = h(1);    % The first control is the PopupMenu
   UserData.Directory = pwd;
   UserData.Mask = '*.*';
   set(FS, 'UserData', UserData);
end
