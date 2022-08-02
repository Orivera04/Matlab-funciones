%LINEEXP  Line Experimenter                      last updated 2/10/96
%
%        An interactive routine that lets you choose pairs of points
%        for two lines using the mouse. Selection of integer
%        point values or decimal point values can be made.
%  
%        Various experiments can be performed.
%
%        Use in the form   ===>  lineexp   <===
%
%  By: David R. Hill, Math Dept, Temple University,
%      Philadelphia, Pa. 19122   Email: hill@math.temple.edu

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%locations info about the lines messages
%
locsum1=[-.15 .85;-.15 .8;-.15 .55;-.15 .50;-.15 .35;-.15 .30];

%STRINGS
%

mess1='Selection out of range.';
mess2='Select point again in the box.';

header='LINE EXP';
bp=setstr(7);
beep=[ bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp...
            bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp...
            bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp bp];

s0=' ';
s1='                     LINE Experiments';
s2='DATA ENTRY';
s3='LINEEXP is over!';
cont='Press ENTER to continue.';

mousedat=['      Directions for Selecting Data Using the Mouse       ';
          '                                                          ';
          'In the graph box, position the mouse at a point and click ';
          'to record the coordinates of the point. Choose two points ';
          'for each line. The data points will be plotted.           ';
          '                                                          ';
          'If integer selection is chosen the value selected will be ';
          'the nearest integer pair to the mouse position.           ';
          '                                                          ';
          'Stay within the graphics box for data selection otherwise ';
          'the results may be erratic.                               ';
          '                                                          ';
          'Warning: Select integer or decimal mode before clicking on';
          'a line selection button.                                  ';
          '                                                          '];

%integer grid values; used in 'integer' selection mode
%
rval=[-10 10 -10 10];
vals=rval(1):rval(2)/10:rval(2);

%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help lineexp,';
helps=[helps 'disp(mousedat),disp(cont),pause,set(gcf,''visible'',''on'');'];
%

%CALL back for done button
done = 'close(gcf),clc,disp(s3)';%callback for quit button
%

%callback for Select Line #1
%
ptsforl1='set(txtHndl,''string'',';
ptsforl1=[ptsforl1 '''Use mouse to select 2 points for line #1.'');'];
ptsforl1=[ptsforl1 'set(txtHndl1,''string'',s0);'];
ptsforl1=[ptsforl1 'axes(grbox);'];%selecting line
ptsforl1=[ptsforl1 'validpt=''N'';while validpt==''N'',[x1,y1]=ginput(1);'];
ptsforl1=[ptsforl1 'if abs(x1)<rval(2) & abs(y1)<rval(2),validpt=''Y'';'];
ptsforl1=[ptsforl1 'else,disp(beep),set(txtHndl,''string'',mess1);'];
ptsforl1=[ptsforl1 'pause(3),set(txtHndl,''string'',mess2);pause(4),'];
ptsforl1=[ptsforl1 'set(txtHndl,''string'',s0);end;end;'];   
ptsforl1=[ptsforl1 'if intsw==''Y'',[mv mi]=min(abs(vals-x1));x1=vals(mi);'];
ptsforl1=[ptsforl1 '[mv mi]=min(abs(vals-y1));y1=vals(mi);end,'];
ptsforl1=[ptsforl1 'plot(x1,y1,''ob'',''erasemode'',''none'');drawnow;'];
ptsforl1=[ptsforl1 'pt1l1=[''Point: ('' num2str(x1) '','' num2str(y1) '')''];'];
ptsforl1=[ptsforl1 'delete(line1but);'];
ptsforl1=[ptsforl1 'axes(basehndl);'];
ptsforl1=[ptsforl1 'text(locsum1(1,1),locsum1(1,2),pt1l1,''color'',''blue'',''erasemode'',''none'');'];
ptsforl1=[ptsforl1 'drawnow;'];
ptsforl1=[ptsforl1 'axes(grbox);'];
ptsforl1=[ptsforl1 'validpt=''N'';while validpt==''N'',[x2,y2]=ginput(1);'];
ptsforl1=[ptsforl1 'if abs(x2)<rval(2) & abs(y2)<rval(2),validpt=''Y'';'];
ptsforl1=[ptsforl1 'else,disp(beep),set(txtHndl,''string'',mess1);'];
ptsforl1=[ptsforl1 'pause(3),set(txtHndl,''string'',mess2);pause(4),'];
ptsforl1=[ptsforl1 'set(txtHndl,''string'',s0);end;end;'];
ptsforl1=[ptsforl1 'if intsw==''Y'',[mv mi]=min(abs(vals-x2));x2=vals(mi);'];
ptsforl1=[ptsforl1 '[mv mi]=min(abs(vals-y2));y2=vals(mi);end,'];
ptsforl1=[ptsforl1 'plot(x2,y2,''ob'',''erasemode'',''none'');drawnow;'];
ptsforl1=[ptsforl1 'pt2l1=[''Point: ('' num2str(x2) '','' num2str(y2) '')''];'];
ptsforl1=[ptsforl1 'axes(basehndl);'];
ptsforl1=[ptsforl1 'text(locsum1(2,1),locsum1(2,2),pt2l1,''color'',''blue'',''erasemode'',''none'');'];
ptsforl1=[ptsforl1 'drawnow;'];
ptsforl1=[ptsforl1 'axes(grbox);'];
ptsforl1=[ptsforl1 'pause(3);slp=(y2-y1)/(x2-x1);'];
ptsforl1=[ptsforl1 'yl=y1+slp*(rval(1)-x1);yr=y1+slp*(rval(2)-x1);'];
ptsforl1=[ptsforl1 'yinter=y1+slp*(-x1);'];
ptsforl1=[ptsforl1 'plot([rval(1) rval(2)],[yl yr],''-b'','];
ptsforl1=[ptsforl1 '''erasemode'',''none'');'];
ptsforl1=[ptsforl1 'set(txtHndl,''string'',''Your line #1 is shown.'');'];
ptsforl1=[ptsforl1 'pause(5);'];

