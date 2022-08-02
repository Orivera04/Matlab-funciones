function grafcplx(action);
%GRAFCPLX Demonstrates complex function plots in MATLAB.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    figNumber=figure( ...
	'Name','Examples of Complex Function Plots', ...
        'NumberTitle','off', ...
	'Visible','off');
    axes( ...
	'Units','normalized', ...
	'XTick',[],'YTick',[],'ZTick',[], ...
	'Box','on', ...
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
	' % examples of functions of complex variables', ...
	' % in MATLAB');

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
	'Callback','grafcplx(''eval'')', ...
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
    % The F(Z)=Z button
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='z';
    callbackStr='grafcplx(''grafbutton'')';
    cmdStr=str2mat( ...
	' % A plot of f(z) = z', ...
	' z=cplxgrid(20);', ...
        ' cplxmap(z,z);' ...
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
    % The F(Z)=Z^3 button
    btnNumber=2;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='z^3';
    callbackStr='grafcplx(''grafbutton'')';
    cmdStr=str2mat( ...
	' % A complex plot of f(z) = z^3', ...
	' % Three maxima at the cube roots of 1', ...
	' z=cplxgrid(20);', ...
        ' cplxmap(z,z.^3);' ...
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
    % The F(Z)=(Z^4-1)^(1/4) button
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='z^4-1';
    callbackStr='grafcplx(''grafbutton'')';
    cmdStr=str2mat( ...
	' % A complex plot of f(z) = (z^4-1)^(1/4)', ...
	' % Four zeros at the fourth roots of 1', ...
	' z=cplxgrid(20);', ...
        ' cplxmap(z,(z.^4-1).^(1/4));' ...
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
    % The F(Z)=SQRT(Z) button
    btnNumber=4;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Square root';
    callbackStr='grafcplx(''grafbutton'')';
    cmdStr=str2mat( ...
	' % A complex plot of f(z) = z^(1/2)', ...
	' % The Riemann surface for the square root', ...
        ' cplxroot(2,15);' ...
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
    % The F(Z)=Z^(1/3) button
    btnNumber=5;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Cube root';
    callbackStr='grafcplx(''grafbutton'')';
    cmdStr=str2mat( ...
	' % A complex plot of f(z) = z^(1/3)', ...
	' % The Riemann surface for the cube root', ...
        ' cplxroot(3,15);' ...
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
        'Callback','grafcplx(''info'')');

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
    ttlStr='Examples of Complex Function Plots';
    hlpStr= ...                                               
        ['                                                 '  
         ' This window lets you see a variety of plots     '  
         ' of functions of complex variables. All you      '  
         ' need to do is push one of the buttons on        '  
         ' the right side of the window. The commands      '  
         ' that generate the plots are shown in the        '  
         ' MiniCommand Window.                             '  
         '                                                 '  
         ' If you like, you can even directly edit the     '  
         ' commands in the MiniCommand Window.             '  
         ' Type control-return to execute code in the      '  
         ' MiniCommand Window.                             '  
         '                                                 '  
         ' File name: grafcplx.m                           '];
    helpfun(ttlStr,hlpStr);                                   

end;    % if strcmp(action, ...
