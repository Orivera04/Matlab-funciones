function xpmovie(action);
%XPMOVIE Movie player GUI shell.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% The variable MovieGUIFlag tells the movie helper functions if
% they are being called from the GUI shell or simply from the
% command line.
MovieGUIFlag=1;

% Possible actions:

if nargin<1,
    action='initialize';
end;

if strcmp(action,'make'),
    figNumber=gcf;
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    makeHndl=hndlList(2);
    playHndl=hndlList(3);
    loopsHndl=hndlList(4);
    modeHndl=hndlList(5);
    infoHndl=hndlList(6);
    closeHndl=hndlList(7);
    movieAxHndl=hndlList(8);
    statusAxHndl=hndlList(9);
    
    set([makeHndl playHndl infoHndl closeHndl],'Enable','off');
    
    % ====== Make the movie here
    set(figNumber,'Pointer','watch');
    set(statusAxHndl,'Visible','on');
    scriptName=get(txtHndl,'UserData');
    set(txtHndl,'String', ...
	['Status: Now making movie "' scriptName '"']);
    axes(movieAxHndl);
    eval(scriptName);
    set(txtHndl,'String', ...
	['Status: Movie complete. Ready to play movie "' scriptName '"']);
    axes(statusAxHndl);
    cla
    set(statusAxHndl,'Visible','off');
    set(statusAxHndl,'UserData',0);
    set(figNumber,'Pointer','arrow');
    % ====== End of making the movie

    set([makeHndl playHndl infoHndl closeHndl],'Enable','on');

elseif strcmp(action,'play'),
    figNumber=gcf;
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    makeHndl=hndlList(2);
    playHndl=hndlList(3);
    loopsHndl=hndlList(4);
    modeHndl=hndlList(5);
    infoHndl=hndlList(6);
    closeHndl=hndlList(7);
    movieAxHndl=hndlList(8);
    
    set([makeHndl playHndl infoHndl closeHndl],'Enable','off');
    
    set(figNumber,'Pointer','watch');
    scriptName=get(txtHndl,'UserData');
    set(txtHndl,'String',['Status: Now playing movie "' scriptName '"']);

    % ====== Play the movie here
    % Get movie data
    M=get(movieAxHndl,'Userdata');
    axes(movieAxHndl);
    numRepsListVal=get(loopsHndl,'Value');
    numRepsList=get(loopsHndl,'String');
    numReps=eval(numRepsList(numRepsListVal,:));

    % Get playback mode info
    modeListVal=get(modeHndl,'Value');
    modeList=get(modeHndl,'String');
    mode=deblank(modeList(modeListVal,:));

    % Now the movie can be played back at roughly 12 frames per second.
    if strcmp(mode,' -->'),
	movie(M,numReps,12);
    elseif strcmp(mode,' <--'),
	movie(fliplr(M),numReps,12);
    elseif strcmp(mode,' <-->'),
	movie(M,-numReps,12);
    end;
    % ====== End of playing movie

    set(txtHndl,'String',['Status: Ready to play movie "' scriptName '"']);
    set(figNumber,'Pointer','arrow');

    set([makeHndl playHndl infoHndl closeHndl],'Enable','on');

elseif strcmp(action,'info'),
    figNumber=gcf;
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    scriptName=get(txtHndl,'UserData');

    ttlStr=get(figNumber,'Name');
    hlpStr1=get(gco,'UserData');
    hlpStr2= ...
        ['                                                          '  
         ' This window is known as a Movie Player. It               '  
         ' works with files written using a special format to       '  
         ' create a graphic user interface for viewing              '  
         ' MATLAB movies conveniently. The actions of               '  
         ' the buttons are summarized below:                        '  
         '                                                          '  
         ' "Make" creates the movie.                                '  
         ' "Play" plays through the frames of the movie.            '  
         ' "Loops/Play" determines how many cycles the              '  
         '        movie plays through all frames.                   '  
         ' "Direction" determines the direction of the              '  
         '        movie: forward, backwards, back-and-forth.        '  
         '                                                          '  
         ' Note: movies may require large amount of                 '  
         ' memory.                                                  '];
    hlpStr2=str2mat(hlpStr2,' ',[' Now playing: "' scriptName '"']);
    if isempty(hlpStr1),
	helpfun(ttlStr,hlpStr2);
    else
	helpfun(ttlStr,hlpStr1,hlpStr2);
    end

