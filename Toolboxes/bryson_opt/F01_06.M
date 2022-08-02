% Script f01_06.m; example of minimization w.r.t two 
% parameters and 1 equality constraint; 10/96, 4/1/02
%
th=[0:2:360]*pi/180; x=2*cos(th); y=.8*sin(th);
x1=1.4*2*cos(th); y1=1.4*.8*sin(th);
x2=(2/1.4)*cos(th); y2=(.8/1.4)*sin(th);
x3=-3; y3=.4*sqrt(3)-(.4/sqrt(3))*(x3-1);
x4=3;  y4=.4*sqrt(3)-(.4/sqrt(3))*(x4-1);
%
figure(1); clf; plot(x,y,x1,y1,x2,y2); grid;
axis([-3 3 -2 2]); hold on; plot([x3 x4],[y3 y4]); 
plot(1,.4*sqrt(3),'o'); plot([-3 2.9],[0 0]);
plot([0 0],[-1.4 1.7]); hold off;
text(3,.03,'y_1'); text(-.1,1.9,'y_2');
text(-2.3,1.8,'y_2 + my_1 - c = 0');
text(-1.8,-1.4,'L = const curves');
text(1.3,.8,'Point for min L'); axis('off');
%print -deps2 \book_do\figures\f01_06 