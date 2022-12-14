function helpfun(titleStr,helpStr1,helpStr2,helpStr3);
% HELPFUN Utility function for displaying help text conveniently.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

numPages=nargin-1;
if nargin<4,
    helpStr3=' ';
end;
if nargin<3,
    helpStr2=' ';
end;

% First turn on the watch pointer in the old figure
oldFigNumber=watchon;

% If the Help Window has already been created, bring it to the front
[existFlag,figNumber]=figflag('MATLAB Expo Info Window',1);
newHelpWindowFlag=~existFlag;

if newHelpWindowFlag,
    position=get(0,'DefaultFigurePosition');
    position(3:4)=[450 380];
    figNumber=figure( ...
        'Name','MATLAB Expo Info Window', ...
        'NumberTitle','off', ...
        'NextPlot','new', ...
	'Visible','off', ...
	'Position',position, ...
	'Colormap',[]);

    %===================================
    % Set up the Help Window
    top=0.95;
    left=0.05;
    right=0.75;
    bottom=0.05;
    labelHt=0.05;
    spacing=0.005;

    % First, the Text Window frame
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
    ttlHndl=uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'Position',labelPos, ...
        'BackgroundColor',[0.5 0.5 0.5], ...
        'ForegroundColor',[1 1 1], ...
        'String',titleStr);
    % Then the editable text field (of which there are three)
    % Store the text field's handle two places: once in the figure
    % UserData and once in the button's UserData.
    for count=1:3,
    	helpStr=eval(['helpStr',num2str(count)]);
    	txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    	txtHndlList(count)=uicontrol( ...
    	    'Style','edit', ...
    	    'Units','normalized', ...
    	    'Max',20, ...
    	    'String',helpStr, ...
    	    'BackgroundColor',[1 1 1], ...
	    'Visible','off', ...
    	    'Position',txtPos);
    end;
    set(txtHndlList(1),'Visible','on');

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    bottom=0.05;
    yInitPos=0.80;
    left=0.80;
    btnWid=0.15;
    btnHt=0.10;
    % Spacing between the button and the next command's label
    spacing=0.05;

    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    yPos=bottom-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.9+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.5 0.5 0.5]);

    %====================================
    % All required BUTTONS
    for count=1:3
	% The PAGE button
	labelStr=['Page ',num2str(count)];
	% The callback will turn off ALL text fields and then turn on
	% only the one referred to by the button.
	callbackStr= ...
	   ['txtHndl=get(gco,''UserData'');' ...
	    'hndlList=get(gcf,''UserData'');' ...
	    'set(hndlList(2:4),''Visible'',''off'');' ...
	    'set(txtHndl,''Visible'',''on'');'];
	btnHndlList(count)=uicontrol( ...
    	    'Style','pushbutton', ...
    	    'Units','normalized', ...
    	    'Position',[left top-btnHt-(count-1)*(btnHt+spacing) btnWid btnHt], ...
    	    'String',labelStr, ...
	    'UserData',txtHndlList(count), ...
	    'Visible','off', ...
    	    'Callback',callbackStr);
    end;

    %====================================
    % The CLOSE button
    callbackStr= ...
	['f1=gcf; f2=gpf; set(f1,''Visible'',''off'');', ...
	 'if f1~=f2, figure(f2); end'];
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left 0.05 btnWid 0.10], ...
        'String','Close', ...
        'Callback',callbackStr);

    hndlList=[ttlHndl txtHndlList btnHndlList];
        
    set(figNumber,'UserData',hndlList)
end;

% Now that we've determined the figure number, we can install the
% Desired strings.
hndlList=get(figNumber,'UserData');
ttlHndl=hndlList(1);
txtHndlList=hndlList(2:4);
btnHndlList=hndlList(5:7);
set(ttlHndl,'String',titleStr);
set(txtHndlList(2:3),'Visible','off');
set(txtHndlList(1),'Visible','on');
set(txtHndlList(1),'String',helpStr1);
set(txtHndlList(2),'String',helpStr2);
set(txtHndlList(3),'String',helpStr3);

if numPages==1,
    set(btnHndlList,'Visible','off');
elseif numPages==2,
    set(btnHndlList,'Visible','off');
    set(btnHndlList(1:2),'Visible','on');
elseif numPages==3,
    set(btnHndlList(1:3),'Visible','on');
end;

set(figNumber,'Visible','on');
% Turn off the watch pointer in the old figure
watchoff(oldFigNumber);
figure(figNumber);
