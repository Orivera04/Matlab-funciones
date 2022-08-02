function T = controls(T, RowMax, ColMax, varargin);

% function T = controls(T, RowMax, ColMax, varargin);
% 
% Creates RowMax * ColMax edit controls within table object.
% The argument list varargin, if supplied, is passed
% to uicontrol when creating the edit controls.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

k = nchildren(T);
if k > 0
   T = deletechild(T, 1:k);
end
if RowMax > 0 & ColMax > 0
   FrameTag = get(T, 'Tag');
   UserData = get(T, 'UserData');
   UserData.RowMax = RowMax;
   UserData.ColMax = ColMax;
   ChildBase = [varargin, {'Style', 'edit', 'Units', 'normalized', 'Position'}];
   ChildPos  = [0 0];
   SliderSizePixels = 15;  % converted to normalized units below
   [UserDataRows, UserDataColumns] = size(UserData.Data);
   T = uicontrol(T, ...
                 'Tag', 'HorizontalSlider', ...  % Tag used by slidercallback function
                 'Style', 'slider', ...
                 'Units', 'pixels', ...
                 'Position', [0 0 SliderSizePixels SliderSizePixels], ...
                 'Callback', ['slidercallback(table, ''' FrameTag ''')']);
   T = setchild(T, 'HorizontalSlider', 'Units', 'normalized');
   SliderPos = getchild(T, 'HorizontalSlider', 'Position');
   SliderSizeH = SliderPos(3);
   SliderSizeV = SliderPos(4);
   setchild(T, 'HorizontalSlider', 'Position', [0 0 1-SliderSizeH SliderSizeV]);
   T = uicontrol(T, ...
                 'Tag', 'VerticalSlider', ...    % Tag used by slidercallback function
                 'Style', 'slider', ...
                 'Units', 'normalized', ...
                 'Position', [1-SliderSizeH SliderSizeV SliderSizeH 1-SliderSizeV], ...
                 'Callback', ['slidercallback(table, ''' FrameTag ''')']);
   TableSizeH = 1 - SliderSizeH;
   TableSizeV = 1 - SliderSizeV;
   ChildSize = [TableSizeH/ColMax TableSizeV/RowMax];
   for m=1:RowMax
      ChildPos(2) = 1 - (m*TableSizeV/RowMax);
      for n=1:ColMax
         ChildPos(1) = (n-1)*TableSizeH / ColMax;
         ChildCallback = ['editcallback(table, ''' FrameTag ''',' num2str(m) ',' num2str(n) ')'];
         ChildArgs = {ChildBase{:}, [ChildPos ChildSize], 'Callback', ChildCallback};
         T = uicontrol(T, ChildArgs{:});
      end
   end
   % Handles are used directly in the scroll function because the table object
   % is not available in callback functions.  It's OK to modify the Value
   % property of the sliders and the String property of the edit controls, 
   % but never change e.g. Parent, Position or Units in this way!
   warning off;
   h = childhandles(T);
   warning on;
   UserData.SliderHHandle = h(1);    % The first 2 controls are the sliders...
   UserData.SliderVHandle = h(2);
   UserData.EditHandles = h(3:end);  % ...the remaining controls are the edits.
   set(T, 'UserData', UserData);
else
   error('RowMax and ColMax must be supplied and > 0');
end
