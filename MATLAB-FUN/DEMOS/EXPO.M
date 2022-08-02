%EXPO	Brings up the splash screen that begins the MATLAB Expo

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

clc;
disp(' ');
disp(' Clearing all windows to begin the MATLAB Expo');
disp(' Now loading Expo initial screen...');
disp(' ');
disp(' ');
disp(' (Typing "expomap" will bring up the Expo Main Map');
disp(' without bringing up the initial splash screen)');
disp(' ');
close all;

%========================================
% Precompile map function
expomap null

%========================================
% Check for the existence of toolboxes
% and assemble required global variable ToolboxExistenceMatrix
existtb

%========================================
% Initialize important default values
defaultPos=get(0,'DefaultFigurePosition');
defaultPos(3:4)=[560 420];
set(0,'DefaultFigurePosition',defaultPos);

figNumber=figure( ...
	'NumberTitle','off', ...
	'Name','Welcome to the MATLAB Expo!', ...
	'Resize','off', ...
	'Pointer','watch');
set(gca,'position',[0 0 1 1]);
axis off
axHndl1=gca;

% Student edition will not spin the membrane.
if ~isstudent
	axHndl2=axes( ...
	    'Units','pixels', ...
	    'Position',[136 183 100 100], ...
	    'Visible','off');
	
	load memmovie
	
	%========================================
	% Create the SPIN button
	spinHndl=uicontrol( ...
	    'Style','pushbutton', ...
	    'Units','pixels', ...
	    'Position',[210 16 70 30], ...
	    'String','Spin', ...
	    'Enable','off', ...
	    'UserData',membraneMovie, ...
	    'Callback','movie(get(gco,''UserData''),1)');
	
	set(spinHndl,'Enable','off');
	
	% Clear membraneMovie since it's so big
	clear membraneMovie
end

%========================================
% Create the CONTINUE button
callbackStr=[ ...
    'colormap([0 0 0]);clf; figNumber=watchon;', ...
    'h=text(0,0,''Opening the MATLAB Expo Main Map...'');', ...
    'axis([-1 1 -1 1]); axis off;', ...
    'set(h,''HorizontalAlignment'',''center'');', ...
    'expomap; delete(figNumber);'];
contHndl=uicontrol( ...
    'Style','pushbutton', ...
    'Units','pixels', ...
    'Position',[351 16 70 30], ...
    'String','Continue', ...
    'Enable','off', ...
    'Callback',callbackStr);

set(contHndl,'Enable','off');

%========================================
% Create the HELP button
helpCallback='expomap(''help'');';
hlpHndl=uicontrol( ...
    'Style','pushbutton', ...
    'Units','pixels', ...
    'Position',[455 16 70 30], ...
    'String','Help', ...
    'Enable','off', ...
    'Callback',helpCallback);

set(hlpHndl,'Enable','off');

% Put up the splash screen background image
load splash
colormap(cm);
axes(axHndl1);
movie(splashImage,1);

if ~isstudent
	% Play spinning membrane movie
	axes(axHndl2)
	movie(get(spinHndl,'UserData'),1);
end
set(gcf,'Pointer','arrow');

set([contHndl spinHndl hlpHndl],'Enable','on');

clear membraneMovie splashImage axHndl1 axHndl2 cm callbackStr figNumber
clear cm2 defaultPos helpCallback spinHndl
clc

