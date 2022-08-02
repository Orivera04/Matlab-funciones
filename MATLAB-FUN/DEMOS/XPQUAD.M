function xpquad(action);
%XPQUAD	Superquadrics plotting demonstration.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Information regarding the play status will be held in
% the axis user data according to the following table:
play= 1;
stop=-1;

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    figNumber=figure( ...
        'Name','Superquadrics', ...
        'NumberTitle','off', ...
	'Visible','off', ...
	'BackingStore','off');
    axes( ...
        'Units','normalized', ...
        'Position',[0.05 0.05 0.70 0.90], ...
        'Visible','off');

    %===================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    bottom=0.05;
    btnWid=0.15;
    btnHt=0.10;
    right=0.95;
    left=right-btnWid;
    % Spacing between the button and the next command's label
    spacing=0.02;
    
    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=bottom-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);

    %====================================
    % The first slider
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    callbackStr='xpquad(''build'');';

    % Generic button information
    sldPos=[left yPos-2*btnHt btnWid btnHt];
    labelPos1=[left yPos-btnHt/2 btnWid btnHt/2];
    labelPos2=[left yPos-btnHt btnWid btnHt/2];
    sld1Hndl=uicontrol( ...
        'Style','slider', ...
        'Units','normalized', ...
        'Position',sldPos, ...
        'Callback',callbackStr);

    uicontrol( ...
	'Style','text', ...
	'String','Vertical', ...
        'Units','normalized', ...
	'Position',labelPos1);
    uicontrol( ...
	'Style','text', ...
	'String','Roundness', ...
        'Units','normalized', ...
	'Position',labelPos2);

    %====================================
    % The second slider
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    callbackStr='xpquad(''build'');';

    % Generic button information
    sldPos=[left yPos-2*btnHt btnWid btnHt];
    labelPos1=[left yPos-btnHt/2 btnWid btnHt/2];
    labelPos2=[left yPos-btnHt btnWid btnHt/2];
    sld2Hndl=uicontrol( ...
        'Style','slider', ...
        'Units','normalized', ...
        'Position',sldPos, ...
        'Callback',callbackStr);

    uicontrol( ...
	'Style','text', ...
	'String','Horizontal', ...
        'Units','normalized', ...
	'Position',labelPos1);
    uicontrol( ...
	'Style','text', ...
	'String','Roundness', ...
        'Units','normalized', ...
	'Position',labelPos2);

    %====================================
    % The INFO button
    labelStr='Info';
    callbackStr='xpquad(''info'')';
    infoHndl=uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+btnHt+spacing btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The CLOSE button
    labelStr='Close';
    callbackStr='close(gcf)';
    closeHndl=uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    % Uncover the figure
    hndlList=[sld1Hndl sld2Hndl infoHndl closeHndl];
    set(figNumber, ...
	'Visible','on', ...
	'UserData',hndlList);

    % Draw the initial superquadric
    xpquad build

elseif strcmp(action,'build'),
    %====================================
    % Build a new maze
    axHndl=gca;
    figNumber=gcf;
    hndlList=get(figNumber,'Userdata');
    sld1Hndl=hndlList(1);
    sld2Hndl=hndlList(2);
    infoHndl=hndlList(3);
    closeHndl=hndlList(4);

    % ====== Start of Demo
    % Xpquad problem
    n=5*get(sld1Hndl,'Value');
    e=5*get(sld2Hndl,'Value');
    [x,y,z]=superquad(n,e,20);
    surfl(x,y,z);
    axis off;
    shading flat;
    colormap(fliplr(pink));

    % ====== End of Demo

elseif strcmp(action,'info');
    ttlStr=get(gcf,'Name');
    hlpStr= ...                                             
        ['                                               '  
         ' This demo shows plots of various versions of  '  
         ' Barr''s "superquadrics" ellipsoid. The shapes  '  
         ' are defined by two parameters, known as       '  
         ' vertical roundness and horizontal roundness.  '  
         ' These two parameters are, in turn, controlled '  
         ' by the sliders on the side panel of the       '  
         ' Superquadrics window.                         '  
         '                                               '  
         ' By adjusting these parameters, you can make   '  
         ' a cube, a sphere, a cylinder, and dozens of   '  
         ' curious generalized ellipsoids.               '  
         '                                               '  
         ' File name: xpquad.m                           '];
    helpfun(ttlStr,hlpStr);                                 
end;    % if strcmp(action, ...