else
    % Turn on the for the old figure
    oldFigNumber=watchon;

    % Since the variable "action" is not the word "make", "play" or 
    % "info", it must be the name of a movie-making script
    scriptName=action;

    figNumber=figure( ...
	'Visible','off', ...
	'NumberTitle','off', ...
	'Name','Movie Player');

    movieAxHndl=axes( ...
	'Units','normalized', ...
	'Visible','off', ...
	'XTick',[],'YTick',[], ...
        'Position',[0.12 0.35 0.50 0.60]);

    % UserData for the status axis will tell how much of the movie is actually complete
    statusAxHndl=axes( ...
	'Units','normalized', ...
        'Position',[0.05 0.15 0.65 0.05], ...
	'Box','on', ...
	'UserData',0, ...
	'Visible','off', ...
	'XTick',[],'YTick',[], ...
	'XLim',[0 1],'YLim',[0 1]);

    %===================================
    % Set up the Comment Window
    top=0.10;
    left=0.05;
    right=0.70;
    bottom=0.05;
    labelHt=0.05;
    spacing=0.005;
    % First, the Comment Window frame
    frmBorder=0.02;
    frmPos=[left-frmBorder bottom-frmBorder ...
	(right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.5 0.5 0.5]);
    % Then the text label
    labelPos=[left top-labelHt (right-left) labelHt];
    txtHndl=uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
	'HorizontalAlignment','left', ...
        'Position',labelPos, ...
        'BackgroundColor',[0.5 0.5 0.5], ...
	'ForegroundColor',[1 1 1], ...
        'String',['Status: Ready to make movie "' scriptName '"'], ...
	'UserData',scriptName);

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    bottom=0.05;
    left=0.75;
    yInitLabelPos=0.90;
    left=0.75;
    labelWid=0.20;
    labelHt=0.05;
    btnWid=0.20;
    btnHt=0.05;
    % Spacing between the label and the button for the same command
    btnOffset=0.003;
    % Spacing between the button and the next command's label
    spacing=0.03;

    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.5 0.5 0.5]);
    
    %====================================
    % The MAKE MOVIE button
    btnNumber=1;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelStr='Make';
    callbackStr='xpmovie make';
    
    % Generic button information
    btnPos=[left yLabelPos-2*btnHt btnWid 2*btnHt];
    hndl1=uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The PLAY MOVIE button
    btnNumber=2;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelStr='Play';
    callbackStr='xpmovie play';
    
    % Generic button information
    btnPos=[left yLabelPos-2*btnHt btnWid 2*btnHt];
    hndl2=uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
	'Enable','off', ...
        'Callback',callbackStr);
    % The next line is a workaround for a Windows bug...
    set(hndl2,'Enable','off');
    %====================================
    % The LOOPS/PLAY command popup button
    btnNumber=3;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelStr=' Loops/Play';
    labelList=' 1| 2| 5| 10| 25| 50';
    
    % Generic label information
    labelPos=[left yLabelPos-labelHt labelWid labelHt];
    uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',labelColor, ...
        'HorizontalAlignment','left', ...
        'String',labelStr);

    % Generic popup button information
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt];
    hndl3=uicontrol( ...
	'Style','popup', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelList);

    %====================================
    % The PLAYBACK DIRECTION command popup button
    btnNumber=4;
    yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
    labelStr=' Direction';
    labelList=' -->| <--| <-->';
    
    % Generic label information
    labelPos=[left yLabelPos-labelHt labelWid labelHt];
    uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',labelColor, ...
        'HorizontalAlignment','left', ...
        'String',labelStr);

    % Generic popup button information
    btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt];
    hndl4=uicontrol( ...
	'Style','popup', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelList);

    %====================================
    infoHndl=uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom+2*btnHt+spacing btnWid 2*btnHt], ...
        'String','Info', ...
        'Callback','xpmovie info');

    % The close button.
    closeHndl=uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom btnWid 2*btnHt], ...
        'String','Close', ...
        'Callback','close(gcf)');

    % ====== Test for PC with 16 color screen
    % On PCs with less than 16 colors movies will break.
    if get(0,'ScreenDepth')<=4,
    	computerType=computer;
    	if strcmp(computerType(1:2),'PC'),
	    warnStr='Sorry, MATLAB requires more than 16 colors for movies.';
    	    set(txtHndl, ...
		'BackgroundColor',[1 0.5 0.5], ...
		'ForegroundColor','k', ...
		'String',warnStr);
	    set([closeHndl infoHndl],'Enable','on');
	    set(hndl1,'Enable','off');
    	end
    end

    % Uncover the figure
    hndlList=[txtHndl hndl1 hndl2 hndl3 hndl4 ...
	infoHndl closeHndl movieAxHndl statusAxHndl];
    watchoff(oldFigNumber);
    set(figNumber,'Visible','on', ...
	'UserData',hndlList);

end;    % if strcmp(action, ...


