% Script p9_3_13m.m; minimum time erection of an inverted pendulum with
% |f|<1; ep=.5; Fig. 1 is a movie, Fig. 2 is a stroboscopic movie;
% s=[th q y yd]';                                          4/98, 3/1/02
%
ts=[.6902 .8933 1.0593 2.7212 4.3234 4.9170]; ep=.5; umax=1; 
[f,t1,x1,tu,u]=ip(ts,ep,umax); N1=length(t1); tf=t1(N1); 
t=tf*[0:.005:1]; x=interp1(t1,x1,t); N=length(t); th=x(:,1); y=x(:,3);
xp=y+sin(th); yp=-cos(th); xa=zeros(N,2); ya=xa; clear x1;
for i=1:N, xa(i,:)=[xp(i) y(i)]; ya(i,:)=[yp(i) 0]; end
%
figure(1); for k=1:2; clf;  
   for i=1:N, x1=y(i)+.1; y1=.075; x2=y(i)-.1; y2=y1; x3=x2; y3=-y1;
      x4=x1; y4=y3; plot([-.9 1.1],[0 0],'r',[0 0],[-1 1],'r--',...
      xa(i,:),ya(i,:),'b',xp(i),yp(i),'bo',y(i),0,'bo',[x1 x2 x3 ...
      x4 x1],[y1 y2 y3 y4 y1],'b'); 
   axis([-1.5 1.7 .625*[-1.6 1.6]]); axis off
   if i==1, pause(1); else pause(.03); end 
end; pause(1); end; pause(1)
%
figure(2); clf; 
   for i=1:5:N, x1=y(i)+.1; y1=.075; x2=y(i)-.1; y2=y1; x3=x2; y3=-y1;
      x4=x1; y4=y3; plot([-.9 1.1],[0 0],'r',[0 0],[-1 1],'r--',...
      xa(i,:),ya(i,:),'b',xp(i),yp(i),'ro',y(i),0,'bo',[x1 x2 x3 ...
      x4 x1],[y1 y2 y3 y4 y1],'b'); 
   axis([-1.5 1.7 .625*[-1.6 1.6]]); axis off; hold on
end; hold off 
