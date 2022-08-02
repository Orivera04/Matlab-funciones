function project(u,w)                          %last updated 5/9/94
%PROJECT  Projecting vector U onto vector W orthogonally. Vectors
%         U and W can be either a pair of 2D or 3D vectors. A sketch
%         showing U being projected onto W is displayed sequentially.
%
%         Use in the form  ===>  project(u,w)  <===       FOR VERSION
%         or               ===>  project  <===                 4.0 +
%
%         In the latter case a menu of options is presented. One option
%         is a demo which randomly selects 2D or 3D.
%
%By: David R. Hill, Math Dept., Temple University,
%    Philadelphia, Pa. 19122    Email: hill@math.temple.edu
arrow='==>';
cont='Press ENTER to continue.';
head='                   PROJECT vector U onto vector W';
errmess1='Too many or too few input arguments.';
errmess2='Input vectors not the same size.';
errmess3 = 'Input vectors not 2D or 3D.';
kindmenu=...
['You can enter a pair of 2D vectors or a pair of 3D vectors:';
 '  <1> Demo                                                 ';
 '  <2> Enter two 2D vectors.                                ';
 '  <3> Enter two 3D vectors.                                ';
 '                                                           ';
 '  <0> QUIT.                                                '];
s0=' ';
s1='Enter your choice.  ';
s2='Enter a pair of 2D vectors.';
s3='Enter a pair of 3D vectors.';
s4='The vector to project is U =  ';
s5='The vector to project onto is W =  ';
s6='Improper choice; try again.';
s7a='To enter a vector, include it entries between square brackets [....]';
s7b='with the entries separated by a space, then press ENTER.';
s8='P is the projection of U onto W.';
s9='Vectors must be real.';
mode=0;
if nargin==1 | nargin > 2
   disp([arrow '   ' errmess1])
   return
end
if nargin==2
   if sum(abs(imag(u)))~=0 | sum(abs(imag(w)))~=0
      disp(s9),return
   end   %Checking to make sure vectors are real.
   [mu,nu]=size(u);[mw,nw]=size(w);
   if mu*nu==mw*nw
      u=u(:);w=w(:);
   else
      disp([arrow '   ' errmess2])
      return
   end
   if length(u)==2,mode=2;end
   if length(u)==3,mode=3;end
   if mode==0
      disp([arrow '   ' errmess3])
      return
   end
   kind=mode;
end
if nargin==0
   validch='N';
   while validch=='N'
      clc,disp(head),disp(s0),disp(kindmenu),disp(s0)
      ch=input(s1);
      if ch==0,return,end
      if ch==1
         z=clock;z=z(5);     %using the minute value to determine
         if 2*fix(z/2)==z    %if the demo is 2D or 3D
            u=[7,3]';w=[4,-5]';validch='Y';kind=2;
         else
            u=[1 4 8]';w=[3 -6 12]';validch='Y';kind=3;
         end
      end
      if ch==2,validch='Y';kind=2;disp(s0),disp(s7a),disp(s7b),disp(s0)
         disp(s2),u=input(s4);w=input(s5);
      end
      if ch==3,validch='Y';kind=3;disp(s0),disp(s7a),disp(s7b),disp(s0)
         disp(s3),u=input(s4);w=input(s5);
      end
      if ch==2 | ch==3
         [mu,nu]=size(u);[mw,nw]=size(w);
         if mu*nu~=ch | mw*nw~=ch
            disp([arrow '   ' errmess2])
            return
         end
      end
      if validch=='N',disp(s6),disp(cont),pause,end
    end %of while validch
end % of nargin==0
if sum(abs(imag(u)))~=0 | sum(abs(imag(w)))~=0
   disp(s9),return
