function xpctrl(action)
%XPCTRL	Demonstrates basic control commands in the Control Toolbox.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    figNumber=figure( ...
	'Name','Examples of Basic Control Commands', ...
        'NumberTitle','off', ...
	'Visible','off');

    figDefaultAxesPos=[0.10 0.45 0.65 0.45];
    set(figNumber,'DefaultAxesPosition',figDefaultAxesPos);

    axes( ...
	'Units','normalized', ...
        'Position',figDefaultAxesPos);

    %===================================
    % Set up the MiniCommand Window
    top=0.35;
    left=0.05;
    right=0.75;
    bottom=0.05;
    labelHt=0.05;
    spacing=0.005;
    promptStr=str2mat(' ',...
              ' % Press the buttons at the right to see examples of basic', ...
	      ' % control commands.');
    % First, the MiniCommand Window frame
    frmBorder=0.02;
    frmPos=[left-frmBorder bottom-frmBorder ...
	(right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);
    % Then the text label
    labelPos=[left top-labelHt (right-left) labelHt];
    uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',[0.50 0.50 0.50], ...
	'ForegroundColor',[1 1 1], ...
        'String','MiniCommand Window');
    % Then the editable text field
    mcwPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    mcwHndl=uicontrol( ...
	'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',mcwPos, ...
	'Callback','xpctrl(''eval'')', ...
        'String',promptStr);
    % Save this handle for future use
    set(gcf,'UserData',mcwHndl);

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    left=0.80;
    btnWid=0.15;
    btnHt=0.08;
    % Spacing between the button and the next command's label
    spacing=0.04;

    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=0.05-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);
    
    %====================================
    % The ROOT LOCUS button
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Root Locus';
    callbackStr='xpctrl(''demobutton'')';
    cmdStr=str2mat( ...
        ' [num,den]=rmodel(3);', ...   
        ' rlocus(num,den)', ...
        ' title(''Root Locus of a Random System'');' ...
    );        
    
    % Generic popup button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',cmdStr);

    %====================================
    % The BODE button
    btnNumber=2;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Bode';
    callbackStr='xpctrl(''demobutton'')';
    cmdStr=str2mat( ...
        ' [num,den]=rmodel(3);', ...   
        ' [mag,phase,w]=bode(num,den);', ...
	' loglog(w,mag)', ...
        ' title(''Bode Magnitude Plot of a Random System'');' ...
    );
    
    % Generic popup button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',cmdStr);

    %====================================
    % The STEP RESPONSE button
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Step';
    callbackStr='xpctrl(''demobutton'')';
    cmdStr=str2mat( ...
        ' [num,den]=rmodel(3);', ...   
        ' step(num,den)', ...
        ' title(''Step Response Plot of a Random System'');' ...
    );        
    
    % Generic popup button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',cmdStr);

    %====================================
    % The IMPULSE button
    btnNumber=4;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Impulse';
    callbackStr='xpctrl(''demobutton'')';
    cmdStr=str2mat( ...
        ' [num,den]=rmodel(3);', ...   
        ' impulse(num,den)', ...
        ' title(''Impulse Response Plot of a Random System'');' ...
    );        
    
    % Generic popup button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
 	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',cmdStr);

    %====================================
    % The NYQUIST button
    btnNumber=5;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Nyquist';
    callbackStr='xpctrl(''demobutton'')';
    cmdStr=str2mat( ...
        ' [num,den]=rmodel(3);', ...   
        ' nyquist(num,den)', ...
        ' title(''Nyquist Plot of a Random System'');' ...
    );        
    
    % Generic popup button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',cmdStr);

    %====================================
    % The INFO button
    uicontrol( ...
	'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+btnHt+spacing btnWid btnHt], ...
        'String','Info', ...
        'Callback','xpctrl(''info'')');

    %====================================
    % The CLOSE button
    uicontrol( ...
	'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom btnWid btnHt], ...
        'String','Close', ...
        'Callback','close(gcf)');

    % Now uncover the figure
    set(figNumber,'Visible','on');

elseif strcmp(action,'demobutton'),
    cmdStr=get(gco,'UserData');
    mcwHndl=get(gcf,'UserData');
    set(mcwHndl,'String',cmdStr);
    evalmcw(mcwHndl);

elseif strcmp(action,'eval'),
    mcwHndl=get(gcf,'UserData');
    cmdStr=get(mcwHndl,'String');
    evalmcw(mcwHndl);

elseif strcmp(action,'info'),
    ttlStr=get(gcf,'Name');
    hlpStr= ...                                             
        ['                                               '  
         ' This window lets you see a variety of Control '  
         ' Toolbox commands by simply pressing the       '  
         ' buttons on the right side of the window. The  '  
         ' commands that generate the plots are shown    '  
         ' in the MiniCommand Window.                    '  
         '                                               '  
         ' The models generated are random with the      '  
         ' constraint that they are guaranteed to be     '  
         ' stable.                                       '  
         '                                               '  
         ' If you like, you can even directly edit the   '  
         ' commands in the MiniCommand Window.           '  
         ' Type control-return to execute code in the    '  
         ' MiniCommand Window.                           '  
         '                                               '  
         ' File name: xpctrl.m                           '];
    helpfun(ttlStr,hlpStr);                

end;    % if strcmp(action, ...
