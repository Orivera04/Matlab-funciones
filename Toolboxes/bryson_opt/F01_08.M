% Script f01_08.m; min time paths thru a region with two 
% layers of const velocity magnitude;      10/96, 4/1/02
%
x1=1; y1=.3; x2=1.4; y2=1;
%
figure(1); clf; plot([0 x1],[0 y1],[x1 x2],[y1 y2],...
   [0 x2],[0 y2],'--',[0 1.8],[y1 y1],'--',[x1 x1],...
   [0 1.2],'--',x2,y2,'o',[0 0],[0 1.2],[0 1.8],[0 0]);
hold on; axis([0 1.8 0 1.2]); text(1.1,.22,'(x_1, y_1)');
text(.8,.13,'\theta_1'); text(1.04,.68,'\theta_2');
text(1.5,.4,'v = v_2'); text(1.5,.2,'v = v_1');
text(1.75,.05,'x'); text(.05,1.15,'y');
text(1.4,.7,'Min Time'); text(1.4,.6,'Path');
text(.6,.8,'Direct'); text(.6,.7,'Path');
th1=pi+atan(.3); th2=3*pi/2; dth=th2-th1;
th=[th1:dth/20:th2]; n=length(th);
xt=ones(1,n)+.15*cos(th); yt=.3*ones(1,n)+.15*sin(th);
plot(xt,yt); th1=pi/2-atan(.4/.7); th2=pi/2; 
dth=th2-th1; th=[th1:dth/20:th2]; n=length(th);
xt=ones(1,n)+.32*cos(th); yt=.3*ones(1,n)+.32*sin(th);
plot(xt,yt,':'); axis('off')
%print -deps2 \book_do\figures\f01_08