end    %checking to make sure vectors are real.
if kind==2   %----- 2D code
   proj=(dot(u,w)/(norm(w)^2))*w; %computing the projection
   xmax=max([u(1),w(1), proj(1)]);ymax=max([u(2),w(2), proj(2)]);
   xk=fix(abs(xmax)/5);yk=fix(abs(ymax)/5);
   maxk=max(xk,yk);maxk=maxk+1;
   ax=5*maxk*[-1 1 -1 1];
   figure,set(gcf,'units','normal')
   set(gcf,'position',[0 0 1 1]) %Setting position of window
   plot([ax(1),ax(2)],[0,0],'-w',[0,0],[ax(3),ax(4)],'-w','erasemode','none')
   axis(axis)
   axis('off')
   title('ORTHOGONAL PROJECTION of 2D VECTORS')
   hold on
   tic;while toc<2,end
   plot([0,u(1)],[0,u(2)],'-g','erasemode','none')%PLOT VECTOR U
   text(u(1)/2,u(2)/2,'U','color','g','erasemode','none')
   drawnow 
   tic;while toc<4,end
   plot([0,w(1)],[0,w(2)],'-b','erasemode','none')%PLOT VECTOR W
   text(7*w(1)/8,7*w(2)/8,'W','color','b','erasemode','none')
   drawnow
   tic;while toc<4,end
   %working on the projection next
   plot([u(1) proj(1)],[u(2) proj(2)],':w','erasemode','none')
   tic;while toc<4,end
   drawnow
   plot([0,proj(1)],[0,proj(2)],'-m','erasemode','none')
   text(proj(1)/2,proj(2)/2,'P','color','m','erasemode','none')
   drawnow
   tic;while toc<3,end
   finst=[s8 '      ' cont];
   handelq=text(.2,.05,finst,'units','normalized',...
           'color','white','erasemode','none');
   drawnow
   hold off
   
end
if kind==3    %----- 3D code
   u=reshape(u,1,3); %making u a row
   w=reshape(w,1,3); %making w a row
   orproj=(dot(u,w)/(norm(w)^2))*w; %projection in 3D
   orproj=reshape(orproj,1,3);
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
   uprime=[u 1]*T;  %u and w are to be ROWS HERE
   wprime=[w 1]*T;
   u2=uprime(1:2);  %the representation of u and w 
   w2=wprime(1:2);  %from R3 as a perspective R2 vector
   pjprime=[orproj 1]*T;
   proj=pjprime(1:2);  %perspective representation of the projection
   %doing the graphics
   org=[0 0];
   Q=[w2;u2;xax2;yax2;zax2;org;proj];
   t1=min(Q(:,1));t2=max(Q(:,1));
   t3=min(Q(:,2));t4=max(Q(:,2));
   xt=max([abs(t1) abs(t2)]);
   ax=[-xt-1 xt+1 t3-1 t4+1]; %stretching things out a bit
   figure,set(gcf,'units','normal')
   set(gcf,'position',[0 0 1 1]) %Setting position of window
   %Next we draw axes from vector ax in black to set size of
   %of axes for future drawing
   plot([ax(1) ax(2)],[0 0],'-k',[0 0],[ax(3) ax(4)],'-k','erasemode','none')
   axis(axis)
   axis('off')
   drawnow
   hold on
   plot([0 xax2(1)],[0 xax2(2)],'-w',[0 yax2(1)],[0 yax2(2)],'-w',[0 zax2(1)],[0 zax2(2)],'-w','erasemode','none')
   title('ORTHOGONAL PROJECTION of 3D VECTORS')
   plot(0,0,'*w','erasemode','none')
   drawnow
   text(xax2(1),xax2(2),'X','erasemode','none')
   drawnow
   text(yax2(1),yax2(2),'Y','erasemode','none')
   drawnow
   text(.9*zax2(1),.9*zax2(2),'Z','erasemode','none')
   drawnow
   tic;while toc<2,end
   plot([0 u2(1)], [0 u2(2)],'-g','erasemode','none')
   drawnow
   text(u2(1)/2,u2(2)/2,'U','color','g','erasemode','none')
   drawnow
   tic;while toc<2,end
   plot([0 w2(1)], [0 w2(2)],'-b','erasemode','none')
   drawnow
   text(.7*w2(1),.7*w2(2),'W','color','b','erasemode','none')
   drawnow
   tic;while toc<2,end
   %drawing projection things
   plot([u2(1) proj(1)],[u2(2) proj(2)],':w','erasemode','none')
   drawnow
   tic;while toc<3,end
   plot([0,proj(1)],[0,proj(2)],'-m','erasemode','none')
   drawnow
   tic;while toc<3,end
   text(proj(1)/2,proj(2)/2,'P','color','m','erasemode','none')
   drawnow
   tic;while toc<3,end
   finst=[s8 '      ' cont];
   handelq=text(.2,0,finst,'units','normalized',...
           'color','white','erasemode','none');
   drawnow
   hold off
end
tic;while toc<2,end
%set(gcf,'units','pixels')
clc,disp('PROJECT is over!')