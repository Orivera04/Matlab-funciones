function vec3demo(x,y)                 %last updated 2/25/96
%VEC3DEMO   Display a pair of three dimensional vectors, their
%           sum, diffence and scalar multiples.
%
%         The input vectors u and v are displayed in a 3-dimensional
%         perspective along with their sum, differnce and selected
%         scalar multiples. For visulaization purposes a set of
%         coordinate 3-D axes are shown.
%
%         Use in the form:  ==>  vec3demo(u,v)  <==                 
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

%INPUT routine

if nargin<2
   clc,disp(head),disp(s0),disp(s0)
   x=input(s1);disp(s0),disp(s0)
   y=input(s2);disp(s0),disp(s0)
end   

[mx,nx]=size(x);[my,ny]=size(y);
if mx*ny~=3 | my*ny~=3
   disp([blk blk blk 'Error in vec3demo: input not 3-vectors.'])
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

x=reshape(x,1,3);y=reshape(y,1,3);
alpha=(210/180)*pi;
beta=0;
gamma=pi/2;
T=zeros(4,4);
T(1:3,1:2)=[cos(alpha) sin(alpha);cos(beta) sin(beta);cos(gamma) sin(gamma)];
T(4,4)=1;
xaxis=[1 0 0];xaxp=[xaxis 1]*T; %unit vectors in axis directions
yaxis=[0 1 0];yaxp=[yaxis 1]*T;
zaxis=[0 0 1];zaxp=[zaxis 1]*T;
scfact=3;
xax2=scfact*xaxp(1:2);yax2=scfact*yaxp(1:2);
zax2=scfact*zaxp(1:2);%scaling the axes

xprime=[x 1]*T;  %x and y are to be ROWS HERE
yprime=[y 1]*T;
x2=xprime(1:2);y2=yprime(1:2);
       %setting up sum, diff & scalar multiples
sum=x+y;dif=x-y;sc1=-2*x;sc2=.5*y;
sumprime=[sum 1]*T;difprime=[dif 1]*T;
sc1prime=[sc1 1]*T;sc2prime=[sc2 1]*T;
s2=sumprime(1:2);d2=difprime(1:2);
sc1=sc1prime(1:2);sc2=sc2prime(1:2);
% generating size for graphs
org=[0 0];
V=[x2;y2;s2;d2;sc1;sc2;org];
t1=min(V(:,1));t2=max(V(:,1));t3=min(V(:,2));t4=max(V(:,2));
ax=[t1 t2 t3 t4];b=sign(ax);%determining axis settings
if b(1)==0
      b(1)=-1;
end
if b(3)==0
      b(3)=-1;
end
if b(2)==0
      b(2)=1;
end
if b(4)==0
      b(4)=1;
end
ax=ax+b;% making a slightly bigger graphics box
T=ax;%renaming axis vector
X=x2;Y=y2;%renaming 2-D image of orig vectors

%doing the graphics
plt=[221 222 223 224];

if ch==1
   figure
   for j=1:4
      subplot(plt(j)),axis(ax),axis('off'),hold on
      title(name(j,:),'erasemode','none')
   end
end

%orig vectors
if ch==1
   subplot(plt(1))
else
   figure,
   axis(ax),axis('off'),hold on
   title(name(1,:),'erasemode','none')
end
plot([0 xax2(1)],[0 xax2(2)],'-w','erasemode','none')
plot([0 yax2(1)],[0 yax2(2)],'-w','erasemode','none')
plot([0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
pause(1)
[xx,yy]=arrowh([0 0],x2);
plot(xx,yy,'-b','erasemode','none')
pause(1)
text(x2(1)/2,x2(2)/2,'u','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(3)
[xx,yy]=arrowh([0 0],y2);
plot(xx,yy,'-y','erasemode','none')
pause(1)
text(y2(1)/2,y2(2)/2,'v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(3)
%text(X(1)/2,X(2)/2,'u','erasemode','none','color','magenta',...
%    'fontsize',14,'fontweight','bold')
%pause(1)
%text(Y(1)/2,Y(2)/2,'v','erasemode','none','color','magenta',...
%     'fontsize',14,'fontweight','bold')
hold off
pause(2)
%++++++++++++++++++++++++++++++++++++++++++++++++
%SUM
if ch==1
   subplot(plt(2))
else
   figure,
   axis(ax),axis('off'),hold on
   title(name(2,:),'erasemode','none')
end
plot([0 xax2(1)],[0 xax2(2)],'-w','erasemode','none')
plot([0 yax2(1)],[0 yax2(2)],'-w','erasemode','none')
plot([0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
pause(1)
[xx,yy]=arrowh([0 0],X);
plot(xx,yy,'-b','erasemode','none')
pause(1)
text(X(1)/2,X(2)/2,'u','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(2)
[xx,yy]=arrowh([0 0],y2);
plot(xx,yy,'-y','erasemode','none')
plot([0 Y(1)],[0 Y(2)],'-y','erasemode','none')
pause(1)
plot([X(1) s2(1)],[X(2) s2(2)],'-y','erasemode','none')
pause(1)
text((X(1)+s2(1))/2,(X(2)+s2(2))/2,'v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
%plot([Y(1) s2(1)],[Y(2) s2(2)],':b','erasemode','none')
pause(2)
plot([0 s2(1)],[0 s2(2)],'--w','erasemode','none')
pause(1)
text(s2(1)/2,s2(2)/2,'u+v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
hold off
pause(3)
%++++++++++++++++++++++++++++++++++++++
%DIFFERENCE
if ch==1
   subplot(plt(3))
else
   figure,
   axis(ax),axis('off'),hold on
   title(name(3,:),'erasemode','none')
end
plot([0 xax2(1)],[0 xax2(2)],'-w','erasemode','none')
plot([0 yax2(1)],[0 yax2(2)],'-w','erasemode','none')
plot([0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
pause(1)
[xx,yy]=arrowh([0 0],X);
plot(xx,yy,'-b','erasemode','none')
pause(1)
[xx,yy]=arrowh([0 0],Y);
plot(xx,yy,'-y','erasemode','none')
pause(1)
plot([Y(1) s2(1)],[Y(2) s2(2)],'-b','erasemode','none')
pause(2)
text((Y(1)+s2(1))/2,(Y(2)+s2(2))/2,'u','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(2)
plot([X(1) s2(1)],[X(2) s2(2)],':y','erasemode','none')
pause(2)
text((X(1)+s2(1))/2,(X(2)+s2(2))/2,'-v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(2)
plot([Y(1) X(1)],[Y(2) X(2)],'--w','erasemode','none')
pause(2)
text(s2(1)/2,s2(2)/2,'u-v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
hold off
pause(3)
%++++++++++++++++++++++++++++++++++++++
%Scalar Multiples
if ch==1
   subplot(plt(4))
else
   figure,
   axis(ax),axis('off'),hold on
   title(name(4,:),'erasemode','none')
end
plot([0 xax2(1)],[0 xax2(2)],'-w','erasemode','none')
plot([0 yax2(1)],[0 yax2(2)],'-w','erasemode','none')
plot([0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
pause(1)
plot([0 -2*X(1)],[0 -2*X(2)],'-b','erasemode','none')
pause(1)
text(-X(1),-X(2),'-2u','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(2)
plot([0 (1/2)*Y(1)],[0 (1/2)*Y(2)],'-y','erasemode','none')
pause(1)
text(.25*Y(1),.25*Y(2),'(1/2)v','erasemode','none','color','magenta',...
     'fontsize',14,'fontweight','bold')
pause(2)
text(T(1),T(3)+1,'Press ENTER to Continue.','erasemode','none')
hold off