%ptsforl1=[ptsforl1 'pause(3);'];
ptsforl1=[ptsforl1 'eval(line2);'];


%option for reselecting points
%display equation in ax+by = c form

%Setting up
%line #2 
%
line2='axes(basehndl);';
line2=[line2 'line2but=uicontrol(''style'',''push'',''units'',''normal'','];
line2=[line2 '''backgroundcolor'',''y'',''pos'',[.05 .65 .25 .05],'];
line2=[line2 '''string'',''Select Points for Line # 2'','];
line2=[line2 '''foregroundcolor'',''b'',''call'',ptsforl2);'];
line2=[line2 'refresh(gcf)'];

%callback for second line
%
ptsforl2=...
'set(txtHndl,''string'',''Use mouse to select 2 pts for line #2.'');';
ptsforl2=[ptsforl2 'set(txtHndl1,''string'',s0);'];
ptsforl2=[ptsforl2 'axes(grbox);'];%selecting line #2
ptsforl2=[ptsforl2 'validpt=''N'';while validpt==''N'',[x1,y1]=ginput(1);'];
ptsforl2=[ptsforl2 'if abs(x1)<rval(2) & abs(y1)<rval(2),validpt=''Y'';'];
ptsforl2=[ptsforl2 'else,disp(beep),set(txtHndl,''string'',mess1);'];
ptsforl2=[ptsforl2 'pause(3),set(txtHndl,''string'',mess2);pause(4),'];
ptsforl2=[ptsforl2 'set(txtHndl,''string'',s0);end;end;']; 
ptsforl2=[ptsforl2 'if intsw==''Y'',[mv mi]=min(abs(vals-x1));x1=vals(mi);'];
ptsforl2=[ptsforl2 '[mv mi]=min(abs(vals-y1));y1=vals(mi);end,'];
ptsforl2=[ptsforl2 'plot(x1,y1,''xr'',''erasemode'',''none'');'];
ptsforl2=[ptsforl2 'pt1l2=[''Point: ('' num2str(x1) '','' num2str(y1) '')''];'];
%ptsforl2=[ptsforl2 'delete(line2but);'];
ptsforl2=[ptsforl2 'axes(basehndl);'];
ptsforl2=[ptsforl2 'text(locsum1(3,1),locsum1(3,2),pt1l2,''color'',''red'',''erasemode'',''none'');'];
ptsforl2=[ptsforl2 'drawnow;'];
ptsforl2=[ptsforl2 'axes(grbox);'];
ptsforl2=[ptsforl2 'validpt=''N'';while validpt==''N'',[x2,y2]=ginput(1);'];
ptsforl2=[ptsforl2 'if abs(x2)<rval(2) & abs(y2)<rval(2),validpt=''Y'';'];
ptsforl2=[ptsforl2 'else,disp(beep),set(txtHndl,''string'',mess1);'];
ptsforl2=[ptsforl2 'pause(3),set(txtHndl,''string'',mess2);pause(4),'];
ptsforl2=[ptsforl2 'set(txtHndl,''string'',s0);end;end;']; 
ptsforl2=[ptsforl2 'if intsw==''Y'',[mv mi]=min(abs(vals-x2));x2=vals(mi);'];
ptsforl2=[ptsforl2 '[mv mi]=min(abs(vals-y2));y2=vals(mi);end,'];
ptsforl2=[ptsforl2 'plot(x2,y2,''xr'',''erasemode'',''none'');'];
ptsforl2=[ptsforl2 'pt2l2=[''Point: ('' num2str(x2) '','' num2str(y2) '')''];'];
ptsforl2=[ptsforl2 'axes(basehndl);'];
ptsforl2=[ptsforl2 'text(locsum1(4,1),locsum1(4,2),pt2l2,''color'',''red'',''erasemode'',''none'');'];
ptsforl2=[ptsforl2 'drawnow;'];
ptsforl2=[ptsforl2 'axes(grbox);'];
ptsforl2=[ptsforl2 'pause(3);slp=(y2-y1)/(x2-x1);'];
ptsforl2=[ptsforl2 'yl=y1+slp*(rval(1)-x1);yr=y1+slp*(rval(2)-x1);'];
ptsforl2=[ptsforl2 'yinter=y1+slp*(-x1);'];
ptsforl2=[ptsforl2 'plot([rval(1) rval(2)],[yl yr],''-r'','];
ptsforl2=[ptsforl2 '''erasemode'',''none'');'];
ptsforl2=[ptsforl2 'set(txtHndl,''string'',''Your line #2 is shown.'');'];
%ptsforl2=[ptsforl2 'pause(5);'];
ptsforl2=[ptsforl2 'delete(line2but);delete(butfrm);delete(rbutint);'];
ptsforl2=[ptsforl2 'delete(rbutdec);pause(2);'];

%COLOR settings
bkgr='white'; %background color
%

%Default selection is INTEGER
intsw='Y'; %setting integer selection switch to YES (ie on) as default


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%THE GUI STARTS HERE
hfig=figure('units','normal','position',[0 0 1 1],'color',bkgr);
axis('off')

%Having done a graphics command the axes for that graphics screen have been
%given a handle. We label it basehndl.
basehndl=gca;

%vanity
axes(basehndl);
text(.90,-.07,'by D.R.Hill','color','black','fontsize',14,...
     'fontweight','bold','fontangle','oblique','erasemode','none')

%
%TITLE
%

titext=text(-.15,1.05,header,'color','g',...
            'fontsize',28,'fontweight','bold',...
            'erasemode','none');
%
%START PUSH BUTTONS for Utility Functions + frame
%
utfrm=uicontrol('style','frame','units','normal',...
                 'position',[.04 .24 .34 .08],'backgroundcolor','y');
helph = uicontrol('style','push','units','normal','pos',[.05 .25 .1 .06], ...
        'string','Help','call',helps);
rstarth = uicontrol('style','push','units','normal','pos',[.16 .25 .1 .06], ...
        'string','Restart','call','close(gcf),lineexp');
endh = uicontrol('style','push','units','normal','pos',[.27 .25 .1 .06], ...
        'string','QUIT','call',done);

%
%Button to refresh screen if graph gets screwed up.
%
rfbut=uicontrol('style','push','units','normal','pos',[.80 .1 .15 .06], ...
        'string','Redraw Graph','call','refresh(gcf)');

%
%Button for line #1
%
axes(basehndl);
line1but=uicontrol('style','push','units','normal',...
                   'backgroundcolor','y',...
                   'pos',[.05 .85 .25 .05],...
                   'string','Select Points for Line # 1',...
                   'foregroundcolor','b',...
                   'call',ptsforl1);
%
%Starting RADIO Buttons for display Mode + FRAME
%

butfrm=uicontrol('style','frame','units','normal',...
                 'position',[.55 .04 .2 .15],'backgroundcolor','y');
rbutint=uicontrol('style','radio','string','Select Integers',...
                  'backgroundcolor','w',...
                  'units','normal','position',[.56 .13 .18 .05],... 
                  'value',1,...
                  'callback',['set(rbutint,''value'',1),'...
                              'set(rbutdec,''value'',0),'...
                              'intsw=''Y'';']);
rbutdec=uicontrol('style','radio','string','Select Decimals',...
                  'backgroundcolor','w',...
                  'units','normal','position',[.56 .05 .18 .05],... 
                  'callback',['set(rbutdec,''value'',1),'...
                              'set(rbutint,''value'',0),'...
                              'intsw=''N'';']);



%
%MESSAGE area    Borrowed from a MathWorks Routine
    %===================================
    % Set up the Comment Window
    top=0.18;
    left=0.05;
    right=0.5;
    bottom=0.05;
    labelHt=0.05;
    spacing=0.005;
    promptStr= ' ';

    % First, the Comment Window frame
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
	'ForegroundColor','white', ...
        'String','Comment Window');
    % Then the text field(s)
    
    txtPos=[left top-labelHt-2*frmBorder (right-left) labelHt];
    txtPos1=[left top-2*labelHt-2*frmBorder (right-left) labelHt];
    txtHndl=uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos, ...
        'String',promptStr,'foregroundcolor','red');
    txtHndl1=uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos1, ...
        'String',promptStr,'foregroundcolor','red');
%first message
%
set(txtHndl,'string','Click on Button to select points for line #1.');

%establish graphics box
%

grbox=axes('position',[.4 .25 .59 .73]);
plot([rval(1) rval(2)],[0 0],'-k',[0 0],[rval(1),rval(2)],'-k',...
     'erasemode','none')
axis(rval);axis('square');axis(axis);
set(grbox,'xcolor',[0 0 0],'ycolor',[0 0 0]);
set(grbox,'xtick',[rval(1):rval(2)],'ytick',[rval(1):rval(2)],...
    'xgrid','on','ygrid','on');
hold on;




