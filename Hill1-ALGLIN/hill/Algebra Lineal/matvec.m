%MATVEC  (Matrix) * (vector) as a function operation.  <2/10/96>
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
menu=['  1. Enter a 2 by 2 matrix.              ';
      '                                         ';
      '  2. Use a built in demonstration matrix.';
      '                                         ';
      '  0. Quit.                               ';
      '                                         '];
demoA=[1 5;5 3];
again='  Improper response; try again.';
enter='  Press ENTER to continue.';
choice='  Your choice  ==>  ';
getio='Enter a 2 by two matrix in the form [1 2;3 4]';
ptselect=[]; %initializing pts selected as input

%THE INPUT ROUTINE
%
respok='N';
while respok=='N'
   clc,disp(s0)
   disp('MATVEC: Function (MATRIX) * (vector) in 2-space.')
   disp(s0),disp(s0)
   disp(menu)
   ch=input(choice);
   if ch==0,return,end
   if ch==2, A=demoA;respok='Y';end
   if ch==1
      disp(s0),disp(getio),disp(s0)
      A=input('Enter your matrix  ==>  ');
      respok='Y';
   end
   if respok=='N',disp(again),disp(s0),disp(enter),pause,end
end

%THE WORKINGS of the routine

Amat=mat2strh(A,2);

bkgr='w'; %background color

rval=[-1 1 -1 1];
beep=setstr(7);


header='Function: Matrix times Vector';
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
mvget1='axes(pgrf);[x1,y1]=ginput(1);inv=[x1 y1];';
mvget1=[mvget1 'inv=inv/norm(inv);x1=inv(1);y1=inv(2);'];
mvget1=[mvget1 'axes(pgrf);plot([0,inv(1)],[0 inv(2)],'];
mvget1=[mvget1 '''-b'',''erasemode'',''none'',''linewidth'',3);'];
mvget1=[mvget1 'plot([inv(1)],[inv(2)],'];
mvget1=[mvget1 '''ob'',''erasemode'',''none'',''linewidth'',3);'];
mvget1=[mvget1 'ptselect=[ptselect [inv(1);inv(2)]];'];



%initial settings
inswtch='N'; %input switch set to say no current input

%graph address
grfad=[.4 .1 .65 .65];
spread=[-1 1 -1 1];

%DRAW CIRCLE
circ='step=.02;t=0:step:2*pi;cx=cos(t);cy=sin(t);';
circ=[circ 'plot(cx,cy,''-k'',''erasemode'',''none'',''linewidth'',3);'];
circ=[circ 'drawnow;';];

% Graph SET UP
pfig='pgrf=axes(''position'',grfad);';
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
getin=[getin 'axes(basehndl);'];
getin=[getin 'set(intxt,''color'',''b'');'];
getin=[getin 'eval(mvget1);inswtch=''Y'';'];
getin=[getin 'x1st=num2str(x1);y1st=num2str(y1);'];
getin=[getin 'axes(basehndl);'];
getin=[getin 'x1sh=text(.2,.8,x1st,''color'',''b'','];
getin=[getin '''fontweight'',''bold'',''fontsize'',16);'];
getin=[getin 'y1sh=text(.2,.74,y1st,''color'',''b'','];
getin=[getin '''fontweight'',''bold'',''fontsize'',16);'];
getin=[getin 'end;'];

