function xpgallry(action);
%XPGALLRY An Expo gallery image shell.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% UserData usage:
% The text window UserData holds the name of the current script.

% Possible actions:
% info
% close

% xpgallry will automatically assume that the argument it is passed 
% is the name of a demo script if it is NOT EQUAL to either
% the reserved word "info".

% The variable GalleryGUIFlag is used to indicate whether or not the
% help string should be passed to the screen or the help button for
% the XPGALLRY GUI shell.
GalleryGUIFlag=1;

if strcmp(action,'info'),
    figNumber=gcf;
    infoHndl=get(figNumber,'UserData');
    infoString=get(infoHndl,'UserData');
    helpfun('Gallery Image Info',infoString);

else
    oldFigNumber=watchon;
 
    % Since the variable "action" is not the
    % word "info", it must be the name of a demo script.
    scriptName=action;

    % Now initialize the whole figure...
    figNumber=figure( ...
        'Name','Gallery Image', ...
        'NumberTitle','off');
    axes( ...
        'Units','normalized', ...
        'Position',[0.05 0.05 0.75 0.90], ...
        'XTick',[],'YTick',[], ...
        'Box','on');

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.90;
    top=0.95;
    bottom=0.05;
    left=0.85;
    btnWid=0.10;
    btnHt=0.10;
    % Spacing between the button and the next command's label
    spacing=0.04;
    
    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);

    %====================================
    % The INFO button
    labelStr='Info';
    callbackStr='xpgallry(''info'')';
    infoHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom+btnHt+spacing btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The CLOSE button
    labelStr='Close';
    callbackStr='close(gcf)';
    closeHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    set(figNumber,'UserData',infoHndl);

    eval(scriptName);

    watchoff(oldFigNumber);
    figure(figNumber);

end;    % if strcmp(action, ...
