% © Gergo Lajos 1998; program a Grafika c. reszhez
 clear;

 x=0.1:0.1:4*pi;
 y1=sin(x);
 y2=sin(x)./x;

 fg=figure;
 r1=subplot(1,2,1);
 l1=plot(x,y1);

 r2=subplot(1,2,2);
 l2=plot(x,y2,'*');

 disp('az elozo pelda);
 pause;

 set(r1,'Position',[0.1 0.1 0.3 0.3]);
 set(l1,LineWidth',5);

 set(r2,'XTick',[1 4 11]);
 set(l2,'LineStyle','+');

 pause;
 delete(fg);