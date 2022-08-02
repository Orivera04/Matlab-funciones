function bblwrap(action);
%BBLWRAP A silly function.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Possible actions:
% push
% info

str= ...                   
    ['d#f2#dwvws#mqfv7ys'  
     '|n<tsnxz#enle2mh}h'  
     'vfgzm92mo}zyv#xd#h'  
     'l;pnpwdit2ihg|{{pz'  
     'ho##{isl#2l{tw4heh'  
     'kkf|8#x|pex#k{|z2#'  
     'ml#lw{x4#t2|f3xztl'  
     '#rn2d#}hvz}#dfz5rm'  
     '#q|ki#lp{f:#d2jxxr'  
     '#wn}m#jmjl#62kn{hj'];

if nargin<1,
    action='initialize';
end;
 
if strcmp(action,'push'),
    btnHndl=gco;
    frag14=setstr(str-3);
    soundHndl=get(gcf,'Userdata');
    counter=get(btnHndl,'UserData');
    if isempty(counter),
	delete(btnHndl);
  	if get(soundHndl,'Value'),
	    sound([0 1]);
	end;
    else
        set(btnHndl,'Position',[rand*0.50+0.05 rand*0.8+0.05 0.15 0.1]);
  	if get(soundHndl,'Value'),
	    sound([0 1]);
	end;
	counter=counter+1;
	set(btnHndl,'UserData',counter);
	if counter==5, set(btnHndl,'String','Okay, stop'); end;

	if counter==10, set(btnHndl,'String','Enough!'); end;

	if counter==15, set(btnHndl,'String','Mercy!'); end;

	if counter==25, set(btnHndl,'String','I concede'); end;
        
	if (counter>30)&(counter<41),
	    Cnbeta=size(frag14,2);
	    volpTest=counter-30;
	    [unSortBuffer,alpha]=sort(sin(volpTest*volpTest+(1:Cnbeta)));
	    [wrapData,enab]=sort(alpha);
	    lpqParam=frag14(volpTest,enab);
	    text(rand,rand,lpqParam,'era','non','col','c','rot',fix(4*rand)*90);
	end;

    end;	

elseif strcmp(action,'info'),
    ttlStr=get(gcf,'Name');
    hlpStr= ...                                          
        ['                                            '  
         ' This figure demonstrates some of the things'  
         ' you can do with the GUI tools now available'  
         ' in MATLAB.                                 '  
         '                                            '  
         ' File name: bblwrap.m                       '];
    helpfun(ttlStr,hlpStr);                              

elseif strcmp(action,'initialize'), 
    % Turn the watch on for the old figure
    oldFigNumber=watchon;

    %===================================
    % Now initialize the whole figure...
    figNumber=figure( ...
        'Name','Bubble Wrap', ...
        'NumberTitle','off', ...
	'Visible','off');

    axes( ...
	'Position',[0 0 0.8 1], ...
	'XLim',[0 1],'YLim',[0 1], ...
	'Visible','off', ...
	'DrawMode','fast');

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    yInitPos=0.90;
    top=0.95;
    bottom=0.05;
    left=0.80;
    btnWid=0.15;
    btnHt=0.10;
    % Spacing between the button and the next command's label
    spacing=0.04;
    
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
    % The SOUND check box
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='Sound';

    % Generic button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    soundHndl=uicontrol( ...
        'Style','checkbox', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr);

    %====================================
    % The INFO button
    labelStr='Info';
    callbackStr='bblwrap info';
    infoHndl=uicontrol( ...
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

    hndlList=soundHndl;
    set(figNumber, ...
	'Visible','on', ...
	'UserData',hndlList);
    
    for n = 1:10,
    	btnHndl=uicontrol( ...
	    'Style','pushbutton', ...
	    'Units','normalized',...
            'Position',[rand*0.50+0.05 rand*0.8+0.05 0.15 0.1], ...
	    'Callback','bblwrap push',...
            'String','Push Me');
    end;

    % One of the buttons will be a mischief maker
    set(btnHndl,'UserData',1);

    watchoff(oldFigNumber);
    figure(figNumber);

end;    % if strcmp(action, ...


