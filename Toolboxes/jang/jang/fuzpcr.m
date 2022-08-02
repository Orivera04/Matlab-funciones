function fuzpcr(action)
%FUZPCR Fuzzy printed character recognition.

%	Roger Jang 7-14-95
%	(Adapted from Ned's neural.m)

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
	global FIS
	tmp = version;
	if str2num(tmp(1))==4,
		load pcr4.mat	% get fis matrix FIS
	else
		load pcr5.mat	% get fis matrix FIS
	end
    oldFigNumber=watchon;

    figNumber=figure( ...
        'Name','Character Recognition Using Fuzzy Logic', ...
        'NumberTitle','off', ...
	'Visible','off', ...
	'BackingStore','off');
	blackbg;

    axPos=[0.40 0.95-0.28 0.20 0.28];
    axHndl1=axes( ...
        'Units','normalized', ...
        'Position',axPos, ...
 	'XTick',[],'YTick',[], ...
	'Box','on');
    labelPos=[0.05 0.80 0.30 0.05];
    uicontrol( ...
        'Style','text', ...
	'String','Original Letter', ...
	'BackgroundColor','k', ...
	'ForegroundColor','w', ...
        'Units','normalized', ...
        'Position',labelPos);

    axHndl2=axes( ...
        'Units','normalized', ...
        'Position',axPos+[0 -0.31 0 0], ...
 	'XTick',[],'YTick',[], ...
	'Box','on');
    labelPos=[0.05 0.50 0.30 0.05];
    uicontrol( ...
        'Style','text', ...
	'String','Letter with Noise', ...
	'BackgroundColor','k', ...
	'ForegroundColor','w', ...
        'Units','normalized', ...
        'Position',labelPos);

    axHndl3=axes( ...
        'Units','normalized', ...
        'Position',axPos+[0 -0.62 0 0], ...
 	'XTick',[],'YTick',[], ...
	'Box','on');
    labelPos=[0.05 0.20 0.30 0.05];
    uicontrol( ...
        'Style','text', ...
	'String','Guess of Fuzzy Logic', ...
	'BackgroundColor','k', ...
	'ForegroundColor','w', ...
        'Units','normalized', ...
        'Position',labelPos);

    %===================================
    % Information for all buttons
    top=0.95;
    bottom=0.05;
    labelColor=[0.8 0.8 0.8];
    btnWid=0.20;
    btnHt=0.10;
    right=0.95;
    left=right-btnWid;
    % Spacing between the button and the next command's label
    spacing=0.05;
    
    %====================================
    % The CONSOLE frame
    frmBorder=0.02;
    frmPos=[left-frmBorder bottom-frmBorder btnWid+2*frmBorder 0.9+2*frmBorder];
    h=uicontrol( ...
        'Style','frame', ...
        'Units','normalized', ...
        'Position',frmPos, ...
	'BackgroundColor',[0.5 0.5 0.5]);

    %====================================
    % The NEW LETTER button
    btnNumber=1;
    yPos=top-btnHt-(btnNumber-1)*(btnHt+spacing);
    labelStr='New Letter';
    callbackStr=[mfilename '(''new'');'];

    % Generic button information
    btnPos=[left yPos btnWid btnHt];
    flyHndl=uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr);

    %====================================
    % The NOISE slider
    btnNumber=2;
    yPos=top-btnHt-(btnNumber-1)*(btnHt+spacing);
    labelStr='Noise';

    % Generic button information
    sldPos=[left yPos btnWid btnHt/2];
    labelPos=[left yPos+btnHt/2 btnWid btnHt/2];
    sldHndl=uicontrol( ...
        'Style','slider', ...
        'Units','normalized', ...
        'Position',sldPos);

    uicontrol( ...
        'Style','text', ...
        'Units','normalized', ...
	'String','Noise', ...
        'Position',labelPos);

    %====================================
    % The HIDE ORIGINAL popup button
    btnNumber=3;
    yPos=top-btnHt-(btnNumber-1)*(btnHt+spacing);
    labelStr='Hide Original';
    callbackStr=[mfilename ' hideorig'];
    
    % Generic button information
    btnPos=[left yPos btnWid btnHt];
    hideOrigHndl=uicontrol( ...
        'Style','checkbox', ...
        'Units','normalized', ...
        'Position',btnPos, ...
 	'Callback',callbackStr, ...
        'String',labelStr);

    %====================================
    % The HIDE GUESS popup button
    btnNumber=4;
    yPos=top-btnHt-(btnNumber-1)*(btnHt+spacing);
    labelStr='Hide Guess';
    callbackStr=[mfilename ' hideguess'];
    
    % Generic button information
    btnPos=[left yPos btnWid btnHt];
    hideGuessHndl=uicontrol( ...
        'Style','checkbox', ...
        'Units','normalized', ...
        'Position',btnPos, ...
 	'Callback',callbackStr, ...
        'String',labelStr);

    %====================================
    % The INFO button
    labelStr='Info';
    callbackStr=[mfilename ' info'];
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
    hndlList=[axHndl1 axHndl2 axHndl3 sldHndl hideOrigHndl hideGuessHndl];
    set(figNumber, ...
	'Visible','on', ...
	'UserData',hndlList);

    watchoff(oldFigNumber);
    feval(mfilename, 'new');
    figure(figNumber);

