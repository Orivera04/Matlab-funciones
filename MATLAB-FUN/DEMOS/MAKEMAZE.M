function makemaze(action);
%MAKEMAZE Make and solve mazes.

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
    oldFigNumber=watchon;

    figNumber=figure( ...
        'Name','Making mazes', ...
        'NumberTitle','off', ...
	'Visible','off', ...
	'BackingStore','off');
    axes( ...
        'Units','normalized', ...
        'Position',[0.05 0.05 0.75 0.90], ...
        'Visible','off', ...
	'NextPlot','add');

    text(0,0,'Press the "Build" button to build a maze.', ...
	'HorizontalAlignment','center');
    axis([-1 1 -1 1]);

    %===================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    bottom=0.05;
    yInitPos=0.90;
    left=0.85;
    btnWid=0.10;
    btnHt=0.10;
    % Spacing between the button and the next command's label
    spacing=0.05;
    
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
    % The BUILD button
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Build';
    cmdStr='build';
    callbackStr='makemaze(''build'');';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    buildHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','yes', ...
        'Callback',callbackStr);

    %====================================
    % The MAZE SIZE label
    btnNumber=2;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    txtStr='Size';

    % Generic popup button information
    txtPos=[left yPos-btnHt/2 btnWid btnHt/2];
    popupHndl=uicontrol( ...
        'Style','text', ...
        'Units','normalized', ...
        'Position',txtPos, ...
        'String',txtStr);

    % The MAZE SIZE popup button
	if isstudent
        popupStr=reshape(' 10  15  20  25  30 ',4,5)';
	else
        popupStr=reshape(' 20  25  30  35  40 ',4,5)';
	end
    
    % Generic popup button information
    btnPos=[left yPos-btnHt btnWid btnHt/2];
    popupHndl=uicontrol( ...
        'Style','popup', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',popupStr);

    %====================================
    % The SOLVE button
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Solve';
    % Setting userdata to -1 (=stop) will stop the demo.
    callbackStr='makemaze(''solve'');';
    
    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    solveHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'Enable','off', ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The STOP button
    btnNumber=4;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Stop';
    % Setting userdata to -1 (=stop) will stop the demo.
    callbackStr='set(gca,''Userdata'',-1)';
    
    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
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
    callbackStr='makemaze(''info'')';
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
    hndlList=[buildHndl popupHndl solveHndl stopHndl infoHndl closeHndl];
    set(figNumber, ...
	'Visible','on', ...
	'UserData',hndlList);

    watchoff(oldFigNumber);
    figure(figNumber);

elseif strcmp(action,'build'),
    %====================================
    % Build a new maze
    axHndl=gca;
    figNumber=gcf;
    hndlList=get(figNumber,'Userdata');
    buildHndl=hndlList(1);
    popupHndl=hndlList(2);
    solveHndl=hndlList(3);
    stopHndl=hndlList(4);
    infoHndl=hndlList(5);
    closeHndl=hndlList(6);
    set([buildHndl solveHndl closeHndl infoHndl],'Enable','off');
    set(stopHndl,'Enable','on');

    % ====== Start of Demo
    % Makemaze problem

    global mazeMatrix mazeHndl

    popupStr=get(popupHndl,'String');
    popupValue=get(popupHndl,'Value');
    mazeSize=str2num(popupStr(popupValue,:));
    mazeWid=mazeSize;
    mazeHt=mazeSize;
    cla reset
    axis off;
    set(axHndl,'Userdata',play);

    set(axHndl, ...
    	'XLim',[1 mazeWid],'YLim',[1 mazeHt], ...
    	'NextPlot','add', ...
    	'Units','normalized', ...
       	'Visible','off');
    mazeMatrix=zeros(mazeWid,mazeHt);
    mazeMatrix(2:(mazeWid-1),2:(mazeHt-1))=ones(mazeWid-2,mazeHt-2);
    mazeMatrix(floor(mazeWid/2),3)=[0];
    mazeHndl=plot(floor(mazeWid/2),3,'w.', ...
    	'MarkerSize',20, ...
    	'EraseMode','xor');
    maze(floor(mazeWid/2),3);
    delete(mazeHndl);
    hold off;

    % ====== End of Demo
    set([buildHndl solveHndl closeHndl infoHndl],'Enable','on');
    set(stopHndl,'Enable','off');

elseif strcmp(action,'solve');
    %====================================
    % Solve an already built maze
    axHndl=gca;
    figNumber=gcf;
    hndlList=get(figNumber,'Userdata');
    buildHndl=hndlList(1);
    popupHndl=hndlList(2);
    solveHndl=hndlList(3);
    stopHndl=hndlList(4);
    infoHndl=hndlList(5);
    closeHndl=hndlList(6);
    set([buildHndl closeHndl infoHndl],'Enable','off');
    set(stopHndl,'Enable','on');

    % ====== Start of Demo
    % Makemaze problem

    global mazeMatrix mazeHndl doneFlag

    hold on;
    set(axHndl,'Userdata',play);

    % Hide the SECRET TREAT somewhere in the maze...
    [mazeHt,mazeWid]=size(mazeMatrix);
    %rewardXPos=floor(rand*mazeWid-1)+1;
    %rewardYPos=floor(rand*mazeHt/2)+floor(mazeHt)/2;
    [rewardXPos,rewardYPos]=ginput(1);
    rewardXPos=round(rewardXPos);
    rewardYPos=round(rewardYPos);
    mazeMatrix(rewardXPos,rewardYPos)=2;
    plot(rewardXPos,rewardYPos,'r.','MarkerSize',20);
    mazeHndl=plot(floor(mazeWid/2),3,'w.', ...
    	'MarkerSize',20, ...
    	'EraseMode','xor');
    doneFlag=0;
    solvmaze(floor(mazeWid/2),3,i);
    %delete(mazeHndl);
    hold off;

    % ====== End of Demo
    set([buildHndl closeHndl infoHndl],'Enable','on');
    set([stopHndl solveHndl],'Enable','off');    

elseif strcmp(action,'info');
    ttlStr=get(gcf,'Name');
    hlpStr= ...                                               
        ['                                                 '  
         ' This demo allows you to build and solve mazes   '  
         ' automatically using recursive algorithms.       '  
         '                                                 '  
         ' Press the "Build" button to initiate the maze   '  
         ' construction process.                           '  
         '                                                 '  
         ' Press the "Solve" button once the maze has      '  
         ' been created. The pointer will turn into a      '  
         ' cross-hair, indicating that you can click on any'  
         ' open (white-colored) part of the maze. As soon  '  
         ' as you do, the maze-solving algorithm will      '  
         ' begin.                                          '  
         '                                                 '  
         ' Pressing the "Stop" button during either maze   '  
         ' construction or solution will stop the process. '  
         '                                                 '  
         ' File name: makemaze.m                           '];
    helpfun(ttlStr,hlpStr);                                   

end;    % if strcmp(action, ...
