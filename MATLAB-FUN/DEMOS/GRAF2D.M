function graf2d(action);
%GRAF2D	Demonstrates XY plots in MATLAB.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    figNumber=figure( ...
	'Name','Examples of XY Plots in MATLAB', ...
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
	' % examples of XY plots in MATLAB');
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
	'Callback','graf2d(''eval'')', ...
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
    spacing=0.03;

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
    % The LINE GRAPH button
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Line';
    callbackStr='graf2d(''demobutton'')';
    cmdStr=str2mat( ...
	' % Line plot of a chirp', ...
        ' x=0:0.05:5;', ...   
        ' y=sin(x.^2);', ...
        ' plot(x,y);' ...
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
    % The BAR GRAPH button
    btnNumber=2;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Bar';
    callbackStr='graf2d(''demobutton'')';
    cmdStr=str2mat( ...
	' % Bar plot of a bell shaped curve', ...
        ' x = -2.9:0.2:2.9;', ...
        ' bar(x,exp(-x.*x));' ...
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
    % The STAIR GRAPH button
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Stair';
    callbackStr='graf2d(''demobutton'')';
    cmdStr=str2mat( ...
	' % Stairstep plot of a sine wave', ...
        ' x=0:0.25:10;', ...   
        ' stairs(x,sin(x));' ...
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
    % The ERROR BAR GRAPH button
    btnNumber=4;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Error Bar';
    callbackStr='graf2d(''demobutton'')';
    cmdStr=str2mat( ...
	' % Errorbar plot', ...
        ' x=-2:0.1:2;', ...
        ' y=erf(x);', ...
        ' e = rand(size(x))/10;', ...
        ' errorbar(x,y,e);' ...
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
    % The POLAR GRAPH button
    btnNumber=5;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Polar';
    callbackStr='graf2d(''demobutton'')';
    cmdStr=str2mat( ...
	' % Polar plot', ...
        ' t=0:.01:2*pi;', ...
        ' polar(t,abs(sin(2*t).*cos(2*t)));' ...
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
    % The STEM button
    btnNumber=6;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Stem';
    callbackStr='graf2d2(''grafbutton'')';
    cmdStr=str2mat( ...
	' % Stem plot', ...
        ' x = 0:0.1:4;', ...
        ' y = sin(x.^2).*exp(-x);', ...
        ' stem(x,y)' ...
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
        'Callback','graf2d(''info'')');

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
         ' This window lets you see a variety of 2-D     '  
         ' line plots in MATLAB by simply pushing the    '  
         ' buttons on the right side of the window. The  '  
         ' commands that generate the plots are shown    '  
         ' in the MiniCommand Window.                    '  
         '                                               '  
         ' If you like, you can even directly edit the   '  
         ' commands in the MiniCommand Window.           '  
         ' Type control-return to execute code in the    '  
         ' MiniCommand Window.                           '  
         '                                               '  
         ' File name: graf2d.m                           '];
    helpfun(ttlStr,hlpStr);                

end;    % if strcmp(action, ...
