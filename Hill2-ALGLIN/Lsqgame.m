%LSQGAME Least Squares Line Game               last updated 4/4/00
%
%     An interactive 'game' to select the least squares line
%     to a set of data. Two guesses for the lsq line can be made
%     using the mouse to select two points that are then connected.
%     The 'true' least squares line can be displayed. 
%     The sum of the squares of the vertical deviations from the 
%     corresponding line is computed and displayed.
%        
%     The data set for the 'game' can be entered using the mouse,
%     typed in as an n by 2 matrix, loaded from a previously
%     stored data set, or loaded by executing a m-file. In the 
%     latter two cases the data set must be an n by 2 matrix 
%     specifically named dmat.
%
%     Upon quitting the game the data set dmat can be saved for
%     future use. 
%
%        Use in the form   ===>  lsqgame   <===
%
%     Requires MATLAB 5 and routine myginput.
%
%  By: David R. Hill, Math Dept, Temple University,
%      Philadelphia, Pa. 19122   Email: hill@math.temple.edu

%It seems that 'erasemode', 'none' causes the cursor to vanish in the
%student edition version 5.
%On 11/17/97 I removed this from the point selection for data & lines.
%Things work fine.
%NOTES: On 11/18/97 Tech Supp Ref Number 153643 indicated a change from 'fullcrosshair'
%to 'crosshair' would fix the vanishing cursor problem I was having. I made this change in
%ginput and called the routine myginput.

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%INITIALIZING Switches
%
swq='N'; %if data set done
sw1='N'; %if line #1 done
sw2='N'; %if line #2 done
dev2sw='N'; %deviations for line #2
dev1sw='N';

%NUMBER of players is 1 or 2
playnum = 1;  %default

%STRINGS
%

mess1='Selection out of range.';
mess2='                       ';
mess3='Vertical line; make another choice.';
mess4='Sum of Squares of Deviations is ';
header='LSQ LINE GAME';
beep=setstr(7);

s0=' ';
s1='                    LSQ LINE GAME';
s2='DATA ENTRY';
s3='LSQGAME is over!';
s4='Data Entry as a set of ordered pairs in an n by 2 matrix';
s5='Enter your matrix like [ 2,3;4,-8; .... ] where the x and y';
s6='coordinates are seperated by a comma and the data pairs are';
s7='seperated by a semicolon. Do not forget the square brackets.';
s8='Data Matrix = ';
s9=['Data Entry from stored data file.';
    'The matrix must be called dmat.  '];
s10=['Enter file name with                  ';
     'appropriate path and attribute:  ==>  '];
s11='Data Entry from an m-file. ';
s12=['The matrix containing the'; 
     'data must be called dmat.'];
s13=['Enter m-file name            ';
     'with appropriate path:  ==>  '];
s14='Matrix of data must be n by 2';

dmenu=[' 1. Select data using the mouse.                  ';
       '                                                  ';
       ' 2. Enter n data points as an n by 2 matrix or    ';
       '    type the name of an n by 2 matrix of data.    ';
       '                                                  ';
       ' 3. Use an n by 2 matrix of data stored in a file.';
       '                                                  ';
       ' 4. Execute an m-file that creates a data set.    ';
       '                                                  ';
       ' 0. QUIT.                                         '];
makech='Enter your choice  ==>  ';
cont='Press ENTER to continue.';
mousedat=['      Directions for Selecting Data Using the Mouse       ';
          '                                                          ';
          'In the graphics box to be shown, position the mouse at a  ';
          'point and click the mouse to record the coordinates of the';
          'point as data. Continue using the mouse to complete your  ';
          'set of data. The data points will be designated by an * . ';
          '                                                          ';
          'To indicate that you have completed data selection press q';
          'on the keyboard.                                          ';
          '                                                          ';
          'Stay within the graphics box for data selection.          '];

