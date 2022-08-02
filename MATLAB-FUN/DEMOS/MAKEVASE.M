function makevase(action);
%MAKEVASE Generate and plot a surface of revolution.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin<1,
    action='initialize';
end;

if strcmp(action,'initialize'),
    figNumber=figure( ...
	'Name','Making a Vase', ...
        'NumberTitle','off', ...
	'Visible','off');
    axes( ...
	'Units','normalized', ...
	'XTick',[],'YTick',[], ...
	'Box','on', ...
        'Position',[0.05 0.35 0.70 0.60]);

    %===================================
    % Set up the Comment Window
    top=0.30;
    left=0.05;
    right=0.75;
    bottom=0.05;
    labelHt=0.05;
    spacing=0.005;
    promptStr= ...
        [' Press the "New Shape" button to create a vase-like'  
         ' shape (or body-of-rotation) using MATLAB graphics.'];
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
        'String','Comment Window');
    % Then the editable text field
    txtPos=[left bottom (right-left) top-bottom-labelHt-spacing];
    txtHndl=uicontrol( ...
	'Style','edit', ...
        'Units','normalized', ...
        'Max',10, ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos, ...
	'Callback','makevase(''eval'')', ...
        'String',promptStr);
    % Save this handle for future use
    set(gcf,'UserData',txtHndl);

    %====================================
    % Information for all buttons
    labelColor=[0.8 0.8 0.8];
    top=0.95;
    left=0.80;
    btnWid=0.15;
    btnHt=0.10;
    % Spacing between the button and the next command's label
    spacing=0.02;

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
    % The NEW SHAPE button
    btnNumber=1;
    yPos=top-(btnNumber-1)*(btnHt+spacing);
    labelStr='New Shape';
    callbackStr='makevase(''newshape'')';
    
    % Generic popup button information
    btnPos=[left yPos-btnHt btnWid btnHt];
    uicontrol( ...
	'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',labelStr, ...
        'Callback',callbackStr, ...
	'UserData',btnNumber);

    %====================================
    % The INFO button
    uicontrol( ...
	'Style','push', ...
        'Units','normalized', ...
        'Position',[left bottom+btnHt+spacing btnWid btnHt], ...
        'String','Info', ...
        'Callback','makevase(''info'')');

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

elseif strcmp(action,'newshape'),
    figNumber=gcf;
    txtHndl=get(figNumber,'UserData');
    str= ...
        [' The red line represents the center of rotation for the shape'  
         ' you are making. Click inside the axis box above to draw the '  
         ' outline of your vase. When you click with the right button  '  
         ' (or do a shift-click), the vase will be drawn.              '];
    set(txtHndl,'String',str);
    cla reset;
    ax=[-1 1 0 1];
    plot([0 0],[0 1],'r');
    axis(ax);
    set(gca,'XTick',[],'YTick',[],'Box','on');
    hold on;
    colormap(fliplr(pink));

    done=0;
    % Make sure the chosen point is a good one
    legalPt=0;
    while ~legalPt,
	waitforbuttonpress;
     	currPt=get(gca,'CurrentPoint');
    	currPt=currPt(1,1:2);
	if (currPt(1))>-1&(currPt(1)<1)&(currPt(2)>0)&(currPt(2)<1),
	    legalPt=1;
	else
	    set(txtHndl,'String',' Please click inside the axis square');
	end;
    end;
    line(currPt(1),currPt(2), ...
	'LineStyle','.', ...
	'Color','r', ...
	'MarkerSize',25, ...
	'EraseMode','none');
    line(-currPt(1),currPt(2), ...
	'LineStyle','.', ...
	'Color','b', ...
	'MarkerSize',25, ...
	'EraseMode','none');
    set(gca,'UserData',currPt);
    while ~done,

	% Make sure the chosen point is a good one
	legalPt=0;
	while ~legalPt,
	    waitforbuttonpress;
     	    currPt=get(gca,'CurrentPoint');
    	    currPt=currPt(1,1:2);
	    if (currPt(1))>-1&(currPt(1)<1)&(currPt(2)>0)&(currPt(2)<1),
		legalPt=1;
	    else
		set(txtHndl,'String',' Please click inside the axis square');
	    end;
	end;

    	line(currPt(1),currPt(2), ...
	    'LineStyle','.', ...
	    'Color','r', ...
	    'MarkerSize',25, ...
	    'EraseMode','none');
    	line(-currPt(1),currPt(2), ...
	    'LineStyle','.', ...
	    'Color','b', ...
	    'MarkerSize',25, ...
	    'EraseMode','none');
	ptList=[get(gca,'UserData'); currPt];
 	set(gca,'UserData',ptList);
  	numPts=size(ptList,1);
	line(ptList([numPts-1 numPts],1),ptList([numPts-1 numPts],2), ...
	    'Color','y', ...
	    'EraseMode','none');
	line(-ptList([numPts-1 numPts],1),ptList([numPts-1 numPts],2), ...
	    'Color','w', ...
	    'EraseMode','none');

  	if ~strcmp(get(figNumber,'SelectionType'),'normal'),
	    if size(ptList,1)<3,
	    	set(txtHndl,'String',' You must choose at least three points');
	    else
	    	done=1;
	    end
  	end
    end;

    str= ...
        [' Drawing is complete. Now rendering solid.           '  
         '                                                     '  
         ' Press the "New Shape" button to create another shape'];
    set(txtHndl,'String',str);
    xylist=get(gca,'UserData');
    x=xylist(:,1)';  
    y=xylist(:,2)';  
    hold off;  
    pause(1);
    n=24;  
    t=(0:n)'*2*pi/n;
    surfl(cos(t)*x,sin(t)*x,ones(n+1,1)*y);; 
    axis([-1.1 1.1 -1.1 1.1 0.1 0.9]);
    axis off; 

elseif strcmp(action,'info'),
    ttlStr=get(gcf,'Name');
    hlpStr= ...                                             
        ['                                               '  
         ' This is a demonstration of MATLAB graphics    '  
         ' applied to both two and three dimensional     '  
         ' representations of data.                      '  
         '                                               '  
         ' First, you specify a line shape with the mouse'  
         ' by clicking on the screen. When you have      '  
         ' finished, the body-of-revolution corresponding'  
         ' to that line is plotted using the SURFL       '  
         ' command.                                      '  
         '                                               '  
         ' File name: makevase.m                         '];
    helpfun(ttlStr,hlpStr);                                 

end;    % if strcmp(action, ...