%Compute Output
cout='if inswtch==''Y''; ';
cout=[cout 'set(intxt,''color'',bkgr);'];
cout=[cout 'set(outtxt,''color'',''m'');'];
cout=[cout 'vout=A*[x1 y1]'';'];
cout=[cout 'x2st=num2str(vout(1));y2st=num2str(vout(2));'];
cout=[cout 'axes(basehndl);'];
cout=[cout 'if y1<0,sgn='' - '';y1st=num2str(abs(y1));'];
cout=[cout 'else,sgn='' + '';end;'];
cout=[cout 'lc=[x1st '' Col1(A) '' sgn y1st '' Col2(A) = ''];'];
cout=[cout 'lcst=text(-.15,.45,lc,''color'',''k'','];
cout=[cout '''fontsize'',12,''fontweight'',''bold'','];
cout=[cout '''erasemode'',''none'');'];
cout=[cout 'x2sh=text(.3,.48,x2st,''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',16);'];
cout=[cout 'y2sh=text(.3,.42,y2st,''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',16);'];
cout=[cout 'if vout(1)~=0 | vout(2)~=0,'];  %checking for nonzero output
cout=[cout 'vout=vout/norm(vout);end,'];
cout=[cout 'x2st=num2str(vout(1));y2st=num2str(vout(2));'];
cout=[cout 'axes(basehndl);'];
cout=[cout 'sclmess=text(-.13,.3,''Scaled Output = '',''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',12);'];
cout=[cout 'x2shs=text(.1,.33,x2st,''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',16);'];
cout=[cout 'y2shs=text(.1,.27,y2st,''color'',''m'','];
cout=[cout '''fontweight'',''bold'',''fontsize'',16);'];
cout=[cout 'axes(pgrf);svd(rand(20));'];
cout=[cout 'plot([0,vout(1)],[0 vout(2)],''-m'',''erasemode'',';];
cout=[cout '''none'',''linewidth'',3);'];
cout=[cout 'if vout(1)==0 | vout(2)==0,'];
cout=[cout 'plot([0,vout(1)],[0 vout(2)],''*m'',''erasemode'',';];
cout=[cout '''none'',''linewidth'',3);end,'];
cout=[cout 'pause(3);'];
cout=[cout 'nextin=uicontrol(''style'',''push'',''units'',''normal'','];
cout=[cout '''pos'',[.05 .2 .08 .06],''string'',''MORE'','];
cout=[cout '''call'',nextone);'];

cout=[cout 'end;'];


%Next input
nextone='set(outtxt,''color'',bkgr);axes(pgrf);';
nextone=[nextone 'plot([0,vout(1)],[0 vout(2)],''-w'',''erasemode'',';];
nextone=[nextone '''none'',''linewidth'',3);'];
nextone=[nextone 'plot([0,x1],[0 y1],''-w'','];
nextone=[nextone '''erasemode'',''none'',''linewidth'',3);'];
nextone=[nextone 'axes(basehndl);delete(x1sh);delete(y1sh);delete(x2sh);'];
nextone=[nextone 'delete(y2sh);delete(lcst);delete(sclmess);'];
nextone=[nextone 'delete(x2shs);delete(y2shs);delete(nextin);'];
nextone=[nextone 'delete(pgrf);eval(pfig);eval(circ);'];
nextone=[nextone '[pm pn]=size(ptselect);axes(pgrf);for ij=1:pn,'];
nextone=[nextone 'plot(ptselect(1,ij),ptselect(2,ij),''ob'','];
nextone=[nextone '''erasemode'',''none'',''linewidth'',3);drawnow;end;'];
nextone=[nextone 'inswtch=''N'';'];

%BEGIN GRAPHICS
hfig=figure('units','normal','position',[0 0 1 1],'color',bkgr);
axis('off')


%Having done a graphics command the axes for that graphics screen have been
%given a handle. We label it basehndl.
basehndl=gca;

%Screen Title and Info
axes(basehndl);
text(.1,1.05,header,'color','green','fontsize',24,...
    'fontweight','bold','erasemode','none')
text(-.1,.95,funcfor1,'color','red','fontsize',28,...
    'fontweight','bold','erasemode','none')
text(-.05,.95,funcfor2,'color','blue','fontsize',20,...
    'fontweight','bold','erasemode','none')
text(.15,.95,funcdo,'color','black','fontsize',20,...
    'fontweight','bold','erasemode','none')
text(.25,.95,funcout,'color','magenta','fontsize',20,...
    'fontweight','bold','erasemode','none')

%Matrix A
text(.6,.93,alabel,'color','red','fontsize',20,...
     'fontweight','bold','erasemode','none')
text(.67,.96,Amat(1,:),'color','red','fontsize',18,...
     'fontweight','bold','erasemode','none')
text(.67,.9,Amat(2,:),'color','red','fontsize',18,...
     'fontweight','bold','erasemode','none')

%
%START PUSH BUTTONS for Utility Functions
%
utfrm=uicontrol('style','frame','units','normal',...
                 'position',[.04 .09 .35 .08],'backgroundcolor','y');
helph = uicontrol('style','push','units','normal','pos',[.05 .1 .1 .06], ...
        'string','Help','call',helps);
rstarth = uicontrol('style','push','units','normal','pos',[.16 .1 .1 .06], ...
        'string','Restart','call','close(gcf),matvec');
endh = uicontrol('style','push','units','normal','pos',[.27 .1 .1 .06], ...
        'string','QUIT','call',done);


%Select input /output button
selinput=uicontrol('style','push','units','normal',...
         'pos',[.05 .75 .18 .06],'string','Select Input','call',getin);
intxt=text(-.1, .75,inmess,'color',bkgr,'fontsize',14,...
          'fontweight','bold','erasemode','none');
compout=uicontrol('style','push','units','normal',...
         'pos',[.05 .55 .18 .06],'string','Compute Output','call',cout);
outtxt=text(-.05,.51, outmess,'color',bkgr,'fontsize',14,...
           'fontweight','bold','erasemode','none');

%vanity
text(.35,-.07,'by D.R.Hill','color','cyan','fontsize',14,'fontweight','bold',...
     'fontangle','oblique','erasemode','none')


%Do figure & draw circle
eval(pfig)
eval(circ)