%Player INFO
player=['This is an interactive game to select a least squares line model';
        'to a data set of ordered pairs. The game can have one player who';
        'can make two guesses at the least squares line OR two players   ';
        'that compete to see which one selects the better model. For     ';
        'either number of players the Least Squares Line which minimizes ';
        'the sum of the squares of the deviations can be displayed along ';
        'with the minimum deviation.                                     ';
        '                                                                '];
plrdraw=['Note: in some instances the graph of the points and lines may   ';
        'disappear. Click on the redraw button to regenerate the graph.  ';
        'It may require several redraws to recover the graph.            '];
plmore=['================================================================';
        'Select the number of PLAYERS:                                   ';
        '                                                                ';
        '1. ONE Player        2. TWO Players        0. QUIT              ';
        '                                                                '];

        

%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help lsqgame,disp(cont),';
helps=[helps 'pause,set(gcf,''visible'',''on'');'];
%

%CALL back for quit button
done = 'close(gcf),clc,disp(s3)';%callback for quit button
%

%callback for Select Line #1
%
ptsforl1='dev1sw=''N'';';
ptsforl1=[ptsforl1 'if swq==''Y'',set(txtHndl,''string'',';];
ptsforl1=[ptsforl1 '''Use mouse to select 2 pts for LSQ line.'');'];
ptsforl1=[ptsforl1 'set(txtHndl1,''string'',s0);'];
ptsforl1=[ptsforl1 'subplot(grbox);'];
ptsforl1=[ptsforl1 '[x1,y1]=myginput(1);'];   %selecting line
ptsforl1=[ptsforl1 'plot(x1,y1,''ob'',''linewidth'',2,''erasemode'',''none'');'];
ptsforl1=[ptsforl1 '[x2,y2]=myginput(1);'];
ptsforl1=[ptsforl1 'plot(x2,y2,''ob'',''linewidth'',2,''erasemode'',''none'');'];
ptsforl1=[ptsforl1 'pause(3);slp=(y2-y1)/(x2-x1);'];
ptsforl1=[ptsforl1 'yl=y1+slp*(rval(1)-x1);yr=y1+slp*(rval(2)-x1);'];
ptsforl1=[ptsforl1 'yinter=y1+slp*(-x1);'];
ptsforl1=[ptsforl1 'plot([rval(1) rval(2)],[yl yr],''-b'','];
ptsforl1=[ptsforl1 '''linewidth'',2,''erasemode'',''none'');'];
ptsforl1=[ptsforl1 'set(txtHndl,''string'',''Your LSQ line is shown.'');'];
ptsforl1=[ptsforl1 'pause(5);'];
ptsforl1=[ptsforl1 'set(txtHndl,''string'','];
ptsforl1=[ptsforl1 '''Computing Sum of Squares of Deviations'');'];
ptsforl1=[ptsforl1 'set(txtHndl1,''string'',s0);'];
ptsforl1=[ptsforl1 'xpt=dmat(:,1);ypt1=y1+slp*(xpt-x1*ones(size(xpt)));'];
ptsforl1=[ptsforl1 'sumsq=0;for ii=1:length(xpt);'];
ptsforl1=[ptsforl1 'plot([dmat(ii,1) dmat(ii,1)],[dmat(ii,2) ypt1(ii)],'];
ptsforl1=[ptsforl1 '''b-'',''erasemode'',''none'');'];
ptsforl1=[ptsforl1 'sumsq=sumsq+abs(dmat(ii,2)-ypt1(ii))^2;end,'];
ptsforl1=[ptsforl1 'dev1sw=''Y'';pause(3);'];
ptsforl1=[ptsforl1 'set(txtHndl,''string'',s0);'];
ptsforl1=[ptsforl1 'set(ssqtxt,''string'','];
ptsforl1=[ptsforl1 '''Line # 1: SUM of Squares of Deviations'');'];
ptsforl1=[ptsforl1 'eqn=[num2str(sumsq) '';   y = '' num2str(slp) '];
ptsforl1=[ptsforl1 '''x + ('' num2str(yinter) '')''];'];
ptsforl1=[ptsforl1 'set(ssqtxt1,''string'',eqn);'];
ptsforl1=[ptsforl1 'if chpl==1,sw2=''Y'';end,'];
ptsforl1=[ptsforl1 'pause(3);sw1=''Y'';end'];



