function projxy(u)                              %last updated 2/10/96
%PROJXY  Orthogonal projection of a 3-d vector onto the xy-plane. 
%
%         Developing the orthogonal projection of a 3D vector onto
%         the XY-plane through a series of plots that show the
%         projections onto the X & Y axes, forming a linear combination
%         of the axes projections, and displaying a vector orthogonal
%         to the XY-plane using the original vector and its projection.
%         This routine can be used in the form
%
%                   ===>  projxy(u)  <===
%
%         where u is the 3D-vector to be projected, or in the form
%
%                   ===>  projxy     <===
%
%         which will prompt the user for vector input. Display options
%         of full screen or subplots are available.
%
%
%By: David R. Hill, Math. Dept., Temple University,      VERSION for 4.2
%    Philadelphia, Pa. 19122     Email: hill@math.temple.edu                                 
head='             PROJECTION of a Vector onto the XY-Plane';
cont='Press ENTER to continue.';
arrow='==>';
errmess='Error in projxy: input not a 3D vector.';
s0=' ';
s1='Enter the 3D-vector to project in the form [2 3 4].';
s2='Enter your vector u = ';
s3=['You will see a series of four pictures. The pictures can be shown';
    'as a full screen display or all four on the same screen but      ';
    'smaller in size.                                                 '];
s4=['              DISPLAY OPTIONS              ';
    '                                           ';
    '  1  All plots on the same screen.         ';
    '  2  Full screen display for each plot.    ';
    '                                           ';
    '  0  QUIT                                  '];
s5='Enter your choice -->  ';
s6='Improper choice; try again.';

if nargin==1
   [mu,nu]=size(u);
   if mu*nu~=3
      disp([arrow '  ' errmess])
      return
   end
end
if nargin~=1
   sw='N';
   while sw=='N'
      clc,disp(head),disp(s0),disp(s1)
      u=input(s2);
      disp(s0)
      [mu,nu]=size(u);
      if mu*nu~=3
         disp([arrow '  ' errmess])
         disp(cont),pause
      else
         sw='Y';
      end
   end
end
sw='N';
while sw=='N'
   clc,disp(head),disp(s0),disp(s0),disp(s3),disp(s0),disp(s4)
   ch=input(s5);
   if ch==0,return,end
   if ch~=1 & ch~=2
      disp(s6),disp(s0),disp(cont),pause
   else
      sw='Y';
   end
end
if ch==2,FS='Y';else,FS='N';end %setting FS = Full Screen code

