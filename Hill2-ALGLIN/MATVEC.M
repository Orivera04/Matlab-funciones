%MATVEC  (Matrix) * (vector) as a function operation.  <8/19/98>
%        Function F(x) = A*x, where A is a 2 by 2 matrix 
%        is explored using the mouse to select an input 
%        vector from the unit circle. The input is shown
%        graphically as a radius of the circle. The output
%        is displayed as a linear combination of the columns
%        of A with 'weights' the components of the input 
%        vector. In addition the output vector is scaled so 
%        we can graph it in the unit circle. The components
%        of the scaled vector are displayed.
%
%        The graphical user interface is employed to make it
%        easy to investigate various ideas relative to this function.
%
%        Use in the form  ==>  matvec  <==
%        Follow the on-screen directions for input and the button 
%        labels for working with the function.
%
%By: David R. Hill, Math. Dept., Temple University,
%    Philadelphia, Pa. 19122  Email: hill@math.temple.edu

%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%Operational Notes:
%   1. If the output vector is all zeros the scaled output
%      display is set to zeros and an asterisk is placed at 
%      the center of the circle.
%
%   2. Routine mat2strh is used.
%
%<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

s0=' ';
menu=['           OPTIONS                       ';
      '                                         ';
      '  1. Enter a 2 by 2 matrix.              ';
      '                                         ';
      '  2. Use a built-in demonstration matrix.';
      '                                         '
      '  0. Quit.                               ';
      '                                         '];
demoA=[1 5;5 3];
again='  Improper response; try again.';
enter='  Press ENTER to continue.';
cont=enter;
badmat='Matrix must be 2 by 2.';
choice='  Your choice  ==>  ';
getio='Enter a 2 by two matrix in the form [1 2;3 4]';
ptselect=[]; %initializing pts selected as input
outpt=[];   %initializing output pts

%THE INPUT ROUTINE
%
clc,help matvec,disp(s0),disp(enter),pause
respok='N';
while respok=='N'
      clc,disp(s0)
   disp('MATVEC: Function (MATRIX) * (vector) in 2-space.')
   disp(s0),disp(s0)
   disp(menu)
   ch=input(choice);
   if isempty(ch)==1
      ch=999;
   end   
   if ch==0,return,end
      if ch==2, A=demoA;respok='Y';end
   if ch==1
      disp(s0),disp(getio),disp(s0)
      havmat='N';
      while havmat=='N'
         A=input('Enter your matrix  ==>  ');
         if isempty(A)==1
            disp('No matrix entered. Try again.')
            disp(cont)
            pause
         else
            havmat='Y';
         end
      end 
      [m,n]=size(A);
      if m~=2 | n~=2
         disp(badmat),disp('TRY AGAIN'),disp(cont),pause
      else
         respok='Y';
      end
   end
   if respok=='N',disp(again),disp(s0),disp(enter),pause,end
end

%THE WORKINGS of the routine

Amat=mat2strh(A,2);

bkgr='w'; %background color

rval=[-1 1 -1 1];
beep=setstr(7);


header='Function: Matrix times a Vector';
funcfor1='A'; 
funcfor2='* (input) ';
funcdo=' ==> ';
funcout='(output)';
inmess='(Click on Circle)';
outmess='(A* input)';
alabel='A = ';

%Code for selecting a point on the circle; actually forcing it to be on
% the circle via nornalizing
%
mvget1='subplot(pgrf);[x1,y1]=myginput(1);inv=[x1 y1];';
mvget1=[mvget1 'inv=inv/norm(inv);x1=inv(1);y1=inv(2);'];
mvget1=[mvget1 'subplot(pgrf);plot([0,inv(1)],[0 inv(2)],'];
mvget1=[mvget1 '''-b'',''erasemode'',''none'',''linewidth'',2);'];
mvget1=[mvget1 'plot([inv(1)],[inv(2)],'];
mvget1=[mvget1 '''ob'',''erasemode'',''none'',''linewidth'',2);'];
mvget1=[mvget1 'ptselect=[ptselect [inv(1);inv(2)]];'];



%initial settings
inswtch='N'; %input switch set to say no current input

%graph address
grfad=[.4 .1 .65 .65];
spread=[-1 1 -1 1];

%DRAW CIRCLE
circ='step=.02;t=0:step:2*pi;cx=cos(t);cy=sin(t);';
circ=[circ 'plot(cx,cy,''-k'',''erasemode'',''none'',''linewidth'',2);'];
circ=[circ 'drawnow;';];