%callback for second 'guess' at lsq line
%
ptsforl2='dev2sw=''N'';';
ptsforl2=[ptsforl2 'if swq==''Y'' & sw1==''Y'','];
ptsforl2=[ptsforl2 'set(txtHndl,''string'','];
ptsforl2=[ptsforl2 '''Use mouse to select 2 pts for LSQ line #2.'');'];
ptsforl2=[ptsforl2 'set(txtHndl1,''string'',s0);'];
ptsforl2=[ptsforl2 'subplot(grbox);'];
ptsforl2=[ptsforl2 '[x1,y1]=myginput(1);'];   %selecting line #2
ptsforl2=[ptsforl2 'plot(x1,y1,''xm'',''linewidth'',2,''erasemode'',''none'');'];
ptsforl2=[ptsforl2 '[x2,y2]=myginput(1);'];
ptsforl2=[ptsforl2 'plot(x2,y2,''xm'',''linewidth'',2,''erasemode'',''none'');'];
ptsforl2=[ptsforl2 'pause(3);slp=(y2-y1)/(x2-x1);'];
ptsforl2=[ptsforl2 'yl=y1+slp*(rval(1)-x1);yr=y1+slp*(rval(2)-x1);'];
ptsforl2=[ptsforl2 'yinter=y1+slp*(-x1);'];
ptsforl2=[ptsforl2 'plot([rval(1) rval(2)],[yl yr],''-m'','];
ptsforl2=[ptsforl2 '''linewidth'',2,''erasemode'',''none'');'];
ptsforl2=[ptsforl2 'set(txtHndl,''string'',''Your LSQ line #2 is shown.'');'];
ptsforl2=[ptsforl2 'pause(5);'];
ptsforl2=[ptsforl2 'set(txtHndl,''string'','];
ptsforl2=[ptsforl2 '''Computing Sum of Squares of Deviations'');'];
ptsforl2=[ptsforl2 'set(txtHndl1,''string'',s0);'];
ptsforl2=[ptsforl2 'xpt=dmat(:,1);ypt2=y1+slp*(xpt-x1*ones(size(xpt)));'];
ptsforl2=[ptsforl2 'sumsq=0;for ii=1:length(xpt);'];
ptsforl2=[ptsforl2 'plot([dmat(ii,1) dmat(ii,1)],[dmat(ii,2) ypt2(ii)],'];
ptsforl2=[ptsforl2 '''m-'',''erasemode'',''none'');'];
ptsforl2=[ptsforl2 'sumsq=sumsq+abs(dmat(ii,2)-ypt2(ii))^2;end,'];
ptsforl2=[ptsforl2 'dev2sw=''Y'';pause(3);'];
ptsforl2=[ptsforl2 'set(txtHndl,''string'',s0);'];
ptsforl2=[ptsforl2 'set(ssqtxt2,''string'','];
ptsforl2=[ptsforl2 '''Line # 2: SUM of Squares of Deviations'');'];
ptsforl2=[ptsforl2 'eqn=[num2str(sumsq) '';   y = '' num2str(slp) '];
ptsforl2=[ptsforl2 '''x + ('' num2str(yinter) '')''];'];
ptsforl2=[ptsforl2 'set(ssqtxt3,''string'',eqn);'];
ptsforl2=[ptsforl2 'pause(3);sw2=''Y'';end'];