u=reshape(u,1,3); %making u a row
alpha=(210/180)*pi; %setting angle for 3D axes
beta=0;
gamma=pi/2;
T=zeros(4,4);
T(1:3,1:2)=[cos(alpha) sin(alpha);cos(beta) sin(beta);cos(gamma) sin(gamma)];
T(4,4)=1;
xaxis=[1 0 0];xaxp=[xaxis 1]*T; %unit vectors in axis directions
yaxis=[0 1 0];yaxp=[yaxis 1]*T;
zaxis=[0 0 1];zaxp=[zaxis 1]*T;
inc=1;  %increment to get slightly longer axes
xax2=(abs(u(1))+inc)*xaxp(1:2);yax2=(abs(u(2))+inc)*yaxp(1:2);
zax2=(abs(u(3))+inc)*zaxp(1:2);                          %scaling the axes
uprime=[u 1]*T;  %u is to be ROWS HERE
u2=uprime(1:2);  %the representation of u from R3 as a perspective R2 vector
%doing the graphics
%clg
org=[0 0];
Q=[u2;xax2;yax2;zax2;org];
t1=min(Q(:,1));t2=max(Q(:,1));
t3=min(Q(:,2));t4=max(Q(:,2));
xt=max([abs(t1) abs(t2)]);
ax=[-xt-1 xt+1 t3-1 t4+1]; %stretching things out a bit
figure,set(gcf,'units','normal')
set(gcf,'position',[0 0 1 1]) %Setting position of window
%THE FIRST FRAME
if FS=='N',subplot(2,2,1),end
%Next we draw axes from vector ax in black to set size of
%of axes for future drawing
plot([ax(1) ax(2)],[0 0],'-k',[0 0],[ax(3) ax(4)],'-k','erasemode','none')
axis(axis)
axis('off')
drawnow
hold on
plot(0,0,'*w',[0 xax2(1)],[0 xax2(2)],'-w','erasemode','none')
text(xax2(1),xax2(2),'X','erasemode','none')
drawnow
plot([0 yax2(1)],[0 yax2(2)],'-w','erasemode','none')
text(yax2(1),yax2(2),'Y','erasemode','none')
drawnow
plot([0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
text(.7*zax2(1),.7*zax2(2),'Z','erasemode','none')
drawnow
tic;while toc<2,end
plot([0 u2(1)], [0 u2(2)],'-y','erasemode','none')
text(u2(1)/2,u2(2)/2,'U','erasemode','none')
title1=['U = [' num2str(u(1)) ' ' num2str(u(2)) ' ' num2str(u(3)) ']'];
title(title1)
drawnow
pause(4)
goon=text(.2,-.1,cont,'units','normalized','erasemode','none');
pause
set(goon,'string',' ');
%xlabel(cont),drawnow,pause,xlabel('         '),drawnow
hold off
%THE SECOND FRAME
if FS=='N';subplot(2,2,2),else,clg,end
%Next we draw axes from vector ax in black to set size of
%of axes for future drawing
plot([ax(1) ax(2)],[0 0],'-k',[0 0],[ax(3) ax(4)],'-k','erasemode','none')
axis(axis)
axis('off')
drawnow
hold on
plot(0,0,'*w',[0 xax2(1)],[0 xax2(2)],'-w','erasemode','none')
drawnow
plot([0 yax2(1)],[0 yax2(2)],'-w','erasemode','none')
drawnow
plot([0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
drawnow
plot([0 u2(1)], [0 u2(2)],'-y','erasemode','none')
drawnow
text(u2(1)/2,u2(2)/2,'U','erasemode','none')
drawnow
tic;while toc<2,end
title('Projecting U onto X & Y axes.')
tic;while toc<2,end
%plotting the projections on to the x & y axes
plot([u2(1) u(1)*xaxp(1)],[u2(2) u(1)*xaxp(2)],':b','erasemode','none')
drawnow
tic;while toc<2,end
plot([0 u(1)*xaxp(1)],[0 u(1)*xaxp(2)],'-b','erasemode','none')
drawnow
tic;while toc<2,end
plot([u2(1) u(2)*yaxp(1)],[u2(2) u(2)*yaxp(2)],':r','erasemode','none')
tic;while toc<2,end
plot([0 u(2)*yaxp(1)],[0 u(2)*yaxp(2)],'-r','erasemode','none')
pause(4)
goon=text(.2,-.1,cont,'units','normalized','erasemode','none');
pause
set(goon,'string',' ');
%xlabel(cont),pause,xlabel('         ')
hold off
%THE THIRD FRAME
if FS=='N',subplot(2,2,3),else,clg,end
%Next we draw axes from vector ax in black to set size of
%of axes for future drawing
plot([ax(1) ax(2)],[0 0],'-k',[0 0],[ax(3) ax(4)],'-k','erasemode','none')
axis(axis)
axis('off')
drawnow
hold on
plot(0,0,'*w',[0 xax2(1)],[0 xax2(2)],'-w','erasemode','none')
drawnow
plot([0 yax2(1)],[0 yax2(2)],'-w','erasemode','none')
drawnow
plot([0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
drawnow
plot([0 u2(1)], [0 u2(2)],'-y','erasemode','none')
drawnow
text(u2(1)/2,u2(2)/2,'U','erasemode','none')
drawnow
tic;while toc<2,end
%plotting the projections on to the x & y axes
plot([u2(1) u(1)*xaxp(1)],[u2(2) u(1)*xaxp(2)],':b','erasemode','none')
drawnow
plot([0 u(1)*xaxp(1)],[0 u(1)*xaxp(2)],'-b','erasemode','none')
drawnow
plot([u2(1) u(2)*yaxp(1)],[u2(2) u(2)*yaxp(2)],':r','erasemode','none')
drawnow
plot([0 u(2)*yaxp(1)],[0 u(2)*yaxp(2)],'-r','erasemode','none')
drawnow
title('Projection of U as lin. comb.')
tic;while toc<2,end
p3=[u(1) u(2) 0]; %3D projection of u onto xy-plane
pp3=[p3 1]*T;     %perspective of the projection
p=pp3(1:2);       %2D representation of perspective projection.
plot([u(1)*xaxp(1) p(1)],[u(1)*xaxp(2) p(2)],':w','erasemode','none')
drawnow
tic;while toc<2,end
plot([u(2)*yaxp(1) p(1)],[u(2)*yaxp(2) p(2)],':w','erasemode','none')
drawnow
tic;while toc<2,end
plot([0 p(1)],[0 p(2)],'-m','erasemode','none')
text(p(1)/2,p(2)/2,'PROJ','erasemode','none')
drawnow
tic;while toc<2,end
pause(4)
goon=text(.2,-.1,cont,'units','normalized','erasemode','none');
pause
set(goon,'string',' ');
%xlabel(cont),pause,xlabel('         ')
hold off
%THE FOURTH FRAME
if FS=='N';subplot(2,2,4),else,clg,end
%Next we draw axes from vector ax in black to set size of
%of axes for future drawing
plot([ax(1) ax(2)],[0 0],'-k',[0 0],[ax(3) ax(4)],'-k','erasemode','none')
axis(axis)
axis('off')
drawnow
hold on
plot(0,0,'*w',[0 xax2(1)],[0 xax2(2)],'-w','erasemode','none')
plot([0 yax2(1)],[0 yax2(2)],'-w','erasemode','none')
plot([0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
plot([0 u2(1)], [0 u2(2)],'-y','erasemode','none')
text(u2(1)/2,u2(2)/2,'U','erasemode','none')
drawnow
%plotting the projections on to the x & y axes
%plot([u2(1) u(1)*xaxp(1)],[u2(2) u(1)*xaxp(2)],':b')
%plot([0 u(1)*xaxp(1)],[0 u(1)*xaxp(2)],'-b')
%plot([u2(1) u(2)*yaxp(1)],[u2(2) u(2)*yaxp(2)],':c13')
%plot([0 u(2)*yaxp(1)],[0 u(2)*yaxp(2)],'-c13')
%p3=[u(1) u(2) 0]; %3D projection of u onto xy-plane
%pp3=[p3 1]*T;     %perspective of the projection
%p=pp3(1:2);       %2D representation of perspective projection.
%plot([u(1)*xaxp(1) p(1)],[u(1)*xaxp(2) p(2)],':w')
%plot([u(2)*yaxp(1) p(1)],[u(2)*yaxp(2) p(2)],':w')
plot([0 p(1)],[0 p(2)],'-m','erasemode','none')
text(p(1)/2,p(2)/2,'PROJ','erasemode','none')
drawnow
tic;while toc<2,end
title('Drawing the orthogonal projector!')
tic;while toc<2,end
plot([u2(1) p(1)],[u2(2) p(2)],'--g','erasemode','none')
drawnow
or=(p3+u)*(.5);  %finding position for word ORTH
or=[or 1]*T;     %half way up the perpendicular
text(or(1),or(2),'S','erasemode','none')
drawnow
pause(2)
goon=text(.2,-.1,cont,'units','normalized','erasemode','none');
pause
set(goon,'string',' ');
%xlabel(cont)
hold off
close(gcf)
%subplot
clc,disp('PROJXY is over!')


