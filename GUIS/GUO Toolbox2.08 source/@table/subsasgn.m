function T = subsasgn(T, index, h);

% function T = subsasgn(T, index, h);
% 
% Defines cell assignment for table objects (see MATLAB help).
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

switch index.type
case {'{}', '()'}
   UserData = get(T, 'UserData');
   UserData.Data(index.subs{:}) = h;
   T = set(T, 'UserData', UserData);
   [RowSize, ColSize] = size(UserData.Data);
	T = setchild(T, 'VerticalSlider', ...
                'Value', UserData.CurrentRow, ...
                'Min', 1, ...
                'Max', RowSize + 1 - UserData.RowMax, ...
                'SliderStep', [1/RowSize UserData.RowMax/RowSize]);
	T = setchild(T, 'HorizontalSlider', ...
                'Value', UserData.CurrentColumn, ...
                'Min', 1, ...
                'Max', ColSize + 1 - UserData.ColMax, ...
                'SliderStep', [1/ColSize UserData.ColMax/ColSize]);
   T = scroll(T, UserData.CurrentRow, UserData.CurrentColumn, '', UserData);
otherwise  % case '.'
   error('Indexing by name is not supported by table object')
end