elseif strcmp(action,'hideorig'),
    figNumber=watchon;
    hndlList=get(figNumber,'Userdata');
    axHndl1=hndlList(1);
    hideOrigHndl=hndlList(5);
    axes(axHndl1);
    if get(hideOrigHndl,'Value'),
	cla
    	axis([0 2 0 2]);
    	text(1,1,'???', ...
	    'HorizontalAlignment','center', ...
	    'Color','yellow', ...
	    'FontSize',24);
    else
	cla
	letter=get(hideOrigHndl,'UserData');
	plotchar(letter);
    end
    watchoff(figNumber);    

elseif strcmp(action,'hideguess'),
    figNumber=watchon;
    hndlList=get(figNumber,'Userdata');
    axHndl3=hndlList(3);
    hideGuessHndl=hndlList(6);
    axes(axHndl3);
    if get(hideGuessHndl,'Value'),
	cla
    	axis([0 2 0 2]);
    	text(1,1,'???', ...
	    'HorizontalAlignment','center', ...
	    'Color','yellow', ...
	    'FontSize',24);
    else
	cla
	letter=get(hideGuessHndl,'UserData');
	plotchar(letter);
    end
    watchoff(figNumber);    

elseif strcmp(action,'new'),
    figNumber=watchon;
    hndlList=get(figNumber,'Userdata');
    axHndl1=hndlList(1);
    axHndl2=hndlList(2);
    axHndl3=hndlList(3);
    sldHndl=hndlList(4);
    hideOrigHndl=hndlList(5);
    hideGuessHndl=hndlList(6);

    load alphabet.mat
    colormap(fliplr(pink));
    randletter=alphabet(:,floor(rand*26+1)); 
    noiselevel=get(sldHndl,'Value');
    testletter=randletter+randn(35,1)*noiselevel;
%    A=logsig(pr2_w2*logsig(pr2_w1*testletter,pr2_b1),pr2_b2);
	global FIS
	[junk, junk, junk, A] = evalfis(testletter, FIS);
%    output=compet(A);
	output = A==max(A);
    outletter=alphabet(:,find(output==1));
    set(hideOrigHndl,'UserData',randletter);
    if ~get(hideOrigHndl,'Value'),
    	axes(axHndl1); 
	plotchar(randletter);
    end
    axes(axHndl2); 
    plotchar(testletter);
    set(hideGuessHndl,'UserData',outletter);
    if ~get(hideGuessHndl,'Value'),
    	axes(axHndl3); 
	plotchar(outletter);
    end

    watchoff(figNumber);

elseif strcmp(action,'info'),
    ttlStr=get(gcf,'Name');
    hlpStr= ...                                                 
        ['                                                   '  
         ' This window demonstrates the use of a fuzzy       '  
         ' logic to recognize the (upper-case) letters       '  
         ' of the alphabet. The system used here is based    '  
         ' on case-based reasoning, that is, the number of   '
	 ' fuzzy rules is equal to the number of printed     '
	 ' characters (26 in this case).The character guessed'
	 ' by the fuzzy inference system is the one with the '
	 ' maximal firing strength of a corresponding rule.  '
         '                                                   '  
         ' You can test the recognition system by pressing   '  
         ' the "New Letter" button. This passes a random     '  
         ' letter to the fuzzy system. The "Noise" slider    '
         ' add noise to make the classification problem      '  
         ' more difficult. The "Hide" buttons allow you hide '  
         ' either the original letter or the system''s guess. '  
         '                                                   '  
         ' File name: fuzpcr.m                               '];
    helpfun(ttlStr,hlpStr);                                     

end;    % if strcmp(action, ...
