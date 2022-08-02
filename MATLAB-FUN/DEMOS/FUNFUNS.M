function funfuns(action);
%FUNFUNS Demonstrates functions that operate on other functions.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    figNumber=figure( ...
	'Name','Function functions in MATLAB', ...
        'NumberTitle','off', ...
	'Visible','off');
    axes( ...
	'Units','normalized', ...
        'Position',[0.10 0.45 0.65 0.45]);

    %===================================
    % Set up the MiniCommand Window
    top=0.35;
    left=0.05;
    right=0.75;
    bottom=0.05;
    labelHt=0.05;
    spacing=0.005;
    promptStr=str2mat(' ',' % Press the buttons at the right to see', ...
	' % examples of functions that operate on other', ...
	' % functions in MATLAB');

    % First, the MiniCommand Window frame
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
    uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',[0.5 0.5 0.5], ...
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
	'Callback','funfuns(''eval'')', ...
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
	'BackgroundColor',[0.5 0.5 0.5]);
    
    %====================================
    % The FPLOT GRAPH button
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Plot';
    callbackStr='funfuns(''grafbutton'')';
    cmdStr=str2mat( ...
	' % Plot the function humps(x) with FPLOT', ...
	' fplot(''humps'',[0,2]);', ...
	' grid;' ...
    );
    
    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',cmdStr);

    %====================================
    % The ZERO FIND button
    btnNumber=2;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Find Zero';
    callbackStr='funfuns(''grafbutton'')';
    cmdStr=str2mat( ...
	' % Find the zero of humps(x) with FZERO', ...
	' z = fzero(''humps'',1);', ...
	' fplot(''humps'',[0,2]);', ...
 	' grid', ...
	' hold on; plot(z,0,''co''); hold off' ...
    );
    
    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',cmdStr);

    %====================================
    % The FMIN button
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Minimize';
    callbackStr='funfuns(''grafbutton'')';
    cmdStr=str2mat( ...
	' % Minimize humps(x) with FMIN', ...
	' m = fmin(''humps'',0.25,1);', ...
	' fplot(''humps'',[0 2]);', ...
	' grid', ...
	' hold on; plot(m,humps(m),''co''); hold off' ...
    );
    
    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',cmdStr);

    %====================================
    % The QUAD button
    btnNumber=4;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Integrate';
    callbackStr='funfuns(''grafbutton'')';
    cmdStr=str2mat( ...
	' % Compute a definite integral with QUAD', ...
	' q = quad(''humps'',0.5,1);', ...
	' fplot(''humps'',[0,2]);', ...
	' title([''Area = '',num2str(q)]);',  ...
	' grid' ...
    );
    
    % Generic button information
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
        'Callback','funfuns(''info'')');

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

elseif strcmp(action,'grafbutton'),
    cmdStr=get(gco,'UserData');
    mcwHndl=get(gcf,'UserData');
    set(mcwHndl,'String',cmdStr);
    evalmcw(mcwHndl);

elseif strcmp(action,'eval'),
    cla reset;
    mcwHndl=get(gcf,'UserData');
    cmdStr=get(mcwHndl,'String');
    evalmcw(mcwHndl);

elseif strcmp(action,'info'),
    ttlStr='Function functions in MATLAB';
    hlpStr= ...           
        ['                                                  '  
         ' Press the buttons on the right side of the       '  
         ' window to see examples of the use of             '  
         ' "function functions" in MATLAB, that is,         '  
         ' functions that take other function names as      '  
         ' input arguments.                                 '  
         '                                                  '  
         ' The function functions in this demo operate on   '  
         ' the "humps" function to calculate zero           '  
         ' crossings, minima, and areas.                    '  
         '                                                  '  
         ' The MiniCommand Window in the lower              '  
         ' right shows the list of commands that create     '
         ' the plot. If you like, you can even directly edit'
         ' the commands in the MiniCommand Window.          '  
         ' Type control-return to execute code in the       '  
         ' MiniCommand Window.                              '  
         '                                                  '  
         ' File name: funfuns.m                             '];
    helpfun(ttlStr,hlpStr);                

end;    % if strcmp(action, ...