% Graph SET UP
pfig='pgrf=subplot(''position'',grfad);';
pfig=[pfig 'plot(spread(1:2),[0 0],''-w'',[0 0],spread(3:4),''-w'');'];
pfig=[pfig 'set(pgrf,''xcolor'',[0 0 0],''ycolor'',[0 0 0]);'];
pfig=[pfig 'set(pgrf,''linewidth'',2);'];
pfig=[pfig 'axis(spread);axis(''square'');axis(axis);'];
pfig=[pfig 'hold on;'];

%Button callbacks
%
%callback for the help button
helps='set(gcf,''visible'',''off'');clc,help matvec,disp(enter),';
helps=[helps 'pause,set(gcf,''visible'',''on'');'];
%
%CALL back for quit button
done = 'hold off,close(gcf),clc,disp(''MATVEC is over!''),return';

%Select input
getin='if inswtch==''N''';
getin=[getin 'set(intxt,''color'',''b'');'];
getin=[getin 'eval(mvget1);inswtch=''Y'';'];
getin=[getin 'x1st=num2str(x1);y1st=num2str(y1);'];
getin=[getin 'subplot(inpoint);'];
getin=[getin 'x1sh=text(0,.9,x1st,''color'',''b'','];
getin=[getin '''fontweight'',''bold'',''fontsize'',12);'];
getin=[getin 'y1sh=text(0,.5,y1st,''color'',''b'','];
getin=[getin '''fontweight'',''bold'',''fontsize'',12);'];
getin=[getin 'end;'];

