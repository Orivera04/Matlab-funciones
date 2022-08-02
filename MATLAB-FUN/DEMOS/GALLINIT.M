function gallinit(figNumber,helpStr)
%GALLINIT Initialize the Gallery figure
%
%	GALLINIT(figNumber,helpStr) interacts
%	with the function XPGALLRY to initialize the Gallery figure
%	with the appropriate information. The string helpStr is the string
% 	returned by the help button of the Gallery figure.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<2,
    helpStr=' ';
end;

% If figNumber is zero, the demo will run without the GUI shell.
if figNumber==0,
    clc
    disp(' ');
    disp(helpStr);
    disp(' ');

else
    figure(figNumber);
    helpHndl=get(figNumber,'UserData');

    % Put the help string in the UserData of the help button.
    % This is where the driver function sshow will look for it.
    set(helpHndl,'UserData',helpStr);
end    % if figNumber==0 ...

