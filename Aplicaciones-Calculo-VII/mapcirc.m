function mapcirc(A,vsw)                   %last updated  2/10/96
%MAPCIRC A 2 by 2 matrix A is used to map the unit circle.
%        The graphical behavior exhibited for various choices of A
%        can be studied. 
%
%                       <><> Use in the form <><>
%        ==>  mapcirc(A)  
%        or   mapcirc(A,1)  to display eigenvectors and their images      
%        or   mapcirc  <==
%
%        In the latter case you will be presented with a menu of options.
%
%               mat2strh utility from D. Hill
%
%  By: David R. Hill, Math. Dept., Temple University,
%      Philadelphia, Pa.  19122   Email:  hill@math.temple.edu
%                                         davehill@templevm.edu

s0=' ';
menu=['  1. Enter a 2 by 2 matrix.              ';
      '                                         ';
      '  2. Use a built in demonstration matrix.';
      '                                         ';
      '  3. Display help for this routine.      ';
      '                                         ';
      '  0. Quit.                               ';
      '                                         '];
menu1=['  1. Show eigenvectors & images.         ';
       '                                         ';
       '  2. Do not show them.                   ';
       '                                         ';
       '  0. Quit.                               ';
       '                                         '];
demoA=[1 3;1 1];
again='  Improper response; try again.';
enter='  Press ENTER to continue.';
choice='  Your choice  ==>  ';
getio='Enter a 2 by 2 matrix in the form [1 2;3 4]';

%THE INPUT ROUTINE
%
if nargin==2,showvec='Y';else,showvec='N';end
if nargin==0
   respok='N';
   while respok=='N'
      clc,disp(s0)
      disp('                  Mapping a CIRCLE.')
      disp(s0),disp(s0)
      disp(menu)
      ch=input(choice);
      if ch==0,return,end
      if ch==2, A=demoA;respok='Y';end
      if ch==3, clc, help mapcirc, disp(enter),pause,end
      if ch==1
         disp(s0),disp(getio),disp(s0)
         A=input('Enter your matrix  ==>  ');
         respok='Y';
      end
      if respok=='N'&ch~=3,disp(again),disp(s0),disp(enter),pause,end
   end
   vecresp='N';
   while vecresp=='N';
      clc,disp(s0),disp('Display eigenvectors and their images?')
      disp(s0),disp(s0),disp(menu1)
      ch=input(choice);
      if ch==0,return,end
      if ch==2, showvec='N';vecresp='Y';end
      if ch==1, showvec='Y';vecresp='Y';end    
      if vecresp=='N',disp(again),disp(s0),disp(enter),pause,end
   end