%Compute Output
cout='if inswtch==''Y''; ';
cout=[cout 'set(intxt,''color'',bkgr);'];
cout=[cout 'set(outtxt,''color'',''m'');'];
cout=[cout 'vout=A*[x1 y1]'';'];
cout=[cout 'x2st=num2str(vout(1));y2st=num2str(vout(2));'];
cout=[cout 'subplot(outpoint);'];
cout=[cout 'if y1<0,sgn='' - '';y1st=num2str(abs(y1));'];
cout=[cout 'else,sgn='' + '';end;'];
cout=[cout 'lc=[x1st '' Col1(A) '' sgn y1st '' Col2(A) = ''];'];
cout=[cout 'lcst=text(0,.9,lc,''color'',''k'','];
cout=[cout '''fontsize'',10,''fontweight'',''bold'','];
cout=[cout '''erasemode'',''none'');'];
cout=[cout 'x2sh=text(.92,.97,x2st,''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',12);'];
cout=[cout 'y2sh=text(.92,.83,y2st,''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',12);'];
cout=[cout 'if vout(1)~=0 | vout(2)~=0,'];  %checking for nonzero output
cout=[cout 'vout=vout/norm(vout);end,'];
cout=[cout 'x2st=num2str(vout(1));y2st=num2str(vout(2));'];
%cout=[cout 'axes(basehndl);'];
cout=[cout 'sclmess=text(.1,.3,''Scaled Output = '',''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',12);'];
cout=[cout 'x2shs=text(.67,.38,x2st,''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',12);'];
cout=[cout 'y2shs=text(.67,.22,y2st,''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',12);'];
cout=[cout 'subplot(pgrf);svd(rand(20));'];
cout=[cout 'plot([0,vout(1)],[0 vout(2)],''-m'',''erasemode'',';];
cout=[cout '''none'',''linewidth'',2);'];
%HERE add magenta circle to output vector  11/3/96
cout=[cout 'plot([vout(1)],[vout(2)],'];
cout=[cout '''om'',''erasemode'',''none'',''linewidth'',2);'];
cout=[cout 'outpt=[outpt [vout(1);vout(2)]];'];
cout=[cout 'if vout(1)==0 | vout(2)==0,'];
cout=[cout 'plot([0,vout(1)],[0 vout(2)],''*m'',''erasemode'',';];
cout=[cout '''none'',''linewidth'',2);end,'];
cout=[cout 'pause(3);'];
cout=[cout 'nextin=uicontrol(''style'',''push'',''units'',''normal'','];
cout=[cout '''pos'',[.05 .15 .08 .06],''string'',''MORE'','];
cout=[cout '''fontsize'',14,''call'',nextone);'];

cout=[cout 'end;'];


%Next input
nextone='set(outtxt,''color'',bkgr);subplot(pgrf);';
nextone=[nextone 'plot([0,vout(1)],[0 vout(2)],''-w'',''erasemode'',';];
nextone=[nextone '''none'',''linewidth'',2);'];
nextone=[nextone 'plot([0,x1],[0 y1],''-w'','];
nextone=[nextone '''erasemode'',''none'',''linewidth'',2);'];
nextone=[nextone 'delete(x1sh);delete(y1sh);delete(x2sh);'];
nextone=[nextone 'delete(y2sh);delete(lcst);delete(sclmess);'];
nextone=[nextone 'delete(x2shs);delete(y2shs);delete(nextin);'];
nextone=[nextone 'delete(pgrf);eval(pfig);eval(circ);'];
nextone=[nextone '[pm pn]=size(ptselect);subplot(pgrf);for ij=1:pn,'];
nextone=[nextone 'plot(ptselect(1,ij),ptselect(2,ij),''ob'','];
nextone=[nextone '''erasemode'',''none'',''linewidth'',2);drawnow;end;'];
%magenta circle to end of output left visible  11/2/96
nextone=[nextone '[pmo pno]=size(outpt);subplot(pgrf);for ij=1:pno,'];
nextone=[nextone 'plot(outpt(1,ij),outpt(2,ij),''om'','];
nextone=[nextone '''erasemode'',''none'',''linewidth'',2);drawnow;end;'];
nextone=[nextone 'inswtch=''N'';'];

%BEGIN GRAPHICS
hfig=figure('units','normal','position',[0 0 1 1],'color',bkgr);
axis('off')

%Screen Title and Info
titlesub=subplot('position',[.1 .95 .8 .04]);axis('off');
text(0,0,header,'color','red','fontsize',16,...
   'fontweight','bold','erasemode','none')

funcsub=subplot('position',[0 .85 .9 .09]);axis('off');
text(.02,0,funcfor1,'color','red','fontsize',28,...
    'fontweight','bold','erasemode','none')
text(.08,0,funcfor2,'color','blue','fontsize',20,...
    'fontweight','bold','erasemode','none')
text(.25,0,funcdo,'color','black','fontsize',20,...
    'fontweight','bold','erasemode','none')
text(.35,0,funcout,'color','magenta','fontsize',20,...
    'fontweight','bold','erasemode','none')

%Matrix A
text(.8,.5,alabel,'color','red','fontsize',20,...
     'fontweight','bold','erasemode','none')
text(.87,.9,Amat(1,:),'color','red','fontsize',18,...
     'fontweight','bold','erasemode','none')
text(.87,.1,Amat(2,:),'color','red','fontsize',18,...
     'fontweight','bold','erasemode','none')

%
%START PUSH BUTTONS for Utility Functions
%
utfrm=uicontrol('style','frame','units','normal',...
                 'position',[.04 .09 .35 .08],'backgroundcolor','y');
helph = uicontrol('style','push','units','normal','pos',[.05 .1 .1 .06], ...
        'string','Help','fontsize',14,'call',helps);
rstarth = uicontrol('style','push','units','normal','pos',[.16 .1 .1 .06], ...
        'string','Restart','fontsize',14,'call','close(gcf),matvec');
endh = uicontrol('style','push','units','normal','pos',[.27 .1 .1 .06], ...
        'string','QUIT','fontsize',14,'call',done);


%Select input /output button
selinput=uicontrol('style','push','units','normal','fontsize',14,...
         'pos',[.05 .75 .18 .06],'string','Select Input','call',getin);
      
      
intxtsub=subplot('position',[.05 .7 .2 .1]);axis('off');
intxt=text(0,0,inmess,'color',bkgr,'fontsize',12,...
   'fontweight','bold','erasemode','none');

compout=uicontrol('style','push','units','normal','fontsize',14,...
   'pos',[.05 .6 .18 .06],'string','Compute Output','call',cout);

outtxtsub=subplot('position',[.08 .53 .1 .1]);axis('off');
outtxt=text(0,0,outmess,'color',bkgr,'fontsize',12,...
           'fontweight','bold','erasemode','none');

%vanity
vansub=subplot('position',[.85 .03 .2 .05]);axis('off');
text(0,0,'by D.R.Hill','color','black','fontsize',10,'fontweight','bold',...
   'fontangle','oblique','erasemode','none')
drawnow
  
%input data area
inpoint=subplot('position',[.26 .63 .1 .1]);axis('off');

%output data area
outpoint=subplot('position',[0 .25 .39 .25]);axis('off')

%Do figure & draw circle
eval(pfig)
eval(circ)



