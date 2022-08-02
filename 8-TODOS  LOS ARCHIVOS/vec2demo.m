function vec2demo(X,Y)                   %last updated 2/25/96
%VEC2DEMO  A graphical demonstration of vector operations for
%          two dimensional vectors.
%
%          Select vectors u = [x1 y1] and v = [x2 y2].
%          They will be displayed graphically along with their sum,
%          difference, and a scalar multiple.
%
%          Use in the form:  ==>  vec2demo(u,v)  <==
%                       or   ==>  vec2demo       <==
%          In the latter case you wil be prompted for input.
%
%  By: David R. Hill, MATH Department, Temple University
%      Philadelphia, Pa., 19122        Email: hill@math.temple.edu

name=['     Original vectors u and v    ';
      '        SUM:  u + v              ';
      '     DIFFERENCE: u - v           ';
      'Scalar Multiple:  (-2u) & (1/2)v '];
head='                    Vector Demonstration in the Plane';
s0=' ';
s1='Enter vector u  ==>  ';
s2='Enter vector v  ==>  ';
s3='There a four graphs generated in this routine.';
s4=['           << OPTIONS >>              ';
    '                                      ';
    '1. Show all graphs on the same screen.';
    '                                      ';
    '2. Show graphs on individual screens. ';
    '                                      ';
    '0. QUIT!                              ']; 
s5='   Enter your choice  ==>  ';      
s6='Routine VEC2DEMO is over!';
s7='Invalid choice; select 0, 1, or 2. TRY AGAIN!';
s8='Press ENTER to continue.';
blk=setstr(219);
er='Error in vec2demo: vectors not the same size';


%INPUT routine

if nargin<2
   clc,disp(head),disp(s0),disp(s0)
   X=input(s1);disp(s0),disp(s0)
   Y=input(s2);disp(s0),disp(s0)
end   
[xm xn]=size(X);[ym yn]=size(Y);
if xm*xn~=2 | ym*yn~=2
   disp([blk blk blk er])
   return
end

validch='N';
while(validch=='N')
   clc,disp(head),disp(s0),disp(s0)
   disp(s3),disp(s0)
   disp(s4),disp(s0)
   ch=input(s5);
   if ch==0,clc,disp(s6),return,end
   if ch==1 | ch==2
      validch='Y';
   else
      disp(s7),disp(s0),disp(s8),pause
   end
end

%START graphs

V=[X;Y;X+Y;X-Y;-2*X;.5*Y];
T1=min(V(:,1))-1;T2=max(V(:,1))+1;T3=min(V(:,2))-1;T4=max(V(:,2))+1;
T=[T1 T2 T3 T4]; %determining graphics box
plt=[221 222 223 224];

if ch==1
   figure
   for j=1:4
      subplot(plt(j)),axis(T),hold on
      title(name(j,:),'erasemode','none')
   end
end

%ORIGINALS
if ch==1
   subplot(plt(1))
else
   figure,
   axis(T),hold on
   title(name(1,:),'erasemode','none')
end
[xx,yy]=arrowh([0 0],X);
plot(xx,yy,'-b','erasemode','none')
[xx,yy]=arrowh([0 0],Y);
plot(xx,yy,'-y','erasemode','none')
pause(3)
text(X(1)/2,X(2)/2,'u','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(1)
text(Y(1)/2,Y(2)/2,'v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
%if ch==2,text(T(1),T(3),s8,'erasemode','none'),pause,else,pause(5),end
hold off
pause(5)

%SUM
if ch==1
   subplot(plt(2))
else
   figure,
   axis(T),hold on
   title(name(2,:),'erasemode','none')
end
[xx,yy]=arrowh([0 0],X);
plot(xx,yy,'-b','erasemode','none')
pause(1)
text(X(1)/2,X(2)/2,'u','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
[xx,yy]=arrowh([0 0],Y);
plot(xx,yy,'-y','erasemode','none')
pause(1)
Z=X+Y;
plot([X(1) Z(1)],[X(2) Z(2)],'-y','erasemode','none')
pause(2)
text((X(1)+Z(1))/2,(X(2)+Z(2))/2,'v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
%plot([Y(1) Z(1)],[Y(2) Z(2)],':b','erasemode','none')
pause(2)
plot([0 Z(1)],[0 Z(2)],'--w','erasemode','none')
pause(1)
text(Z(1)/2,Z(2)/2,'u+v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
%if ch==2,xlabel(s8,'erasemode','none'),pause,else,pause(5),end
hold off
pause(5)

%DIFERENCE
if ch==1
   subplot(plt(3))
else
   figure,
   axis(T),hold on
   title(name(3,:),'erasemode','none')
end
[xx,yy]=arrowh([0 0],X);
plot(xx,yy,'-b','erasemode','none')
[xx,yy]=arrowh([0 0],Y);
plot(xx,yy,'-y','erasemode','none')
pause(1)
plot([Y(1) Z(1)],[Y(2) Z(2)],'-b','erasemode','none')
pause(2)
text((Y(1)+Z(1))/2,(Y(2)+Z(2))/2,'u','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
plot([X(1) Z(1)],[X(2) Z(2)],':y','erasemode','none')
pause(2)
text((X(1)+Z(1))/2,(X(2)+Z(2))/2,'-v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
plot([Y(1) X(1)],[Y(2) X(2)],'--w','erasemode','none')
pause(2)
text(Z(1)/2,Z(2)/2,'u-v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
%if ch==2,xlabel(s8,'erasemode','none'),pause,else,pause(5),end
hold off
pause(5)

%MULTIPLES
if ch==1
   subplot(plt(4))
else
   figure,
   axis(T),hold on
   title(name(4,:),'erasemode','none')
end
[xx,yy]=arrowh([0 0],-2*X);
plot(xx,yy,'-b','erasemode','none')
text(-X(1),-X(2),'-2u','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(1)
[xx,yy]=arrowh([0 0],(1/2)*Y);
plot(xx,yy,'-y','erasemode','none')
text(.25*Y(1),.25*Y(2),'(1/2)v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(1)
xlabel(s8,'erasemode','none')
hold off
if ch==1,subplot,end