end
%setting graphics items
bkgr='w';
setwin='hfig=figure(''units'',''normal'',''color'',bkgr,';
setwin=[setwin '''position'',[0 0 1 1]);'];
setwin=[setwin 'axis(''off'');basehndl=gca;'];
        %setting graphics window to full size

[m,n]=size(A);
if m~=2 | n~=2    %checking size of A
   disp('ERROR: Matrix is wrong size.')
   return
end
%info on matrix A

%Check if A is 'real' diagonalizable.
%
[v,d]=eig(A);v1=v(:,1);v2=v(:,2);
lievecs='Y'; %linearly independent eigenvectors
%check complex
if abs(imag(d(1,1)))>10*eps | abs(imag(d(2,2)))>10*eps
   lievecs='N';  
end
%check diagonalizable
if abs(det(v))<1000*eps
   lievecs='N';
end

%The unit circle.
step=.08;
t=0:step:2.05*pi;
m=length(t);
x=cos(t);y=sin(t);u=[x;y];

%Finding input that generates eigen directions.
%vx1=A\v(:,1);vx2=A\v(:,2);
%vx1=vx1/norm(vx1);vx2=vx2/norm(vx2);
v1srch=[];v2srch=[];
for ij=1:m
   v1srch=[v1srch abs(norm(u(:,ij)-v1))];
   v2srch=[v2srch abs(norm(u(:,ij)-v2))];
end
[m1 i1]=min(v1srch); %i1 = place where 1st eigenvector is graphed
[m2 i2]=min(v2srch);

%input & output

v = A*u;
uin=u(:,1:m);
vout=v(:,1:m);
[vm,vn]=size(vout);

for ii=1:m
  nc(ii)=norm(v(:,ii));
end
maxnc=max(1,max(nc)); %size of graph window

%Begin graphing
eval(setwin)

axes(basehndl);
text(.15,1.05,'Mapping a circle with matrix A.','color','k',...
      'fontweight','bold','fontsize',20,'erasemode','none')
text(.35,.9,'A = ','color','r',...
      'fontweight','bold','fontsize',20,'erasemode','none')
a1=mat2strh(A(1,:),4);
a2=mat2strh(A(2,:),4);
text(.4,.95,a1,'color','r',...
      'fontweight','bold','fontsize',20,'erasemode','none')
text(.4,.85,a2,'color','r',...
      'fontweight','bold','fontsize',20,'erasemode','none')
contmess=text(.8,-.1,enter,'color','red','erasemode','none',...
         'fontweight','bold');
%set(contmess,'visible','off');
drawnow

gr1clr='b'; %color in graph #1
gr1=axes('position',[-.05 .1 .6 .6]);
ox=[-maxnc maxnc 0 0];oy=[0 0 -maxnc maxnc];
plot(ox,oy,'-w','erasemode','none');
set(gr1,'xcolor',[0 0 0],'ycolor',[0 0 0]);
axis(axis),axis('square')
drawnow
title('Input: x = unit vector.','color',gr1clr,...
      'fontweight','bold','fontsize',18,'erasemode','none')
drawnow
hold on

gr2clr='m'; %color in graph #2
gr2=axes('position',[.45 .1 .6 .6]);
plot(ox,oy,'-w','erasemode','none');
set(gr2,'xcolor',[0 0 0],'ycolor',[0 0 0]);
axis(axis),axis('square')
drawnow
title('Output: y = A*x.','color',gr2clr,...
      'fontweight','bold','fontsize',18,'erasemode','none')
drawnow 
hold on
pause(2)

vecclr='-y'; %color of eigenvectors & images

for ii=1:vn
   axes(gr1);colorset=['-' gr1clr];
   if showvec=='Y'
      if ii==i1 | ii==i2
         colorset=vecclr;
      else 
         colorset=['-' gr1clr];
      end
   end
   plot([0 uin(1,ii)],[0 uin(2,ii)],colorset,'erasemode','none',...
       'linewidth',3)
   drawnow
   axes(gr2);colorset=['-' gr2clr];
   if showvec=='Y'
      if ii==i1 | ii==i2
         colorset=vecclr;
      else 
         colorset=['-' gr2clr];
      end
   end
   plot([0 vout(1,ii)],[0 vout(2,ii)],colorset,'erasemode','none',...
        'linewidth',3)
   drawnow
   axes(gr1);colorset='-w';
   if showvec=='Y'
      if ii==i1 | ii==i2
         colorset=vecclr;
      else 
         colorset=gr1clr;
      end
   end
   plot([0 uin(1,ii)],[0 uin(2,ii)],colorset,'erasemode','none',...
        'linewidth',3)
   
   plot([0 uin(1,ii)],[0 uin(2,ii)],'.b','erasemode','none',...
        'markersize',10)
   drawnow
   axes(gr2);colorset='-w';
   if showvec=='Y'
      if ii==i1 | ii==i2
         colorset=vecclr;
      else 
         colorset=gr2clr;
      end
   end
   plot([0 vout(1,ii)],[0 vout(2,ii)],colorset,'erasemode','none',...
       'linewidth',3)
   plot([0 vout(1,ii)],[0 vout(2,ii)],'.m','erasemode','none',...
        'markersize',10)
   drawnow
end

%plot the eigenvectors at end if they have been selected
if showvec=='Y'
   axes(gr1)
   plot([0 v1(1)],[0 v1(2)],vecclr,'erasemode','none','linewidth',4)
   plot([0 v2(1)],[0 v2(2)],vecclr,'erasemode','none','linewidth',4)
   axes(gr2)
   w1=A*v1;w2=A*v2;
   plot([0 w1(1)],[0 w1(2)],vecclr,'erasemode','none','linewidth',4)
   plot([0 w2(1)],[0 w2(2)],vecclr,'erasemode','none','linewidth',4)
   drawnow
end
%The last axes specified is gr2 so ginput commands will gather information
%relative to the center of the image graph.
pause
clc,disp('MAPCIRC is over!')
hold off
