function spinner(action);
%SPINNER Colorful lines spinning through space.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Possible actions:
% initialize
% start

% Information regarding the play status will be held in
% the axis user data according to the following table:
play= 1;
stop=-1;

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    oldFigNumber=watchon;

    figNumber=figure( ...
        'Name','Color Spinner', ...
        'NumberTitle','off', ...
	'Visible','off');
    axes( ...
        'Units','normalized', ...
        'Position',[0.05 0.05 0.75 0.90], ...
        'Visible','off');

    text(0,0,'Press the "Start" button to see the Spinner demo', ...
	'HorizontalAlignment','center');
    axis([-1 1 -1 1]);

    %===================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.90;
    xPos=0.85;
    btnLen=0.10;
    btnWid=0.10;
    % Spacing between the button and the next command's label
    spacing=0.05;
    
    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[xPos-frmBorder yPos btnLen+2*frmBorder 0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);

    %====================================
    % The START button
    btnNumber=1;
    yPos=0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr='Start';
    cmdStr='start';
    callbackStr='spinner(''start'');';

    % Generic popup button information
    btnPos=[xPos yPos-spacing btnLen btnWid];
    startHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','yes', ...
        'Callback',callbackStr);

    %====================================
    % The STOP button
    btnNumber=2;
    yPos=0.90-(btnNumber-1)*(btnWid+spacing);
    labelStr='Stop';
    % Setting userdata to -1 (=stop) will stop the demo.
    callbackStr='set(gca,''Userdata'',-1)';
    
    % Generic popup button information
    btnPos=[xPos yPos-spacing btnLen btnWid];
    stopHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'Enable','off', ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The INFO button
    labelStr='Info';
    callbackStr='spinner(''info'')';
    infoHndl=uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos 0.20 btnLen 0.10], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The CLOSE button
    labelStr='Close';
    callbackStr='close(gcf)';
    closeHndl=uicontrol( ...
        'Style','push', ...
        'Units','normalized', ...
        'Position',[xPos 0.05 btnLen 0.10], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    % Uncover the figure
    hndlList=[startHndl stopHndl infoHndl closeHndl];
    set(figNumber, ...
	'Visible','on', ...
	'UserData',hndlList);

    watchoff(oldFigNumber);
    figure(figNumber);

elseif strcmp(action,'start'),
    axHndl=gca;
    figNumber=gcf;
    hndlList=get(figNumber,'Userdata');
    startHndl=hndlList(1);
    stopHndl=hndlList(2);
    infoHndl=hndlList(3);
    closeHndl=hndlList(4);
    set([startHndl infoHndl closeHndl],'Enable','off');
    set(stopHndl,'Enable','on');
    
    % ====== Start of Demo

    % This file adapted from COOLLINES.M
    %
    % by T. Krauss, The MathWorks, 12/11/92
    % modified, N. Gulley, 4-21-93
    cla 
    colormap([])
    N=50;    % number of lines
    M=50;    % number of colors
    map=hsv(M);
    set(figNumber,'BackingStore','off');
    set(axHndl, ...
        'XLim',[-0.01 1.01],'YLim',[-0.01 1.01], ...
        'XTick',[],'YTick',[], ...
        'Box','on', ...
	'Drawmode','fast', ...
        'ColorOrder',map, ...
        'Visible','on', ...
	'NextPlot','add', ...
        'UserData',play);

    h=plot([0 0],zeros(2,N),'EraseMode','background');

    x=rand;
    y=rand;
    x1=rand;
    y1=rand;
    dx=.01;
    dy=.01;
    dx1=.01;
    dy1=.01;
    mind=.001;
    maxd=.05;
    i=0;

    while get(axHndl,'Userdata')==play,
        i=i+1;
   	x=x+dx;
    	y=y+dy;
    	x1=x1+dx1;
    	y1=y1+dy1;
    	if (x>1),
            x=1; 
            dx=-(rand*(maxd-mind)+mind);
        end
        if (x<0),
            x=0; 
	    dx=(rand*(maxd-mind)+mind);
        end
        if (y>1),
	    y=1;
  	    dy=-(rand*(maxd-mind)+mind);
        end
        if (y<0),
	    y=0;
	    dy=(rand*(maxd-mind)+mind);
        end

        if (x1>1),
	    x1=1; 
	    dx1=-(rand*(maxd-mind)+mind);
        end
        if (x1<0),
	    x1=0;
	    dx1=(rand*(maxd-mind)+mind);
        end
        if (y1>1),
	    y1=1;
	    dy1=-(rand*(maxd-mind)+mind);
        end
        if (y1<0),
	    y1=0;
	    dy1=(rand*(maxd-mind)+mind);
        end
        set(h(rem(i,N)+1), ...
	    'Xdata',[x x1], ...
            'Ydata',[y y1]);
            %'Color',map(rem(i,M)+1,:));
        drawnow;
    end

    % ====== End of Demo
    set([startHndl infoHndl closeHndl],'Enable','on');
    set(stopHndl,'Enable','off');

elseif strcmp(action,'info');
    ttlStr='Spinner Info';
    hlpStr= ...                                         
        ['                                           '  
         ' This demo simply shows off some of the    '  
         ' animation capabilites of MATLAB by sending'  
         ' colorful lines spinning around the figure '  
         ' window.                                   '  
         '                                           '  
         ' File name: spinner.m                      '];
    helpfun(ttlStr,hlpStr);                             

end;    % if strcmp(action, ...