%callback for exact solution button
%
showsoln='if swq==''Y'' & sw1==''Y'' & sw2==''Y'',';
showsoln=[showsoln 'if dev1sw==''Y'',subplot(grbox);for ii=1:length(xpt);'];
showsoln=[showsoln 'plot([dmat(ii,1) dmat(ii,1)],[dmat(ii,2) ypt1(ii)],'];
showsoln=[showsoln '''w-'',''erasemode'',''none'');end,end,'];
showsoln=[showsoln 'if dev2sw==''Y'',subplot(grbox);for ii=1:length(xpt);'];
showsoln=[showsoln 'plot([dmat(ii,1) dmat(ii,1)],[dmat(ii,2) ypt2(ii)],'];
showsoln=[showsoln '''w-'',''erasemode'',''none'');end,end,'];
%ERASING deviations in preceding code
showsoln=[showsoln 'set(txtHndl,''string'','];
showsoln=[showsoln '''Displaying "the least squares line".'');'];
showsoln=[showsoln 'set(txtHndl1,''string'',s0);'];
showsoln=[showsoln 'pause(3),'];
showsoln=[showsoln 'subplot(grbox);'];
showsoln=[showsoln 'lsqpoly=polyfit(dmat(:,1),dmat(:,2),1);'];
showsoln=[showsoln 'slp=lsqpoly(1);'];
%get point on lsq line
showsoln=[showsoln 'x1=dmat(1,1);y1=polyval(lsqpoly,x1);'];
showsoln=[showsoln 'yl=y1+slp*(rval(1)-x1);yr=y1+slp*(rval(2)-x1);'];
showsoln=[showsoln 'plot([rval(1) rval(2)],[yl yr],''-r'','];
showsoln=[showsoln '''linewidth'',2,''erasemode'',''none'');'];
showsoln=[showsoln 'set(txtHndl,''string'','];
showsoln=[showsoln '''"The least squares line" is shown.'');'];
showsoln=[showsoln 'pause(5);'];
showsoln=[showsoln 'set(txtHndl,''string'','];
showsoln=[showsoln '''Computing Sum of Squares of Deviations'');'];
showsoln=[showsoln 'set(txtHndl1,''string'',s0);'];
showsoln=[showsoln 'xpt=dmat(:,1);ypt=y1+slp*(xpt-x1*ones(size(xpt)));'];
showsoln=[showsoln 'sumsq=0;for ii=1:length(xpt);'];
showsoln=[showsoln 'plot([dmat(ii,1) dmat(ii,1)],[dmat(ii,2) ypt(ii)],'];
showsoln=[showsoln '''r-'',''erasemode'',''none'');'];
showsoln=[showsoln 'sumsq=sumsq+abs(dmat(ii,2)-ypt(ii))^2;end,'];
showsoln=[showsoln 'pause(3);'];
showsoln=[showsoln 'set(txtHndl,''string'',s0);'];
showsoln=[showsoln 'set(ssqtxt4,''string'','];
showsoln=[showsoln '''MININUM SUM of Squares of Deviations'');'];
showsoln=[showsoln 'eqn=[num2str(sumsq) '';   y = '' num2str(slp) '];
showsoln=[showsoln '''x + ('' num2str(lsqpoly(2)) '')''];'];
showsoln=[showsoln 'set(ssqtxt5,''string'',eqn);'];
showsoln=[showsoln 'pause(3);end'];


%Selecting number of players
%
validpl='N';
while validpl=='N'
   clc,disp(s1),disp(s0)
   disp(player)
   disp(plmore)
   chpl=input(makech);
   if isempty(chpl)==1,chp1=999;end
   if chpl==0,validpl='Y';clc,disp(s3),return,end
   if chpl==1,validpl='Y';end
   if chpl==2,validpl='Y';end
end

%Determining Data: Mouse or matrix or file
%
validch='N';
while validch=='N'
   clc,disp(s0),disp(s1),disp(s0),disp(s2),disp(s0)
   disp(dmenu),ch=input(makech);
   if isempty(ch)==1,ch=999;end
   if ch==0, validch='Y';clc,disp(s3),return,end
   if ch==1, validch='Y';datasw=ch;end
   if ch==2, validch='Y';datasw=ch;
      clc,disp(s0),disp(s4),disp(s0),format compact
      disp(s5),disp(s6),disp(s7),disp(s0),dmat=input(s8);
      format
   end
   if ch==3,validch='Y';datasw=ch;
      clc,disp(s0),disp(s9),disp(s0),
      disp(s10(1,:)),filst=input(s10(2,:),'s');
      e=exist(filst);
      if e~=0
         load(filst)
         ef=exist('dmat');
         if ef~=1
            error(['File exists, but matrix dmat does not.'])
         end
      else
         error(['File ' filst ' not found. Start over.'])
      end
   end
   if ch==4,validch='Y';datasw=ch;
      clc,disp(s0),
      format compact,disp(s11),disp(s12),format
      disp(s0),filst=input(s13,'s');
      e=exist(filst);
      if e==2
         eval(filst)
         ef=exist('dmat');
         if ef~=1
            error(['File exists, but matrix dmat does not.'])
         end
      else
         error(['File ' filst ' not found. Start over.'])
      end
   end
end
%Check size of matrix dmat
%
if ch~=1,[m,n]=size(dmat);
   if n~=2
      error(s14),return
   end      
end

%Based on whether or not we use the mouse show the data &
%set up use of the GUI
%
if ch==1
   clc,disp(s0),disp(mousedat),disp(s0),disp(cont),pause
   rval(1)=-10;%rectangle dimensions
   rval(2)=10;rval(3)=-10;rval(4)=10;
else
   x=dmat(:,1);y=dmat(:,2);
   maxx=max(x);minx=min(x);miny=min(y);maxy=max(y);
   xspread=maxx-minx;yspread=maxy-miny;
   incx=.1*xspread;incy=.1*yspread;  %taking 1/10 of spreads
                                     %for grapics box border
   rval(1)=minx-incx;rval(2)=maxx+incx;
   rval(3)=miny-incy;rval(4)=maxy+incy;   
end


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%THE GUI STARTS HERE
hfig=figure('units','normal','position',[0 0 1 1]);

%vanity
subplot('position',[.55 .05 .4 .1]);axis('off')
text(0,0,'by D.R.Hill','color','black','fontsize',10,...
     'fontweight','bold','fontangle','oblique','erasemode','none')

%
%TITLE
%

subplot('position',[0 .95 .4 .1]);axis('off')
titext=text(0,0,header,'color','m',...
            'fontsize',20,'fontweight','bold',...
            'erasemode','none');
%
%START PUSH BUTTONS for Utility Functions + frame
%
utfrm=uicontrol('style','frame','units','normal',...
                 'position',[.04 .24 .34 .08],'backgroundcolor','y');
helph = uicontrol('style','push','units','normal','pos',[.05 .25 .1 .06], ...
        'string','Help','call',helps);
rstarth = uicontrol('style','push','units','normal','pos',[.16 .25 .1 .06], ...
        'string','Restart','call','close(gcf),lsqgame');
endh = uicontrol('style','push','units','normal','pos',[.27 .25 .1 .06], ...
        'string','QUIT','call',done);

%
%Button to refresh screen if graph gets screwed up.
%
%rfbut=uicontrol('style','push','units','normal','pos',[.85 .1 .15 .06], ...
%        'string','Redraw Graph','call','refresh(gcf)');


%
%Blank fields for SUMSQ info to be set later
%
ssmess=subplot('position',[0 .35 .4 .3]);axis('off')
ssqtxt=text(0,.85,mess2,'fontweight','bold',...
       'color','b','units','normal','erasemode','none');
ssqtxt1=text(0,.7,mess2,'fontweight','bold',...
        'color','b','units','normal','erasemode','none');
ssqtxt2=text(0,.55,mess2,'fontweight','bold',...
        'color','m','units','normal','erasemode','none');
ssqtxt3=text(0,.4,mess2,'fontweight','bold',...
        'color','m','units','normal','erasemode','none');
ssqtxt4=text(0,.25,mess2,'fontweight','bold',...
        'color','r','units','normal','erasemode','none');
ssqtxt5=text(0,.1,mess2,'fontweight','bold',...
        'color','r','units','normal','erasemode','none');
%
%
%Buttons for lines 
%
selfrm=uicontrol('style','frame','units','normal',...
                 'position',[.04 .72 .22 .19],'backgroundcolor','y');

line1but=uicontrol('style','push','units','normal',...
                   'backgroundcolor','y',...
                   'pos',[.05 .85 .2 .05],...
                   'string','Select Line # 1',...
                   'foregroundcolor','b',...
                   'call',ptsforl1);
line2but=uicontrol('style','push','units','normal',...
                   'backgroundcolor','y',...
                   'pos',[.05 .79 .2 .05],...
                   'string','Select Line # 2',...
                   'foregroundcolor','b',...
                   'call',ptsforl2);
linetrue=uicontrol('style','push','units','normal',...
                   'backgroundcolor','y',...
                   'pos',[.05 .73 .2 .05],...
                   'string','Show LSQ Solution',...
                   'foregroundcolor','b',...
                   'call',showsoln);

%
%MESSAGE area    Borrowed from a MathWorks Routine
    %===================================
    % Set up the Comment Window
    top=0.20;
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
        'Position',txtPos,'fontsize',10, ...
        'String',promptStr,'foregroundcolor','red','fontweight','bold');
    txtHndl1=uicontrol( ...
	'Style','text', ...
        'Units','normalized', ...
        'BackgroundColor',[1 1 1], ...
        'Position',txtPos1, 'fontsize',10,...
        'String',promptStr,'foregroundcolor','red','fontweight','bold');
%First Message
if ch==1
    set(txtHndl,'string','USE the MOUSE to SELECT a DATA SET.');
    set(txtHndl1,'string','Press q to quit data selection.');
else
   set(txtHndl,'string','DATA SET is displayed.');
   set(txtHndl1,'string','Click button Select Line # 1.');
end


%establish graphics box
%

grbox=subplot('position',[.43 .25 .56 .73]);
axis(rval);axis(axis);

%plot sides of box

%top=line([rval(1) rval(2)],[rval(4) rval(4)],...
%'Color','k','erasemode','none');
%bot=line([rval(1) rval(2)],[rval(3) rval(3)],...
%'Color','k','erasemode','none');
%left=line([rval(1) rval(1)],[rval(3) rval(4)],...
%'Color','k','erasemode','none');
%right=line([rval(2) rval(2)],[rval(3) rval(4)],...
%'Color','k','erasemode','none');
hold on

if ch==1
   dmat=[];swq='N';
   while swq=='N'
      subplot(grbox);
      [x,y,z]=myginput(1);
      if abs(z)=='q' | abs(z)=='Q'
         swq='Y'; %saying we have data set & it is plotted
         %break
      else
        if x>rval(2) | x<rval(1) | y>rval(4) | y<rval(3)
           for jj=1:25,disp(beep);end
           set(txtHndl,'string',mess1);
           pause(2)
           set(txtHndl,'string',s0);
        else    
           plot(x,y,'*k','linewidth',2,'erasemode','none')
           dmat=[dmat;[x y]];
           [m n]=size(dmat);
        end
      end
   end
   set(txtHndl,'string','DATA SET is displayed.')
   set(txtHndl1,'string','Click button Select Line #1.')
end

if ch~=1  %data here in dmat; must display it
   subplot(grbox)
   for ii=1:m
       plot(dmat(ii,1),dmat(ii,2),'*k','linewidth',2,'erasemode','none')
   end
   swq='Y'; %saying we have data set & it is plotted
end
