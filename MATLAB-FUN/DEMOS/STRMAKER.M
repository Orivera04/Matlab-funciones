function strmaker(action)
%STRMAKER Slide Show format string-building tool.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    action='mixed';
end;

if strcmp(action,'mixed')|strcmp(action,'type'),
    if strcmp(action,'mixed'), textBoxTop=0.40; end
    if strcmp(action,'type'), textBoxTop=0.97; end

    pos=get(0,'DefaultFigurePosition');
    pos=[pos(1) pos(2)-40 560 460];
    figNumber=figure( ...
        'Name','String Maker', ...
        'NumberTitle','off', ...
	'Position',pos);

    %===================================
    % Set up the Comment Window
    top=textBoxTop;
    left=0.03;
    right=0.77;
    bottom=0.03;
    labelHt=0.00;
    spacing=0.005;
    % First, the MiniCommand Window frame
    frmBorder=0.015;
    frmPos=[left-frmBorder bottom-frmBorder ...
	(right-left)+2*frmBorder (top-bottom)+2*frmBorder];
    uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);
    % Then the editable text field
    txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    txtHndl=uicontrol( ...
	'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos);
    % Save this handle for future use
    set(gcf,'UserData',txtHndl);

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.90;
    top=0.97;
    left=0.82;
    right=0.97;
    btnWid=right-left;
    btnHt=0.08;
    % Spacing between the button and the next command's label
    spacing=0.04;
    
    %====================================
    % The CONSOLE frame
    frmBorder=0.015;
    yPos=bottom-frmBorder;
    frmPos=[left-frmBorder yPos btnWid+2*frmBorder (top-bottom)+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.50 0.50 0.50]);

    %====================================
    % The QUOTE button
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Quote';
    callbackStr='strmaker(''quote'');';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    quoteHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','yes', ...
        'Callback',callbackStr);

    %====================================
    % The UNQUOTE button
    btnNumber=2;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Unquote';
    callbackStr='strmaker(''unquote'');';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    unquoteHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','yes', ...
        'Callback',callbackStr);

    %====================================
    % The CLEAR button
    btnNumber=3;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Clear';
    callbackStr='strmaker(''clear'')';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    clearHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Interruptible','yes', ...
        'Callback',callbackStr);

    %====================================
    % The HELP button
    labelStr='Help';
    callbackStr='strmaker(''help'')';
    helpHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom+btnHt+spacing btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The CLOSE button
    labelStr='Close';
    callbackStr='close(gcf)';
    closeHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',[left bottom btnWid btnHt], ...
        'String',labelStr, ...
        'Callback',callbackStr);

    hndlList=[txtHndl quoteHndl unquoteHndl helpHndl closeHndl];
    set(figNumber, ...
	'Visible','on', ...
	'UserData',hndlList);

elseif strcmp(action,'quote'),
    axHndl=gca;
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    str=get(txtHndl,'String');
    % Replace all zeros with 32s (ASCII spaces) to avoid problems.
    str(find(abs(str)==0))=32*ones(size(find(abs(str)==0)));
    numRows=size(str,1);
    spaces=32*ones(numRows,4);
    quotes=setstr(39*ones(numRows,1));
    openBrace=['['; setstr(32*ones(numRows-1,1))];
    closeBrace=[setstr(32*ones(numRows-1,2)); '];'];
    strNew=[spaces openBrace quotes str quotes closeBrace];
    strNew=str2mat('str= ...',strNew,'ssdisp(figNumber,str);');
    set(txtHndl,'String',strNew);

elseif strcmp(action,'unquote'),
    axHndl=gca;
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    str=get(txtHndl,'String');
    [numRows,numCols]=size(str);
    strNew=str(2:numRows-1,7:numCols-3);
    set(txtHndl,'String',strNew);

elseif strcmp(action,'clear'),
    hndlList=get(gcf,'Userdata');
    txtHndl=hndlList(1);
    set(txtHndl,'String','');

elseif strcmp(action,'help'),
    ttlStr=get(gcf,'Name');
    hlpStr= ...                                                
        ['                                                  '  
         ' The STRMAKER window is used to create            '  
         ' the strings that will work in conjunction with   '  
         ' slide show scripts.                              '  
         '                                                  '  
         ' Simply type the desired text into the text field,'  
         ' and when you are ready to move it into your      '  
         ' script, push the "Quote" button. Then you need   '  
         ' only copy the resulting text and paste it into   '  
         ' your script.                                     '  
         '                                                  '  
         ' The "Unquote" button strips the quoting applied  '  
         ' by the "Quote" button, and the "Clear" button    '  
         ' removes all text from the text field.            '  
         '                                                  '  
         ' File name: strmaker.m                            '];
    helpfun(ttlStr,hlpStr);                                    

end;    % if strcmp(action, ...
